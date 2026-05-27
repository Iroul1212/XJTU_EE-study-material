# 🖥️ 网页上传设置指南

> 想让同学们在网站上直接拖拽上传文件？跟着下面步骤，5 分钟搞定。

---

## 方案一：部署到 Netlify（⭐ 推荐，最简单）

Netlify 提供免费托管，并内置了 OAuth 认证，可以直接启用网页后台。

### 步骤

1. **注册 Netlify**：打开 [netlify.com](https://netlify.com)，用 GitHub 账号登录

2. **导入项目**：点击 **"Add new site" → "Import an existing project" → 选择 GitHub → 选择 `XJTU_EE-study-material`**

3. **配置构建设置**（已通过 `netlify.toml` 自动配置）：
   - Build command：留空（或填 `echo ok`）
   - Publish directory：`docs`

4. **部署**：点击 **Deploy site**

5. **启用 Identity**：进入站点设置 → **Identity** → **Enable Identity**

6. **启用 Git Gateway**：Identity → **Services** → **Enable Git Gateway**

7. **修改 CMS 配置**：编辑 `docs/admin/config.yml`，将 backend 改为：
   ```yaml
   backend:
     name: git-gateway
     branch: main
   ```

8. **邀请用户**：在 Identity 页面邀请同学注册，他们就能在 `你的域名/admin/` 登录上传了！

> ✅ 完成！现在同学访问 `/admin/` 就能直接在网页上传文件到 GitHub 仓库。

---

## 方案二：保持 GitHub Pages + 外部 OAuth（需要额外配置）

如果不想迁移到 Netlify，可以在 GitHub Pages 上使用 Decap CMS，但需要部署一个 OAuth 代理服务器：

1. 在 GitHub 创建 OAuth App（Settings → Developer settings → OAuth Apps）
2. 部署 OAuth 代理（推荐使用 [Vercel](https://vercel.com) 免费部署）
3. 在 `config.yml` 中配置 `base_url` 指向你的 OAuth 代理

> 💡 建议直接用方案一（Netlify），省去 OAuth 配置的麻烦。

---

## 使用方式

配置完成后，任何有 GitHub 账号的同学都可以：

1. 打开网站，点击侧边栏 **"🖥️ 网页上传（CMS后台）"**
2. 用 GitHub 账号登录
3. 在后台界面中拖拽上传 PDF、图片、Markdown 等文件
4. 文件自动提交到 GitHub 仓库，维护者审核后合并

上传的文件会保存到 `docs/assets/uploads/` 目录（可在 `config.yml` 中修改）。
