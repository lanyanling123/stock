// @ts-ignore
/* eslint-disable */
import { request } from '@umijs/max';

/** 获取当前的用户 GET /api/currentUser */
export async function currentUser(options?: { [key: string]: any }) {
  return request<{
    data: API.CurrentUser;
  }>('/api/currentUser', {
    method: 'GET',
    ...(options || {}),
  });
}

/** 退出登录接口 POST /api/login/outLogin */
export async function outLogin(options?: { [key: string]: any }) {
  return request<Record<string, any>>('/api/login/outLogin', {
    method: 'POST',
    ...(options || {}),
  });
}

/** 登录接口 POST /api/login/account */
export async function login(body: API.LoginParams, options?: { [key: string]: any }) {
  return request<API.LoginResult>('/api/login/account', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 此处后端没有提供注释 GET /api/notices */
export async function getNotices(options?: { [key: string]: any }) {
  return request<API.NoticeIconList>('/api/notices', {
    method: 'GET',
    ...(options || {}),
  });
}

/** 获取规则列表 GET /api/rule */
export async function rule(
  params: {
    // query
    /** 当前的页码 */
    current?: number;
    /** 页面的容量 */
    pageSize?: number;
  },
  options?: { [key: string]: any },
) {
  return request<API.RuleList>('/api/rule', {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 更新规则 PUT /api/rule */
export async function updateRule(options?: { [key: string]: any }) {
  return request<API.RuleListItem>('/api/rule', {
    method: 'POST',
    data: {
      method: 'update',
      ...(options || {}),
    },
  });
}

/** 新建规则 POST /api/rule */
export async function addRule(options?: { [key: string]: any }) {
  return request<API.RuleListItem>('/api/rule', {
    method: 'POST',
    data: {
      method: 'post',
      ...(options || {}),
    },
  });
}

/** 删除规则 DELETE /api/rule */
export async function removeRule(options?: { [key: string]: any }) {
  return request<Record<string, any>>('/api/rule', {
    method: 'POST',
    data: {
      method: 'delete',
      ...(options || {}),
    },
  });
}
export async function getLatestDate(
    tableId: number
) {
  return request<any>(`/api/Common/maxdatadate/${tableId}`, {
    method: 'GET',
  });
}
export async function getCommonData(
  tableId: number,
  params: any,
  options?: { [key: string]: any },
) {
  return request<any>(`/api/Common/query/${tableId}`, {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

export async function getTradeDate(
  params: any,
  options?: { [key: string]: any },
) {
  return request<any>(`/api/Common/tradedate`, {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}
export async function updateCommonData(
  tableId: number,
  params: any,
  options?: { [key: string]: any },
) {
  return request<any>(`/api/Common/update/${tableId}`, {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}
export async function getCommonDataPaging(
  params: {
    // query
    /** 当前的页码 */
    current?: number;
    /** 页面的容量 */
    pageSize?: number;
  },
  options?: { [key: string]: any },
) {
  return request<any>('/api/Common', {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}
// 导入自选股
export async function importSelfStock(
  params: any,
  options?: { [key: string]: any },
) {
  return request<any>(`/api/Common/import/self`, {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}
export async function importSubjectStock(
  params: any,
  options?: { [key: string]: any },
) {
  return request<any>(`/api/Common/import/subject`, {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}
// 删除自选股
export async function deleteSelfStock(
  params: any,
  options?: { [key: string]: any },
) {
  return request<any>(`/api/Common/del/self`, {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}
// 获取自选股最新日期
export async function getLatestTradeDate(
  options?: { [key: string]: any },
) {
  return request<any>(`/api/Common/latestdate`, {
    method: 'GET',
    ...(options || {}),
  });
}
// 获取是否交易时间
export async function getIsTradeDay(
) {
  return request<any>(`/api/Common/istradeday`, {
    method: 'GET',
  });
}