import 'dart:async';
import 'dart:math';

import 'package:cityCloud/dart_class/flame/scale_translate_canvas_effect.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

enum RemiderType {
  Message, //信封样式，点击之后跳到关注页
  Number, //显示一个数字，点击之后显示广告
}

///头顶提示信息
class RemiderInfo {
  final RemiderType type;

  ///type是Number的时候有用
  final int number;
  RemiderInfo({@required this.type, this.number}) : assert(type != null);
}

class RemiderSprite extends SpriteComponent {
  final double radius;
  final RemiderInfo info;
  ScalTranslateCanvasEffect _scalTranslateCanvasEffect;
  RemiderSprite.fromSprite({@required this.info, @required this.radius}) {
    width = radius * 1.2;
    height = radius * 1.2;
    Timer.run(() {
      _scalTranslateCanvasEffect = ScalTranslateCanvasEffect(
        destinationScale: Offset(0, -1),
        destinationTranslate: Position(0, y),
        travelTime: 0.3,
        reverse: true,
      );
    });
    Sprite.loadSprite(
      'icon_mail.png',
    ).then((value) {
      sprite = value;
    });
  }

  @override
  bool loaded() => super.loaded();

  Future dismiss() {
    Completer completer = Completer();
    _scalTranslateCanvasEffect = ScalTranslateCanvasEffect(
      destinationScale: Offset(0, -1),
      destinationTranslate: Position(0, y),
      travelTime: 0.3,
      onComplete: () {
        completer.complete();
      },
    );
    return completer.future;
  }

  @override
  void render(Canvas canvas) {
    _scalTranslateCanvasEffect?.setEffectToCanvas(canvas);
    Paint paint = Paint();
    if (info.type == RemiderType.Message) {
      paint.color = Color.fromRGBO(149, 131, 116, 1);
    } else {
      paint.color = Colors.red;
    }

    canvas.drawCircle(Offset(0, y), radius, paint);
    Path path = Path();
    path.moveTo(-radius * 0.3, y + radius * 0.8);
    path.lineTo(-radius * 0.1, y + radius * 1.1);
    path.arcTo(Rect.fromCenter(center: Offset(x, y + radius * 1.1), width: radius * 0.1 * 2, height: radius * 0.1 * 2),
        0, pi, false);
    path.lineTo(radius * 0.1, y + radius * 1.1);
    path.lineTo(radius * 0.3, y + radius * 0.8);
    path.close();
    canvas.drawPath(path, paint);
    if (loaded()) {
      canvas.save();
      if(renderFlipX) {
        canvas.scale(-1,1);
      }
      canvas.translate(-width / 2, -height / 2);

      
      if (info.type == RemiderType.Message) {
        super.render(canvas);
      } else {
        TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 12), text: '${info.number}');
        TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(x + 1, y - 2));
      }

      canvas.restore();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scalTranslateCanvasEffect?.update(dt);
  }
}
