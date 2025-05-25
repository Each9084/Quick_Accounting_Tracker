import 'package:accounting_tracker/data/dao/user_dao.dart';
import 'package:accounting_tracker/data/dataModel/user_entity.dart';

class UserService {
  //初始化时默认用户,仅当此时无活跃用户时,创建本地用户
  static Future<void> ensureLocalUserExists() async {
    final activeUser = await UserDao.getActiveUser();
    if (activeUser != null) return;

    final defaultUser = UserEntity(id: null,
        uid: "local-default-user",
        username: "localUser",
        email: "offline@example.com",
        createdAt: DateTime.now(),
        avatarUrl: null,
        token: null,
    );

    await UserDao.insertUser(defaultUser);
    print("Default local user created");
  }
}