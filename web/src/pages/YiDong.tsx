import { DownOutlined } from '@ant-design/icons';
import type { ProColumns } from '@ant-design/pro-components';
import { LightFilter, ProFormDatePicker, ProFormDateRangePicker, ProFormDigitRange, ProFormText, ProTable, QueryFilter } from '@ant-design/pro-components';
import { Button, Tag } from 'antd';
import React, { useState, useCallback } from 'react';
import { useEffect, useRef } from 'react';
import { getCommonData, getLatestDate } from '@/services/ant-design-pro/api';
import { formatDateToYYYYMMDD } from '@/services/utils/dateUtils';
const columns: ProColumns<any>[] = [
  {
    title: '日期',
    dataIndex: 't_date',
    render: (_) => <a>{_}</a>,
  },
  {
    title: '题材',
    dataIndex: 'plate_name',
    width: 100,
  },
  {
    title: '涨停数量',
    dataIndex: 'zt_count',
    width: 90,
    sorter: (a, b) => a.zt_count - b.zt_count,
  },
  {
    title: '分析原因',
    dataIndex: 'reason',
  },

];

const YiDong: React.FC = () => {
  // 用于存储主表数据
  const dataAll = useRef<any[]>([]);
  const [tableData, setTableData] = useState<any[]>([]);
  // 用于存储每个展开行的数据，使用行ID作为key
  const [expandedRowData, setExpandedRowData] = useState<Record<string, any[]>>({});
  // 用于存储加载状态
  const [expandedRowLoading, setExpandedRowLoading] = useState<Record<string, boolean>>({});
  
  // 用于存储查询参数
  const [searchParams, setSearchParams] = useState<any>({});

  const latestDateRef = useRef<number>(0);

  // 重构: 创建一个通用函数来处理数据格式化和设置
  const processData = (data: any[]) => {
    dataAll.current = data;
    // 遍历数据，为每一行添加唯一的key
    const parentData: any[] = [];
    data.forEach((item: any, index: number) => {
      const parentItem = parentData.find(
        (parentItem: any) => parentItem.plate_name === item.plate_name && parentItem.t_date === item.t_date
      );
      if (!parentItem) {
        parentData.push({
          ...item,
          key: `${item.plate_name}-${item.t_date}-${index}`, // 确保key唯一
        });
      }
    });
    setTableData(parentData);
  };

  useEffect(() => {
    const checkFileExists = async () => {
      try {
        const latestDate = await getLatestDate();
        latestDateRef.current = latestDate.data;
        const response = await getCommonData(104, { t_date: latestDate.data });
        
        if (response && response.data && Array.isArray(response.data)) {
          // 使用重构后的函数处理数据
          processData(response.data);
        }
      } catch (error) {
        console.error('获取数据失败:', error);
      }
    };

    checkFileExists();
  }, []);
  
  // 处理查询提交的函数
  const handleSearch = async (values: any) => {
    try {
      setSearchParams(values);
      // 调用API获取数据，传递查询参数
     if(values.t_date){
       if (Array.isArray(values.t_date)) {
          // 如果是数组，检查每个元素的类型
          values.t_date = values.t_date.map((date: any) => {
            return formatDateToYYYYMMDD(date);
          });
        } else {
          // 单个日期处理
          values.t_date = formatDateToYYYYMMDD(values.t_date);
        }
      }else{
        // 给默认值
        values.t_date = latestDateRef.current;
      }
      // 改成模糊查询
      if(values.plate_name){
        values.plate_name = `%${values.plate_name.trim()}%`;
      }
      if(values.name){
        values.name = `%${values.name.trim()}%`;
      }
      console.log('查询参数:', values);
      const response = await getCommonData(104, values);
      
      if (response && response.data && Array.isArray(response.data)) {
        // 使用重构后的函数处理数据
        processData(response.data);
      }
    } catch (error) {
      console.error('查询数据失败:', error);
    }
  };
  // 用于获取展开行数据的函数
  const fetchExpandedRowData = useCallback(async (record: any) => {
    // 设置当前行的加载状态为true
    setExpandedRowLoading(prev => ({
      ...prev,
      [record.plate_id]: true
    }));
    
    try {
        console.log('获取展开行数据 for record:', record);
        setExpandedRowData(prev => ({
          ...prev,
          [record.plate_id]: dataAll.current.filter((item: any) => item.plate_id === record.plate_id)
        }));
    } catch (error) {
      console.error('获取展开行数据失败:', error);
    } finally {
      // 设置当前行的加载状态为false
      setExpandedRowLoading(prev => ({
        ...prev,
        [record.plate_id]: false
      }));
    }
  }, []);
  
  return (
    <div>
    <LightFilter layout="horizontal" bordered  size="middle"
      onFinish={handleSearch}>
      <ProFormText name="plate_name" label="题材" 
        labelCol={{ span: 8 }} 
        wrapperCol={{ span: 16 }} />
      <ProFormDateRangePicker name="t_date" label="日期"
      />
      <ProFormText name="name" label="股票" 
        labelCol={{ span: 8 }} 
        wrapperCol={{ span: 16 }} />
      <ProFormDigitRange
              label="涨停数量"
              name="zt_count"
              separator="-"
              placeholder={['最小值', '最大值']}
              separatorWidth={30}
              labelCol={{ span: 8 }} 
              wrapperCol={{ span: 16 }} />
    </LightFilter>
    <ProTable<any>
      columns={columns}
      request={() => {
        return Promise.resolve({
          data: tableData,
          success: true,
        });
      }}
      dataSource={tableData}
      size="small"
      rowKey="key"
      pagination={false}
      expandable={{
        expandedRowRender: (record) => (
          <ExpandedContent 
            record={record} 
            fetchData={fetchExpandedRowData} 
            data={expandedRowData[record.plate_id] || []}
            loading={expandedRowLoading[record.plate_id] || false}
          />
        )
      }}
      search={false}
      dateFormatter="string"
      headerTitle="涨停题材列表"
      options={false}
    />
    </div>
  );
};

// 创建一个独立的展开内容组件来正确使用useEffect
const ExpandedContent: React.FC<{
  record: any;
  fetchData: (record: any) => void;
  data: any[];
  loading: boolean;
}> = ({ record, fetchData, data, loading }) => {
  useEffect(() => {
    fetchData(record);
  }, [record, fetchData]);

  return (
    <ProTable
      columns={[
        { title: '股票代码', dataIndex: 'code', key: 'code' },
        { title: '股票名称', dataIndex: 'name', key: 'name' },
        { title: '价格', dataIndex: 'price', key: 'price' },
        { title: '涨停时间', dataIndex: 'time', key: 'time' },
        { title: '涨停天数', dataIndex: 'day', key: 'day' },
        { title: '几天几板', dataIndex: 'num', key: 'num' },
      ]}
      size="small"
      headerTitle={false}
      search={false}
      options={false}
      dataSource={data}
      pagination={false}
      loading={loading}
    />
  );
};

export default YiDong;