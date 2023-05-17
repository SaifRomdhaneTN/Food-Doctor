import 'package:flutter/material.dart';

TextStyle kTextRegStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Eastman',
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    shadows: [Shadow(color: Colors.black,offset: Offset.fromDirection(5.0,-1.0))]
);

const kInputDecorationOfAuth = InputDecoration(
  errorStyle: TextStyle(color: Colors.redAccent,fontFamily: "Eastman"),
  errorMaxLines: 2,
  hintText: '',
  fillColor: Colors.white,
  filled: true,
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),

  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF40513B), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF9DC08B), width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);


const TextStyle kRegButtonTxtStyle = TextStyle(
    fontSize: 25.0,
    fontFamily: 'EastMan',
);
const kTitleTextStyle =  TextStyle(
    fontFamily: 'Eastman',
    fontSize: 80.0,
    color: Colors.white,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0.0, 2.0),
        blurRadius: 1.0,
        color: Color.fromRGBO(0, 0, 0, 0.4),
      ),
    ],
    fontWeight: FontWeight.bold
);
const kTitleTextStyle2 =  TextStyle(
    fontFamily: 'Eastman',
    fontSize: 30.0,
    color: Color(0xFF609966),
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0.0, 2.0),
        blurRadius: 1.0,
        color: Color.fromRGBO(0, 0, 0, 0.5),
      ),
    ],
    fontWeight: FontWeight.bold
);
const kInfoButtonTextStyleReg2 = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Color(0xFFEDF1D6)
);
const kFormHomeTextStyle= TextStyle(
    color: Color(0xFF609966),
    fontSize: 20,
    wordSpacing: 5,
    fontWeight: FontWeight.bold,
);

const kFormTextStyle = TextStyle(
    color: Color(0xFF609966),
    fontSize: 24,
    fontFamily: "Eastman",
    fontWeight: FontWeight.bold,
    shadows: <Shadow>[
      Shadow(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          offset: Offset(0, 1),
          blurRadius: 2
      )
    ]
);

const kCPWhite = Color(0xFFEDF1D6);
const kCPGreenLight = Color(0xFF9DC08B);
const kCPGreenMid = Color(0xFF609966);
const kCPGteenDark = Color(0xFF40513B);

final kButtonStyleAppBar = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
  elevation: MaterialStateProperty.resolveWith((states) => 5),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(45))
    ),
  ),
);

const kButtonTextStyleAppbar = TextStyle(
    color: kCPGreenMid,
    fontFamily: "Eastman",
    fontWeight: FontWeight.bold,
    fontSize: 18
);

const kcustomContainer = BoxDecoration(
  color: Color(0xFF609966),
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      blurRadius: 10,
      offset: Offset(0,5)
    )
  ]
) ;

const kSearchFieldDec =  InputDecoration(
border: OutlineInputBorder(
borderRadius: BorderRadius.all(Radius.circular(10.0)),
),
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(color: kCPGreenLight,width: 2.0),
borderRadius: BorderRadius.all(Radius.circular(10.0)),
),
focusedBorder: OutlineInputBorder(
borderSide: BorderSide(color: kCPGteenDark, width: 3.0),
borderRadius: BorderRadius.all(Radius.circular(10.0)),
),
filled: true,
fillColor: kCPWhite,
hintText: "nom du produit",
prefixIcon: Icon(Icons.search),
iconColor: kCPGreenMid,
);
const kResultPNameTextStyle = TextStyle(
  fontSize: 14,
  fontFamily: "Eastman",
  wordSpacing:5,
  height: 1.5,
);
const kResultPIngrTextStyle = TextStyle(
  fontSize: 22,
  fontFamily: "Eastman",
  wordSpacing:5,
  height: 1.5,
);
final kWelcomeScreenCircularButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateColor.resolveWith((states) =>Colors.white),
  elevation: MaterialStateProperty.resolveWith((states) => 10),
  shape: MaterialStateProperty.all<CircleBorder>(
      const CircleBorder(
      )
  ),
);

final kAccountManagmentButtons = ButtonStyle(
  elevation: MaterialStateProperty.resolveWith((states) => 5),
  shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      )
  ),
  backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFF609966)),
);
const kPrefDisplayTextStyle =  TextStyle(
color: Color(0xFF609966),
fontFamily: 'Eastman',
fontSize: 16,
fontWeight: FontWeight.bold
);



const kUserDisplayTextStyle =  TextStyle(
    color: Color(0xFFEDF1D6),
    fontSize: 24,
    fontFamily: 'Eastman',
    fontWeight: FontWeight.bold
);

const kFiltersOptionTextStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'EastMan'
);

const kSearchParametersNames = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'EastMan',
  color: kCPGreenMid
);