import 'package:flutter/cupertino.dart';

///Singleton class for consistency of styles across the app. Access styles through Styles.<styleName>
class Styles {
  ///SINGLETON CONFIG DO NOT MODIFY
  static final Styles _instance = Styles._internal();
  factory Styles() => _instance;
  Styles._internal();

  static const double kItemExtent = 32.0;

  //Default Colors
  static const Color backgroundPrimary = Color(0xFF91DAFF);
  static const Color backgroundAccent = Color(0xFF4EC3FF);
  static const Color backgroundComplementory = Color(0xFFf8c098);

  static const Color actionPrimary = Color(0xFF1F7A97);
  static const Color actionSecondary = Color(0x551F7A97);

  static const Color comingSoonColor = Color(0x77777777);

  //Asset Paths
  static const String mainLogoPath = "assets/vpt_mainlogo.png";
  static const String ctsibLogoPath = "assets/ctsib_mainlogo.png";
  static const String gvLogoPath = "assets/gv_mainlogo.png";

  //Text Styles
  static const TextStyle title = TextStyle(
      fontFamily: "Unbounded", fontSize: 32, fontWeight: FontWeight.bold);
  static const TextStyle subtitle = TextStyle(fontSize: 24);
  static const TextStyle placeholderStyle =
      TextStyle(color: CupertinoColors.inactiveGray, fontSize: 24);
  static const TextStyle inputStyle =
      TextStyle(color: CupertinoColors.black, fontSize: 24);
  static const TextStyle actionText = TextStyle(
      color: CupertinoColors.white, fontSize: 32, fontWeight: FontWeight.bold);
  static const TextStyle subactionText = TextStyle(
      color: CupertinoColors.white, fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle popupSelectionText =
      TextStyle(color: CupertinoColors.black);

  static const TextStyle comingSoonTitle = TextStyle(
      color: comingSoonColor, fontSize: 32, fontWeight: FontWeight.bold);
  static const TextStyle comingSoonSubtitle = TextStyle(
      color: comingSoonColor, fontSize: 24, fontWeight: FontWeight.bold);
}
