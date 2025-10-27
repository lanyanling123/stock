#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
九阳公社异动解析爬虫程序
爬取网站：https://www.jiuyangongshe.com/action/2025-10-23
"""

import os
import time
import logging
import requests
from bs4 import BeautifulSoup
import psycopg2
from psycopg2.extras import execute_values
from fake_useragent import UserAgent
from dotenv import load_dotenv
import re

# 加载环境变量
load_dotenv()

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('spider.log', encoding='utf-8'),
        logging.StreamHandler()
    ]
)

class StockSpider:
    def __init__(self):
        self.base_url = "https://www.jiuyangongshe.com"
        # 更新为有效的URL，使用当前日期或最近的有效日期
        import datetime
        today = datetime.date.today()
        # 使用今天的日期或者最近一个工作日的日期
        self.target_url = f"https://www.jiuyangongshe.com/action/{today.strftime('%Y-%m-%d')}"
        self.ua = UserAgent()
        self.session = requests.Session()
        self.db_conn = None
        
        # 配置请求头
        self.headers = {
            'User-Agent': self.ua.random,
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1',
        }
        
        # 数据库配置
        self.db_config = {
            'host': os.getenv('DB_HOST', 'localhost'),
            'port': os.getenv('DB_PORT', '5432'),
            'database': os.getenv('DB_NAME', 'stock_db'),
            'user': os.getenv('DB_USER', 'postgres'),
            'password': os.getenv('DB_PASSWORD', '')
        }
        
        # 爬虫配置
        self.timeout = int(os.getenv('REQUEST_TIMEOUT', '30'))
        self.retry_count = int(os.getenv('RETRY_COUNT', '3'))
        self.delay = int(os.getenv('DELAY_BETWEEN_REQUESTS', '2'))
    
    def is_garbled_text(self, text):
        """检测文本是否乱码"""
        if not text:
            return False
        
        # 检查是否包含常见的乱码字符
        garbled_patterns = [
            '锘�', '�', 'ï»¿', 'Ã', 'Â', 'ä»', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë',
            'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷', 'ø', 'ù',
            'ú', 'û', 'ü', 'ý', 'þ', 'ÿ'
        ]
        
        # 检查前100个字符
        sample = text[:100]
        for pattern in garbled_patterns:
            if pattern in sample:
                return True
        
        # 检查是否有大量不可打印字符
        non_printable_count = sum(1 for c in sample if ord(c) < 32 and c not in '\n\r\t')
        if non_printable_count > len(sample) * 0.1:  # 超过10%的不可打印字符
            return True
            
        return False

    def get_page_content(self, url):
        """获取页面内容，彻底修复编码问题"""
        for attempt in range(self.retry_count):
            try:
                self.headers['User-Agent'] = self.ua.random
                # 重置并优化请求头
                self.headers = {
                    'User-Agent': self.ua.random,
                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                    'Accept-Language': 'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
                    'Connection': 'keep-alive',
                    'Upgrade-Insecure-Requests': '1',
                    # 移除Accept-Encoding头，让requests自动处理
                }
                
                # 使用session发送请求，保留Cookie信息
                response = self.session.get(url, headers=self.headers, timeout=self.timeout)
                response.raise_for_status()
                
                # 检查响应的编码设置
                logging.info(f"响应的Content-Type: {response.headers.get('Content-Type')}")
                logging.info(f"响应的编码设置: {response.encoding}")
                
                # 尝试使用多种方式解码内容
                try:
                    # 方法1：使用chardet检测编码
                    try:
                        import chardet
                        result = chardet.detect(response.content)
                        encoding = result['encoding'] or 'utf-8'
                        logging.info(f"chardet检测到的编码: {encoding}")
                        text = response.content.decode(encoding)
                    except:
                        # 方法2：尝试常见的编码格式
                        encodings = ['utf-8', 'gbk', 'gb2312', 'big5']
                        text = None
                        for enc in encodings:
                            try:
                                text = response.content.decode(enc)
                                logging.info(f"成功使用编码 {enc} 解码内容")
                                break
                            except:
                                continue
                        
                        # 如果上述方法都失败，使用requests的自动编码
                        if text is None:
                            text = response.text
                            logging.info(f"使用requests自动编码: {response.encoding}")
                    
                    # 验证解码是否成功
                    if any(ord(c) > 127 for c in text[:100]):
                        logging.info(f"HTML内容前100个字符(可能包含非ASCII字符): {text[:100]}")
                    else:
                        logging.info(f"HTML内容前100个字符: {text[:100]}")
                    
                    # 保存获取到的原始内容，用于调试
                    with open('debug_raw_response.txt', 'w', encoding='utf-8') as f:
                        f.write(f"URL: {url}\n")
                        f.write(f"Headers: {response.headers}\n\n")
                        f.write(f"Content (first 1000 chars):\n{text[:1000]}")
                    
                    return text
                    
                except Exception as e:
                    logging.error(f"解码过程中发生错误: {str(e)}")
                    # 仍然尝试返回原始响应文本，即使解码失败
                    return response.text if hasattr(response, 'text') else None
                    
            except requests.RequestException as e:
                logging.warning(f"第{attempt + 1}次请求失败: {e}")
                if attempt < self.retry_count - 1:
                    time.sleep(self.delay * (attempt + 1))
                else:
                    logging.error(f"所有重试失败: {url}")
                    return None

    def run(self):
        """运行爬虫"""
        logging.info("开始爬取九阳公社异动解析数据")
        logging.info(f"目标URL: {self.target_url}")
        
        # 连接数据库
        if not self.connect_database():
            return
        
        try:
            # 获取页面内容
            html_content = self.get_page_content(self.target_url)
            
            if html_content:
                logging.info(f"成功获取HTML内容，长度: {len(html_content)}")
                # 解析数据
                stock_data = self.parse_stock_data(html_content)
                
                # 保存数据
                if stock_data:
                    self.save_to_database(stock_data)
                else:
                    logging.warning("未解析到任何股票数据")
                    
                    # 保存原始HTML用于调试
                    with open('debug_page.html', 'w', encoding='utf-8') as f:
                        f.write(html_content)
                    logging.info("已保存原始页面到 debug_page.html")
                    
                    # 保存解析失败的详细信息
                    self.save_debug_info(html_content)
            else:
                logging.error("未能获取页面内容")
                
        except Exception as e:
            logging.error(f"爬虫运行出错: {e}")
        
        finally:
            self.close_database()
            logging.info("爬虫运行结束")

    def connect_database(self):
        """连接PostgreSQL数据库"""
        try:
            self.db_conn = psycopg2.connect(**self.db_config)
            logging.info("数据库连接成功")
            return True
        except Exception as e:
            logging.error(f"数据库连接失败: {e}")
            return False
    
    def close_database(self):
        """关闭数据库连接"""
        if self.db_conn:
            self.db_conn.close()
            logging.info("数据库连接已关闭")
    
    def get_page_content(self, url):
        """获取页面内容，彻底修复编码问题"""
        for attempt in range(self.retry_count):
            try:
                self.headers['User-Agent'] = self.ua.random
                # 移除Accept-Encoding头，让requests自动处理
                headers = self.headers.copy()
                if 'Accept-Encoding' in headers:
                    del headers['Accept-Encoding']
                
                response = self.session.get(url, headers=headers, timeout=self.timeout)
                response.raise_for_status()
                
                # 详细记录响应信息
                logging.info(f"响应状态码: {response.status_code}")
                logging.info(f"响应Content-Type: {response.headers.get('Content-Type', '未设置')}")
                logging.info(f"响应编码: {response.encoding}")
                
                # 优先使用response.text，让requests自动处理编码
                text = response.text
                
                # 如果检测到乱码，尝试手动解码
                if self.is_garbled_text(text):
                    logging.warning("检测到乱码，尝试手动解码")
                    
                    # 尝试常见的编码格式
                    encodings = ['utf-8', 'gbk', 'gb2312', 'big5', 'iso-8859-1']
                    for encoding in encodings:
                        try:
                            text = response.content.decode(encoding)
                            if not self.is_garbled_text(text):
                                logging.info(f"成功使用编码 {encoding} 解码")
                                break
                        except:
                            continue
                
                # 记录获取到的内容前200个字符
                logging.info(f"获取到的HTML内容前200字符: {text[:200]}")
                
                return text
                
            except requests.RequestException as e:
                logging.warning(f"第{attempt + 1}次请求失败: {e}")
                if attempt < self.retry_count - 1:
                    time.sleep(self.delay * (attempt + 1))
                else:
                    logging.error(f"所有重试失败: {url}")
                    return None
    
    def parse_stock_data(self, html_content):
        """解析股票异动数据"""
        if not html_content:
            return []
        
        logging.info(f"开始解析HTML内容，长度: {len(html_content)}")
        
        # 详细检查HTML内容的编码情况
        if self.is_garbled_text(html_content):
            logging.warning("检测到HTML内容可能乱码")
            
            # 显示前200个字符的十六进制表示，用于调试
            sample = html_content[:200]
            hex_sample = ' '.join(f'{ord(c):02x}' for c in sample)
            logging.info(f"HTML内容前200字符十六进制: {hex_sample}")
            
            # 显示前200个字符的原始内容
            logging.info(f"HTML内容前200字符原始: {repr(sample)}")
        else:
            logging.info(f"HTML内容前200字符: {html_content[:200]}")
        
        # 尝试使用不同的解析器
        parsers = ['lxml', 'html.parser', 'html5lib']
        soup = None
        for parser in parsers:
            try:
                soup = BeautifulSoup(html_content, parser)
                logging.info(f"成功使用 {parser} 解析器解析HTML")
                break
            except Exception as e:
                logging.warning(f"使用 {parser} 解析器失败: {e}")
        
        if not soup:
            logging.error("所有HTML解析器都失败了")
            return []
            
        stock_data = []
        
        # 根据提供的XPath路径解析结构
        # 路径: /html/body/div/div/div/div[2]/div/div/section/ul/li[3]/div[2]/div/ul/li[1]/div[1]/div[1]/div[1]
        
        # 查找主要容器
        main_sections = soup.find_all('section')
        logging.info(f"找到 {len(main_sections)} 个主要板块容器") 
        for section in main_sections:
            try:
                # 查找板块名称（通常在h2或h3标签中）
                plate_name = self.extract_plate_name_from_section(section)
                
                # 查找股票列表容器
                stock_containers = section.find_all('ul')
                
                for stock_container in stock_containers:
                    # 查找股票项
                    stock_items = stock_container.find_all('li')
                    
                    for stock_item in stock_items:
                        stock_info = self.extract_stock_info_from_item(stock_item)
                        if stock_info:
                            data = {
                                'plate_name': plate_name,
                                'stock_name': stock_info.get('name', ''),
                                'latest_price': stock_info.get('price', 0),
                                'change_percent': stock_info.get('change_percent', 0),
                                'limit_up_time': stock_info.get('limit_up_time', ''),
                                'analysis_text': stock_info.get('analysis', ''),
                                'source_url': self.target_url
                            }
                            stock_data.append(data)
                            
            except Exception as e:
                logging.warning(f"解析板块数据时出错: {e}")
                continue
        
        # 如果上述方法没有找到数据，尝试备用解析方法
        if not stock_data:
            stock_data = self.alternative_parse_method(soup)
        
        # 如果仍然没有数据，尝试精确匹配XPath结构
        if not stock_data:
            stock_data = self.precise_xpath_parse(soup)
        
        logging.info(f"解析到 {len(stock_data)} 条股票数据")
        return stock_data
    
    def extract_plate_name_from_section(self, section):
        """从section中提取板块名称"""
        # 查找板块名称，通常在h2、h3或标题元素中
        plate_selectors = ['h2', 'h3', 'h4', '.title', '.plate-name', '.board-name']
        
        for selector in plate_selectors:
            plate_element = section.find(selector)
            if plate_element and plate_element.get_text(strip=True):
                text = plate_element.get_text(strip=True)
                # 过滤掉非板块名称的文本
                if len(text) < 50 and not any(word in text for word in ['首页', '导航', '菜单']):
                    return text
        
        # 如果找不到明确的板块名称，尝试从父元素查找
        parent = section.find_parent()
        if parent:
            for selector in plate_selectors:
                plate_element = parent.find(selector)
                if plate_element and plate_element.get_text(strip=True):
                    text = plate_element.get_text(strip=True)
                    if len(text) < 50:
                        return text
        
        return "未知板块"
    
    def extract_stock_info_from_item(self, stock_item):
        """从股票项中提取股票信息"""
        stock_info = {}
        
        # 根据XPath路径结构解析
        # 股票名称可能在div[1]/div[1]/div[1]这样的结构中
        
        # 查找股票名称 - 尝试多种选择器
        name_selectors = [
            '.stock-name', '.name', '.title', '.code',
            'div > div > div',  # 匹配XPath中的div[1]/div[1]/div[1]
            'span', 'strong', 'b'
        ]
        
        for selector in name_selectors:
            name_elements = stock_item.select(selector)
            for name_element in name_elements:
                text = name_element.get_text(strip=True)
                # 过滤掉明显不是股票名称的文本
                if (len(text) <= 20 and 
                    len(text) >= 2 and 
                    not any(word in text for word in ['板块', '分类', '更多', '时间', '价格', '涨幅']) and
                    not text.isdigit()):  # 排除纯数字
                    stock_info['name'] = text
                    break
            if stock_info.get('name'):
                break
        
        # 提取价格信息
        price_elements = stock_item.find_all(text=re.compile(r'\d+\.?\d*'))
        for text in price_elements:
            price_match = re.search(r'(\d+\.?\d*)', str(text))
            if price_match:
                try:
                    price = float(price_match.group(1))
                    # 检查是否是合理的价格（股票价格通常在1-1000之间）
                    if 1 <= price <= 1000:
                        stock_info['price'] = price
                        break
                except ValueError:
                    continue
        
        # 提取涨跌幅
        change_elements = stock_item.find_all(text=re.compile(r'[+-]?\d+\.?\d*%'))
        for text in change_elements:
            change_match = re.search(r'([+-]?\d+\.?\d*)%', str(text))
            if change_match:
                try:
                    stock_info['change_percent'] = float(change_match.group(1))
                    break
                except ValueError:
                    continue
        
        # 提取涨停时间
        time_elements = stock_item.find_all(text=re.compile(r'\d{1,2}:\d{2}'))
        for text in time_elements:
            time_match = re.search(r'(\d{1,2}:\d{2})', str(text))
            if time_match:
                stock_info['limit_up_time'] = time_match.group(1)
                break
        
        # 提取解析内容 - 查找包含"解析"的文本
        analysis_elements = stock_item.find_all(text=re.compile(r'解析'))
        for text in analysis_elements:
            if len(str(text).strip()) > 10:
                stock_info['analysis'] = str(text).strip()
                break
        
        # 如果找不到解析内容，尝试获取整个股票项的文本
        if not stock_info.get('analysis') and stock_info.get('name'):
            full_text = stock_item.get_text(strip=True)
            # 排除已经提取的信息
            if stock_info.get('name'):
                full_text = full_text.replace(stock_info['name'], '')
            if len(full_text) > 20:
                stock_info['analysis'] = full_text[:200]  # 限制长度
        
        return stock_info if stock_info.get('name') else None
    
    def alternative_parse_method(self, soup):
        """备用解析方法"""
        stock_data = []
        
        # 尝试查找表格数据
        tables = soup.find_all('table')
        for table in tables:
            rows = table.find_all('tr')
            for row in rows:
                cells = row.find_all(['td', 'th'])
                if len(cells) >= 3:  # 至少有3列数据
                    data = {
                        'plate_name': '表格数据',
                        'stock_name': cells[0].get_text(strip=True) if len(cells) > 0 else '',
                        'latest_price': self.extract_number(cells[1].get_text()) if len(cells) > 1 else 0,
                        'change_percent': self.extract_number(cells[2].get_text()) if len(cells) > 2 else 0,
                        'limit_up_time': cells[3].get_text(strip=True) if len(cells) > 3 else '',
                        'analysis_text': cells[4].get_text(strip=True) if len(cells) > 4 else '',
                        'source_url': self.target_url
                    }
                    if data['stock_name']:
                        stock_data.append(data)
        
        return stock_data
    
    def extract_number(self, text):
        """从文本中提取数字"""
        try:
            numbers = re.findall(r'[-+]?\d*\.?\d+', text)
            return float(numbers[0]) if numbers else 0
        except:
            return 0
    
    def save_to_database(self, stock_data):
        """保存数据到数据库"""
        if not stock_data:
            logging.warning("没有数据需要保存")
            return
        
        try:
            cursor = self.db_conn.cursor()
            
            # 准备插入数据
            insert_query = """
            INSERT INTO stock_movement_analysis 
            (plate_name, stock_name, latest_price, change_percent, limit_up_time, analysis_text, source_url)
            VALUES %s
            ON CONFLICT (stock_name, plate_name, crawl_time) DO NOTHING
            """
            
            # 准备数据元组
            data_tuples = [(
                item['plate_name'],
                item['stock_name'],
                item['latest_price'],
                item['change_percent'],
                item['limit_up_time'],
                item['analysis_text'],
                item['source_url']
            ) for item in stock_data]
            
            # 批量插入
            execute_values(cursor, insert_query, data_tuples)
            self.db_conn.commit()
            
            logging.info(f"成功保存 {len(stock_data)} 条数据到数据库")
            cursor.close()
            
        except Exception as e:
            logging.error(f"保存数据到数据库失败: {e}")
            self.db_conn.rollback()
    
    def precise_xpath_parse(self, soup):
        """精确匹配XPath结构解析"""
        stock_data = []
        
        # 根据提供的XPath路径：/html/body/div/div/div/div[2]/div/div/section/ul/li[3]/div[2]/div/ul/li[1]/div[1]/div[1]/div[1]
        # 尝试逐层解析
        
        # 第一层：body > div > div > div > div[2] > div > div > section
        sections = soup.select('body > div > div > div > div:nth-of-type(2) > div > div > section')
        
        for section in sections:
            try:
                # 提取板块名称
                plate_name = self.extract_plate_name_from_section(section)
                
                # 查找ul列表
                ul_lists = section.find_all('ul')
                
                for ul in ul_lists:
                    # 查找li项
                    li_items = ul.find_all('li')
                    
                    for li in li_items:
                        # 在li中查找div结构
                        div_containers = li.select('div > div > div')
                        
                        for div_container in div_containers:
                            stock_info = self.extract_stock_info_from_precise_div(div_container)
                            if stock_info:
                                data = {
                                    'plate_name': plate_name,
                                    'stock_name': stock_info.get('name', ''),
                                    'latest_price': stock_info.get('price', 0),
                                    'change_percent': stock_info.get('change_percent', 0),
                                    'limit_up_time': stock_info.get('limit_up_time', ''),
                                    'analysis_text': stock_info.get('analysis', ''),
                                    'source_url': self.target_url
                                }
                                stock_data.append(data)
                                
            except Exception as e:
                logging.warning(f"精确解析时出错: {e}")
                continue
        
        return stock_data
    
    def extract_stock_info_from_precise_div(self, div_container):
        """从精确的div结构中提取股票信息"""
        stock_info = {}
        
        # 股票名称可能在第一个div中
        name_elements = div_container.find_all(text=True)
        for text in name_elements:
            text_str = str(text).strip()
            # 过滤股票名称
            if (2 <= len(text_str) <= 20 and 
                not any(word in text_str for word in ['板块', '分类', '更多', '时间', '价格', '涨幅', '%', ':', '：']) and
                not text_str.isdigit() and
                not re.search(r'\d+\.?\d*', text_str)):
                stock_info['name'] = text_str
                break
        
        # 提取价格信息
        price_text = div_container.get_text()
        price_match = re.search(r'(\d+\.?\d*)', price_text)
        if price_match:
            try:
                price = float(price_match.group(1))
                if 1 <= price <= 1000:
                    stock_info['price'] = price
            except ValueError:
                pass
        
        # 提取涨跌幅
        change_match = re.search(r'([+-]?\d+\.?\d*)%', price_text)
        if change_match:
            try:
                stock_info['change_percent'] = float(change_match.group(1))
            except ValueError:
                pass
        
        # 提取涨停时间
        time_match = re.search(r'(\d{1,2}:\d{2})', price_text)
        if time_match:
            stock_info['limit_up_time'] = time_match.group(1)
        
        # 提取解析内容
        if len(price_text) > 20:
            stock_info['analysis'] = price_text[:200]
        
        return stock_info if stock_info.get('name') else None
    
    def run(self):
        """运行爬虫"""
        logging.info("开始爬取九阳公社异动解析数据")
        
        # 连接数据库
        if not self.connect_database():
            return
        
        try:
            # 获取页面内容
            html_content = self.get_page_content(self.target_url)
            
            if html_content:
                # 解析数据
                stock_data = self.parse_stock_data(html_content)
                
                # 保存数据
                if stock_data:
                    self.save_to_database(stock_data)
                else:
                    logging.warning("未解析到任何股票数据")
                    
                    # 保存原始HTML用于调试
                    with open('debug_page.html', 'w', encoding='utf-8') as f:
                        f.write(html_content)
                    logging.info("已保存原始页面到 debug_page.html")
                    
                    # 保存解析失败的详细信息
                    self.save_debug_info(html_content)
            
        except Exception as e:
            logging.error(f"爬虫运行出错: {e}")
        
        finally:
            self.close_database()
            logging.info("爬虫运行结束")
    
    def save_debug_info(self, html_content):
        """保存调试信息"""
        soup = BeautifulSoup(html_content, 'lxml')
        
        # 保存所有section信息
        sections = soup.find_all('section')
        with open('debug_sections.txt', 'w', encoding='utf-8') as f:
            for i, section in enumerate(sections):
                f.write(f"=== Section {i+1} ===\n")
                f.write(str(section)[:500] + "\n\n")
        
        # 保存所有ul信息
        uls = soup.find_all('ul')
        with open('debug_uls.txt', 'w', encoding='utf-8') as f:
            for i, ul in enumerate(uls):
                f.write(f"=== UL {i+1} ===\n")
                f.write(str(ul)[:300] + "\n\n")

        logging.info("已保存调试信息到 debug_sections.txt 和 debug_uls.txt")

def main():
    """主函数"""
    spider = StockSpider()
    spider.run()

if __name__ == "__main__":
    main()