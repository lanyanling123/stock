import React, { useEffect } from 'react';
import { PageContainer } from '@ant-design/pro-components';
import { Input, Button } from 'antd';
import { useEffect, useRef } from 'react';

const IndexSH: React.FC = () => {
  const iframeRef = useRef<HTMLIFrameElement>(null);
  const [inputValue, setInputValue] = React.useState('');

  // 组件加载时的逻辑
  useEffect(() => {
    // 如果需要在组件加载时执行一些逻辑
    // 例如检查kline_index_edit.html是否存在
    const checkFileExists = async () => {
      try {
        const response = await fetch('/kline_index_edit.html');
        if (!response.ok) {
          console.warn('kline_index_edit.html 文件不存在，请确保文件位于public目录下');
        }
      } catch (error) {
        console.error('检查kline_index_edit.html文件时出错:', error);
      }
    };

    checkFileExists();
  }, []);

    // 处理输入变化
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(e.target.value);
  };
  // 处理股票代码输入和传递
  const handleCodeSubmit = () => {
    console.log('liquanchun 点击了切换股票按钮');
    const stockCode = inputValue.trim();
    console.log('liquanchun 提交的股票代码:', stockCode);
    if (stockCode && iframeRef.current?.contentWindow) {
      // 向iframe发送股票代码
      iframeRef.current.contentWindow.postMessage({
        type: 'SET_STOCK_CODE',
        code: stockCode
      }, '*');
    }
  };

  return (
    <div style={{ width: '100%', height: '100vh', overflow: 'hidden' }}>
      <div style={{ marginBottom: 1, padding: '5px' }}>
        <Input
          value={inputValue}
          onChange={handleInputChange}
          placeholder="请输入股票代码，例如：600000.sh"
          style={{ width: 200, marginRight: '10px' }}
          onPressEnter={handleCodeSubmit}
        />
        <Button type="primary" onClick={handleCodeSubmit}>
          切换股票
        </Button>
      </div>
      <iframe
        ref={iframeRef}
        src="/kline_index_edit.html"
        style={{
          width: '100%',
          height: 'calc(100% - 70px)',
          border: 'none',
        }}
        frameBorder="0"
      />
    </div>
  );
};

export default IndexSH;