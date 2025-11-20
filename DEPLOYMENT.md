# 资源管理系统部署指南

## 📋 部署前检查

### ✅ 构建状态
- 构建时间: 2025-11-19 16:28
- 构建输出: `dist/` 目录
- 本地预览: ✅ 通过 (http://localhost:4173)

### 📦 构建文件
```
dist/
├── index.html              (381 B)
└── assets/
    ├── index-868d04f5.css  (175.8 KB)
    ├── index-fab32b6a.js   (1.64 MB)
    └── new-logo-434e823b.png (9.78 KB)
```

## 🚀 部署方式

### 方法1: CloudStudio部署 (推荐)
1. 登录CloudStudio平台
2. 创建新的静态网站应用
3. 上传整个 `dist/` 目录
4. 配置域名和SSL证书

### 方法2: 传统服务器部署

#### Nginx配置示例
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

#### 部署步骤
```bash
# 1. 上传部署包
scp resource-management-20251119_163206.tar.gz user@server:/tmp/

# 2. 登录服务器
ssh user@server

# 3. 解压和部署
cd /tmp
tar -xzf resource-management-20251119_163206.tar.gz
sudo cp -r dist/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo systemctl restart nginx
```

### 方法3: Docker部署
```dockerfile
FROM nginx:alpine
COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 方法4: Vercel/Netlify部署
- Vercel: `vercel --prod`
- Netlify: 拖拽 `dist/` 目录到控制台

## 🔧 环境要求

### 浏览器兼容性
- Chrome/Edge 88+
- Firefox 85+
- Safari 14+

### 服务器要求
- 静态文件服务器 (Nginx/Apache)
- HTTPS支持 (推荐)
- 压缩支持 (gzip/brotli)

## 📊 性能优化

### 已应用优化
- JavaScript压缩: 1.64MB → 510KB (gzipped)
- CSS压缩: 180KB → 25KB (gzipped)
- 代码分割 (建议后续优化)

### 建议配置
```nginx
gzip on;
gzip_types text/css application/javascript image/svg+xml;
```

## 🔍 验证部署

### 检查清单
- [ ] 页面正常加载
- [ ] 路由功能正常
- [ ] 图表显示正确
- [ ] 响应式设计适配
- [ ] 无控制台错误

### 测试URL
```
https://your-domain.com/  # 首页
https://your-domain.com/#/partner-management  # 合作方管理
https://your-domain.com/#/price-maintenance   # 价格维护
```

## 📞 支持

如遇部署问题，请检查：
1. 服务器日志: `tail -f /var/log/nginx/error.log`
2. 浏览器控制台: F12 开发者工具
3. 网络请求: 检查资源加载状态

---

**部署完成时间**: 2025-11-19 16:32  
**部署文件大小**: 536KB (压缩后)