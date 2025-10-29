// 1. 首先，确保导入了所需的图标
import { DeleteOutlined, DownOutlined, EditOutlined, PlusOutlined, UploadOutlined } from '@ant-design/icons';
import type { ActionType, ProColumns } from '@ant-design/pro-components';
import { DragSortTable, EditableProTable, LightFilter, ProFormDatePicker, ProFormDateRangePicker, ProFormDigitRange, ProFormText, ProTable, QueryFilter } from '@ant-design/pro-components';
import { Button, DatePicker, Flex, Form, Input, message, Modal, Popconfirm, Select, Space, Splitter, Table, Tag, Typography } from 'antd';
import React, { useState, useCallback } from 'react';
import { useEffect, useRef } from 'react';
import { getCommonData, getIsTradeDay, getLatestDate, getLatestTradeDate, importSubjectStock, updateCommonData } from '@/services/ant-design-pro/api';
import dayjs from 'dayjs';
import { formatDateToYYYYMMDD, isTradeTime } from '@/services/utils/dateUtils';
import { stockRealTimePrice } from '@/services/utils/dataRealTime';


const Subject: React.FC = () => {
  // 判断是否是交易日
  const isTradeDayRef = useRef<boolean>(false);
  // 用于存储主表数据
  const dataAll = useRef<any[]>([]);
  const actionRef = useRef<ActionType>(null);
  const [tableData, setTableData] = useState<any[]>([]);
  const [stockData, setStockData] = useState<any[]>([]);
  const stockDataRef = useRef<any[]>([]);

  const [tableTitle, setTableTitle] = useState<React.ReactNode>('题材');

  const [columns, setColumns] = useState<ProColumns<any>[]>([]);
  const [stockColumns, setStockColumns] = useState<ProColumns<any>[]>([]);

  const selectedSubjectIdRef = useRef<number>(0);
  const selectedSubjectRowRef = useRef<any>(null);
  // 2. 添加编辑对话框相关状态
  const [isEditModalVisible, setIsEditModalVisible] = useState(false);
  const [currentRecord, setCurrentRecord] = useState<any>(null);
  const [editForm] = Form.useForm();

  const [isStockModalVisible, setIsStockModalVisible] = useState(false);
  const [stockForm] = Form.useForm();

  const [isImportStockModalVisible, setIsImportStockModalVisible] = useState(false);
  const [importStockForm] = Form.useForm();

  const [isEditStockModalVisible, setIsEditStockModalVisible] = useState(false);
  const [currentStockRecord, setCurrentStockRecord] = useState<any>(null);
  const [editStockForm] = Form.useForm();

  const [plateOptions, setPlateOptions] = useState<any[]>([]);

  const timerRef = useRef<NodeJS.Timeout | null>(null);

  const latestTradeDateRef = useRef<string>('');
  // 添加排序状态
  const [sortOrder, setSortOrder] = useState<{ field: string; order: 'ascend' | 'descend' | null }>({
    field: '',
    order: null
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        const isTradetime = await getIsTradeDay();
        isTradeDayRef.current = isTradetime.data;
        // 获取最新交易日
        const latestDate = await getLatestTradeDate();
        latestTradeDateRef.current = latestDate.data;
        processDataSubject();
      } catch (error) {
        console.error('获取数据失败:', error);
      }
    };
    initColumns();
    fetchData();
  }, []);

  useEffect(() => {
    // 清除之前的定时器
    if (timerRef.current) {
      clearInterval(timerRef.current);
    }
    // 当selectedSubjectIdRef.current == 100时启动定时器
    if (selectedSubjectIdRef.current === 100) {
      // 立即执行一次
      fetchRealtimeStockData();
      if (isTradeDayRef.current && isTradeTime()) {
        timerRef.current = setInterval(fetchRealtimeStockData, 1000 * 5 * 2);
      }
    }
    // 组件卸载时清除定时器
    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current);
        timerRef.current = null;
      }
    };
  }, [selectedSubjectIdRef.current]);

  const fetchRealtimeStockData = async () => {
    if (stockDataRef.current.length === 0) {
      return;
    }
    try {
      const { priceData, avgPriceChangePercent, upCount, downCount } = await stockRealTimePrice(stockDataRef.current);
      // 用颜色标识上涨为红色，下跌为绿色
      const avgPriceChange = parseFloat(avgPriceChangePercent);
      // 为平均涨跌幅添加颜色标识
      const coloredAvgChange = (
        <span style={{
          color: avgPriceChange > 0 ? 'red' : avgPriceChange < 0 ? 'green' : 'black'
        }}>
          {avgPriceChangePercent}%
        </span>
      );

      // 更新标题
      setTableTitle(
        <>
          {selectedSubjectRowRef.current.name}（平均涨跌幅：{coloredAvgChange}），涨跌数对比 （
          <span style={{ color: 'red' }}>{upCount}上涨</span>，
          <span style={{ color: 'green' }}>{downCount}下跌</span>
          ）
        </>
      );
      // 如果有排序状态，先排序数据再更新
      let sortedData = [...priceData];
      if (sortOrder.field && sortOrder.order) {
        sortedData.sort((a, b) => {
          const field = sortOrder.field;
          const order = sortOrder.order === 'ascend' ? 1 : -1;

          if (field === 'priceChangePercent') {
            return (a.priceChangePercent - b.priceChangePercent) * order;
          }
          if (field === 'amount') {
            return (a.amount - b.amount) * order;
          }
          // 其他字段可以根据需要添加排序逻辑
          return 0;
        });
      }
      // 更新股票数据
      setStockData(sortedData);

      if (!isTradeDayRef.current || !isTradeTime()) {
        // 非交易时间，清除定时器
        if (timerRef.current) {
          clearInterval(timerRef.current);
          timerRef.current = null;
        }
      }
    } catch (error) {
      console.error('获取实时股票数据失败:', error);
    }
  };

  const initColumns = () => {
    const cols: ProColumns<any>[] = [
      {
				title: '排序',
				dataIndex: 'sort',
				width: 60,
				className: 'drag-visible',
			},
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
            <EditOutlined />
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
            <a key="delete"><DeleteOutlined /></a>
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
        render: (_) => <a href={`https://quote.eastmoney.com/${_}.html#fullScreenChart`} target="_blank">{_}</a>
      },
      {
        title: '股票名称',
        dataIndex: 'name',
      },
      {
				title: '价格',
				dataIndex: 'currentPrice',
				align: 'right',
				width: 80,
				render: (_, record) => {
					const color = record.priceChange >= 0 ? 'red' : 'green';
					return <span style={{ color }}>{record.currentPrice}</span>;
				},
			},
			{
				title: '涨跌幅',
				dataIndex: 'priceChangePercent',
				align: 'right',
				width: 80,
				sorter: (a, b) => a.priceChangePercent - b.priceChangePercent,
				render: (_, record) => {
					// 根据priceChange设置涨跌幅的颜色
					const color = record.priceChange >= 0 ? 'red' : 'green';
					return <span style={{ color }}>{record.priceChangePercent}%</span>;
				},
			},
			{
				title: '成交额',
				dataIndex: 'amount',
				align: 'right',
				width: 80,
				sorter: (a, b) => a.amount - b.amount,
				render: (_, record) => {
					// 根据priceChange设置涨跌幅的颜色
					return <span>{record.amount}亿</span>;
				},
			},
      {
				title: '总市值',
				dataIndex: 'totalMarketValue',
				align: 'right',
				width: 90,
				sorter: (a, b) => a.totalMarketValue - b.totalMarketValue,
				render: (_, record) => {
					// 根据priceChange设置涨跌幅的颜色
					return <span>{record.totalMarketValue}亿</span>;
				},
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
        render: (_, record) => {
          return record.update_at ? dayjs(record.update_at).format('YYYY-MM-DD HH:mm') : '-';
        },
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
            <EditOutlined />
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
            <a key="delete"><DeleteOutlined /></a>
          </Popconfirm>
        ],
      },
    ];
    setStockColumns(stockColumns);
  }
  const processDataSubject = async () => {
    const response = await getCommonData(100, { deleted: 0 });
    // 排序
    response.data.sort((a, b) => a.order_no - b.order_no);
    setTableData(response.data);
  };
  const handleSubjectClick = async (record: any) => {
    setTableTitle(record.name);
    if (record.subject_id) {
      const response = await getCommonData(106, { subject_id: record.subject_id, deleted: 0 });
      stockDataRef.current = response.data;
      setStockData(response.data);
      await fetchRealtimeStockData();
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
  const handleSubjectEditFormSubmit = async () => {
    try {
      const values = await editForm.validateFields();
      if (selectedSubjectIdRef.current > 0) {

        // 调用 API 更新数据
        const response = await updateCommonData(100, {
          pk: 'subject_id',
          subject_id: currentRecord.subject_id,
          t_date: latestTradeDateRef.current,
          ...values
        });

        if (response.success) {
          message.success('更新成功');

          // 更新本地表格数据
          setTableData(tableData.map(item =>
            item.subject_id === currentRecord.subject_id ? { ...item, ...values } : item
          ));
        }
      } else {
        // 新增
        const response = await updateCommonData(100, {
          t_date: latestTradeDateRef.current,
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
  const handleStockEditFormSubmit = async () => {
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
      var resp = await updateCommonData(100, { pk: 'subject_id', subject_id: subjectId, deleted: 1 });
      if (resp.success) {
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
          pk: 'code,subject_id',
          code: record.code,
          subject_id: record.subject_id,
          deleted: 1
        });
      if (resp.success) {
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
        await handleSubjectClick(selectedSubjectRowRef.current);
      }

      // 关闭对话框
      setIsStockModalVisible(false);
    } catch (error) {
      console.error('提交股票代码表单失败:', error);
      message.error('提交表单失败，请重试');
    }
  };
  // 5. 实现导入股票对话框显示函数
  const handleImportStockClick = (record: any) => {
    // 检查是否已选择主题
    if (selectedSubjectIdRef.current <= 0) {
      message.error('请先选择一个题材');
      return;
    }
    // 清空表单
    importStockForm.setFieldsValue({
      stockCodes: '',
    });
    // 显示对话框
    setIsImportStockModalVisible(true);
  };
  // 6. 实现导入股票代码提交函数，分行解析并保存
  const handleImportStockFormSubmit = async () => {
    try {
      const values = await importStockForm.validateFields();
      values.t_date = formatDateToYYYYMMDD(values.t_date);
      values.subject_id = selectedSubjectIdRef.current;
      // 调用 API 更新数据
      const response = await importSubjectStock(values);
      // 关闭对话框
      setIsImportStockModalVisible(false);
      if (response.success) {
        message.success('更新成功');
        handleSubjectClick(selectedSubjectRowRef.current);
      }
    } catch (error) {
      console.error('提交表单失败:', error);
      message.error('提交表单失败，请重试');
    }
  }
  // 选择日期之后，获取异动题材
  const handelSelectDate = async (date: any, dateString: string) => {
    console.log(date, dateString);
    setPlateOptions([]);
    const response = await getCommonData(108, { t_date: formatDateToYYYYMMDD(dateString) });
    if (response && response.data && Array.isArray(response.data)) {
      // 给 plateOptions 赋值
      const Options = response.data.map((item: any) => ({
        label: item.name,
        value: item.plate_id,
      }));
      setPlateOptions(Options);
    }
  }
  /// 处理股票代码排序结束事件
  const handleDragSortEnd = async (
      beforeIndex: number,
      afterIndex: number,
      newDataSource: any,
    ) => {
      let seq = 1;
      for (const item of newDataSource) {
        try {
          const response = await updateCommonData(100, {
            pk: 'subject_id',
            subject_id: item.subject_id,
            order_no: seq++,
          });
        }
        catch (error) {
          console.error('排序失败:', error);
          message.error('排序失败');
        }
      }
      processDataSubject();
    };
  return (
    <>
      <Modal
        title="从异动股票导入到当前题材"
        open={isImportStockModalVisible}
        onCancel={() => setIsImportStockModalVisible(false)}
        footer={[
          <Button key="cancel" onClick={() => setIsImportStockModalVisible(false)}>
            取消
          </Button>,
          <Button key="submit" type="primary" onClick={handleImportStockFormSubmit}>
            确认
          </Button>,
        ]}
        width={400}
      >
        <Form
          form={importStockForm}
          layout="vertical"
        >
          <Form.Item
            label="交易日"
            name="t_date"
            rules={[
              { required: true, message: '请选择一个交易日' },
            ]}
          >
            <DatePicker
              format="YYYY-MM-DD"
              placeholder="请选择日期"
              onChange={async (date: dayjs.Dayjs, dateString: string) => {
                await handelSelectDate(date, dateString);
              }}
            />
          </Form.Item>
          <Form.Item
            label="选择异动题材"
            name="plate_id"
            rules={[
              { required: true, message: '请选择异动题材' },
            ]}
          >
            <Select
              options={plateOptions}
              placeholder="请选择异动题材"
            />
          </Form.Item>

        </Form>
      </Modal>
      <Modal
        title="编辑题材"
        open={isEditModalVisible}
        onCancel={() => setIsEditModalVisible(false)}
        footer={[
          <Button key="cancel" onClick={() => setIsEditModalVisible(false)}>
            取消
          </Button>,
          <Button key="submit" type="primary" onClick={handleSubjectEditFormSubmit}>
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
              { required: true, message: '请输入' },
            ]}
          >
            <Select
              options={[
                { label: '主流题材', value: '主流题材' },
                { label: '大分支', value: '大分支' },
                { label: '异动', value: '异动' },
              ]}
              placeholder="请选择分类"
            />
          </Form.Item>

          <Form.Item
            label="状态"
            name="status"
            rules={[
              { required: true, message: '请选择状态' },
            ]}
          >
            <Input placeholder="请输入状态" />
            {/* <Select
              options={[
                { label: '主升浪', value: '主升浪' },
                { label: '补涨1', value: '补涨1' },
                { label: '补涨2', value: '补涨2' },
                { label: '补涨3', value: '补涨3' },
                { label: '龙头断板', value: '龙头断板' },
                { label: '退潮', value: '退潮' }
              ]}
              placeholder="请选择状态"
            /> */}
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
          <Button key="submit" type="primary" onClick={handleStockEditFormSubmit}>
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

      <Splitter style={{ height: '100%', boxShadow: '0 0 10px rgba(0, 0, 0, 0.1)' }}>
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
          <DragSortTable<any>
            rowKey='subject_id'
            actionRef={actionRef}
            columns={columns}
            dataSource={tableData}
            pagination={false}
            onRow={(record, rowIndex) => ({
              onClick: async (e) => {
                selectedSubjectIdRef.current = record.subject_id;
                selectedSubjectRowRef.current = record;
                await handleSubjectClick(record);
              },
            })}
            dragSortKey="sort"
				    onDragSortEnd={handleDragSortEnd}
            search={false}
            options={false}
            size='small'
          />
        </Splitter.Panel>
        <Splitter.Panel>
          <ProTable<any>
            headerTitle={tableTitle}
            columns={stockColumns}
            pagination={{
              showSizeChanger: true,
              showQuickJumper: true,
              defaultPageSize: 25,
              pageSizeOptions: ['25', '50', '100'],
            }}
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
                onClick={handleImportStockClick}
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