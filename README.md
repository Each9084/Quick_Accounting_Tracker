# 📒 Quick Accounting Tracker

> 一款典雅简约、功能实用的 Flutter 记账助手应用。专为记录日常收入支出、管理财务分类而设计，支持本地离线保存、分类管理、自定义键盘、国际化与夜间模式。

![Platform](https://img.shields.io/badge/Platform-Flutter-blue)  
![License](https://img.shields.io/badge/License-MIT-green)  
![Language](https://img.shields.io/badge/Language-Dart-lightgrey)

---

## ✨ 项目亮点

- 🧩 极简本地记账体验（支持 SQLite 离线持久化）
- 📅 支持按月分页浏览账单，滑动加载
- 🔍 自定义键盘 + 分类图标 + 金额校验
- 🌙 支持暗黑模式切换
- 🌐 多语言支持（中文 & English）
- 🗃️ 分类管理：系统分类 + 自定义分类
- 🔄 动态波浪背景，典雅视觉风格
- 🛠️ 支持账单编辑 / 删除 / 查询
- 📝 版本更迭时间轴（Version Timeline）

---

## 🧭 截图预览

> 待添加：你可以上传一些 `screenshots/` 图片到 GitHub 仓库，并嵌入展示。

---

## 🗂️ 项目结构（节选）

lib/
 ├── data/                  # 数据模型与 SQLite DAO
 ├── models/                # 账单、分类模型
 ├── screens/               # 各页面（主页、设置页、分类管理等）
 ├── theme/                 # 主题设置与切换
 ├── widgets/               # 通用组件（波浪背景、账单卡片等）
 ├── l10n/                  # 多语言资源文件（strings_zh.dart 等）
 └── main.dart              # 应用入口

---

## 🚀 如何运行

1. ✅ 安装 Flutter SDK，并配置好 Android 环境（推荐真机调试）
2. ✅ 克隆项目：

```bash
git clone https://github.com/Each9084/Quick_Accounting_Tracker.git
cd Quick_Accounting_Tracker
```

3. ✅ 获取依赖包：

```bash
flutter pub get
```

4. ✅ 运行：

```bash
flutter run
```

------

## 🌐 多语言与暗黑模式

- 当前支持语言：
  - 🇨🇳 简体中文（默认）
  - 🇺🇸 English
- 在设置页可切换语言（无需重启）
- 主题支持明亮 / 夜间模式切换，亦可跟随系统设置自动切换

------

## 🧾 更新日志（Version Timeline）

在侧边栏可查看完整版本更迭记录，呈现为竖状时间轴：

> 📅 项目从 2024 年 7 月 23 日立项，逐步加入了自定义键盘、UI 重构、国际化支持等内容。
>  最新版本：`v0.2.4` （2025-05-25）

------

## 📬 用户反馈与参与

欢迎通过以下方式向我提交反馈或建议：

| 类型         | 跳转方式                                                     |
| ------------ | ------------------------------------------------------------ |
| 📮 提交 Issue | [GitHub Issues](https://github.com/Each9084/Quick_Accounting_Tracker/issues) |
| 📧 邮件反馈   | [each9084@gmail.com](mailto:each9084@gmail.com)              |
| 📷 微信扫码   | 请在 App 的反馈页面扫码                                      |
| 📺 Bilibili   | [我的主页](https://space.bilibili.com/34878493?spm_id_from=333.337.0.0) |

------

## 📌 TODO（待办计划）

-  云端同步（Firebase / Supabase）
-  多账本支持（切换生活 / 房租等）
-  OCR 扫描小票识别备注
-  高级筛选与统计图表展示
-  导出为 CSV / Excel 报表

------

## 📄 License

本项目基于 MIT 开源协议，欢迎 Fork 与二次开发。

| 层级                | 代表文件/文件夹              | 主要职责                            | 示例文件                   |
| ----------------- | --------------------- | ------------------------------- | ---------------------- |
| 1️⃣ 数据库定义层        | `db/`                 | 创建、配置 SQLite 数据库和表结构            | `app_database.dart`    |
| 2️⃣ 数据模型层         | `dataModel/`          | 与数据库字段 1:1 对应，适合 SQLite 存取      | `user_entity.dart`     |
| 3️⃣ DAO 层         | `dao/`                | 封装对表的 **增删改查（CRUD）** 操作         | `user_dao.dart`        |
| 4️⃣ Mapper 层      | `mapper/`             | 将数据库模型（Entity） ↔️ 业务模型（Model）转换 | `user_mapper.dart`     |
| 5️⃣ Repository 层  | `repository/`         | 整合多个 DAO，进行**抽象封装**，方便上层调用      | `user_repository.dart` |
| 6️⃣ Service 层（推荐） | `service/`            | 负责**业务流程逻辑**，如初始化、校验、事务等        | `user_service.dart`    |
| 7️⃣ UI 层          | `screens/`、`widgets/` | 调用 service / repository 获取数据并渲染 | `bill_home_page.dart`  |
