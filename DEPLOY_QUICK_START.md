# 🚀 资源管理系统云服务器部署快速指南

## 📋 部署前准备

### 本地文件已准备完成
- ✅ 构建文件：`dist/` 目录
- ✅ 部署压缩包：`resource-management-20251119_170451.tar.gz` (536KB)
- ✅ 服务器部署脚本：`server-deploy.sh`

### 云服务器要求
- Linux系统 (Ubuntu/CentOS)
- 1GB+ 内存
- 5GB+ 磁盘空间
- Root权限

---

## 🎯 三步完成部署

### 第一步：上传文件到服务器
```bash
# 替换 your-server-ip 为您的云服务器IP
scp resource-management-20251119_170451.tar.gz root@your-server-ip:/tmp/
scp server-deploy.sh root@your-server-ip:/tmp/
```

### 第二步：登录服务器执行部署
```bash
ssh root@your-server-ip
cd /tmp
chmod +x server-deploy.sh
./server-deploy.sh
```

### 第三步：验证部署
```bash
# 检查nginx状态
systemctl status nginx

# 查看网站
curl http://localhost
# 或在浏览器访问: http://your-server-ip
```

---

## 🔧 高级配置 (可选)

### 配置域名和SSL
```bash
# 1. 安装certbot
apt install certbot python3-certbot-nginx  # Ubuntu
yum install certbot python3-certbot-nginx  # CentOS

# 2. 申请SSL证书 (替换your-domain.com)
certbot --nginx -d your-domain.com

# 3. 自动续期
echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -
```

### 防火墙配置
```bash
# Ubuntu/Debian
ufw allow 80
ufw allow 443
ufw enable

# CentOS/RHEL
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
```

### 性能优化配置
```bash
# 编辑nginx配置
nano /etc/nginx/nginx.conf

# 添加到http块
worker_processes auto;
worker_connections 1024;

# 重启nginx
systemctl restart nginx
```

---

## 📊 部署文件说明

| 文件 | 说明 | 大小 |
|------|------|------|
| `index.html` | 主页面 | 381B |
| `assets/index-868d04f5.css` | 样式文件 | 175.8KB |
| `assets/index-fab32b6a.js` | JavaScript | 1.6MB |
| `assets/new-logo-434e823b.png` | Logo图片 | 9.78KB |

---

## 🔍 故障排除

### 常见问题

**1. 网站无法访问**
```bash
# 检查nginx状态
systemctl status nginx
# 查看错误日志
tail -f /var/log/nginx/error.log
```

**2. 权限问题**
```bash
# 重新设置权限
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/
```

**3. 端口被占用**
```bash
# 查看端口占用
netstat -tlnp | grep :80
# 停止占用服务
systemctl stop apache2  # 或其他web服务器
```

### 回滚操作
```bash
# 如果部署有问题，可以恢复备份
BACKUP_DIR=$(ls /var/www/ | grep backup | tail -1)
cp -r /var/www/$BACKUP_DIR/* /var/www/html/
systemctl restart nginx
```

---

## 📞 技术支持

部署过程中如遇问题，请检查：
1. 服务器系统日志：`journalctl -xe`
2. Nginx错误日志：`/var/log/nginx/error.log`
3. 系统资源使用：`top`、`df -h`

---

**部署完成后，您的资源管理系统将可通过公网IP或域名访问！** 🎉