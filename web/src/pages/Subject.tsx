// 1. 首先，确保导入了所需的图标
import { DownOutlined, PlusOutlined, UploadOutlined } from '@ant-design/icons';
import type { ActionType, ProColumns } from '@ant-design/pro-components';
import { EditableProTable, LightFilter, ProFormDatePicker, ProFormDateRangePicker, ProFormDigitRange, ProFormText, ProTable, QueryFilter } from '@ant-design/pro-components';
import { Button, Flex, Form, Input, message, Modal, Popconfirm, Space, Splitter, Table, Tag, Typography } from 'antd';
import React, { useState, useCallback } from 'react';
import { useEffect, useRef } from 'react';
import { getCommonData, getLatestDate,updateCommonData } from '@/services/ant-design-pro/api';


const Subject: React.FC = () => {
  // 用于存储主表数据
  const dataAll = useRef<any[]>([]);
  const [form] = Form.useForm();
  const actionRef = useRef<ActionType>(null);
  const [tableData, setTableData] = useState<any[]>([]);
  const [stockData, setStockData] = useState<any[]>([]);

  const [columns, setColumns] = useState<ProColumns<any>[]>([]);
  const [stockColumns, setStockColumns] = useState<ProColumns<any>[]>([]);

  const [editableKeys, setEditableRowKeys] = useState<React.Key[]>([]);
  const [dataSource, setDataSource] = useState<readonly any[]>([]);
  const latestDateRef = useRef<number>(0);
  const selectedSubjectIdRef = useRef<number>(0);
  
  // 2. 添加编辑对话框相关状态
  const [isEditModalVisible, setIsEditModalVisible] = useState(false);
  const [currentRecord, setCurrentRecord] = useState<any>(null);
  const [editForm] = Form.useForm();

  const [isStockModalVisible, setIsStockModalVisible] = useState(false);
  const [stockForm] = Form.useForm();
  const stockActionRef = useRef<ActionType>(null);

  const [isEditStockModalVisible, setIsEditStockModalVisible] = useState(false);
  const [currentStockRecord, setCurrentStockRecord] = useState<any>(null);
  const [editStockForm] = Form.useForm();

  useEffect(() => {
    const checkFileExists = async () => {
      try {
        const latestDate = await getLatestDate();
        latestDateRef.current = latestDate.data;
        processDataSubject();
      } catch (error) {
        console.error('获取数据失败:', error);
      }
    };
    initColumns();
    checkFileExists();
  }, []);
  const initColumns = () => {
      const cols: ProColumns<any>[] = [
      {
        title: '名称',
        dataIndex: 'name',
        render: (_) => <a>{_}</a>,
      },
      {
        title: '分类',
        dataIndex: 'tags',
      },
      {
        title: '状态',
        dataIndex: 'status',
      },
      {
        title: '操作',
        valueType: 'option',
        width: 100,
        render: (text, record, _, action) => [
          <a
            key="editable"
            onClick={() => {
                selectedSubjectIdRef.current = record.subject_id;
                handleUpdateSubject(record);
            }}
          >
            编辑
          </a>,
          // 然后，将 message.confirm 替换为 Modal.confirm
            <Popconfirm
              title="删除确认"
              description="确认删除该主题吗？"
              onConfirm={async () => {
                try {
                  await deleteSubject(record.subject_id);
                } catch (error) {
                  message.error('删除失败');
                }
              }}
              okText="确认"
              cancelText="取消"
            >
              <a key="delete">删除</a>
            </Popconfirm>
        ],
      },
    ];
    setColumns(cols);

    const stockColumns: ProColumns<any>[] = [
          {
            title: '股票代码',
            dataIndex: 'code',
            width: 100,
            render: (_) => <a>{_}</a>,
          },
          {
            title: '股票名称',
            dataIndex: 'name',
          },
                    {
            title: '所属行业',
            dataIndex: 'industry1',
          },
                    {
            title: '细分行业',
            dataIndex: 'industry2',
          },
          {
            title: '标记',
            dataIndex: 'tags',
          },
          {
            title: '更新时间',
            dataIndex: 'update_at',
          },
          {
        title: '操作',
        valueType: 'option',
        width: 100,
        render: (text, record, _, action) => [
          <a
            key="editable"
            onClick={() => {
                setCurrentStockRecord(record);
                handleUpdateStock(record);
            }}
          >
            编辑
          </a>,
          // 然后，将 message.confirm 替换为 Modal.confirm
            <Popconfirm
              title="删除确认"
              description="确认删除该股票吗？"
              onConfirm={async () => {
                try {
                  await deleteStock(record);
                } catch (error) {
                  message.error('删除失败');
                }
              }}
              okText="确认"
              cancelText="取消"
            >
              <a key="delete">删除</a>
            </Popconfirm>
        ],
      },
        ];
    setStockColumns(stockColumns);
  }
  const processDataSubject = async () => {
    const response = await getCommonData(100,{deleted:0});
    setTableData(response.data);
  };
  const handleSubjectClick = async() => {
    if (selectedSubjectIdRef.current) {
        const response = await getCommonData(106,{subject_id:selectedSubjectIdRef.current,deleted:0});
        setStockData(response.data);
    }
  };
  // 3. 完善 handleUpdateSubject 函数
  const handleUpdateSubject = async (record: any) => {
    setCurrentRecord(record);
    editForm.setFieldsValue({
      name: record.name,
      tags: record.tags,
      status: record.status,
    });
    setIsEditModalVisible(true);
  };
  // 编辑股票
  const handleUpdateStock = async (record: any) => {
    editStockForm.setFieldsValue({
      tags: record.tags
    });
    setIsEditStockModalVisible(true);
  };
  // 4. 添加表单提交处理函数
  const handleEditFormSubmit = async () => {
    try {
      const values = await editForm.validateFields();
      if(selectedSubjectIdRef.current > 0){

        // 调用 API 更新数据
        const response = await updateCommonData(100, {
          pk: 'subject_id',
          subject_id: currentRecord.subject_id,
          ...values
        });
        
        if (response.success) {
          message.success('更新成功');
          
          // 更新本地表格数据
          setTableData(tableData.map(item => 
            item.subject_id === currentRecord.subject_id ? { ...item, ...values } : item
          ));
        }
      }else{
          // 新增
          const response = await updateCommonData(100, {
            ...values
          });
          if (response.success) {
            message.success('新增成功');
            // 新增本地表格数据
            processDataSubject();
          }
      }
        // 关闭对话框
        setIsEditModalVisible(false);
    } catch (error) {
      console.error('提交表单失败:', error);
      message.error('提交表单失败，请重试');
    }
  };
  const handleEditStockFormSubmit = async()=>{
    try {
      const values = await editStockForm.validateFields();
        // 调用 API 更新数据
        const response = await updateCommonData(101, {
          pk: 'code,subject_id',
          code: currentStockRecord.code,
          subject_id: currentStockRecord.subject_id,
          ...values
        });
        if (response.success) {
          message.success('更新成功');
          // 更新本地表格数据
          setStockData(stockData.map(item => 
            item.code === currentStockRecord.code ? { ...item, ...values } : item
          ));
        }
      // 关闭对话框
      setIsEditStockModalVisible(false);
    } catch (error) {
      console.error('提交表单失败:', error);
      message.error('提交表单失败，请重试');
    }
  }
  // 删除主题
  const deleteSubject = async (subjectId: number) => {
    try {
       var resp = await updateCommonData(100,{pk:'subject_id',subject_id:subjectId,deleted:1});
       if(resp.success){
        message.success('删除成功');
        setTableData(tableData.filter((item) => item.subject_id !== subjectId));
       }
    } catch (error) {
      message.error('删除失败');
    }
  };
    // 删除股票
  const deleteStock = async (record: any) => {
    try {
       var resp = await updateCommonData(101,
        {
          pk:'code,subject_id',
          code:record.code,
          subject_id:record.subject_id,
          deleted:1
        });
       if(resp.success){
        message.success('删除成功');
        setStockData(stockData.filter((item) => item.code !== record.code));
       }
    } catch (error) {
      message.error('删除失败');
    }
  };
  // 3. 实现新增股票对话框显示函数
  const handleNewStockClick = () => {
          // 检查是否已选择主题
      if (selectedSubjectIdRef.current <= 0) {
        message.error('请先选择一个主题');
        return;
      }
    // 清空表单
    stockForm.setFieldsValue({
      stockCodes: '',
    });
    // 显示对话框
    setIsStockModalVisible(true);
  };

  // 4. 实现股票代码提交函数，分行解析并保存
  const handleStockFormSubmit = async () => {
    try {
      const values = await stockForm.validateFields();
      // 分行解析股票代码
      const stockCodes = values.stockCodes
        .split('\n') // 按换行符分割
        .map(code => code.trim()) // 去除首尾空格
        .filter(code => code.length > 0); // 过滤空行
      
      if (stockCodes.length === 0) {
        message.error('请输入股票代码');
        return;
      }
      // 批量处理股票代码保存
      const successStockCodes = [];
      const failedStockCodes = [];
      
      for (const code of stockCodes) {
        try {
          // 调用 API 保存单个股票代码
          const response = await updateCommonData(101, {
            subject_id: selectedSubjectIdRef.current,
            code: code,
          });
          
          if (response.success) {
            successStockCodes.push(code);
          } else {
            failedStockCodes.push(code);
          }
        } catch (error) {
          console.error(`保存股票代码 ${code} 失败:`, error);
          failedStockCodes.push(code);
        }
      }
      
      // 显示结果提示
      if (successStockCodes.length > 0) {
        message.success(`成功保存 ${successStockCodes.length} 个股票代码`);
      }
      
      if (failedStockCodes.length > 0) {
        message.error(`有 ${failedStockCodes.length} 个股票代码保存失败: ${failedStockCodes.join(', ')}`);
      }
      
      // 刷新股票列表
      if (selectedSubjectIdRef.current > 0) {
        await handleSubjectClick();
      }
      
      // 关闭对话框
      setIsStockModalVisible(false);
    } catch (error) {
      console.error('提交股票代码表单失败:', error);
      message.error('提交表单失败，请重试');
    }
  };

  return (
    <>
      <Modal
        title="编辑主题"
        open={isEditModalVisible}
        onCancel={() => setIsEditModalVisible(false)}
        footer={[
          <Button key="cancel" onClick={() => setIsEditModalVisible(false)}>
            取消
          </Button>,
          <Button key="submit" type="primary" onClick={handleEditFormSubmit}>
            确认
          </Button>,
        ]}
        width={400}
      >
        <Form
          form={editForm}
          layout="horizontal"
          initialValues={{ size: 'default' }}
        >
          <Form.Item
            label="名称"
            name="name"
            rules={[
              { required: true, message: '请输入名称' },
            ]}
          >
            <Input placeholder="请输入主题名称" />
          </Form.Item>
          
          <Form.Item
            label="分类"
            name="tags"
            rules={[
              { required: true, message: '请输入分类' },
            ]}
          >
            <Input placeholder="请输入分类标签" />
          </Form.Item>
          
          <Form.Item
            label="状态"
            name="status"
            rules={[
              { required: true, message: '请选择状态' },
            ]}
          >
            <Input placeholder="请输入状态" />
          </Form.Item>
        </Form>
      </Modal>
      <Modal
        title="新增股票"
        open={isStockModalVisible}
        onCancel={() => setIsStockModalVisible(false)}
        footer={[
          <Button key="cancel" onClick={() => setIsStockModalVisible(false)}>
            取消
          </Button>,
          <Button key="submit" type="primary" onClick={handleStockFormSubmit}>
            确认
          </Button>,
        ]}
        width={400}
      >
        <Form
          form={stockForm}
          layout="vertical"
        >
          <Form.Item
            label="股票代码（每行一个）"
            name="stockCodes"
            rules={[
              { required: true, message: '请输入股票代码' },
            ]}
          >
            <Input.TextArea
              placeholder="请输入股票代码，每行一个"
              rows={10}
              maxLength={1000}
              showCount
            />
          </Form.Item>
          
          <div style={{ fontSize: '12px', color: '#999', marginTop: 10 }}>
            <p>提示：</p>
            <p>1. 请先在左侧选择一个主题</p>
            <p>2. 股票代码请每行输入一个</p>
            <p>3. 系统将自动解析并保存所有有效的股票代码</p>
          </div>
        </Form>
      </Modal>

      <Modal
        title="编辑股票"
        open={isEditStockModalVisible}
        onCancel={() => setIsEditStockModalVisible(false)}
        footer={[
          <Button key="cancel" onClick={() => setIsEditStockModalVisible(false)}>
            取消
          </Button>,
          <Button key="submit" type="primary" onClick={handleEditStockFormSubmit}>
            确认
          </Button>,
        ]}
        width={400}
      >
        <Form
          form={editForm}
          layout="horizontal"
          initialValues={{ size: 'default' }}
        >
          <Form.Item
            label="名称"
            name="name"
            rules={[
              { required: true, message: '请输入名称' },
            ]}
          >
            <Input placeholder="请输入主题名称" />
          </Form.Item>
          
          <Form.Item
            label="标注"
            name="tags"
            rules={[
              { required: true, message: '请输入标注' },
            ]}
          >
            <Input placeholder="请输入标注" />
          </Form.Item>
        </Form>
      </Modal>

      <Splitter style={{ height: 200, boxShadow: '0 0 10px rgba(0, 0, 0, 0.1)' }}>
    <Splitter.Panel defaultSize="30%" min="20%" max="40%">
      <Space>
        <Button
          size='small'
          color="primary" 
          variant="filled"
          onClick={() => {
             // 弹出新建主题对话框
             selectedSubjectIdRef.current = 0;
             setIsEditModalVisible(true);
             // 清空表单值
             editForm.setFieldsValue({
              name: '',
              tags: '',
              status: '',
             });
          }}
          icon={<PlusOutlined />}
        >
          新建一行
        </Button>
      </Space>
      <ProTable<any> 
      rowKey='subject_id'
      actionRef={actionRef}
      columns={columns} 
      dataSource={tableData}
      onRow={(record, rowIndex) => ({
        onClick: async (e) => {
          selectedSubjectIdRef.current = record.subject_id;
          await handleSubjectClick();
        },
      })}
      pagination={false}
        search={false}
        options={false}
        size='small'
       />
    </Splitter.Panel>
    <Splitter.Panel>
      <ProTable<any> 
      columns={stockColumns} 
      pagination={false}
        search={false}
        options={false}
        size='small'
       dataSource={stockData} 
       toolBarRender={() => [
        <Button
          key="newbutton"
          color="primary" 
          variant="filled"
          icon={<PlusOutlined />}
          size='small'
          onClick={handleNewStockClick}
        >
          新增股票
        </Button>,
        <Button
          key="importbutton"
          color="primary" 
          variant="filled"
          size='small'
          icon={<UploadOutlined />}
          onClick={() => {
            actionRef.current?.reload();
          }}
        >
          导入股票
        </Button>,
      ]}
       />
    </Splitter.Panel>
  </Splitter>
  </>
  );
};

export default Subject;