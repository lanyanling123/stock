#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
爬虫运行脚本
"""

import os
import sys

# 添加当前目录到Python路径
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from stock_spider import StockSpider

def main():
    """主函数"""
    print("开始运行九阳公社异动解析爬虫...")
    
    spider = StockSpider()
    spider.run()
    
    print("爬虫运行完成！")

if __name__ == "__main__":
    main()