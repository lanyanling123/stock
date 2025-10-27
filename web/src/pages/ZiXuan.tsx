// 1. 首先，确保导入了所需的图标
import { DownOutlined, FilterOutlined, PlusOutlined, UploadOutlined } from '@ant-design/icons';
import type { ActionType, ProColumns } from '@ant-design/pro-components';
import { EditableProTable, LightFilter, ProFormDatePicker, ProFormDateRangePicker, ProFormDigitRange, ProFormRadio, ProFormText, ProTable, QueryFilter } from '@ant-design/pro-components';
import { Button, DatePicker, Flex, Form, Input, message, Modal, Popconfirm, Radio, RadioChangeEvent, Space, Splitter, Table, TableColumnsType, Tag, Typography } from 'antd';
import React, { useState, useCallback, Children } from 'react';
import { useEffect, useRef } from 'react';
import { getCommonData, getLatestDate, updateCommonData, getTradeDate,importSelfStock } from '@/services/ant-design-pro/api';
import { SelectCommonPlacement } from 'antd/es/_util/motion';
import { formatDateToYYYYMMDD, formatYYYYMMDDToStr, formatYYYYMMDDToDate, transformStockData } from '@/services/utils/dateUtils';
import dayjs from 'dayjs';
import customParseFormat from 'dayjs/plugin/customParseFormat';

