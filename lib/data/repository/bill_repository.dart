import 'package:accounting_tracker/data/dao/bill_dao.dart';
import 'package:accounting_tracker/data/mapper/bill_mapper.dart';
import 'package:accounting_tracker/models/bill.dart';

class BillRepository {
  BillRepository();

  /// 插入账单（返回插入后的 ID）
  Future<int> insertBill(Bill bill, {required int userId}) async {
    final entity = BillMapper.toEntity(bill, userId: userId);
    return await BillDao.insertBill(entity);
  }


  //更新账单
  Future<int> updateBill(Bill bill, {required int userId}) async {
    final entity = BillMapper.toEntity(bill, userId: userId);
    return await BillDao.updateBill(entity);
  }

  //删除账单
  Future<int> deleteBill(int billId) async {
    return await BillDao.deleteBill(billId);
  }

  //清空所有帐单
  Future<void> clearAll() async {
    await BillDao.clearAll();
  }

  //获取指定用户所有账单（按时间倒序）
  Future<List<Bill>> getAllBillsByUser(int userId) async {
    final entities = await BillDao.getBillsByUser(userId);
    //下面BillMapper.toModel 是 高级写法,等效
    return entities.map((entity) => BillMapper.toModel(entity)).toList();
  }

  //获取某年某月的账单
  Future<List<Bill>> getBillsByMonth({
    required int userId,
    required int year,
    required int month,
  })async{
    final entities = await BillDao.getBillByMonth(user_id: userId, year: year, month: month);
    return  entities.map(BillMapper.toModel).toList();
  }

  //通过 ID 获取账单详情 查不到为 null
  Future<Bill?> getBillById(int id) async {
    final entity = await BillDao.getBillById(id);
    return entity != null?BillMapper.toModel(entity) : null;
  }

  //删除某用户的所有账单
   Future<int> deleteAllByUser(int userId) async {
    return await BillDao.deleteAllByUser(userId);
   }

}
