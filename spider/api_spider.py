#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
九阳公社API接口爬虫程序
通过API接口获取股票异动解析数据
"""

import os
import time
import logging
import requests
import psycopg2
from psycopg2.extras import execute_values
from dotenv import load_dotenv
import json
from datetime import datetime

# 加载环境变量
load_dotenv()

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('api_spider.log', encoding='utf-8'),
        logging.StreamHandler()
    ]
)

class ApiStockSpider:
    def __init__(self):
        self.api_url = "https://app.jiuyangongshe.com/jystock-app/api/v1/action/field"
        self.session = requests.Session()
        self.db_conn = None
        
        # 配置请求头
        self.headers = {
            'Accept': 'application/json, text/plain, */*',
            'Accept-Encoding': 'gzip, deflate, br, zstd',
            'Accept-Language': 'zh-CN,zh;q=0.9',
            'Connection': 'keep-alive',
            'Content-Type': 'application/json',
            'Cookie': 'SESSION=ZDBlY2JkMjMtN2Y3MS00NjFkLWExZWUtYmEzNDc4NjExNjlm; Hm_lvt_58aa18061df7855800f2a1b32d6da7f4=1758760787,1760014888,1760964085; Hm_lpvt_58aa18061df7855800f2a1b32d6da7f4=1761313154',
            'Host': 'app.jiuyangongshe.com',
            'Origin': 'https://www.jiuyangongshe.com',
            'Referer': 'https://www.jiuyangongshe.com/',
            'Sec-Fetch-Dest': 'empty',
            'Sec-Fetch-Mode': 'cors',
            'Sec-Fetch-Site': 'same-site',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',
            'platform': '3',
            'sec-ch-ua': '"Google Chrome";v="141", "Not?A_Brand";v="8", "Chromium";v="141"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-platform': '"Windows"',
            'timestamp': '1761313260317',
            'token': 'c2b06f5ce6059235d1c2f99bdfc04265'
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

    def make_api_request(self, url=None, params=None):
        """发送API请求"""
        for attempt in range(self.retry_count):
            try:
                # 更新时间戳和token（如果需要）
                current_timestamp = str(int(time.time() * 1000))
                self.headers['timestamp'] = current_timestamp
                
                # 使用指定的URL或默认URL
                request_url = url or self.api_url
                
                # 请求体
                request_body = params or {}
                
                logging.info(f"发送API请求到: {request_url}")
                
                response = self.session.post(
                    request_url, 
                    headers=self.headers, 
                    json=request_body,
                    timeout=self.timeout
                )
                response.raise_for_status()
                
                logging.info(f"API响应状态码: {response.status_code}")
                
                # 解析JSON响应
                result = response.json()
                
                return result
                
            except requests.RequestException as e:
                logging.warning(f"第{attempt + 1}次API请求失败: {e}")
                if attempt < self.retry_count - 1:
                    time.sleep(self.delay * (attempt + 1))
                else:
                    logging.error(f"所有API请求重试失败")
                    return None
            except Exception as e:
                logging.error(f"API请求过程中发生错误: {e}")
                return None

    def parse_api_data(self, api_response):
        """解析API返回的数据"""
        if not api_response or 'data' not in api_response:
            logging.error("API响应数据格式错误")
            return []
        
        stock_data = []
        
        try:
            data_list = api_response['data']
            
            for item in data_list:
                logging.info(f"解析股票数据: {item}")
                # 过滤掉无效数据
                if not item.get('name') or item.get('name') == '简图':
                    continue
                
                plate_name = item.get('name', '')
                
                # 检查是否有股票列表
                if 'list' in item and item['list']:
                    for stock_item in item['list']:
                        stock_info = self.extract_stock_info(stock_item, plate_name)
                        if stock_info:
                            stock_data.append(stock_info)
            
            logging.info(f"从API解析到 {len(stock_data)} 条股票数据")
            
        except Exception as e:
            logging.error(f"解析API数据时出错: {e}")
        
        return stock_data

    def extract_stock_info(self, stock_item, plate_name):
        """从股票项中提取股票信息"""
        try:
            stock_name = stock_item.get('name', '')
            
            # 检查是否有article和action_info
            article = stock_item.get('article', {})
            action_info = article.get('action_info', {}) if article else {}
            
            if not stock_name or not action_info:
                return None
            
            # 提取价格（需要除以100，因为API返回的是整数形式）
            price = action_info.get('price', 0)
            if price:
                price = float(price) / 100
            
            # 提取涨跌幅
            change_percent = action_info.get('shares_range', 0)
            if change_percent:
                change_percent = float(change_percent)
            
            # 提取涨停时间
            limit_up_time = action_info.get('time', '')
            
            # 提取解析内容
            analysis_text = action_info.get('expound', '')
            
            # 构建数据字典
            stock_info = {
                'plate_name': plate_name,
                'stock_name': stock_name,
                'latest_price': price,
                'change_percent': change_percent,
                'limit_up_time': limit_up_time,
                'analysis_text': analysis_text,
                'source_url': self.api_url
            }
            
            logging.info(f"解析股票数据: {stock_name} - {plate_name}")
            return stock_info
            
        except Exception as e:
            logging.warning(f"提取股票信息时出错: {e}")
            return None

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

    def get_stock_details(self, action_field_id):
        """获取特定板块的股票详情"""
        # 尝试不同的API接口来获取股票详情
        detail_urls = [
            f"https://app.jiuyangongshe.com/jystock-app/api/v1/action/list?action_field_id={action_field_id}",
            f"https://app.jiuyangongshe.com/jystock-app/api/v1/action/detail?action_field_id={action_field_id}",
            f"https://app.jiuyangongshe.com/jystock-app/api/v1/action/stock?action_field_id={action_field_id}"
        ]
        
        for url in detail_urls:
            try:
                logging.info(f"尝试获取股票详情: {url}")
                response = self.make_api_request(url=url)
                if response and 'data' in response:
                    return response
            except Exception as e:
                logging.warning(f"获取股票详情失败: {e}")
                continue
        
        return None

    def run(self):
        """运行API爬虫"""
        logging.info("开始通过API爬取九阳公社异动解析数据")
        
        # 连接数据库
        if not self.connect_database():
            return
        
        try:
            # 1. 先获取板块列表
            api_response = self.make_api_request()
            
            if api_response:
                # 保存板块列表响应
                with open('api_response.json', 'w', encoding='utf-8') as f:
                    json.dump(api_response, f, indent=2, ensure_ascii=False)
                
                # 2. 解析板块列表，获取有股票的板块
                valid_plates = []
                for item in api_response.get('data', []):
                    if item.get('count', 0) > 0 and item.get('action_field_id'):
                        valid_plates.append({
                            'name': item.get('name', ''),
                            'action_field_id': item.get('action_field_id'),
                            'count': item.get('count', 0)
                        })
                
                logging.info(f"找到 {len(valid_plates)} 个有股票的板块")
                
                # 3. 对每个有股票的板块获取详情
                all_stock_data = []
                for plate in valid_plates:
                    logging.info(f"获取板块 '{plate['name']}' 的股票详情")
                    
                    # 尝试获取股票详情
                    stock_detail_response = self.get_stock_details(plate['action_field_id'])
                    
                    if stock_detail_response:
                        # 保存详情响应
                        detail_filename = f"api_response_{plate['name']}.json"
                        with open(detail_filename, 'w', encoding='utf-8') as f:
                            json.dump(stock_detail_response, f, indent=2, ensure_ascii=False)
                        
                        # 解析股票数据
                        stock_data = self.parse_api_data(stock_detail_response, plate['name'])
                        all_stock_data.extend(stock_data)
                    else:
                        logging.warning(f"无法获取板块 '{plate['name']}' 的股票详情")
                
                # 4. 保存数据
                if all_stock_data:
                    self.save_to_database(all_stock_data)
                    self.print_summary(all_stock_data)
                else:
                    logging.warning("未解析到任何股票数据")
                    
                    # 尝试直接从板块列表解析（如果数据在板块列表中）
                    stock_data = self.parse_api_data(api_response)
                    if stock_data:
                        self.save_to_database(stock_data)
                        self.print_summary(stock_data)
            else:
                logging.error("API请求失败")
                
        except Exception as e:
            logging.error(f"API爬虫运行出错: {e}")
        
        finally:
            self.close_database()
            logging.info("API爬虫运行结束")

    def print_summary(self, stock_data):
        """打印解析结果摘要"""
        logging.info("=== 解析结果摘要 ===")
        for data in stock_data:
            logging.info(f"板块: {data['plate_name']}, 股票: {data['stock_name']}, "
                        f"价格: {data['latest_price']}, 涨跌幅: {data['change_percent']}%")
        logging.info("==================")

def main():
    """主函数"""
    spider = ApiStockSpider()
    spider.run()

if __name__ == "__main__":
    main()