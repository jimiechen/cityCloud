import 'dart:convert';

class CommonServerDataModel {
  String id;
  String dataId;
  String dataFormat;
  String dataType;
  String data;
  Map<String, dynamic> json;
  String uid;
  String f1;
  String f2;
  String f3;
  String f4;
  String f5;
  String f6;
  String version;
  String source;
  String sign;
  String createDate;
  String createTime;
  String updateTime;

  CommonServerDataModel(
      {this.id,
      this.dataId,
      this.dataFormat,
      this.dataType,
      this.data,
      this.json,
      this.uid,
      this.f1,
      this.f2,
      this.f3,
      this.f4,
      this.f5,
      this.f6,
      this.version,
      this.source,
      this.sign,
      this.createDate,
      this.createTime,
      this.updateTime});

  CommonServerDataModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    dataId = jsonMap['data_id'];
    dataFormat = jsonMap['data_format'];
    dataType = jsonMap['data_type'];
    data = jsonMap['data'];
    dynamic tmpJson = jsonMap['json'];
    if (tmpJson is String) {
      tmpJson = jsonDecode(tmpJson);
    }
    json = tmpJson is Map ? tmpJson : null;
    uid = jsonMap['uid'];
    f1 = jsonMap['f1'];
    f2 = jsonMap['f2'];
    f3 = jsonMap['f3'];
    f4 = jsonMap['f4'];
    f5 = jsonMap['f5'];
    f6 = jsonMap['f6'];
    version = jsonMap['version'];
    source = jsonMap['source'];
    sign = jsonMap['sign'];
    createDate = jsonMap['create_date'];
    createTime = jsonMap['create_time'];
    updateTime = jsonMap['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data_id'] = this.dataId;
    data['data_format'] = this.dataFormat;
    data['data_type'] = this.dataType;
    data['data'] = this.data;
    data['json'] = this.json;
    data['uid'] = this.uid;
    data['f1'] = this.f1;
    data['f2'] = this.f2;
    data['f3'] = this.f3;
    data['f4'] = this.f4;
    data['f5'] = this.f5;
    data['f6'] = this.f6;
    data['version'] = this.version;
    data['source'] = this.source;
    data['sign'] = this.sign;
    data['create_date'] = this.createDate;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    return data;
  }
}
