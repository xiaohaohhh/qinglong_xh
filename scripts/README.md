# QingLong 容器化部署指南

## 🏷️ 镜像版本说明

### 基础镜像区别
| 镜像标签      | 基础系统       | 推荐使用场景                  |
|--------------|---------------|----------------------------|
| `latest`     | Alpine Linux  | 常规使用（体积更小，资源占用更低）   |
| `debian`     | Debian Slim   | 需要复杂依赖/兼容性要求高的环境     |

### 镜像拉取命令
```bash
# 默认Alpine版本
docker pull whyour/qinglong:latest

# Debian版本
docker pull whyour/qinglong:debian
```

## 🚢 Docker 部署配置

### 最小化部署命令
```bash
docker run -dit \
  -v $(pwd)/ql/data:/ql/data \
  -p 5700:5700 \
  -e QlBaseUrl="/" \
  -e QlPort="5700" \
  --name qinglong \
  --hostname qinglong \
  --restart unless-stopped \
  whyour/qinglong:latest
```

### 配置参数说明
| 参数                 | 必须  | 默认值   | 说明                                                                 |
|----------------------|-------|---------|---------------------------------------------------------------------|
| `-v [path]:/ql/data` | ✅    | 无      | 数据持久化目录，推荐使用绝对路径（如：`/opt/ql/data:/ql/data`）            |
| `-p [host]:[container]` | ✅ | 5700    | 端口映射（主机端口:容器端口），修改后需同步调整QlPort                          |
| `QlBaseUrl`          | ❌    | /       | WEB访问路径（如需设置为`/test`，需配合反向代理使用）                          |
| `QlPort`             | ❌    | 5700    | 容器内部服务运行端口（使用host网络模式时必须显式声明）                          |

## 🔧 依赖管理

### 一键安装脚本
```bash
# 使用国内镜像源加速安装
bash <(curl -sL https://ghproxy.cn/https://github.com/xiaohaohhh/qinglong_xh/raw/main/scripts/development_install.sh)
```

### 主要功能特性
- 📦 自动安装 Node.js/Python 基础依赖
- 🛠️ 编译构建 Canvas 支持
- 🌐 配置淘宝NPM镜像源加速
- ✅ 依赖完整性验证
- 🐧 自动适配 Alpine/Debian 环境

## ⚠️ 注意事项

1. **数据持久化**  
   务必保证 `/ql/data` 目录的持久化挂载，避免容器重建时数据丢失

2. **端口冲突处理**  
   当出现以下错误时，表示端口被占用：
   ```bash
   docker: Error response from daemon: Ports are not available...
   ```
   解决方案：  
   - 更改主机端口：`-p 5701:5700`
   - 停止占用进程

3. **资源监控**  
   推荐配置资源限制防止内存泄漏：
   ```bash
   --memory 768m --memory-swap 1g
   ```

4. **网络问题排查**  
   国内服务器建议配置镜像加速：
   ```bash
   -e NPM_CONFIG_REGISTRY=https://registry.npmmirror.com
   ```

## 📚 常用命令参考

### 容器管理
```bash
# 查看实时日志
docker logs -f qinglong

# 执行容器内命令
docker exec qinglong node -v

# 备份数据目录
tar -czvf ql_backup_$(date +%Y%m%d).tar.gz /ql/data
```

### 服务管理
```bash
# 重启面板服务（容器内执行）
ql restart

# 更新面板代码（容器内执行）
ql update
```