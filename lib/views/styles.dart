import 'package:flutter/cupertino.dart';

///Singleton class for consistency of styles across the app. Access styles through Styles.<styleName>
class Styles {
  ///SINGLETON CONFIG DO NOT MODIFY
  static final Styles _instance = Styles._internal();
  factory Styles() => _instance;
  Styles._internal();

  ///Background-related styles
  static const Color backgroundPrimary = Color(0xFF91DAFF);
  static const Color backgroundAccent = Color(0xFF4EC3FF);
}
