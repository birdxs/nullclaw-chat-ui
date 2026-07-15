FROM --platform=$BUILDPLATFORM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# 生产镜像 —— 用 nginx 服务静态文件
FROM nginx:alpine

# 复制构建产物
COPY --from=builder /app/build /usr/share/nginx/html

# nginx 配置：SPA fallback + WebSocket 代理
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
