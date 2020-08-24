import 'dart:math';

import 'package:cityCloud/dart_class/extension/Iterable_extension.dart';
import 'package:cityCloud/styles/color_helper.dart';
import 'package:cityCloud/util/image_helper.dart';
import 'package:cityCloud/util/uuid.dart';

class PersonModel {
  int faceColorValue; //通过Color(faceColorValue)得到脸的颜色
  int bodyID; //身体id，对应于ImageHelper.bodys数组下标
  int eyeID; //眼睛id，对应于ImageHelper.eyes数组下标
  int footID; //脚id，对应于ImageHelper.foots数组下标
  int hairID; //头发id，对应于ImageHelper.hairs数组下标
  int handID; //手id，对应于ImageHelper.hands数组下标
  int noseID; //鼻子id，对应于ImageHelper.noses数组下标

  String id; //小人唯一识别id，用于小人间区分

  PersonModel(
      {this.faceColorValue, this.bodyID, this.eyeID, this.footID, this.hairID, this.handID, this.noseID, this.id}) {
    id ??= Uuid.generateV4() + '_' + DateTime.now().toIso8601String();
    insureValueValid();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['faceColorValue'] = this.faceColorValue;
    data['bodyID'] = this.bodyID;
    data['eyeID'] = this.eyeID;
    data['footID'] = this.footID;
    data['hairID'] = this.hairID;
    data['handID'] = this.handID;
    data['noseID'] = this.noseID;
    return data;
  }

  ///确保各个值都有效
  void insureValueValid() {
    Random random = Random();
    if (faceColorValue == null || faceColorValue > 0xFFFFFFFF) {
      faceColorValue = ColorHelper.faces.randomItem.value;
    }
    if (bodyID == null || bodyID >= ImageHelper.bodys.length) {
      bodyID = random.nextInt(ImageHelper.bodys.length);
    }
    if (eyeID == null || eyeID >= ImageHelper.eyes.length) {
      eyeID = random.nextInt(ImageHelper.eyes.length);
    }

    if (footID == null || footID >= ImageHelper.foots.length) {
      footID = random.nextInt(ImageHelper.foots.length);
    }

    if (hairID == null || hairID >= ImageHelper.hairs.length) {
      hairID = random.nextInt(ImageHelper.hairs.length);
    }

    if (handID == null || handID >= ImageHelper.hands.length) {
      handID = random.nextInt(ImageHelper.hands.length);
    }

    if (noseID == null || noseID >= ImageHelper.noses.length) {
      noseID = random.nextInt(ImageHelper.noses.length);
    }
  }
}
