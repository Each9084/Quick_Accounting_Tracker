# 📒 Quick Accounting Tracker

> 🧾 一款典雅简约、功能实用的 Flutter 记账助手应用。  
> 🎯 记录日常收入支出，管理分类，支持离线保存、国际化与夜间模式。

---

## ✨ 功能亮点

- 🧩 极简本地记账体验（SQLite 离线持久化）
- 📅 按月分页浏览账单，支持滑动加载
- 🔢 自定义键盘 + 分类图标 + 金额校验
- 🌙 支持暗黑模式切换
- 🌐 多语言支持（中文 & English）
- 🗃️ 分类管理：系统分类 + 自定义分类
- 🌊 动态波浪背景，典雅视觉风格
- 🛠️ 支持账单编辑 / 删除 / 查询
- 📝 版本更迭时间轴（Version Timeline）

---

## 🧭 截图预览 功能展示

<img src =../accounting_tracker/assets/img/introduction/2addpage.gif width = 60%> 

<img src =../accounting_tracker/assets/img/weChat_QRCode.jpg width = 60%>



|  #   | 功能说明                                        | 截图                                                         |
| :--: | ----------------------------------------------- | ------------------------------------------------------------ |
|  1️⃣   | 主页面：显示当月账单、总资产卡片、添加按钮等    | <p align="center"><img src = ../accounting_tracker/assets/img/introduction/1mainpage.gif width = 60% ></p> |
|  2️⃣   | 添加账单：支持自定义键盘、备注、图标分类等      | <div align="center"><img src =../accounting_tracker/assets/img/introduction/2addpage.gif width = 60%> </div>|
|  3️⃣   | 删除账单：通过滑动删除并展示红色提示背景        | <div align="center"><img src = ../accounting_tracker/assets/img/introduction/3delete.gif width = 60%></div> |
|  4️⃣   | 到达指定日期 / 搜索功能（模糊查询）             | <div align="center"><img src =../accounting_tracker/assets/img/introduction/4search.gif width = 60%> </div>|
|  5️⃣   | 夜间模式：支持系统同步或手动切换主题            | <div align="center"><img src =../accounting_tracker/assets/img/introduction/5nightmode.gif width = 60%> </div>|
|  6️⃣   | 多语言支持：中文 / English 实时切换             | <div align="center"><img src =../accounting_tracker/assets/img/introduction/6multilanguage.gif width = 60%> </div>|
|  7️⃣   | 分类管理：用户可添加、编辑、删除分类            | <div align="center"><img src =../accounting_tracker/assets/img/introduction/7addcategory.gif width=60%> </div>|
|  8️⃣   | 反馈页面：支持 GitHub issue、邮箱、B 站私信反馈 | <div align="center"><img src =../accounting_tracker/assets/img/introduction/8feedback.gif width = 60%> </div>|
|  9️⃣   | 版本回顾：时间轴展示每个版本更新记录            | <div align="center"><img src =../accounting_tracker/assets/img/introduction/9update.gif width=60%> </div>|
|  🔟   | 清除缓存：一键重置账本、分类等信息              | <div align="center"><img src =../accounting_tracker/assets/img/introduction/10clearcache.gif width = 60%></div> |

---

## 🗂️ 项目结构

```
lib/
├── data/            # 本地数据库访问（DAO、Entity、Migration）
│   ├── dao/         # DAO 层（如 UserDao、BillDao）
│   ├── db/          # AppDatabase 初始化与迁移
│   ├── dataModel/   # SQLite Entity 数据结构
│   └── repository/  # Repository 封装
├── models/          # UI 业务模型（如 Bill, Category）
├── screens/         # 页面视图（主页、设置页等）
├── widgets/         # 自定义组件
├── l10n/            # 多语言资源管理
├── theme/           # 夜间/日间主题
└── main.dart        # 项目入口
```

| 层级     | 模块          | 职责说明                           | 示例文件               |
| -------- | ------------- | ---------------------------------- | ---------------------- |
| 数据库   | `db/`         | 创建数据库与迁移                   | `app_database.dart`    |
| 数据模型 | `dataModel/`  | Entity 定义，映射数据库字段        | `user_entity.dart`     |
| DAO 层   | `dao/`        | 数据库操作封装（增删改查）         | `bill_dao.dart`        |
| 映射层   | `mapper/`     | 数据模型与业务模型转换             | `bill_mapper.dart`     |
| 仓储层   | `repository/` | 整合 DAO，封装业务逻辑调用入口     | `user_repository.dart` |
| 服务层   | `service/`    | 高级逻辑控制（如初始化、事务处理） | `bill_service.dart`    |
| UI 层    | `screens/` 等 | 页面与组件显示                     | `bill_home_page.dart`  |

---

## 📥 下载与体验

📦 [点击前往 Release 页面](https://github.com/Each9084/Quick_Accounting_Tracker/releases) 下载安卓 APK 文件安装体验。

---

## 🚀 快速开始

1. ✅ 安装 Flutter SDK，并配置 Android 开发环境
2. ✅ 克隆项目：

```bash
git clone https://github.com/Each9084/Quick_Accounting_Tracker.git
cd Quick_Accounting_Tracker
```

3. ✅ 获取依赖包：

```bash
flutter pub get
```

4. ✅ 启动项目：

```bash
flutter run
```

---

## 🌐 多语言与夜间模式

- 支持语言切换：
  - 🇨🇳 简体中文
  - 🇺🇸 English（默认）
- 在设置页面实时切换语言（无需重启）
- 支持亮 / 暗模式切换，可跟随系统设置

---

## 🧾 更新日志（Version Timeline）

> 📅 项目始于 2024 年 7 月 23 日，持续更新中  
> 🔖 当前版本：`v0.2.4`（2025-05-25）

📌 点击 App 侧边栏“版本更迭”可查看完整时间线。

---

## 📬 用户反馈与参与

欢迎通过以下方式反馈 Bug 或建议：

| 渠道           | 链接                                                         |
| -------------- | ------------------------------------------------------------ |
| 📮 GitHub Issue | [GitHub Issues](https://github.com/Each9084/Quick_Accounting_Tracker/issues) |
| 📧 邮件反馈     | [each9084@gmail.com](mailto:each9084@gmail.com)              |
| 📷 微信扫码     | 请在 App 内“反馈页面”扫码                                    |
| 📺 Bilibili     | [B 站主页](https://space.bilibili.com/34878493?spm_id_from=333.337.0.0) |

---

## 🚧 开发计划（Roadmap）

- ✅ 多语言支持（完成）
- ✅ 分类管理模块（完成）
- ✅ 自定义键盘（完成）
- ✅ 波浪视觉风格（完成）
- 🕐 OCR 小票识别备注（计划中）
- 🕐 Firebase 云同步（计划中）
- 🕐 多账本支持（计划中）
- 🕐 数据导出功能（CSV / Excel）

---

## 📄 License

本项目基于 MIT 协议开源，欢迎自由使用、Fork 与二次开发。
