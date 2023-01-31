import 'package:flutter/cupertino.dart';

///Singleton class for consistency of styles across the app. Access styles through Styles.<styleName>
class Styles {
  ///SINGLETON CONFIG DO NOT MODIFY
  static final Styles _instance = Styles._internal();
  factory Styles() => _instance;
  Styles._internal();

  static const Color backgroundPrimary = Color(0xFF91DAFF);
  static const Color backgroundAccent = Color(0xFF4EC3FF);
  static const Color backgroundComplementory = Color(0xFFf8c098);

  //Asset Paths
  static const String mainLogoPath = "assets/vpt_mainlogo.png";
}