dayjs.extend(customParseFormat);
const dateFormat = 'YYYY-MM-DD';
const ZiXuan: React.FC = () => {
	// 用于存储主表数据
	const dataAll = useRef<any[]>([]);
	const [form] = Form.useForm();
	const actionRef = useRef<ActionType>(null);
	const [stockData, setStockData] = useState<any[]>([]);

	const [stockColumns, setStockColumns] = useState<ProColumns<any>[]>([]);

	const latestDateRef = useRef<number>(0);
	const tradeDateRef = useRef<[]>([]);

	const selectedSubjectIdRef = useRef<number>(0);
	const [selectedSubjectId, setSelectedSubjectId] = useState<number>(0);
	// 2. 添加编辑对话框相关状态
	const [editForm] = Form.useForm();

	const [isStockModalVisible, setIsStockModalVisible] = useState(false);
	const [stockForm] = Form.useForm();
	const stockActionRef = useRef<ActionType>(null);

	const [isEditStockModalVisible, setIsEditStockModalVisible] = useState(false);
	const [currentStockRecord, setCurrentStockRecord] = useState<any>(null);
	const [editStockForm] = Form.useForm();

	const [isImportStockModalVisible, setIsImportStockModalVisible] = useState(false);
	const [importStockForm] = Form.useForm();

	// 2. 添加选项数据状态
	const [placementOptions, setPlacementOptions] = useState<[]>([]);
	// 3. 添加查询参数状态
	const searchParmasRef = useRef<any>(null);

	// 在组件顶部定义状态
	const [dateRange, setDateRange] = useState<[dayjs.Dayjs, dayjs.Dayjs]>([
		dayjs().subtract(5, 'day'),
		dayjs()
	]);

	useEffect(() => {
		const checkFileExists = async () => {
			try {
				const latestDate = await getLatestDate();
				latestDateRef.current = latestDate.data;
				const tradeDate = await getTradeDate({ days: 5 });
				tradeDateRef.current = tradeDate.data;

				if (tradeDateRef.current && tradeDateRef.current.length > 0) {
					setDateRange([
						dayjs(formatYYYYMMDDToStr(tradeDateRef.current[4].T_date), dateFormat),
						dayjs(formatYYYYMMDDToStr(tradeDateRef.current[0].T_date), dateFormat)
					]);
				}
				getPlacementOptions();
			} catch (error) {
				console.error('获取数据失败:', error);
			}
		};
		initColumns();
		checkFileExists();
	}, []);
	const initColumns = () => {
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
				title: '辨识度',
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

	// 获取放置位置选项的API函数
	const getPlacementOptions = async () => {
		try {
			const response = await getCommonData(100, { deleted: 0 });
			const placementOptions = [{ label: '辨识度', value: 100 }, ...response.data.map((item: any) => ({
				value: item.subject_id,
				label: item.name,
			}))];
			setPlacementOptions(placementOptions);
			handleQueryClick({
				subject_id: 100, t_date: [
					dayjs(formatYYYYMMDDToStr(tradeDateRef.current[4].T_date), dateFormat),
					dayjs(formatYYYYMMDDToStr(tradeDateRef.current[0].T_date), dateFormat)]
			});
		} catch (error) {
			console.error('获取放置位置选项失败:', error);
		}
	};

	// 编辑股票
	const handleUpdateStock = async (record: any) => {
		editStockForm.setFieldsValue({
			tags: record.tags
		});
		setIsEditStockModalVisible(true);
	};
	const handleEditStockFormSubmit = async () => {
		try {
			const values = await editStockForm.validateFields();
			const params = {
				pk: 'code,subject_id,t_date',
				code: currentStockRecord.code,
				subject_id: currentStockRecord.subject_id,
				t_date: currentStockRecord.t_date,
			}
			if (values.tags) {
				params.tags = values.tags;
				params.flag = 1;
			} else {
				params.flag = 0;
			}
			// 调用 API 更新数据
			const response = await updateCommonData(105, params);
			if (response.success) {
				message.success('更新成功');
				handleQueryClick(searchParmasRef.current);
			}
			// 关闭对话框
			setIsEditStockModalVisible(false);
		} catch (error) {
			console.error('提交表单失败:', error);
			message.error('提交表单失败，请重试');
		}
	}
	// 删除股票
	const deleteStock = async (record: any) => {
		try {
			var resp = await updateCommonData(105,
				{
					pk: 'code,subject_id,t_date',
					code: record.code,
					subject_id: record.subject_id,
					t_date: record.t_date,
					deleted: 1
				});
			if (resp.success) {
				message.success('删除成功');
				handleQueryClick(searchParmasRef.current);
			}
		} catch (error) {
			message.error('删除失败');
		}
	};
	// 3. 实现新增股票对话框显示函数
	const handleNewStockClick = () => {
		// 清空表单
		stockForm.setFieldsValue({
			stockCodes: '',
			t_date: dayjs(formatYYYYMMDDToStr(latestDateRef.current), dateFormat)
		});
		// 显示对话框
		setIsStockModalVisible(true);
	};

	const handelImportSelfStock = async () => {
		importStockForm.setFieldsValue({
			t_date1: dayjs(formatYYYYMMDDToStr(tradeDateRef.current[1].T_date), dateFormat),
			t_date2: dayjs(formatYYYYMMDDToStr(tradeDateRef.current[0].T_date), dateFormat),
		});
		setIsImportStockModalVisible(true);
	}
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
			const existCodes = dataAll.current.filter((item: any) => item.t_date == formatDateToYYYYMMDD(values.t_date));
			// 批量处理股票代码保存
			const successStockCodes = [];
			const failedStockCodes = [];

			// 序号
			var seq = existCodes.length + 1;
			for (const code of stockCodes) {
				try {
					if (existCodes.some((item: any) => item.code === code)) {
						continue;
					}
					// 调用 API 保存单个股票代码
					const response = await updateCommonData(105, {
						subject_id: selectedSubjectIdRef.current,
						code: code,
						t_date: formatDateToYYYYMMDD(values.t_date),
						order_no: seq++
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
				handleQueryClick(searchParmasRef.current);
			}

			if (failedStockCodes.length > 0) {
				message.error(`有 ${failedStockCodes.length} 个股票代码保存失败: ${failedStockCodes.join(', ')}`);
			}
			// 关闭对话框
			setIsStockModalVisible(false);
		} catch (error) {
			console.error('提交股票代码表单失败:', error);
			message.error('提交表单失败，请重试');
		}
	};
	// 导入自选股票
	const handleImportStockFormSubmit = async () => {
		try {
			const values = await importStockForm.validateFields();
			const params = {
				subjectid: selectedSubjectIdRef.current,
				date1: values.t_date1.hasOwnProperty('$d') ? formatDateToYYYYMMDD(values.t_date1) : tradeDateRef.current[1].T_date,
				date2: values.t_date2.hasOwnProperty('$d') ? formatDateToYYYYMMDD(values.t_date2) : tradeDateRef.current[0].T_date,
			}
			// 调用 API 导入自选股票
			const response = await importSelfStock(params);
			if (response.success) {
				message.success('导入成功');
				handleQueryClick(searchParmasRef.current);
			}
			// 关闭对话框
			setIsImportStockModalVisible(false);
		} catch (error) {
			console.error('提交导入股票代码表单失败:', error);
			message.error('提交表单失败，请重试');
		}
	}
	/// 查询股票
	const handleQueryClick = async (values: any) => {
		try {
			console.log(values);
			// 保存查询参数
			searchParmasRef.current = values;
			selectedSubjectIdRef.current = values.subject_id;
			setSelectedSubjectId(values.subject_id);
			if (values.t_date) {
				if (Array.isArray(values.t_date)) {
					// 如果是数组，检查每个元素的类型
					values.t_date = values.t_date.map((date: any, index: number) => {
						if (index == 0) {
							return date.hasOwnProperty('$d') ? formatDateToYYYYMMDD(date) : tradeDateRef.current[4].T_date;
						} else {
							return date.hasOwnProperty('$d') ? formatDateToYYYYMMDD(date) : tradeDateRef.current[0].T_date;
						}
					});
				} else {
					// 单个日期处理
					values.t_date = formatDateToYYYYMMDD(values.t_date);
				}
			} else {
				// 给默认值
				values.t_date = latestDateRef.current;
			}
			if (values.subject_id === 100) {
				delete values.subject_id;
				values.flag = 1;
			}
			const response = await getCommonData(107, values);
			if (response.success) {
				// 从新定义列
				const colsRedef: ProColumns[] = [];
				for (const col of response.data) {
					if (colsRedef.find((item: any) => item.dataIndex === col.t_date)) {
						continue;
					}
					colsRedef.push(
						{
							dataIndex: col.t_date, title: col.t_date, children: [
								{ dataIndex: col.t_date + '_code', title: '代码' },
								{ dataIndex: col.t_date + '_name', title: '名称' },
								{ dataIndex: col.t_date + '_tags', title: '辨识度' },
							]
						});
				}
				// console.log('列定义', colsRedef);
				setStockColumns(colsRedef);
				// 对数据进行行转列处理
				// const mockData: StockData[] = [
				// { t_date: '20251024', code: '002050', name: '三花智控', tags: '容量' },
				// { t_date: '20251023', code: '301038', name: '深水规院', tags: '容量' },
				// { t_date: '20251023', code: '002049', name: '紫光国微', tags: '容量' },
				// { t_date: '20251023', code: '688008', name: '澜起科技', tags: '容量' },
				// { t_date: '20251023', code: '603986', name: '兆易创新', tags: '容量' },
				// ];
				dataAll.current = response.data;
				const transformedData = transformStockData(response.data);
				// console.log('转换后的数据列名:', Object.keys(transformedData[0]));
				// console.log('转换后的数据:');
				// console.table(transformedData);
				setStockData(transformedData);
			} else {
				message.error('查询失败');
			}
			console.log(values);
		} catch (error) {
			console.error('查询股票失败:', error);
			message.error('查询股票失败，请重试');
		}
	};
	return (
		<>
			<Modal
				title="新增自选股"
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
						label="交易日"
						name="t_date"
						rules={[
							{ required: true, message: '请选择一个交易日' },
						]}
					>
						<DatePicker
							format="YYYY-MM-DD"
							placeholder="请选择日期"
						/>
					</Form.Item>
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
				title="导入自选股"
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
						label="从交易日"
						name="t_date1"
						rules={[
							{ required: true, message: '请选择一个交易日' },
						]}
					>
						<DatePicker
							format="YYYY-MM-DD"
							placeholder="请选择日期"
						/>

					</Form.Item>

					<Form.Item
						label="到交易日"
						name="t_date2"
						rules={[
							{ required: true, message: '请选择一个交易日' },
						]}
					>
						<DatePicker
							format="YYYY-MM-DD"
							placeholder="请选择日期"
						/>
					</Form.Item>
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
						label="股票名称"
						name="name"
						rules={[
							{ required: true, message: '请输入股票名称' },
						]}
					>
						<Input disabled placeholder="请输入主题名称" />
					</Form.Item>

					<Form.Item
						label="辨识度"
						name="tags"
					>
						<Input placeholder="请输入辨识度" />
					</Form.Item>
				</Form>
			</Modal>

			<LightFilter
				initialValues={{
					subject_id: 'bsd',
					t_date: dateRange
				}}
				bordered
				collapseLabel={<FilterOutlined />}
				onFinish={handleQueryClick}
			>
				<ProFormRadio.Group
					name="subject_id"
					radioType="button"
					options={placementOptions}
				/>
				<ProFormDateRangePicker name="t_date" label="日期范围" placeholder="日期范围" />
			</LightFilter>

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
						disabled={selectedSubjectId <= 100}
						icon={<PlusOutlined />}
						size='small'
						onClick={handleNewStockClick}
					>
						加自选股票
					</Button>,
					<Button
						key="importbutton"
						color="primary"
						variant="filled"
						size='small'
						disabled={selectedSubjectId <= 100}
						icon={<UploadOutlined />}
						onClick={handelImportSelfStock}
					>
						导入自选股票
					</Button>,
				]}
			/>
		</>
	);
};

export default ZiXuan;

