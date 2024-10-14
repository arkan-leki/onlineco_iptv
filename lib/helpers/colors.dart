part of 'helpers.dart';

const Color kColorPrimary = Color.fromARGB(255, 57, 192, 254);
const Color kColorPrimaryDark = Color(0xFF0090FF);

//const Color kColorFocus Color.fromARGB(255, 201, 225, 43)5);    /// focus
//const Color kColorFocus = Color.fromRGBO(237, 222, 4, 1);    /// focus
const Color kColorFocus = Color.fromARGB(255, 32, 182, 223);    /// focus

const Color kColorBack = Color.fromARGB(255, 136, 195, 255);
const Color kColorBackDark = Color.fromARGB(255, 18, 123, 220);     // background

const Color kColorCardLight = Color.fromARGB(255, 17, 104, 154);
const Color kColorCardDark = Color.fromARGB(255, 12, 78, 120);
const Color kColorCardDarkness = Color.fromARGB(255, 13, 38, 74);

const Color kColorHint = Color(0xFF555866);
const Color kColorHintGrey = Color(0xFF757575);
const Color kColorFontLight = Color(0xFFFFFFFF);    // the top left text next to the logo text color

BoxDecoration kDecorBackground = const BoxDecoration(
  gradient: LinearGradient(
    colors: [kColorBackDark, kColorBack],
  ),
);

BoxDecoration kDecorIconCircle = const BoxDecoration(
  shape: BoxShape.circle,
  gradient: LinearGradient(
    colors: [kColorPrimaryDark, kColorPrimary],
  ),
);

/*
const Color kColorPrimary = Color(0xFFEF233C);
const Color kColorPrimaryDark = Color(0xFFB31A2D);

const Color kColorFocus = Color(0xFFD72036);

const Color kColorBack = Color(0xFF131518);
const Color kColorBackDark = Color(0xFF171A1D);

const Color kColorCardLight = Color(0xFF272B30);
const Color kColorCardDark = Color(0xFF1D2024);
const Color kColorCardDarkness = Color(0xFF131518);
 */
