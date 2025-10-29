import {
  LockOutlined,
  LogoutOutlined,
  MobileOutlined,
  SettingOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { FormattedMessage, history, useModel } from '@umijs/max';
import type { MenuProps } from 'antd';
import { Alert, Button, message, Modal, Tabs } from 'antd';
import { createStyles } from 'antd-style';
import React, { useState } from 'react';
import { flushSync } from 'react-dom';
import { outLogin } from '@/services/ant-design-pro/api';
import { login } from '@/services/ant-design-pro/api';
import {
  LoginForm,
  ProForm,
  ProFormCaptcha,
  ProFormCheckbox,
  ProFormText,
  useIntl,
} from '@ant-design/pro-components';
import HeaderDropdown from '../HeaderDropdown';
import { getFakeCaptcha } from '@/services/ant-design-pro/login';
export type GlobalHeaderRightProps = {
  menu?: boolean;
  children?: React.ReactNode;
};

const useStyles = createStyles(({ token }) => {
  return {
    action: {
      display: 'flex',
      height: '48px',
      marginLeft: 'auto',
      overflow: 'hidden',
      alignItems: 'center',
      padding: '0 8px',
      cursor: 'pointer',
      borderRadius: token.borderRadius,
      '&:hover': {
        backgroundColor: token.colorBgTextHover,
      },
    },
    formContainer: {
      padding: '0 16px',
      width: '100%',
      boxSizing: 'border-box',
    },
  };
});

export const AvatarDropdown: React.FC<GlobalHeaderRightProps> = ({
  menu,
  children,
}) => {
  const [userLoginState, setUserLoginState] = useState<API.LoginResult>({});
  const [loginModalVisible, setLoginModalVisible] = useState<boolean>(false);
  const [registerModalVisible, setRegisterModalVisible] = useState<boolean>(false);
  const [type, setType] = useState<string>('account');
  
  const { initialState, setInitialState } = useModel('@@initialState');
  const { styles } = useStyles();
  const intl = useIntl();
  
  // 获取当前用户信息
  const { currentUser } = initialState || {};

  /**
   * 退出登录，并且显示登录对话框
   */
  const loginOut = async () => {
    try {
      console.log('开始退出登录');
      // 先清除本地用户状态，确保UI立即更新
      flushSync(() => {
        setInitialState((s) => ({ ...s, currentUser: undefined }));
      });

      // 调用退出登录API，但不阻塞对话框显示
      try {
        await outLogin();
        console.log('退出登录API调用成功');
      } catch (error) {
        console.error('退出登录API调用失败，但继续显示登录对话框', error);
      }

      // 显示登录对话框
      console.log('设置登录对话框可见');
      setLoginModalVisible(true);
    } catch (error) {
      console.error('退出登录过程中发生错误', error);
      // 即使发生错误也尝试显示登录对话框
      setLoginModalVisible(true);
    }
  };

  const onMenuClick: MenuProps['onClick'] = (event) => {
    const { key } = event;
    if (key === 'logout') {
      loginOut();
      return;
    }
    history.push(`/account/${key}`);
  };

  // 登录处理函数
  const handleLogin = async (values: any) => {
    try {
      const msg = await login({ ...values, type: 'account' });
      if (msg.status === 'ok') {
        // 登录成功后关闭对话框并刷新用户信息
        setLoginModalVisible(false);
        // 重新获取用户信息
        if (initialState?.fetchUserInfo) {
          const currentUser = await initialState.fetchUserInfo();
          setInitialState((s) => ({ ...s, currentUser }));
        }
      }
    } catch (error) {
      console.error('登录失败', error);
    }
  };

  const menuItems = [
    ...(menu
      ? [
        {
          key: 'center',
          icon: <UserOutlined />,
          label: '个人中心',
        },
        {
          key: 'settings',
          icon: <SettingOutlined />,
          label: '个人设置',
        },
        {
          type: 'divider' as const,
        },
      ]
      : []),
    {
      key: 'logout',
      icon: <LogoutOutlined />,
      label: '退出登录',
    },
  ];
  
  const fetchUserInfo = async () => {
    const userInfo = await initialState?.fetchUserInfo?.();
    if (userInfo) {
      flushSync(() => {
        setInitialState((s) => ({
          ...s,
          currentUser: userInfo,
        }));
      });
    }
  };
  
  const handleSubmit = async (values: API.LoginParams) => {
    try {
      // 登录
      const msg = await login({ ...values, type });
      if (msg.status === 'ok') {
        const defaultLoginSuccessMessage = '登录成功！';
        message.success(defaultLoginSuccessMessage);
        await fetchUserInfo();
        const urlParams = new URL(window.location.href).searchParams;
        window.location.href = urlParams.get('redirect') || '/';
        return;
      }
      console.log(msg);
      // 如果失败去设置用户错误信息
      setUserLoginState(msg);
    } catch (error) {
      const defaultLoginFailureMessage = '登录失败，请重试！';
      console.log(error);
      message.error(defaultLoginFailureMessage);
    }
  };
  
  const { status, type: loginType } = userLoginState;
  
  const LoginMessage: React.FC<{
    content: string;
  }> = ({ content }) => {
    return (
      <Alert
        style={{
          marginBottom: 24,
        }}
        message={content}
        type="error"
        showIcon
      />
    );
  };
  
  // 渲染内容：根据用户是否登录显示不同内容
  const renderContent = () => {
    // 用户已登录：显示用户名和下拉菜单
    if (currentUser) {
      return (
        <HeaderDropdown
          menu={{
            selectedKeys: [],
            onClick: onMenuClick,
            items: menuItems,
          }}
        >
          <div className={styles.action}>
            <UserOutlined style={{ marginRight: 4 }} />
            <span>{currentUser.name}</span>
          </div>
        </HeaderDropdown>
      );
    }
    
    // 用户未登录：显示登录按钮
    return (
      <Button 
        type="link" 
        onClick={() => setLoginModalVisible(true)}
        style={{ marginLeft: 'auto' }}
      >
        登录
      </Button>
    );
  };

  return (
    <>
      {renderContent()}

      {/* 登录对话框 */}
      <Modal
        title="用户登录"
        open={loginModalVisible}
        onCancel={() => setLoginModalVisible(false)}
        footer={null}
        width={500}
        style={{ zIndex: 1000 }}
      >
        <div className={styles.formContainer}>
          <LoginForm
            contentStyle={{
              minWidth: 280,
              maxWidth: 300,
            }}
            logo={<img alt="logo" src="/logo.svg" />}
            title="StockView"
            initialValues={{
              autoLogin: true,
            }}
            onFinish={async (values) => {
              await handleSubmit(values as API.LoginParams);
            }}
          >
            <Tabs
              activeKey={type}
              onChange={setType}
              centered
              items={[
                {
                  key: 'account',
                  label: '账户密码登录',
                },
                {
                  key: 'mobile',
                  label: '手机号登录',
                },
              ]}
            />

            {status === 'error' && loginType === 'account' && (
              <LoginMessage
                content={'账户或密码错误(admin/ant.design)'}
              />
            )}
            {type === 'account' && (
              <>
                <ProFormText
                  name="username"
                  fieldProps={{
                    size: 'large',
                    prefix: <UserOutlined />,
                  }}
                  placeholder={'用户名: admin or user'}
                  rules={[
                    {
                      required: true,
                      message: (
                        <FormattedMessage
                          id="pages.login.username.required"
                          defaultMessage="请输入用户名!"
                        />
                      ),
                    },
                  ]}
                />
                <ProFormText.Password
                  name="password"
                  fieldProps={{
                    size: 'large',
                    prefix: <LockOutlined />,
                  }}
                  placeholder={'密码: ant.design'}
                  rules={[
                    {
                      required: true,
                      message: (
                        <FormattedMessage
                          id="pages.login.password.required"
                          defaultMessage="请输入密码！"
                        />
                      ),
                    },
                  ]}
                />
              </>
            )}

            {status === 'error' && loginType === 'mobile' && (
              <LoginMessage content="验证码错误" />
            )}
            {type === 'mobile' && (
              <>
                <ProFormText
                  fieldProps={{
                    size: 'large',
                    prefix: <MobileOutlined />,
                  }}
                  name="mobile"
                  placeholder={'手机号'}
                  rules={[
                    {
                      required: true,
                      message: (
                        <FormattedMessage
                          id="pages.login.phoneNumber.required"
                          defaultMessage="请输入手机号！"
                        />
                      ),
                    },
                    {
                      pattern: /^1\d{10}$/,
                      message: (
                        <FormattedMessage
                          id="pages.login.phoneNumber.invalid"
                          defaultMessage="手机号格式错误！"
                        />
                      ),
                    },
                  ]}
                />
                <ProFormCaptcha
                  fieldProps={{
                    size: 'large',
                    prefix: <LockOutlined />,
                  }}
                  captchaProps={{
                    size: 'large',
                  }}
                  placeholder={'请输入验证码'}
                  captchaTextRender={(timing, count) => {
                    if (timing) {
                      return `${count} ${'获取验证码'}`;
                    }
                    return '获取验证码';
                  }}
                  name="captcha"
                  rules={[
                    {
                      required: true,
                      message: (
                        <FormattedMessage
                          id="pages.login.captcha.required"
                          defaultMessage="请输入验证码！"
                        />
                      ),
                    },
                  ]}
                  onGetCaptcha={async (phone) => {
                    const result = await getFakeCaptcha({
                      phone,
                    });
                    if (!result) {
                      return;
                    }
                    message.success('获取验证码成功！验证码为：1234');
                  }}
                />
              </>
            )}
            <div
              style={{
                marginBottom: 24,
              }}
            >
              <ProFormCheckbox noStyle name="autoLogin">
                <FormattedMessage
                  id="pages.login.rememberMe"
                  defaultMessage="自动登录"
                />
              </ProFormCheckbox>
              <a
                style={{
                  float: 'right',
                }}
              >
                <FormattedMessage
                  id="pages.login.forgotPassword"
                  defaultMessage="忘记密码"
                />
              </a>
            </div>
          </LoginForm>
        </div>
      </Modal>

      {/* 注册对话框 */}
      <Modal
        title="用户注册"
        open={registerModalVisible}
        onCancel={() => setRegisterModalVisible(false)}
        footer={null}
        width={400}
      >
        <div className={styles.formContainer}>
          <ProForm
            onFinish={handleLogin}
            layout="vertical"
            autoComplete="off"
          >
            <ProFormText
              name="username"
              placeholder="用户名"
              rules={[{ required: true, message: '请输入用户名' }]}
              style={{ marginBottom: 16 }}
            />
            <ProFormText.Password
              name="password"
              placeholder="密码"
              rules={[{ required: true, message: '请输入密码' }]}
              style={{ marginBottom: 16 }}
            />
            <ProFormText
              name="email"
              placeholder="邮箱"
              rules={[
                { required: true, message: '请输入邮箱' },
                { type: 'email', message: '邮箱格式不正确' }
              ]}
              style={{ marginBottom: 16 }}
            />
            <div style={{ textAlign: 'right', marginBottom: 24 }}>
              <a
                style={{ color: '#1890ff' }}
                onClick={() => {
                  setRegisterModalVisible(false);
                  setLoginModalVisible(true);
                }}
              >
                已有账号，去登录
              </a>
            </div>
          </ProForm>
        </div>
      </Modal>
    </>
  );
};

export default AvatarDropdown;