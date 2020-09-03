import 'package:cityCloud/expanded/database/database.dart';
import 'package:moor/moor.dart';

class PersonModels extends Table {
  IntColumn get faceColorValue => integer()();
  IntColumn get bodyID => integer()();
  IntColumn get eyeID => integer()();
  IntColumn get footID => integer()();
  IntColumn get hairID => integer()();
  IntColumn get handID => integer()();
  IntColumn get noseID => integer()();
  TextColumn get id => text()();

  ///该条数据是否已经上传到服务器了
  BoolColumn get uploaded => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  static bool isAllValueValidated(PersonModel personModel) {
    return personModel.faceColorValue != null &&
        personModel.bodyID != null &&
        personModel.eyeID != null &&
        personModel.footID != null &&
        personModel.hairID != null &&
        personModel.handID != null &&
        personModel.noseID != null &&
        personModel.id != null &&
        personModel.uploaded != null;
  }
  // int faceColorValue; //通过Color(faceColorValue)得到脸的颜色
  // int bodyID; //身体id，对应于ImageHelper.bodys数组下标
  // int eyeID; //眼睛id，对应于ImageHelper.eyes数组下标
  // int footID; //脚id，对应于ImageHelper.foots数组下标。10开始是女的
  // int hairID; //头发id，对应于ImageHelper.hairs数组下标。10开始是女的
  // int handID; //手id，对应于ImageHelper.hands数组下标
  // int noseID; //鼻子id，对应于ImageHelper.noses数组下标

  // String id; //小人唯一识别id，用于小人间区分

  // PersonModel({this.faceColorValue, this.bodyID, this.eyeID, this.footID, this.hairID, this.handID, this.noseID, this.id}) {
  //   id ??= Uuid.generateUuidV4WithoutDashes();
  //   insureValueValid();
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['faceColorValue'] = this.faceColorValue;
  //   data['bodyID'] = this.bodyID;
  //   data['eyeID'] = this.eyeID;
  //   data['footID'] = this.footID;
  //   data['hairID'] = this.hairID;
  //   data['handID'] = this.handID;
  //   data['noseID'] = this.noseID;
  //   data['id'] = this.id;
  //   return data;
  // }

  // ///确保各个值都有效
  // void insureValueValid() {
  //   Random random = Random();
  //   if (faceColorValue == null || faceColorValue > 0xFFFFFFFF) {
  //     faceColorValue = ColorHelper.faces.randomItem.value;
  //   }
  //   if (bodyID == null || bodyID >= ImageHelper.bodys.length) {
  //     bodyID = random.nextInt(ImageHelper.bodys.length);
  //   }
  //   if (eyeID == null || eyeID >= ImageHelper.eyes.length) {
  //     eyeID = random.nextInt(ImageHelper.eyes.length);
  //   }

  //   if (footID == null || footID >= ImageHelper.foots.length) {
  //     footID = random.nextInt(ImageHelper.foots.length);
  //   }

  //   if (hairID == null || hairID >= ImageHelper.hairs.length) {
  //     int tmpID = random.nextInt(ImageHelper.hairs.length ~/ 2);
  //     if (bodyID >= ImageHelper.hairs.length ~/ 2) {
  //       //女的
  //       tmpID += ImageHelper.hairs.length ~/ 2;
  //     }
  //     hairID = tmpID;
  //   }

  //   if (handID == null || handID >= ImageHelper.hands.length) {
  //     handID = random.nextInt(ImageHelper.hands.length);
  //   }

  //   if (noseID == null || noseID >= ImageHelper.noses.length) {
  //     noseID = random.nextInt(ImageHelper.noses.length);
  //   }
  // }
}
