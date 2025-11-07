1、查看进程端口5000
ss -tulpn | grep 5000
2、结束进程
taskkill /pid 1234 /f

# 找到占用 5000 端口的进程 PID
PID=$(ss -tlnp | grep ":5000 " | awk '{print $NF}' | cut -d= -f2 | cut -d, -f1)
# 终止进程（谨慎操作）
kill $PID

3、查看端口5000是否被释放
ss -tulpn | grep 5000
4、执行命令
nohup dotnet /var/stockinfo/api/StockAPI.dll --urls "http://0.0.0.0:5000" > stockapi.log 2>&1 &

创建服务配置文件​​：
使用 sudo vim /etc/systemd/system/stockapi.service命令创建并编辑一个服务文件，内容如下：

# 服务器端程序目录
/var/stockinfo/


[Unit]
Description=StockInfo .NET 9 WebAPI Application
After=network.target

[Service]
# 设置工作目录，这里就是你的dll文件所在目录
WorkingDirectory=/var/stockinfo/api
# 启动命令
ExecStart=/root/.dotnet/dotnet StockAPI.dll
# 如果应用需要特定端口或地址，建议在此通过环境变量设置
Environment=ASPNETCORE_URLS=http://0.0.0.0:5000
# 设置运行用户，从安全角度考虑，建议创建一个专用用户而非直接使用root
User=www-data
# 自动重启策略：始终重启，并在5秒后重试
Restart=always
RestartSec=5
# 日志标识
SyslogIdentifier=stockapi

[Install]
WantedBy=multi-user.target





​​启用并启动服务​​：
# 重新加载systemd配置，使其识别新服务
sudo systemctl daemon-reload
# 设置服务开机自启
sudo systemctl enable stockapi.service
# 立即启动服务
sudo systemctl start stockapi.service
​​管理服务​​：
​​查看状态​​：sudo systemctl status stockapi.service
​​停止服务​​：sudo systemctl stop stockapi.service
​​重启服务​​：sudo systemctl restart stockapi.service
​​查看实时日志​​：sudo journalctl -u stockapi.service -f


# nginx 配置文件示例

vim /etc/nginx/conf/nginx.conf

# 查看状态
systemctl status nginx

# 启动 Nginx
sudo systemctl start nginx

# 停止 Nginx
sudo systemctl stop nginx

# 重启 Nginx
sudo systemctl restart nginx

# 重新加载配置（不中断服务）
sudo systemctl reload nginx

# 启用开机自启
sudo systemctl enable nginx

# 或者测试具体响应
curl http://localhost

# 查询防火墙生效规则
iptables -L -n -v

# 添加防火墙规则，允许 HTTP 和 HTTPS 流量通过
iptables -A INPUT -p tcp --dport 5432 -j ACCEPT

iptables -A INPUT -p tcp --dport 5002 -j ACCEPT