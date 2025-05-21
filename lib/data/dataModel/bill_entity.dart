//数据库专用的数据模型, 本地数据模型（可与 UI 层解耦）
class BillEntity {
  final int? id;
  final int user_id;
  final double amount;
  final String note;
  final String category_name;
  final int category_icon_code;
  final bool is_income;
  final String date;

  BillEntity({ //未来是自增的,没必要required
    this.id,
    required this.user_id,
    required this.amount,
    required this.note,
    required this.category_name,
    required this.category_icon_code,
    required this.is_income,
    required this.date});

  //  将BillEntity 类的实例转换为一个 Map<String, dynamic> 类型的对象
  //  转成Map
  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "user_id":user_id,
      "amount":amount,
      "note":note,
      "category_name":category_name,
      "category_icon_code":category_icon_code,
      "is_income":is_income?1:0,
      "date":date,
    };
  }


  //将数据库中的 Map<String, dynamic> 数据转换成一个 BillEntity 实例
  //factory 构造函数，能够做一些额外的处理，比如数据转换
  //普通构造函数 如上面的BillEntity 就只能进行简单的赋值和初始化
  factory BillEntity.fromMap(Map<String, dynamic> map){
    return BillEntity(id: map["id"],
        user_id: map["user_id"],
        amount: map["amount"],
        note: map["note"],
        category_name: map["category_name"],
        category_icon_code: map["category_icon_code"],
        is_income: map["is_income"] == 1,
        date: map["date"]);
  }


}
