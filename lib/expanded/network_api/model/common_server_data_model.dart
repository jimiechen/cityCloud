class CommonServerDataModel {
  String id;
  String dataId;
  String dataFormat;
  String dataType;
  String data;
  Map<String,dynamic> json;
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

  CommonServerDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataId = json['data_id'];
    dataFormat = json['data_format'];
    dataType = json['data_type'];
    data = json['data'];
    json = json['json'];
    uid = json['uid'];
    f1 = json['f1'];
    f2 = json['f2'];
    f3 = json['f3'];
    f4 = json['f4'];
    f5 = json['f5'];
    f6 = json['f6'];
    version = json['version'];
    source = json['source'];
    sign = json['sign'];
    createDate = json['create_date'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
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
