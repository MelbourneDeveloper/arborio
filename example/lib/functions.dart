// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

Curve getAnimationCurve(String curve) => switch (curve) {
      ('bounceIn') => Curves.bounceIn,
      ('bounceInOut') => Curves.bounceInOut,
      ('bounceOut') => Curves.bounceOut,
      ('easeInCirc') => Curves.easeInCirc,
      ('easeInOutExpo') => Curves.easeInOutExpo,
      ('elasticInOut') => Curves.elasticInOut,
      ('easeInOut') => Curves.easeInOut,
      ('easeOutCirc') => Curves.easeOutCirc,
      ('elasticOut') => Curves.elasticOut,
      ('elasticIn') => Curves.elasticIn,
      ('easeIn') => Curves.easeIn,
      ('ease') => Curves.ease,
      ('easeInBack') => Curves.easeInBack,
      ('easeOutBack') => Curves.easeOutBack,
      ('easeInOutBack') => Curves.easeInOutBack,
      ('easeInSine') => Curves.easeInSine,
      ('easeOutSine') => Curves.easeOutSine,
      ('easeInOutSine') => Curves.easeInOutSine,
      ('easeInQuad') => Curves.easeInQuad,
      ('easeOutQuad') => Curves.easeOutQuad,
      ('easeInOutQuad') => Curves.easeInOutQuad,
      ('easeInQuart') => Curves.easeInQuart,
      ('easeOutQuart') => Curves.easeOutQuart,
      ('easeInOutQuart') => Curves.easeInOutQuart,
      ('easeInQuint') => Curves.easeInQuint,
      ('easeOutQuint') => Curves.easeOutQuint,
      ('easeInOutQuint') => Curves.easeInOutQuint,
      ('easeInExpo') => Curves.easeInExpo,
      ('easeOutExpo') => Curves.easeOutExpo,
      ('linear') => Curves.linear,
      _ => Curves.easeInOut,
    };
