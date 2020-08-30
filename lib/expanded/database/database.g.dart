// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class CacheDBItem extends DataClass implements Insertable<CacheDBItem> {
  final int index;
  final String content;
  final String type;
  CacheDBItem(
      {@required this.index, @required this.content, @required this.type});
  factory CacheDBItem.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return CacheDBItem(
      index: intType.mapFromDatabaseResponse(data['${effectivePrefix}dbIndex']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || index != null) {
      map['dbIndex'] = Variable<int>(index);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    return map;
  }

  CacheDBItemsCompanion toCompanion(bool nullToAbsent) {
    return CacheDBItemsCompanion(
      index:
          index == null && nullToAbsent ? const Value.absent() : Value(index),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
    );
  }

  factory CacheDBItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CacheDBItem(
      index: serializer.fromJson<int>(json['index']),
      content: serializer.fromJson<String>(json['content']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'index': serializer.toJson<int>(index),
      'content': serializer.toJson<String>(content),
      'type': serializer.toJson<String>(type),
    };
  }

  CacheDBItem copyWith({int index, String content, String type}) => CacheDBItem(
        index: index ?? this.index,
        content: content ?? this.content,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('CacheDBItem(')
          ..write('index: $index, ')
          ..write('content: $content, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(index.hashCode, $mrjc(content.hashCode, type.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CacheDBItem &&
          other.index == this.index &&
          other.content == this.content &&
          other.type == this.type);
}

class CacheDBItemsCompanion extends UpdateCompanion<CacheDBItem> {
  final Value<int> index;
  final Value<String> content;
  final Value<String> type;
  const CacheDBItemsCompanion({
    this.index = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
  });
  CacheDBItemsCompanion.insert({
    this.index = const Value.absent(),
    @required String content,
    @required String type,
  })  : content = Value(content),
        type = Value(type);
  static Insertable<CacheDBItem> custom({
    Expression<int> index,
    Expression<String> content,
    Expression<String> type,
  }) {
    return RawValuesInsertable({
      if (index != null) 'dbIndex': index,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
    });
  }

  CacheDBItemsCompanion copyWith(
      {Value<int> index, Value<String> content, Value<String> type}) {
    return CacheDBItemsCompanion(
      index: index ?? this.index,
      content: content ?? this.content,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (index.present) {
      map['dbIndex'] = Variable<int>(index.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheDBItemsCompanion(')
          ..write('index: $index, ')
          ..write('content: $content, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $CacheDBItemsTable extends CacheDBItems
    with TableInfo<$CacheDBItemsTable, CacheDBItem> {
  final GeneratedDatabase _db;
  final String _alias;
  $CacheDBItemsTable(this._db, [this._alias]);
  final VerificationMeta _indexMeta = const VerificationMeta('index');
  GeneratedIntColumn _index;
  @override
  GeneratedIntColumn get index => _index ??= _constructIndex();
  GeneratedIntColumn _constructIndex() {
    return GeneratedIntColumn(
      'dbIndex',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedTextColumn _content;
  @override
  GeneratedTextColumn get content => _content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [index, content, type];
  @override
  $CacheDBItemsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cache_d_b_items';
  @override
  final String actualTableName = 'cache_d_b_items';
  @override
  VerificationContext validateIntegrity(Insertable<CacheDBItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dbIndex')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['dbIndex'], _indexMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content'], _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {index};
  @override
  CacheDBItem map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CacheDBItem.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CacheDBItemsTable createAlias(String alias) {
    return $CacheDBItemsTable(_db, alias);
  }
}

class CarInfo extends DataClass implements Insertable<CarInfo> {
  final int carID;
  final String id;
  CarInfo({@required this.carID, @required this.id});
  factory CarInfo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return CarInfo(
      carID: intType.mapFromDatabaseResponse(data['${effectivePrefix}car_i_d']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || carID != null) {
      map['car_i_d'] = Variable<int>(carID);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    return map;
  }

  CarInfosCompanion toCompanion(bool nullToAbsent) {
    return CarInfosCompanion(
      carID:
          carID == null && nullToAbsent ? const Value.absent() : Value(carID),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
    );
  }

  factory CarInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CarInfo(
      carID: serializer.fromJson<int>(json['carID']),
      id: serializer.fromJson<String>(json['id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'carID': serializer.toJson<int>(carID),
      'id': serializer.toJson<String>(id),
    };
  }

  CarInfo copyWith({int carID, String id}) => CarInfo(
        carID: carID ?? this.carID,
        id: id ?? this.id,
      );
  @override
  String toString() {
    return (StringBuffer('CarInfo(')
          ..write('carID: $carID, ')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(carID.hashCode, id.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CarInfo && other.carID == this.carID && other.id == this.id);
}

class CarInfosCompanion extends UpdateCompanion<CarInfo> {
  final Value<int> carID;
  final Value<String> id;
  const CarInfosCompanion({
    this.carID = const Value.absent(),
    this.id = const Value.absent(),
  });
  CarInfosCompanion.insert({
    @required int carID,
    @required String id,
  })  : carID = Value(carID),
        id = Value(id);
  static Insertable<CarInfo> custom({
    Expression<int> carID,
    Expression<String> id,
  }) {
    return RawValuesInsertable({
      if (carID != null) 'car_i_d': carID,
      if (id != null) 'id': id,
    });
  }

  CarInfosCompanion copyWith({Value<int> carID, Value<String> id}) {
    return CarInfosCompanion(
      carID: carID ?? this.carID,
      id: id ?? this.id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (carID.present) {
      map['car_i_d'] = Variable<int>(carID.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarInfosCompanion(')
          ..write('carID: $carID, ')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }
}

class $CarInfosTable extends CarInfos with TableInfo<$CarInfosTable, CarInfo> {
  final GeneratedDatabase _db;
  final String _alias;
  $CarInfosTable(this._db, [this._alias]);
  final VerificationMeta _carIDMeta = const VerificationMeta('carID');
  GeneratedIntColumn _carID;
  @override
  GeneratedIntColumn get carID => _carID ??= _constructCarID();
  GeneratedIntColumn _constructCarID() {
    return GeneratedIntColumn(
      'car_i_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [carID, id];
  @override
  $CarInfosTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'car_infos';
  @override
  final String actualTableName = 'car_infos';
  @override
  VerificationContext validateIntegrity(Insertable<CarInfo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('car_i_d')) {
      context.handle(
          _carIDMeta, carID.isAcceptableOrUnknown(data['car_i_d'], _carIDMeta));
    } else if (isInserting) {
      context.missing(_carIDMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarInfo map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CarInfo.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CarInfosTable createAlias(String alias) {
    return $CarInfosTable(_db, alias);
  }
}

class PersonModel extends DataClass implements Insertable<PersonModel> {
  final int faceColorValue;
  final int bodyID;
  final int eyeID;
  final int footID;
  final int hairID;
  final int handID;
  final int noseID;
  final String id;
  PersonModel(
      {@required this.faceColorValue,
      @required this.bodyID,
      @required this.eyeID,
      @required this.footID,
      @required this.hairID,
      @required this.handID,
      @required this.noseID,
      @required this.id});
  factory PersonModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return PersonModel(
      faceColorValue: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}face_color_value']),
      bodyID:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}body_i_d']),
      eyeID: intType.mapFromDatabaseResponse(data['${effectivePrefix}eye_i_d']),
      footID:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}foot_i_d']),
      hairID:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}hair_i_d']),
      handID:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}hand_i_d']),
      noseID:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}nose_i_d']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || faceColorValue != null) {
      map['face_color_value'] = Variable<int>(faceColorValue);
    }
    if (!nullToAbsent || bodyID != null) {
      map['body_i_d'] = Variable<int>(bodyID);
    }
    if (!nullToAbsent || eyeID != null) {
      map['eye_i_d'] = Variable<int>(eyeID);
    }
    if (!nullToAbsent || footID != null) {
      map['foot_i_d'] = Variable<int>(footID);
    }
    if (!nullToAbsent || hairID != null) {
      map['hair_i_d'] = Variable<int>(hairID);
    }
    if (!nullToAbsent || handID != null) {
      map['hand_i_d'] = Variable<int>(handID);
    }
    if (!nullToAbsent || noseID != null) {
      map['nose_i_d'] = Variable<int>(noseID);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    return map;
  }

  PersonModelsCompanion toCompanion(bool nullToAbsent) {
    return PersonModelsCompanion(
      faceColorValue: faceColorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(faceColorValue),
      bodyID:
          bodyID == null && nullToAbsent ? const Value.absent() : Value(bodyID),
      eyeID:
          eyeID == null && nullToAbsent ? const Value.absent() : Value(eyeID),
      footID:
          footID == null && nullToAbsent ? const Value.absent() : Value(footID),
      hairID:
          hairID == null && nullToAbsent ? const Value.absent() : Value(hairID),
      handID:
          handID == null && nullToAbsent ? const Value.absent() : Value(handID),
      noseID:
          noseID == null && nullToAbsent ? const Value.absent() : Value(noseID),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
    );
  }

  factory PersonModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PersonModel(
      faceColorValue: serializer.fromJson<int>(json['faceColorValue']),
      bodyID: serializer.fromJson<int>(json['bodyID']),
      eyeID: serializer.fromJson<int>(json['eyeID']),
      footID: serializer.fromJson<int>(json['footID']),
      hairID: serializer.fromJson<int>(json['hairID']),
      handID: serializer.fromJson<int>(json['handID']),
      noseID: serializer.fromJson<int>(json['noseID']),
      id: serializer.fromJson<String>(json['id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'faceColorValue': serializer.toJson<int>(faceColorValue),
      'bodyID': serializer.toJson<int>(bodyID),
      'eyeID': serializer.toJson<int>(eyeID),
      'footID': serializer.toJson<int>(footID),
      'hairID': serializer.toJson<int>(hairID),
      'handID': serializer.toJson<int>(handID),
      'noseID': serializer.toJson<int>(noseID),
      'id': serializer.toJson<String>(id),
    };
  }

  PersonModel copyWith(
          {int faceColorValue,
          int bodyID,
          int eyeID,
          int footID,
          int hairID,
          int handID,
          int noseID,
          String id}) =>
      PersonModel(
        faceColorValue: faceColorValue ?? this.faceColorValue,
        bodyID: bodyID ?? this.bodyID,
        eyeID: eyeID ?? this.eyeID,
        footID: footID ?? this.footID,
        hairID: hairID ?? this.hairID,
        handID: handID ?? this.handID,
        noseID: noseID ?? this.noseID,
        id: id ?? this.id,
      );
  @override
  String toString() {
    return (StringBuffer('PersonModel(')
          ..write('faceColorValue: $faceColorValue, ')
          ..write('bodyID: $bodyID, ')
          ..write('eyeID: $eyeID, ')
          ..write('footID: $footID, ')
          ..write('hairID: $hairID, ')
          ..write('handID: $handID, ')
          ..write('noseID: $noseID, ')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      faceColorValue.hashCode,
      $mrjc(
          bodyID.hashCode,
          $mrjc(
              eyeID.hashCode,
              $mrjc(
                  footID.hashCode,
                  $mrjc(
                      hairID.hashCode,
                      $mrjc(handID.hashCode,
                          $mrjc(noseID.hashCode, id.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PersonModel &&
          other.faceColorValue == this.faceColorValue &&
          other.bodyID == this.bodyID &&
          other.eyeID == this.eyeID &&
          other.footID == this.footID &&
          other.hairID == this.hairID &&
          other.handID == this.handID &&
          other.noseID == this.noseID &&
          other.id == this.id);
}

class PersonModelsCompanion extends UpdateCompanion<PersonModel> {
  final Value<int> faceColorValue;
  final Value<int> bodyID;
  final Value<int> eyeID;
  final Value<int> footID;
  final Value<int> hairID;
  final Value<int> handID;
  final Value<int> noseID;
  final Value<String> id;
  const PersonModelsCompanion({
    this.faceColorValue = const Value.absent(),
    this.bodyID = const Value.absent(),
    this.eyeID = const Value.absent(),
    this.footID = const Value.absent(),
    this.hairID = const Value.absent(),
    this.handID = const Value.absent(),
    this.noseID = const Value.absent(),
    this.id = const Value.absent(),
  });
  PersonModelsCompanion.insert({
    @required int faceColorValue,
    @required int bodyID,
    @required int eyeID,
    @required int footID,
    @required int hairID,
    @required int handID,
    @required int noseID,
    @required String id,
  })  : faceColorValue = Value(faceColorValue),
        bodyID = Value(bodyID),
        eyeID = Value(eyeID),
        footID = Value(footID),
        hairID = Value(hairID),
        handID = Value(handID),
        noseID = Value(noseID),
        id = Value(id);
  static Insertable<PersonModel> custom({
    Expression<int> faceColorValue,
    Expression<int> bodyID,
    Expression<int> eyeID,
    Expression<int> footID,
    Expression<int> hairID,
    Expression<int> handID,
    Expression<int> noseID,
    Expression<String> id,
  }) {
    return RawValuesInsertable({
      if (faceColorValue != null) 'face_color_value': faceColorValue,
      if (bodyID != null) 'body_i_d': bodyID,
      if (eyeID != null) 'eye_i_d': eyeID,
      if (footID != null) 'foot_i_d': footID,
      if (hairID != null) 'hair_i_d': hairID,
      if (handID != null) 'hand_i_d': handID,
      if (noseID != null) 'nose_i_d': noseID,
      if (id != null) 'id': id,
    });
  }

  PersonModelsCompanion copyWith(
      {Value<int> faceColorValue,
      Value<int> bodyID,
      Value<int> eyeID,
      Value<int> footID,
      Value<int> hairID,
      Value<int> handID,
      Value<int> noseID,
      Value<String> id}) {
    return PersonModelsCompanion(
      faceColorValue: faceColorValue ?? this.faceColorValue,
      bodyID: bodyID ?? this.bodyID,
      eyeID: eyeID ?? this.eyeID,
      footID: footID ?? this.footID,
      hairID: hairID ?? this.hairID,
      handID: handID ?? this.handID,
      noseID: noseID ?? this.noseID,
      id: id ?? this.id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (faceColorValue.present) {
      map['face_color_value'] = Variable<int>(faceColorValue.value);
    }
    if (bodyID.present) {
      map['body_i_d'] = Variable<int>(bodyID.value);
    }
    if (eyeID.present) {
      map['eye_i_d'] = Variable<int>(eyeID.value);
    }
    if (footID.present) {
      map['foot_i_d'] = Variable<int>(footID.value);
    }
    if (hairID.present) {
      map['hair_i_d'] = Variable<int>(hairID.value);
    }
    if (handID.present) {
      map['hand_i_d'] = Variable<int>(handID.value);
    }
    if (noseID.present) {
      map['nose_i_d'] = Variable<int>(noseID.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonModelsCompanion(')
          ..write('faceColorValue: $faceColorValue, ')
          ..write('bodyID: $bodyID, ')
          ..write('eyeID: $eyeID, ')
          ..write('footID: $footID, ')
          ..write('hairID: $hairID, ')
          ..write('handID: $handID, ')
          ..write('noseID: $noseID, ')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }
}

class $PersonModelsTable extends PersonModels
    with TableInfo<$PersonModelsTable, PersonModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $PersonModelsTable(this._db, [this._alias]);
  final VerificationMeta _faceColorValueMeta =
      const VerificationMeta('faceColorValue');
  GeneratedIntColumn _faceColorValue;
  @override
  GeneratedIntColumn get faceColorValue =>
      _faceColorValue ??= _constructFaceColorValue();
  GeneratedIntColumn _constructFaceColorValue() {
    return GeneratedIntColumn(
      'face_color_value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bodyIDMeta = const VerificationMeta('bodyID');
  GeneratedIntColumn _bodyID;
  @override
  GeneratedIntColumn get bodyID => _bodyID ??= _constructBodyID();
  GeneratedIntColumn _constructBodyID() {
    return GeneratedIntColumn(
      'body_i_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _eyeIDMeta = const VerificationMeta('eyeID');
  GeneratedIntColumn _eyeID;
  @override
  GeneratedIntColumn get eyeID => _eyeID ??= _constructEyeID();
  GeneratedIntColumn _constructEyeID() {
    return GeneratedIntColumn(
      'eye_i_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _footIDMeta = const VerificationMeta('footID');
  GeneratedIntColumn _footID;
  @override
  GeneratedIntColumn get footID => _footID ??= _constructFootID();
  GeneratedIntColumn _constructFootID() {
    return GeneratedIntColumn(
      'foot_i_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hairIDMeta = const VerificationMeta('hairID');
  GeneratedIntColumn _hairID;
  @override
  GeneratedIntColumn get hairID => _hairID ??= _constructHairID();
  GeneratedIntColumn _constructHairID() {
    return GeneratedIntColumn(
      'hair_i_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _handIDMeta = const VerificationMeta('handID');
  GeneratedIntColumn _handID;
  @override
  GeneratedIntColumn get handID => _handID ??= _constructHandID();
  GeneratedIntColumn _constructHandID() {
    return GeneratedIntColumn(
      'hand_i_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _noseIDMeta = const VerificationMeta('noseID');
  GeneratedIntColumn _noseID;
  @override
  GeneratedIntColumn get noseID => _noseID ??= _constructNoseID();
  GeneratedIntColumn _constructNoseID() {
    return GeneratedIntColumn(
      'nose_i_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [faceColorValue, bodyID, eyeID, footID, hairID, handID, noseID, id];
  @override
  $PersonModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'person_models';
  @override
  final String actualTableName = 'person_models';
  @override
  VerificationContext validateIntegrity(Insertable<PersonModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('face_color_value')) {
      context.handle(
          _faceColorValueMeta,
          faceColorValue.isAcceptableOrUnknown(
              data['face_color_value'], _faceColorValueMeta));
    } else if (isInserting) {
      context.missing(_faceColorValueMeta);
    }
    if (data.containsKey('body_i_d')) {
      context.handle(_bodyIDMeta,
          bodyID.isAcceptableOrUnknown(data['body_i_d'], _bodyIDMeta));
    } else if (isInserting) {
      context.missing(_bodyIDMeta);
    }
    if (data.containsKey('eye_i_d')) {
      context.handle(
          _eyeIDMeta, eyeID.isAcceptableOrUnknown(data['eye_i_d'], _eyeIDMeta));
    } else if (isInserting) {
      context.missing(_eyeIDMeta);
    }
    if (data.containsKey('foot_i_d')) {
      context.handle(_footIDMeta,
          footID.isAcceptableOrUnknown(data['foot_i_d'], _footIDMeta));
    } else if (isInserting) {
      context.missing(_footIDMeta);
    }
    if (data.containsKey('hair_i_d')) {
      context.handle(_hairIDMeta,
          hairID.isAcceptableOrUnknown(data['hair_i_d'], _hairIDMeta));
    } else if (isInserting) {
      context.missing(_hairIDMeta);
    }
    if (data.containsKey('hand_i_d')) {
      context.handle(_handIDMeta,
          handID.isAcceptableOrUnknown(data['hand_i_d'], _handIDMeta));
    } else if (isInserting) {
      context.missing(_handIDMeta);
    }
    if (data.containsKey('nose_i_d')) {
      context.handle(_noseIDMeta,
          noseID.isAcceptableOrUnknown(data['nose_i_d'], _noseIDMeta));
    } else if (isInserting) {
      context.missing(_noseIDMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PersonModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PersonModelsTable createAlias(String alias) {
    return $PersonModelsTable(_db, alias);
  }
}

class TileInfo extends DataClass implements Insertable<TileInfo> {
  final int tileMapX;
  final int tileMapY;
  final int viewID;
  final int bgColor;
  final String id;
  TileInfo(
      {@required this.tileMapX,
      @required this.tileMapY,
      @required this.viewID,
      @required this.bgColor,
      @required this.id});
  factory TileInfo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return TileInfo(
      tileMapX:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}tile_map_x']),
      tileMapY:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}tile_map_y']),
      viewID:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}view_i_d']),
      bgColor:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}bg_color']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || tileMapX != null) {
      map['tile_map_x'] = Variable<int>(tileMapX);
    }
    if (!nullToAbsent || tileMapY != null) {
      map['tile_map_y'] = Variable<int>(tileMapY);
    }
    if (!nullToAbsent || viewID != null) {
      map['view_i_d'] = Variable<int>(viewID);
    }
    if (!nullToAbsent || bgColor != null) {
      map['bg_color'] = Variable<int>(bgColor);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    return map;
  }

  TileInfosCompanion toCompanion(bool nullToAbsent) {
    return TileInfosCompanion(
      tileMapX: tileMapX == null && nullToAbsent
          ? const Value.absent()
          : Value(tileMapX),
      tileMapY: tileMapY == null && nullToAbsent
          ? const Value.absent()
          : Value(tileMapY),
      viewID:
          viewID == null && nullToAbsent ? const Value.absent() : Value(viewID),
      bgColor: bgColor == null && nullToAbsent
          ? const Value.absent()
          : Value(bgColor),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
    );
  }

  factory TileInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TileInfo(
      tileMapX: serializer.fromJson<int>(json['tileMapX']),
      tileMapY: serializer.fromJson<int>(json['tileMapY']),
      viewID: serializer.fromJson<int>(json['viewID']),
      bgColor: serializer.fromJson<int>(json['bgColor']),
      id: serializer.fromJson<String>(json['id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tileMapX': serializer.toJson<int>(tileMapX),
      'tileMapY': serializer.toJson<int>(tileMapY),
      'viewID': serializer.toJson<int>(viewID),
      'bgColor': serializer.toJson<int>(bgColor),
      'id': serializer.toJson<String>(id),
    };
  }

  TileInfo copyWith(
          {int tileMapX, int tileMapY, int viewID, int bgColor, String id}) =>
      TileInfo(
        tileMapX: tileMapX ?? this.tileMapX,
        tileMapY: tileMapY ?? this.tileMapY,
        viewID: viewID ?? this.viewID,
        bgColor: bgColor ?? this.bgColor,
        id: id ?? this.id,
      );
  @override
  String toString() {
    return (StringBuffer('TileInfo(')
          ..write('tileMapX: $tileMapX, ')
          ..write('tileMapY: $tileMapY, ')
          ..write('viewID: $viewID, ')
          ..write('bgColor: $bgColor, ')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      tileMapX.hashCode,
      $mrjc(tileMapY.hashCode,
          $mrjc(viewID.hashCode, $mrjc(bgColor.hashCode, id.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TileInfo &&
          other.tileMapX == this.tileMapX &&
          other.tileMapY == this.tileMapY &&
          other.viewID == this.viewID &&
          other.bgColor == this.bgColor &&
          other.id == this.id);
}

class TileInfosCompanion extends UpdateCompanion<TileInfo> {
  final Value<int> tileMapX;
  final Value<int> tileMapY;
  final Value<int> viewID;
  final Value<int> bgColor;
  final Value<String> id;
  const TileInfosCompanion({
    this.tileMapX = const Value.absent(),
    this.tileMapY = const Value.absent(),
    this.viewID = const Value.absent(),
    this.bgColor = const Value.absent(),
    this.id = const Value.absent(),
  });
  TileInfosCompanion.insert({
    @required int tileMapX,
    @required int tileMapY,
    @required int viewID,
    @required int bgColor,
    @required String id,
  })  : tileMapX = Value(tileMapX),
        tileMapY = Value(tileMapY),
        viewID = Value(viewID),
        bgColor = Value(bgColor),
        id = Value(id);
  static Insertable<TileInfo> custom({
    Expression<int> tileMapX,
    Expression<int> tileMapY,
    Expression<int> viewID,
    Expression<int> bgColor,
    Expression<String> id,
  }) {
    return RawValuesInsertable({
      if (tileMapX != null) 'tile_map_x': tileMapX,
      if (tileMapY != null) 'tile_map_y': tileMapY,
      if (viewID != null) 'view_i_d': viewID,
      if (bgColor != null) 'bg_color': bgColor,
      if (id != null) 'id': id,
    });
  }

  TileInfosCompanion copyWith(
      {Value<int> tileMapX,
      Value<int> tileMapY,
      Value<int> viewID,
      Value<int> bgColor,
      Value<String> id}) {
    return TileInfosCompanion(
      tileMapX: tileMapX ?? this.tileMapX,
      tileMapY: tileMapY ?? this.tileMapY,
      viewID: viewID ?? this.viewID,
      bgColor: bgColor ?? this.bgColor,
      id: id ?? this.id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tileMapX.present) {
      map['tile_map_x'] = Variable<int>(tileMapX.value);
    }
    if (tileMapY.present) {
      map['tile_map_y'] = Variable<int>(tileMapY.value);
    }
    if (viewID.present) {
      map['view_i_d'] = Variable<int>(viewID.value);
    }
    if (bgColor.present) {
      map['bg_color'] = Variable<int>(bgColor.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TileInfosCompanion(')
          ..write('tileMapX: $tileMapX, ')
          ..write('tileMapY: $tileMapY, ')
          ..write('viewID: $viewID, ')
          ..write('bgColor: $bgColor, ')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }
}

class $TileInfosTable extends TileInfos
    with TableInfo<$TileInfosTable, TileInfo> {
  final GeneratedDatabase _db;
  final String _alias;
  $TileInfosTable(this._db, [this._alias]);
  final VerificationMeta _tileMapXMeta = const VerificationMeta('tileMapX');
  GeneratedIntColumn _tileMapX;
  @override
  GeneratedIntColumn get tileMapX => _tileMapX ??= _constructTileMapX();
  GeneratedIntColumn _constructTileMapX() {
    return GeneratedIntColumn(
      'tile_map_x',
      $tableName,
      false,
    );
  }

  final VerificationMeta _tileMapYMeta = const VerificationMeta('tileMapY');
  GeneratedIntColumn _tileMapY;
  @override
  GeneratedIntColumn get tileMapY => _tileMapY ??= _constructTileMapY();
  GeneratedIntColumn _constructTileMapY() {
    return GeneratedIntColumn(
      'tile_map_y',
      $tableName,
      false,
    );
  }

  final VerificationMeta _viewIDMeta = const VerificationMeta('viewID');
  GeneratedIntColumn _viewID;
  @override
  GeneratedIntColumn get viewID => _viewID ??= _constructViewID();
  GeneratedIntColumn _constructViewID() {
    return GeneratedIntColumn(
      'view_i_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bgColorMeta = const VerificationMeta('bgColor');
  GeneratedIntColumn _bgColor;
  @override
  GeneratedIntColumn get bgColor => _bgColor ??= _constructBgColor();
  GeneratedIntColumn _constructBgColor() {
    return GeneratedIntColumn(
      'bg_color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [tileMapX, tileMapY, viewID, bgColor, id];
  @override
  $TileInfosTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tile_infos';
  @override
  final String actualTableName = 'tile_infos';
  @override
  VerificationContext validateIntegrity(Insertable<TileInfo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tile_map_x')) {
      context.handle(_tileMapXMeta,
          tileMapX.isAcceptableOrUnknown(data['tile_map_x'], _tileMapXMeta));
    } else if (isInserting) {
      context.missing(_tileMapXMeta);
    }
    if (data.containsKey('tile_map_y')) {
      context.handle(_tileMapYMeta,
          tileMapY.isAcceptableOrUnknown(data['tile_map_y'], _tileMapYMeta));
    } else if (isInserting) {
      context.missing(_tileMapYMeta);
    }
    if (data.containsKey('view_i_d')) {
      context.handle(_viewIDMeta,
          viewID.isAcceptableOrUnknown(data['view_i_d'], _viewIDMeta));
    } else if (isInserting) {
      context.missing(_viewIDMeta);
    }
    if (data.containsKey('bg_color')) {
      context.handle(_bgColorMeta,
          bgColor.isAcceptableOrUnknown(data['bg_color'], _bgColorMeta));
    } else if (isInserting) {
      context.missing(_bgColorMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TileInfo map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TileInfo.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TileInfosTable createAlias(String alias) {
    return $TileInfosTable(_db, alias);
  }
}

abstract class _$CustomDatabase extends GeneratedDatabase {
  _$CustomDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $CacheDBItemsTable _cacheDBItems;
  $CacheDBItemsTable get cacheDBItems =>
      _cacheDBItems ??= $CacheDBItemsTable(this);
  $CarInfosTable _carInfos;
  $CarInfosTable get carInfos => _carInfos ??= $CarInfosTable(this);
  $PersonModelsTable _personModels;
  $PersonModelsTable get personModels =>
      _personModels ??= $PersonModelsTable(this);
  $TileInfosTable _tileInfos;
  $TileInfosTable get tileInfos => _tileInfos ??= $TileInfosTable(this);
  CacheDBItemsDao _cacheDBItemsDao;
  CacheDBItemsDao get cacheDBItemsDao =>
      _cacheDBItemsDao ??= CacheDBItemsDao(this as CustomDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cacheDBItems, carInfos, personModels, tileInfos];
}
