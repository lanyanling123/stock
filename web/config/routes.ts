/**
 * @name umi 的路由配置
 * @description 只支持 path,component,routes,redirect,wrappers,name,icon 的配置
 * @param path  path 只支持两种占位符配置，第一种是动态参数 :id 的形式，第二种是 * 通配符，通配符只能出现路由字符串的最后。
 * @param component 配置 location 和 path 匹配后用于渲染的 React 组件路径。可以是绝对路径，也可以是相对路径，如果是相对路径，会从 src/pages 开始找起。
 * @param routes 配置子路由，通常在需要为多个路径增加 layout 组件时使用。
 * @param redirect 配置路由跳转
 * @param wrappers 配置路由组件的包装组件，通过包装组件可以为当前的路由组件组合进更多的功能。 比如，可以用于路由级别的权限校验
 * @param name 配置路由的标题，默认读取国际化文件 menu.ts 中 menu.xxxx 的值，如配置 name 为 login，则读取 menu.ts 中 menu.login 的取值作为标题
 * @param icon 配置路由的图标，取值参考 https://ant.design/components/icon-cn， 注意去除风格后缀和大小写，如想要配置图标为 <StepBackwardOutlined /> 则取值应为 stepBackward 或 StepBackward，如想要配置图标为 <UserOutlined /> 则取值应为 user 或者 User
 * @doc https://umijs.org/docs/guides/routes
 * SmileOutlined	smile	笑脸图标
HomeOutlined	home	首页图标
UserOutlined	user	用户图标
SettingOutlined	setting	设置图标
PieChartOutlined	pieChart	饼图图标
BarChartOutlined	barChart	柱状图图标
LineChartOutlined	lineChart	折线图图标
AreaChartOutlined	areaChart	区域图图标
MenuOutlined	menu	菜单图标
BellOutlined	bell	铃铛图标
SearchOutlined	search	搜索图标
PlusOutlined	plus	加号图标
EditOutlined	edit	编辑图标
DeleteOutlined	delete	删除图标
UploadOutlined	upload	上传图标
DownloadOutlined	download	下载图标
LeftOutlined	left	左箭头图标
RightOutlined	right	右箭头图标
RefreshOutlined	refresh	刷新图标
EyeOutlined	eye	眼睛图标
 */
export default [
  {
    path: '/user',
    layout: false,
    routes: [
      {
        name: 'login',
        path: '/user/login',
        component: './user/login',
      },
    ],
  },
  {
    path: '/welcome',
    name: 'welcome',
    icon: 'smile',
    component: './Welcome',
  },
  // {
  //   path: '/index-sh',
  //   name: 'index-sh',
  //   icon: 'home',
  //   component: './IndexSH',
  // },
    {
    path: '/yidong',
    name: '异动',
    icon: 'bell',
    component: './YiDong',
  },
  // {
  //   path: '/ticai',
  //   name: '题材',
  //   icon: 'menu',
  //   component: './Subject',
  // },
  //   {
  //   path: '/zixuan',
  //   name: '自选',
  //   icon: 'home',
  //   component: './ZiXuan',
  // },
  {
    path: '/',
    redirect: '/welcome',
  },
  {
    component: '404',
    layout: false,
    path: './*',
  },
];
