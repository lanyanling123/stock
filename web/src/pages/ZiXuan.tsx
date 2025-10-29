// 1. 首先，确保导入了所需的图标
import { DeleteOutlined, DownOutlined, EditOutlined, FilterOutlined, PlusOutlined, UploadOutlined } from '@ant-design/icons';
import type { ActionType, ProColumns } from '@ant-design/pro-components';
import { DragSortTable, EditableProTable, LightFilter, ProFormDatePicker, ProFormDateRangePicker, ProFormDigitRange, ProFormRadio, ProFormText, ProTable, QueryFilter } from '@ant-design/pro-components';
import { Button, DatePicker, Flex, Form, Input, message, Modal, Popconfirm, Radio, RadioChangeEvent, Select, Space, Splitter, Table, TableColumnsType, Tag, Typography } from 'antd';
import React, { useState, useCallback, Children } from 'react';
import { useEffect, useRef } from 'react';
import {
	getCommonData, getLatestDate, updateCommonData,
	getTradeDate, importSelfStock, deleteSelfStock, 
	getIsTradeDay
} from '@/services/ant-design-pro/api';
import { SelectCommonPlacement } from 'antd/es/_util/motion';
import { formatDateToYYYYMMDD, formatYYYYMMDDToStr, formatYYYYMMDDToDate, transformStockData, stockCode2, isTradeTime } from '@/services/utils/dateUtils';
import dayjs from 'dayjs';
import customParseFormat from 'dayjs/plugin/customParseFormat';
import { stockRealTimePrice } from '@/services/utils/dataRealTime';

