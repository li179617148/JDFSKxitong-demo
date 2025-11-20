#!/bin/bash

# 资源管理系统部署脚本
# 使用方法：./deploy.sh [部署目标]

TARGET_DIR=${1:-"/var/www/html"}

echo "=== 资源管理系统部署 ==="
echo "目标目录: $TARGET_DIR"

# 检查dist目录是否存在
if [ ! -d "dist" ]; then
    echo "❌ 错误: dist目录不存在，请先运行 npm run build"
    exit 1
fi

# 检查dist目录内容
echo "📦 检查构建文件..."
if [ ! -f "dist/index.html" ]; then
    echo "❌ 错误: dist/index.html 不存在"
    exit 1
fi

# 显示构建文件信息
echo "📋 构建文件列表:"
ls -la dist/
echo ""

# 压缩构建文件
echo "🗜️  创建部署压缩包..."
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="resource-management-${TIMESTAMP}.tar.gz"
tar -czf "$ARCHIVE_NAME" dist/

if [ $? -eq 0 ]; then
    echo "✅ 压缩包创建成功: $ARCHIVE_NAME"
else
    echo "❌ 压缩包创建失败"
    exit 1
fi

# 显示文件大小
echo "📊 文件大小:"
du -h "$ARCHIVE_NAME"
echo ""

echo "=== 部署指南 ==="
echo "1. 将压缩包 $ARCHIVE_NAME 上传到服务器"
echo "2. 在服务器上解压: tar -xzf $ARCHIVE_NAME"
echo "3. 将dist目录内容复制到web服务器目录"
echo ""
echo "示例服务器命令:"
echo "   sudo cp -r dist/* $TARGET_DIR/"
echo "   sudo chown -R www-data:www-data $TARGET_DIR/"
echo "   sudo systemctl restart nginx  # 或 apache2"
echo ""

echo "🚀 部署文件准备完成!"