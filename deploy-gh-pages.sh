#!/bin/bash

# 部署到GitHub Pages的脚本
echo "开始部署到GitHub Pages..."

# 构建项目
echo "构建项目..."
npm run build

# 创建临时目录用于部署
echo "准备部署文件..."
mkdir -p temp-deploy
cp -r dist/* temp-deploy/

# 提交并推送部署文件
echo "提交部署文件..."
git add temp-deploy/
git commit -m "Deploy: 部署到GitHub Pages - $(date)"

# 推送到gh-pages分支
echo "推送到GitHub Pages..."
git push origin gh-pages

# 清理临时文件
rm -rf temp-deploy

echo "部署完成！"