dayjs.extend(customParseFormat);
const dateFormat = 'YYYY-MM-DD';
const ZiXuan: React.FC = () => {
	// 判断是否是交易日
	const isTradeDayRef = useRef<boolean>(false);
	const [filterForm] = Form.useForm();
	// 所有原始数据
	const dataAll = useRef<any[]>([]);
	// 表格显示数据
	const [stockData, setStockData] = useState<any[]>([]);

	// 需要获取实时行情的数据
	const realtimeDataRef = useRef<any[]>([]);
	// 表格列定义
	const [stockColumns, setStockColumns] = useState<ProColumns<any>[]>([]);

	const newestTradeDateRef = useRef<number>(0);
	const tradeDateRef = useRef<[]>([]);

	const selectedSubjectIdRef = useRef<number>(0);
	const [selectedSubjectId, setSelectedSubjectId] = useState<number>(0);

	const [isStockModalVisible, setIsStockModalVisible] = useState(false);
	const [stockForm] = Form.useForm();

	const [isEditStockModalVisible, setIsEditStockModalVisible] = useState(false);
	const [currentStockRecord, setCurrentStockRecord] = useState<any>(null);
	const [editStockForm] = Form.useForm();

	const [isImportStockModalVisible, setIsImportStockModalVisible] = useState(false);
	const [importStockForm] = Form.useForm();

	const [tableTitle, setTableTitle] = useState<React.ReactNode>('');
	// 主流题材标签数据
	const [mainSubjectOptions, setMainSubjectOptions] = useState<any[]>([]);
	// 3. 添加查询参数状态
	const searchParmasRef = useRef<any>(null);

	const timerRef = useRef<NodeJS.Timeout | null>(null);

	// 添加排序状态
	const [sortOrder, setSortOrder] = useState<{ field: string; order: 'ascend' | 'descend' | null }>({
		field: '',
		order: null
	});
	// 在组件顶部定义状态
	const [dateRange, setDateRange] = useState<[dayjs.Dayjs, dayjs.Dayjs]>([
		dayjs().subtract(5, 'day'),
		dayjs()
	]);

	useEffect(() => {
		const fetchIniData = async () => {
			try {
				const isTradetime = await getIsTradeDay();
				isTradeDayRef.current = isTradetime.data;
				// 最新交易日
				newestTradeDateRef.current = parseInt((await getLatestDate(105)).data);
				// 最近5个交易日
				const tradeDate = await getTradeDate({ days: 5 });
				tradeDateRef.current = tradeDate.data;

				if (tradeDateRef.current && tradeDateRef.current.length > 0) {
					const newDateRange = [
						dayjs(formatYYYYMMDDToStr(tradeDateRef.current[3].T_date), dateFormat),
						dayjs(formatYYYYMMDDToStr(tradeDateRef.current[0].T_date), dateFormat)
					];
					setDateRange(newDateRange);
					// 添加：更新表单值
					filterForm.setFieldsValue({
						t_date: newDateRange
					});
				}
				getMainSubjectOptions();
			} catch (error) {
				console.error('获取数据失败:', error);
			}
		};
		initColumns();
		fetchIniData();
	}, []);
	useEffect(() => {
		// 清除之前的定时器
		if (timerRef.current) {
			clearInterval(timerRef.current);
		}
		// 立即执行一次
		fetchRealtimeStockData();
		if (isTradeDayRef.current && isTradeTime()) {
			timerRef.current = setInterval(fetchRealtimeStockData, 1000 * 5 * 2);
		}
		// 组件卸载时清除定时器
		return () => {
			if (timerRef.current) {
				clearInterval(timerRef.current);
				timerRef.current = null;
			}
		};
	}, [selectedSubjectIdRef.current]);
	// 获取股票实时价格
	const fetchRealtimeStockData = async () => {
		if (realtimeDataRef.current.length === 0) {
			return;
		}
		try {
			const { priceData, avgPriceChangePercent, upCount, downCount } = await stockRealTimePrice(realtimeDataRef.current);
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
			const subjectName = searchParmasRef.current == null ? '辨识度' : mainSubjectOptions.find((item: any) => item.value == searchParmasRef.current.subject_id).label;
			// 更新标题
			setTableTitle(
				<>
					{subjectName}股票 {formatYYYYMMDDToStr(newestTradeDateRef.current)}（平均涨跌幅：{coloredAvgChange}），涨跌数对比 （
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
			if (selectedSubjectIdRef.current == 100) {
				// 辨识度数据
				setStockData(sortedData);
			} else {
				// 删除 dataALL 数据 newestTradeDateRef.current 之前的数据
				const filteredData = dataAll.current.filter((item: any) => item.t_date < newestTradeDateRef.current);
				// 自选股数据
				const transformedData = transformStockData([...priceData, ...filteredData]);
				// transformedData 数据增加key字段
				transformedData.forEach((item: any, index: number) => {
					item.key = index;
				});
				console.log(transformedData);
				setStockData(transformedData);
			}

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
		const stockColumns: ProColumns<any>[] = [
			{
				title: '序号',
				dataIndex: 'index',
				width: 50,
				align: 'center',
				render: (_, __, index) => index + 1,
				fixed: 'left',
			},
			{
				title: '代码',
				dataIndex: 'code',
				width: 80,
				render: (_) => <a href={`https://quote.eastmoney.com/${_}.html#fullScreenChart`} target="_blank">{_}</a>
			},
			{
				title: '名称',
				dataIndex: 'name',
				width: 80,
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
				title: '辨识度',
				dataIndex: 'tags',
			},
			{
				title: '自选日期',
				dataIndex: 't_date',
			},
			{
				title: '题材',
				dataIndex: 'subject',
				width: 120,
				sorter: (a, b) => a.subject.localeCompare(b.subject),
			},
			{
				title: '行业分类',
				dataIndex: 'industry1',
			},
			{
				title: '细分行业',
				dataIndex: 'industry2',
			},
			{
				title: '更新时间',
				dataIndex: 'update_at',
			},
		];
		setStockColumns(stockColumns);
	}

	// 获取主流题材
	const getMainSubjectOptions = async () => {
		try {
			const response = await getCommonData(100, { deleted: 0, tags: '主流题材,大分支' });
			const placementOptions = [{ label: '辨识度', value: 100 }, ...response.data.map((item: any) => ({
				value: item.subject_id,
				label: item.name,
			}))];
			setMainSubjectOptions(placementOptions);
			handleQueryBSD({
				subject_id: 100, t_date: [
					dayjs(formatYYYYMMDDToStr(tradeDateRef.current[4].T_date), dateFormat),
					dayjs(formatYYYYMMDDToStr(tradeDateRef.current[0].T_date), dateFormat)]
			});
		} catch (error) {
			console.error('获取放置位置选项失败:', error);
		}
	};

	// 编辑股票
	const handleUpdateStock = async (record: any, text: React.ReactNode) => {
		// 获取text 中的 _owner 内容
		const tdate = text._owner.key.split('-')[0];
		setCurrentStockRecord({
			code: record[`${tdate}_code`],
			name: record[`${tdate}_name`],
			tags: record[`${tdate}_tags`],
			subject_id: selectedSubjectIdRef.current,
			t_date: tdate,
		})
		editStockForm.setFieldsValue({
			name: record[`${tdate}_name`],
			tags: record[`${tdate}_tags`],
		});
		setIsEditStockModalVisible(true);
	};
	// 删除股票
	const deleteStock = async (record: any, text: React.ReactNode) => {
		try {
			const tdate = text._owner.key.split('-')[0];
			const indx = tradeDateRef.current.findIndex((item: any) => item.T_date == tdate);
			// 上一个交易日
			const lastDate = tradeDateRef.current[indx + 1].T_date;
			var resp = await deleteSelfStock(
				{
					subjectid: selectedSubjectIdRef.current,
					code: record[`${tdate}_code`],
					t_date: tdate,
				});
			if (resp.success) {
				// 更新删除标识
				const response = await updateCommonData(105, {
					pk: 'code,subject_id,t_date',
					subject_id: selectedSubjectIdRef.current,
					code: record[`${tdate}_code`],
					t_date: formatDateToYYYYMMDD(lastDate),
					is_delete: 1
				});
				message.success('删除成功');
				handleQueryZX(searchParmasRef.current);
			}
		} catch (error) {
			message.error('删除失败');
		}
	};
	// 编辑股票表单提交
	const handleEditStockFormSubmit = async () => {
		try {
			const values = await editStockForm.validateFields();
			const params = {
				pk: 'code,subject_id,t_date',
				code: currentStockRecord.code,
				subject_id: currentStockRecord.subject_id,
				t_date: currentStockRecord.t_date,
				name: values.name,
			}
			if (values.tags) {
				params.tags = values.tags;
				params.flag = 1;
			} else {
				params.flag = 0;
				params.tags = '';
			}
			// 调用 API 更新数据
			const response = await updateCommonData(105, params);
			if (response.success) {
				message.success('更新成功');
				handleQueryZX(searchParmasRef.current);
			}
			// 关闭对话框
			setIsEditStockModalVisible(false);
		} catch (error) {
			console.error('提交表单失败:', error);
			message.error('提交表单失败，请重试');
		}
	}

	// 3. 实现新增股票对话框显示函数
	const handleNewStockClick = () => {
		// 清空表单
		stockForm.setFieldsValue({
			stockCodes: '',
			t_date: dayjs(formatYYYYMMDDToStr(newestTradeDateRef.current), dateFormat)
		});
		// 显示对话框
		setIsStockModalVisible(true);
	};
	// 导入自选股
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
						order_no: seq++,
						is_new: 1
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
				handleQueryZX(searchParmasRef.current);
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
				handleQueryZX(searchParmasRef.current);
			}
			// 关闭对话框
			setIsImportStockModalVisible(false);
		} catch (error) {
			console.error('提交导入股票代码表单失败:', error);
			message.error('提交表单失败，请重试');
		}
	}
	// 查询辨识度股票
	const handleQueryBSD = async () => {
		const response = await getCommonData(107, { t_date: newestTradeDateRef.current, flag: 1 });
		if (response.success) {
			initColumns();
			realtimeDataRef.current = response.data;
			setStockData(response.data);
			// 确保数据更新后获取实时数据
			selectedSubjectIdRef.current = 100;
			fetchRealtimeStockData();
		}
	}
	/// 查询自选股票
	const handleQueryZX = async (values: any) => {
		try {
			setTableTitle('');
			// 保存查询参数
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
				values.t_date = newestTradeDateRef.current;
			}
			const response = await getCommonData(107, values);

			if (response.success) {
				dataAll.current = response.data;
				// 最新日期自选股
				realtimeDataRef.current = response.data.filter((item: any) => item.t_date == newestTradeDateRef.current);

				resetTableColumns(response.data);

				const transformedData = transformStockData(response.data);
				// transformedData 数据增加key字段
				transformedData.forEach((item: any, index: number) => {
					item.key = index;
				});
				// console.log('转换后的数据列名:', Object.keys(transformedData[0]));
				// console.log('转换后的数据:');
				setStockData(transformedData);
				selectedSubjectIdRef.current = values.subject_id;
			} else {
				message.error('查询失败');
				realtimeDataRef.current = [];
				setStockData([]);
			}
		} catch (error) {
			console.error('查询股票失败:', error);
			message.error('查询股票失败，请重试');
		}
	};
	/// 重置表格列
	const resetTableColumns = (serviceData: any[]) => {
		// 从新定义列
		const colsRedef: ProColumns[] = [
			{
				title: '序号',
				dataIndex: 'index',
				width: 50,
				align: 'center',
				render: (_, __, index) => index + 1,
				fixed: 'left',
			},
			{
				title: '排序',
				dataIndex: 'sort',
				width: 60,
				className: 'drag-visible',
			}
		];

		let idx = 0;
		for (const col of serviceData) {
			if (colsRedef.find((item: any) => item.dataIndex === col.t_date)) {
				continue;
			}
			idx++;
			const bgColorClass = idx % 2 === 0 ? 'table-column-bg-even' : 'table-column-bg-odd';
			if (idx < 2) {
				// 只设置前2天的列可编辑
				colsRedef.push({
					dataIndex: col.t_date,
					title: col.t_date,
					className: bgColorClass,
					children: [
						{
							dataIndex: col.t_date + '_code',
							title: '代码',
							className: bgColorClass,
							render: (_) => <a href={`https://quote.eastmoney.com/${_}.html#fullScreenChart`} target="_blank">{_}</a>
						},
						{
							dataIndex: col.t_date + '_name',
							title: '名称',
							className: bgColorClass,
							render: (_, record) => {
								let color = record[col.t_date + '_is_new'] == 1 ? 'Lime' : record[col.t_date + '_is_delete'] == 1 ? 'Navy' : '';
								return <span style={{ color }}>{record[col.t_date + '_name'] || '-'}</span>;
							},
						},
						{
							dataIndex: col.t_date + '_tags',
							title: '辨识度',
							className: bgColorClass
						},
						{
							title: '价格',
							dataIndex: col.t_date + '_currentPrice',
							align: 'right',
							width: 80,
							render: (_, record) => {
								const color = record[col.t_date + '_priceChangePercent'] >= 0 ? 'red' : 'green';
								return <span style={{ color }}>{record[col.t_date + '_currentPrice'] || '-'}</span>;
							},
						},
						{
							title: '涨跌幅',
							dataIndex: col.t_date + '_priceChangePercent',
							align: 'right',
							width: 80,
							sorter: (a, b) => a[col.t_date + '_priceChangePercent'] - b[col.t_date + '_priceChangePercent'],
							render: (_, record) => {
								// 根据priceChange设置涨跌幅的颜色
								const color = record[col.t_date + '_priceChangePercent'] >= 0 ? 'red' : 'green';
								return <span style={{ color }}>{record[col.t_date + '_priceChangePercent'] ? record[col.t_date + '_priceChangePercent'] + '%' : '-'}</span>;
							},
						},
						{
							title: '成交额',
							dataIndex: col.t_date + '_amount',
							align: 'right',
							width: 80,
							sorter: (a, b) => a[col.t_date + '_amount'] - b[col.t_date + '_amount'],
							render: (_, record) => {
								// 根据priceChange设置涨跌幅的颜色
								return <span>{record[col.t_date + '_amount'] ? record[col.t_date + '_amount'] + '亿' : '-'}</span>;
							},
						},
						{
							title: '操作',
							valueType: 'option',
							width: 60,
							className: bgColorClass,
							render: (text, record, _, action) => {
								// 检查单元格值是否为空
								if (!record[col.t_date + '_code'] || record[col.t_date + '_code'] === '') {
									return null; // 如果为空，不显示任何按钮
								}
								return [
									<a
										key="editable"
										onClick={() => {
											setCurrentStockRecord(record);
											handleUpdateStock(record, text);
										}}
									>
										<EditOutlined />
									</a>,
									<Popconfirm
										title="删除确认"
										description="确认删除该股票吗？"
										onConfirm={async () => {
											try {
												await deleteStock(record, text);
											} catch (error) {
												message.error('删除失败');
											}
										}}
										okText="确认"
										cancelText="取消"
									>
										<a key="delete"><DeleteOutlined /></a>
									</Popconfirm>
								];
							},
						},
					]
				});
			} else {
				colsRedef.push(
					{
						dataIndex: col.t_date, title: col.t_date, className: bgColorClass, children: [
							{
								dataIndex: col.t_date + '_code',
								title: '代码',
								className: bgColorClass,
								render: (_) => <a href={`https://quote.eastmoney.com/${_}.html#fullScreenChart`} target="_blank">{_}</a>
							},
							{
								dataIndex: col.t_date + '_name',
								title: '名称',
								className: bgColorClass,
								render: (_, record) => {
									let color = record[col.t_date + '_is_new'] == 1 ? 'yellow' : record[col.t_date + '_is_delete'] == 1 ? 'Fuchsia' : '';
									return <span style={{ color }}>{record[col.t_date + '_name'] || '-'}</span>;
								}
							},
							{
								dataIndex: col.t_date + '_tags',
								title: '辨识度',
								className: bgColorClass
							},
						]
					});
			}
		}
		setStockColumns(colsRedef);
	}
	const handleDragSortEnd = async (
		beforeIndex: number,
		afterIndex: number,
		newDataSource: any,
	) => {
		setStockData(newDataSource);
		// 获取  dataALL最大 t_date
		const maxTDate = dataAll.current.reduce((max, item) => item.t_date > max ? item.t_date : max, '');
		const newOrderCode = []
		for (const item of newDataSource) {
			if (item[`${maxTDate}_code`]) {
				newOrderCode.push(item[`${maxTDate}_code`]);
			}
		}
		// 排序完成，更新数据库
		let seq = 1;
		for (const code of newOrderCode) {
			try {
				const response = await updateCommonData(105, {
					pk: 'code,subject_id,t_date',
					subject_id: selectedSubjectIdRef.current,
					code: code,
					t_date: maxTDate,
					order_no: seq++
				});
			}
			catch (error) {
				console.error('股票代码排序失败:', error);
				message.error('股票代码排序失败');
			}
		}
		handleQueryZX(searchParmasRef.current);
	};
	// 添加排序变化处理函数
	const handleTableChange = (pagination: any, filters: any, sorter: any) => {
		if (sorter.field || sorter.order) {
			setSortOrder({
				field: sorter.field || '',
				order: sorter.order as 'ascend' | 'descend' | null
			});
		} else {
			setSortOrder({ field: '', order: null });
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
					form={editStockForm}
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
						<Input disabled placeholder="请输入股票名称" />
					</Form.Item>

					<Form.Item
						label="辨识度"
						name="tags"
					>
						<Select
							placeholder="请输入辨识度"
							options={[
								{
									value: '',
									label: '空',
								},
								{
									value: '反包首板',
									label: '反包首板',
								},
								{
									value: '容量',
									label: '容量',
								},
								{
									value: '10日涨幅',
									label: '10日涨幅',
								},
								{
									value: '20日涨幅',
									label: '20日涨幅',
								},
								{
									value: '2板',
									label: '2板',
								},
								{
									value: '3板',
									label: '3板',
								},
								{
									value: '4板',
									label: '4板',
								},
								{
									value: '5板',
									label: '5板',
								},
								{
									value: '6板',
									label: '6板',
								},
								{
									value: '7板',
									label: '7板',
								},
								{
									value: '多板',
									label: '多板',
								},
								{
									value: '超预期',
									label: '超预期',
								},

							]}
						/>
					</Form.Item>
				</Form>
			</Modal>

			<LightFilter
				initialValues={{
					subject_id: 'bsd',
					t_date: dateRange
				}}
				form={filterForm}
				bordered
				collapseLabel={<FilterOutlined />}
				onFinish={(values) => {
					searchParmasRef.current = values;

					// 获取当前表单值
					if (values.t_date && values.t_date[0] && values.t_date[1]) {
						const startDate = dayjs(values.t_date[0]);
						const endDate = dayjs(values.t_date[1]);
						// 两个日期差值不能超过5天
						const diffDays = endDate.diff(startDate, 'day');
						if (diffDays > 5) {
							message.error('日期范围必须在5天内');
							return;
						}
						if (values.subject_id == 100) {
							handleQueryBSD();
						} else {
							handleQueryZX(values);
						}
					}
				}}
			>
				<ProFormRadio.Group
					name="subject_id"
					radioType="button"
					options={mainSubjectOptions}
				/>
				<ProFormDateRangePicker name="t_date" label="日期范围" placeholder="日期范围"
					// 最大日期为当天，之后的日期不可选择
					fieldProps={{
						disabledDate: (current) => {
							// 禁用当天之后的日期
							if (current && current > dayjs().endOf('day')) {
								return true;
							}
							return false;
						},
						// 限制日期范围不超过5天
					}}
					// 添加提示信息
					tooltip="最多可选择5天"
				/>
			</LightFilter>

			<DragSortTable<any>
				headerTitle={tableTitle}
				columns={stockColumns}
				pagination={false}
				search={false}
				options={false}
				size='small'
				dataSource={stockData}
				rowKey='key'
				dragSortKey="sort"
				onDragSortEnd={handleDragSortEnd}
				onChange={handleTableChange}
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

