//数据库专用的数据模型, 本地数据模型（可与 UI 层解耦）
class BillEntity {
  final int? id;
  final String userId;
  final double amount;
  final String note;
  final String categoryName;
  final String categoryIcon;
  final bool isIncome;
  final String date;

  BillEntity({ //未来是自增的,没必要required
    this.id,
    required this.userId,
    required this.amount,
    required this.note,
    required this.categoryName,
    required this.categoryIcon,
    required this.isIncome,
    required this.date});

  //  将BillEntity 类的实例转换为一个 Map<String, dynamic> 类型的对象
  //  转成Map
  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "userId":userId,
      "amount":amount,
      "note":note,
      "categoryName":categoryName,
      "categoryIcon":categoryIcon,
      "isIncome":isIncome?1:0,
      "date":date,
    };
  }


  //将数据库中的 Map<String, dynamic> 数据转换成一个 BillEntity 实例
  //factory 构造函数，能够做一些额外的处理，比如数据转换
  //普通构造函数 如上面的BillEntity 就只能进行简单的赋值和初始化
  factory BillEntity.fromMap(Map<String, dynamic> map){
    return BillEntity(id: map["id"],
        userId: map["userId"],
        amount: map["amount"],
        note: map["note"],
        categoryName: map["categoryName"],
        categoryIcon: map["categoryIcon"],
        isIncome: map["isIncome"] == 1,
        date: map["date"]);
  }


}
