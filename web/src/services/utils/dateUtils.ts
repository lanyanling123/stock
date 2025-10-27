/**
 * 将各种日期格式转换为YYYYMMDD格式的字符串
 * @param date 日期对象、字符串或其他日期格式
 * @returns YYYYMMDD格式的日期字符串
 */
export const formatDateToYYYYMMDD = (date: any): string => {
  // 如果已经是YYYYMMDD格式的字符串，直接返回
  if (typeof date === 'string' && /^\d{8}$/.test(date)) {
    return date;
  }

  try {
    // 检查是否有format方法（dayjs或moment对象）
    if (date && typeof date.format === 'function') {
      return date.format('YYYYMMDD');
    }

    // 处理字符串格式的日期
    if (typeof date === 'string') {
      // 处理标准日期字符串 (YYYY-MM-DD, MM/DD/YYYY等)
      const dateObj = new Date(date);
      if (!isNaN(dateObj.getTime())) {
        return formatDateObject(dateObj);
      }
    }

    // 处理Date对象
    if (date instanceof Date && !isNaN(date.getTime())) {
      return formatDateObject(date);
    }

    // 无法格式化时返回原始值
    return date;
  } catch (error) {
    console.error('日期格式化失败:', error);
    return date;
  }
};
// 添加一个辅助函数，将YYYYMMDD格式的数字或字符串转换为Date对象
/**
 * 将YYYYMMDD格式的数字或字符串转换为Date对象
 * @param dateString YYYYMMDD格式的数字或字符串
 * @returns Date对象或undefined
 */
export const formatYYYYMMDDToDate = (dateString: number | string | undefined): Date | undefined => {
  if (!dateString) return undefined;
  const str = String(dateString);
  if (str.length !== 8) return undefined;
  const year = parseInt(str.substring(0, 4), 10);
  const month = parseInt(str.substring(4, 6), 10) - 1; // 月份从0开始
  const day = parseInt(str.substring(6, 8), 10);

  // 验证日期是否有效
  const date = new Date(year, month, day);
  // 检查创建的日期是否与输入值匹配（防止无效日期如2月30日）
  if (date.getFullYear() === year && date.getMonth() === month && date.getDate() === day) {
    return date;
  }
  return undefined;
};
export const formatYYYYMMDDToStr = (dateString: number | string | undefined): string | undefined => {
  if (!dateString) return undefined;
  const str = String(dateString);
  if (str.length !== 8) return undefined;
  const year = parseInt(str.substring(0, 4), 10);
  const month = parseInt(str.substring(4, 6), 10); // 月份从0开始
  const day = parseInt(str.substring(6, 8), 10);
  return `${year}-${month}-${day}`;
};
/**
 * 辅助函数：将Date对象格式化为YYYYMMDD格式
 * @param date Date对象
 * @returns YYYYMMDD格式的日期字符串
 */
const formatDateObject = (date: Date): string => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}${month}${day}`;
};

// 假设查询返回的数据类型
interface StockData {
  t_date: string;
  code: string;
  name: string;
  tags: string;
}

// 转换后的单行数据接口（属性是动态的，例如 `20251024_t_date_code`）
interface TransformedRow {
  [key: string]: string | undefined; // 动态键，值为字符串或undefined（用于空单元格）
}

/**
 * 将查询到的数据转换为目标表格格式
 * @param data 从数据库查询到的原始数据
 * @returns 转换后的数据数组
 */
export const transformStockData = (data: StockData[]): TransformedRow[] => {
  // 1. 按日期分组
  const groupedByDate: { [date: string]: StockData[] } = {};
  for (const item of data) {
    if (!groupedByDate[item.t_date]) {
      groupedByDate[item.t_date] = [];
    }
    groupedByDate[item.t_date].push(item);
  }
  // 对groupedByDate 按照 order_no 字段排序，字段是数值类型的
  for (const date in groupedByDate) {
    groupedByDate[date].sort((a, b) => a.order_no - b.order_no);
  }
  // 2. 确定所有日期组中最大的数据长度
  const allDates = Object.keys(groupedByDate);
  const maxRows = Math.max(...allDates.map(date => groupedByDate[date].length), 0);

  // 3. 构建结果数组
  const result: TransformedRow[] = [];

  for (let rowIndex = 0; rowIndex < maxRows; rowIndex++) {
    const newRow: TransformedRow = {};

    // 遍历每个日期，将对应行的数据填入新对象的相应列中
    for (const date of allDates) {
      const dateGroup = groupedByDate[date];
      const dataItem = dateGroup[rowIndex]; // 当前行对应的数据项，可能为undefined

      // 定义该日期对应的列名
      const codeKey = `${date}_code`;
      const nameKey = `${date}_name`;
      const tagsKey = `${date}_tags`;

      // 赋值，如果该日期组在当前行没有数据，则对应列的值为 undefined（在表格中显示为空）
      newRow[codeKey] = dataItem?.code;
      newRow[nameKey] = dataItem?.name;
      newRow[tagsKey] = dataItem?.tags;
    }

    result.push(newRow);
  }

  return result;
}
