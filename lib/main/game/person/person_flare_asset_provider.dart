import 'dart:typed_data';

import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:flame/flame.dart';
import 'package:flare_flutter/asset_provider.dart';
import 'package:flutter_hrlweibo/flutter_hrlweibo.dart';

class PersonFlareLoader {
  static PersonFlareLoader share = PersonFlareLoader._();
  StreamController _streamController = StreamController<ByteData>.broadcast();
  ByteData _flareData;

  PersonFlareLoader._() {
    Flame.bundle.load(PersonFlareAsset).then((value) {
      _flareData = value;
      _streamController.add(_flareData);
    });
  }
  factory PersonFlareLoader() => share;

  PersonFlareAssetProvider createAssetProvider() {
    PersonFlareAssetProvider provider = PersonFlareAssetProvider();
    if (_flareData != null) {
      provider.completer?.complete(_flareData);
    } else {
      _streamController.stream.listen((event) {
        provider.completer?.complete(event);
      });
    }
    return provider;
  }
}

class PersonFlareAssetProvider extends AssetProvider {
  Completer<ByteData> completer = Completer<ByteData>();
  @override
  Future<ByteData> load() {
    return completer.future;
  }
}
