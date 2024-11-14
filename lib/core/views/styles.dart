import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Singleton class for consistency of styles across the app. Access styles through Styles.<styleName>
class Styles {
  ///SINGLETON CONFIG DO NOT MODIFY
  static final Styles _instance = Styles._internal();

  factory Styles() => _instance;
  Styles._internal();

  static const kItemExtent = 32.0;

  // Base Colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const gray = Color(0xFF777777);
  static const blue = Color(0xFF007AFF);
  static const green = Color(0xFF4CD964);
  static const red = Color(0xFFFF3B30);
  static const yellow = Color(0xFFFFCC00);
  static const orange = Color(0xFFFF9500);
  static const mint = Color(0xFF00C2A8);

  // Status Colors
  static const inactiveGray = Color(0xFFCCCCCC);
  static const link = Color(0xFF2C8ECA);
  static const errorRed = Color(0xFFD32F2F);

  // Primary Colors
  static const skyBlue = Color(0xFF74C6E7);
  static const activeOrange = Color(0xFFEA7A36);

  // Secondary Colors
  static const navyBlue = Color(0xFF19365A);
  static const ceruleanBlue = Color(0xFF2C8ECA);

  // Action Colors (Derived from Primary for buttons, highlights, CTAs)
  static const actionPrimary = Color(0xDCEA7A36); //activeOrange at 87% opacity
  static const actionSecondary = skyBlue;

  // Background Colors (Neutral background colors)
  static const backgroundPrimary = white;
  static const backgroundAccent =
      Color(0x202C8ECA); //ceruleanBlue at 12% opacity
  static const backgroundComplementary =
      Color(0x2019365A); //navyBlue at 12% opacity

  // Other Colors
  static const comingSoonColor = Color(0x77777777);
  static const transparent = Colors.transparent;

  //Asset Paths
  static const mainLogoPath = "assets/images/vpt_mainlogo.png";
  //Text Styles
  static const title = TextStyle(
    fontFamily: "Unbounded",
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const subtitle = TextStyle(fontSize: 24);
  static const heading1 = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static const heading2 = TextStyle(
    fontSize: 20,
  );
  static const heading3 = TextStyle(fontSize: 18);
  static const body = TextStyle(fontSize: 16);
  static const placeholderStyle =
      TextStyle(color: Styles.inactiveGray, fontSize: 24);
  static const inputStyle = TextStyle(color: Styles.black, fontSize: 24);
  static const actionText =
      TextStyle(color: Styles.black, fontSize: 28, fontWeight: FontWeight.bold);
  static const subactionText =
      TextStyle(color: Styles.white, fontSize: 18, fontWeight: FontWeight.bold);
  static const popupSelectionText =
      TextStyle(color: Styles.black, fontSize: 16);

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
  static const error = TextStyle(color: Styles.errorRed);

  //Borders
  static const borderRadiusS = BorderRadius.all(Radius.circular(4));
  static const borderRadiusM = BorderRadius.all(Radius.circular(8));
  static const borderRadiusL = BorderRadius.all(Radius.circular(16));
}
