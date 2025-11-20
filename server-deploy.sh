#!/bin/bash

# 云服务器部署脚本
# 在云服务器上执行此脚本

echo "=== 资源管理系统云服务器部署 ==="

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
    echo "请使用 root 权限执行此脚本"
    exit 1
fi

# 设置变量
DEPLOY_DIR="/var/www/html"
BACKUP_DIR="/var/www/backup_$(date +%Y%m%d_%H%M%S)"
ARCHIVE_NAME="resource-management-20251119_170451.tar.gz"

echo "📦 部署目录: $DEPLOY_DIR"
echo "🗂️  备份目录: $BACKUP_DIR"

# 检查压缩包是否存在
if [ ! -f "/tmp/$ARCHIVE_NAME" ]; then
    echo "❌ 错误: 找不到部署压缩包 /tmp/$ARCHIVE_NAME"
    echo "请先上传压缩包到服务器"
    exit 1
fi

# 创建备份
if [ -d "$DEPLOY_DIR" ]; then
    echo "💾 创建当前网站备份..."
    mkdir -p "$BACKUP_DIR"
    cp -r $DEPLOY_DIR/* "$BACKUP_DIR/" 2>/dev/null || true
fi

# 安装nginx（如果未安装）
if ! command -v nginx &> /dev/null; then
    echo "🔧 安装 Nginx..."
    # Ubuntu/Debian
    if command -v apt &> /dev/null; then
        apt update
        apt install -y nginx
    # CentOS/RHEL
    elif command -v yum &> /dev/null; then
        yum install -y nginx
    else
        echo "❌ 无法自动安装nginx，请手动安装"
        exit 1
    fi
fi

# 解压部署文件
echo "📂 解压部署文件..."
cd /tmp
tar -xzf "$ARCHIVE_NAME"

if [ ! -d "dist" ]; then
    echo "❌ 解压失败，找不到 dist 目录"
    exit 1
fi

# 清理目标目录并部署
echo "🚀 部署文件..."
rm -rf $DEPLOY_DIR/*
cp -r dist/* $DEPLOY_DIR/

# 设置权限
echo "🔐 设置文件权限..."
chown -R www-data:www-data $DEPLOY_DIR/ 2>/dev/null || chown -R nginx:nginx $DEPLOY_DIR/
chmod -R 755 $DEPLOY_DIR/

# 配置nginx
echo "⚙️  配置 Nginx..."
cat > /etc/nginx/sites-available/resource-management << 'EOF'
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html;

    # 启用gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    # 处理Vue Router的history模式
    location / {
        try_files $uri $uri/ /index.html;
    }

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
}
EOF

# 启用站点
ln -sf /etc/nginx/sites-available/resource-management /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# 测试nginx配置
nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx配置测试通过"
    systemctl restart nginx
    systemctl enable nginx
else
    echo "❌ Nginx配置错误"
    exit 1
fi

# 检查服务状态
echo "🔍 检查服务状态..."
systemctl status nginx --no-pager

# 显示部署信息
echo ""
echo "=== 🎉 部署完成 ==="
echo "📁 部署目录: $DEPLOY_DIR"
echo "🌐 网站地址: http://$(curl -s ifconfig.me 2>/dev/null || echo 'your-server-ip')"
echo "💾 备份位置: $BACKUP_DIR"
echo ""
echo "📋 下一步操作:"
echo "1. 配置防火墙: ufw allow 80 && ufw allow 443"
echo "2. 申请SSL证书: certbot --nginx"
echo "3. 设置域名解析指向服务器IP"
echo ""
echo "🔧 如需回滚: cp -r $BACKUP_DIR/* $DEPLOY_DIR/"