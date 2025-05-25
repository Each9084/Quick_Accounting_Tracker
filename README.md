# accounting_tracker

A new Flutter project.

## Getting Started

| 层级                | 代表文件/文件夹              | 主要职责                            | 示例文件                   |
| ----------------- | --------------------- | ------------------------------- | ---------------------- |
| 1️⃣ 数据库定义层        | `db/`                 | 创建、配置 SQLite 数据库和表结构            | `app_database.dart`    |
| 2️⃣ 数据模型层         | `dataModel/`          | 与数据库字段 1:1 对应，适合 SQLite 存取      | `user_entity.dart`     |
| 3️⃣ DAO 层         | `dao/`                | 封装对表的 **增删改查（CRUD）** 操作         | `user_dao.dart`        |
| 4️⃣ Mapper 层      | `mapper/`             | 将数据库模型（Entity） ↔️ 业务模型（Model）转换 | `user_mapper.dart`     |
| 5️⃣ Repository 层  | `repository/`         | 整合多个 DAO，进行**抽象封装**，方便上层调用      | `user_repository.dart` |
| 6️⃣ Service 层（推荐） | `service/`            | 负责**业务流程逻辑**，如初始化、校验、事务等        | `user_service.dart`    |
| 7️⃣ UI 层          | `screens/`、`widgets/` | 调用 service / repository 获取数据并渲染 | `bill_home_page.dart`  |
