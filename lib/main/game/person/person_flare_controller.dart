import 'dart:math';

import 'package:cityCloud/expanded/database/database.dart';
import 'package:cityCloud/main/game/person/person_const_data.dart';
import 'package:cityCloud/util/image_helper.dart';
import 'package:flame/flame.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class PersonSpriteFlareController extends FlareController {
  PersonModel _personModel;

  /// The current [FlutterActorArtboard].
  FlutterActorArtboard _artboard;

  /// The current [ActorAnimation].
  String _animationName;
  final double _mixSeconds = 0.1;

  /// The [FlareAnimationLayer]s currently active.
  final List<FlareAnimationLayer> _animationLayers = [];

  /// Called at initialization time, it stores the reference
  /// to the current [FlutterActorArtboard].
  @override
  void initialize(FlutterActorArtboard artboard) {
    _artboard = artboard;
    play(PersonAction_Walk);
    if (_personModel != null) {
      _resetImage();
    }
  }

  /// Listen for when the animation called [name] has completed.
  void onCompleted(String name) {}

  /// Add the [FlareAnimationLayer] of the animation named [name],
  /// to the end of the list of currently playing animation layers.
  void play(String name, {double mix = 1.0, double mixSeconds = 0.2}) {
    _animationName = name;
    if (_animationName != null && _artboard != null) {
      ActorAnimation animation = _artboard.getAnimation(_animationName);
      if (animation != null) {
        _animationLayers.add(FlareAnimationLayer()
          ..name = _animationName
          ..animation = animation
          ..mix = mix
          ..mixSeconds = mixSeconds);
        isActive.value = true;
      }
    }
  }

  ///重置flare动画中的图片，以实现不同小人的flare
  void resetImage(PersonModel model) {
    _personModel = model;
    if (_artboard != null) {
      _resetImage();
    }
  }

  void _resetImage() {
    if (_personModel.bodyID != null && _personModel.bodyID != 0 && _personModel.bodyID < ImageHelper.bodys.length) {
      Flame.images.load(ImageHelper.bodys[_personModel.bodyID]).then((image) {
        (_artboard.getNode('body') as FlutterActorImage)?.changeImage(image);
      });
    }

    if (_personModel.eyeID != null && _personModel.eyeID != 0 && _personModel.eyeID < ImageHelper.eyes.length) {
      Flame.images.load(ImageHelper.eyes[_personModel.eyeID]).then((image) {
        (_artboard.getNode('eye') as FlutterActorImage)?.changeImage(image);
      });
    }

    if (_personModel.footID != null && _personModel.footID != 0 && _personModel.footID < ImageHelper.foots.length) {
      Flame.images.load(ImageHelper.foots[_personModel.footID]).then((image) {
        (_artboard.getNode('left_foot') as FlutterActorImage)?.changeImage(image);
        (_artboard.getNode('right_foot') as FlutterActorImage)?.changeImage(image);
      });
    }
  }

  ///清空动作
  void clearAllAnimation({bool exceptColseEye = true}) {
    if (exceptColseEye) {
      List<FlareAnimationLayer> tmpList = [];
      _animationLayers?.forEach((element) {
        if (element.name == PersonAction_CloseEye) {
          tmpList.add(element);
        }
      });
      _animationLayers.clear();
      _animationLayers.addAll(tmpList);
    } else {
      _animationLayers.clear();
    }
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  /// Advance all the [FlareAnimationLayer]s that are currently controlled
  /// by this object, and mixes them accordingly.
  ///
  /// If an animation completes during the current frame (and doesn't loop),
  /// the [onCompleted()] callback will be triggered.
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    /// List of completed animations during this frame.
    List<FlareAnimationLayer> completed = [];

    /// This loop will mix all the currently active animation layers so that,
    /// if an animation is played on top of the current one, it'll smoothly mix
    ///  between the two instead of immediately switching to the new one.
    for (int i = 0; i < _animationLayers.length; i++) {
      FlareAnimationLayer layer = _animationLayers[i];
      layer.mix += elapsed;
      layer.time += elapsed;

      double mix = (_mixSeconds == null || _mixSeconds == 0.0) ? 1.0 : min(1.0, layer.mix / _mixSeconds);

      /// Loop the time if needed.
      if (layer.animation.isLooping) {
        layer.time %= layer.animation.duration;
      }

      /// Apply the animation with the current mix.
      layer.animation.apply(layer.time, _artboard, mix);

      /// Add (non-looping) finished animations to the list.
      if (layer.time > layer.animation.duration) {
        completed.add(layer);
      }
    }

    /// Notify of the completed animations.
    for (final FlareAnimationLayer animation in completed) {
      _animationLayers.remove(animation);
      onCompleted(animation.name);
    }
    return _animationLayers.isNotEmpty;
  }
}
