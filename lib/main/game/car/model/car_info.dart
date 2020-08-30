import 'package:moor/moor.dart';

class CarInfos extends Table {
  IntColumn get carID => integer()();
  TextColumn get id => text()();

  ///该条数据是否已经上传到服务器了
  BoolColumn get uploaded => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// int carID;
//   String id; //小车唯一识别id，用于小车区分

//   CarInfo({
//     this.carID,
//     this.id,
//   }) {
//     assert(carID != null);
//     id ??= Uuid.generateUuidV4WithoutDashes();
//     insureValueValid();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['carID'] = this.carID;
//     data['id'] = this.id;
//     return data;
//   }

//   ///确保各个值都有效
//   void insureValueValid() {
//     Random random = Random();
//     if (carID == null || carID >= ImageHelper.carNumber) {
//       carID = random.nextInt(ImageHelper.carNumber);
//     }
//   }
