import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Singleton class for consistency of styles across the app. Access styles through Styles.<styleName>
class Styles {
  ///SINGLETON CONFIG DO NOT MODIFY
  static final Styles _instance = Styles._internal();

  factory Styles() => _instance;
  Styles._internal();

  static const kItemExtent = 32.0;

  //Default Colors
  static const backgroundPrimary = Color(0xFF91DAFF);
  static const backgroundAccent = Color(0xFF4EC3FF);
  static const backgroundComplementory = Color(0xFFf8c098);

  static const actionPrimary = Color(0xFF1F7A97);
  static const actionSecondary = Color(0x551F7A97);

  static const comingSoonColor = Color(0x77777777);

  static const white = CupertinoColors.white;
  static const black = CupertinoColors.black;
  static const transparent = Colors.transparent;

  //Asset Paths
  static const mainLogoPath = "assets/images/vpt_mainlogo.png";
  //Text Styles
  static const title = TextStyle(
    fontFamily: "Unbounded",
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const subtitle = TextStyle(fontSize: 24);
  static const heading1 = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static const heading2 = TextStyle(fontSize: 20);
  static const heading3 = TextStyle(fontSize: 18);
  static const placeholderStyle =
      TextStyle(color: CupertinoColors.inactiveGray, fontSize: 24);
  static const inputStyle =
      TextStyle(color: CupertinoColors.black, fontSize: 24);
  static const actionText = TextStyle(
      color: CupertinoColors.white, fontSize: 28, fontWeight: FontWeight.bold);
  static const subactionText = TextStyle(
      color: CupertinoColors.white, fontSize: 18, fontWeight: FontWeight.bold);
  static const popupSelectionText =
      TextStyle(color: CupertinoColors.black, fontSize: 20);

  static const comingSoonTitle = TextStyle(
    color: comingSoonColor,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: "Unbounded",
  );
  static const comingSoonSubtitle = TextStyle(
      color: comingSoonColor, fontSize: 24, fontWeight: FontWeight.bold);
  static const comingSoonHeading3 =
      TextStyle(color: comingSoonColor, fontSize: 18);

  static TextStyle timerTextStyle = GoogleFonts.robotoMono(
      fontWeight: FontWeight.bold, fontSize: 24, color: white.withOpacity(0.8));
  static const error = TextStyle(color: CupertinoColors.destructiveRed);

  //Borders
  static const borderRadiusS = BorderRadius.all(Radius.circular(4));
  static const borderRadiusM = BorderRadius.all(Radius.circular(8));
  static const borderRadiusL = BorderRadius.all(Radius.circular(16));
}
