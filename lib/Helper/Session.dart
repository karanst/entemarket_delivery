import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import 'color.dart';
import 'constant.dart';
import 'constant.dart';
import 'string.dart';



setPrefrence(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getPrefrence(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

setPrefrenceBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

Future<bool> getPrefrenceBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

back() {
  return BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [grad1Color, grad2Color],
        stops: [0, 1]),
  );
}

shadow() {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(color: Color(0x1a0400ff), offset: Offset(0, 0), blurRadius: 30)
    ],
  );
}

placeHolder(double height) {
  return AssetImage(
    'assets/images/placeholder.png',
  );
}
Widget text(String text,
    {var fontSize = 12.0,
      textColor = const Color(0xffffffff),
      var fontFamily = fontRegular,
      var isCentered = false,
      var isEnd = false,
      var maxLine = 2,
      var latterSpacing = 0.25,
      var textAllCaps = false,
      var isLongText = false,
      var overFlow = false,
      var decoration=false,}) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : isEnd ? TextAlign.end : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    softWrap: true,
    overflow: overFlow ? TextOverflow.ellipsis : TextOverflow.clip,
    style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: textColor,
        height: 1.5,
        letterSpacing: latterSpacing,
        decoration: decoration?TextDecoration.underline:TextDecoration.none
    ),
  );
}
class NewButton extends StatefulWidget {
  var textContent;
  bool selected=false;
  //   var icon;
  VoidCallback onPressed;
  double? width = 80.w;
  double? height = 6.5.h;
  NewButton( {
    @required this.textContent,
    required this.onPressed,
    required this.selected,
    this.width,
    this.height,
    //   @required this.icon,
  });

  @override
  quizButtonState createState() => quizButtonState();
}

class quizButtonState extends State<NewButton> {

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedContainer(
          width: !widget.selected?widget.width:15.w,
          height: widget.height,
          duration: Duration(milliseconds: 500),
          curve: Curves.bounceInOut,
          decoration: BoxDecoration(
            boxShadow:  [BoxShadow(color: AppColor().colorView().withOpacity(0.15), blurRadius: 1, spreadRadius: 1)],
            gradient: new LinearGradient(
              colors: [
                !widget.selected?Color(0xff0D7ACF):Colors.white,
                !widget.selected?Color(0xff0D7ACF):Colors.white,
            /*    !widget.selected?AppColor().colorPrimary():Colors.white,
                !widget.selected?AppColor().colorPrimary():Colors.white,*/
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              /*  begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),*/
              stops: [0.0, 1.0],),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),

          ),
          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: !widget.selected?Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: text(widget.textContent, textColor: Colors.white, fontFamily: fontMedium, textAllCaps: false,fontSize: 10.sp),
              ),
            ],
          ):CircularProgressIndicator(color: AppColor().colorPrimary(),)),
    );
  }
}
setSnackbar(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    content:text(
      msg,
      isCentered: true,
      textColor: Colors.white,
    ),
    behavior: SnackBarBehavior.floating,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.black,
    elevation: 1.0,
  ));
}
BoxDecoration boxDecoration(
    {double radius = 10.0,
      Color color = Colors.transparent,
      Color bgColor = Colors.white,
      var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow
        ? [BoxShadow(color: AppColor().colorView().withOpacity(0.1), blurRadius: 4, spreadRadius: 1)]
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}
errorWidget(double size) {
  return Icon(
    Icons.account_circle,
    color: Colors.grey,
    size: size,
  );
}

getAppBar(String title, BuildContext context, {Widget widget =const SizedBox()}) {
  return AppBar(
    leading: Builder(builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.all(10),

        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Icon(
              Icons.keyboard_arrow_left,
              color: white,
              size: 30,
            ),
          ),
        ),
      );
    }),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    actions: [
      widget
    ],
    backgroundColor: secondary,
  );
}

noIntImage() {
  return Image.asset(
    'assets/images/no_internet.png',
    fit: BoxFit.contain,
  );
}

noIntText(BuildContext context) {
  return Container(
      child: Text(NO_INTERNET,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: primary, fontWeight: FontWeight.normal)));
}

noIntDec(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
    child: Text(NO_INTERNET_DISC,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: lightBlack2,
              fontWeight: FontWeight.normal,
            )),
  );
}


Widget showCircularProgress(bool _isProgress, Color color) {
  if (_isProgress) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(color),
    ));
  }
  return Container(
    height: 0.0,
    width: 0.0,
  );
}

imagePlaceHolder(double size) {
  return new Container(
    height: size,
    width: size,
    child: Icon(
      Icons.account_circle,
      color: white,
      size: size,
    ),
  );
}

Future<void> clearUserSession() async {
  final waitList = <Future<void>>[];

  SharedPreferences prefs = await SharedPreferences.getInstance();

  waitList.add(prefs.remove(ID));
  waitList.add(prefs.remove(MOBILE));
  waitList.add(prefs.remove(EMAIL));
  CUR_USERID = '';
  CUR_USERNAME = "";
  CUR_BALANCE = '';

  await prefs.clear();
}

Future<void> saveUserDetail(
    String userId,
    String name,
    String email,
    String mobile) async {
  final waitList = <Future<void>>[];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  waitList.add(prefs.setString(ID, userId));
  waitList.add(prefs.setString(USERNAME, name));
  waitList.add(prefs.setString(EMAIL, email));
  waitList.add(prefs.setString(MOBILE, mobile));
  await Future.wait(waitList);
}

String? validateField(String? value) {
  if (value!.length == 0)
    return FIELD_REQUIRED;
  else
    return null;
}

String? validateUserName(String? value) {
  if (value!.isEmpty) {
    return USER_REQUIRED;
  }
  if (value.length <= 1) {
    return USER_LENGTH;
  }
  return null;
}

String? validateMob(String? value) {
  if (value!.isEmpty) {
    return MOB_REQUIRED ;
  }
  if (value.length < 9) {
    return VALID_MOB;
  }
  return null;
}


String? validatePass(String? value) {
  if (value!.length == 0)
    return PWD_REQUIRED;
  else if (value.length <= 7)
    return PWD_LENGTH;
  else
    return null;
}

String? validateAltMob(String value) {
  if (value.isNotEmpty) if (value.length <9) {
    return VALID_MOB;
  }
  return null;
}



Widget getProgress() {
  return Center(child: CircularProgressIndicator());
}

Widget getNoItem() {
  return Center(child: Text(noItem));
}
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

Widget shimmer() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
              .map((_) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          color: white,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 18.0,
                                color: white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              Container(
                                width: 100.0,
                                height: 8.0,
                                color: white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              Container(
                                width: 20.0,
                                height: 8.0,
                                color: white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    ),
  );
}

String getToken() {
  final claimSet =
      new JwtClaim(issuer: 'eshop', maxAge: const Duration(minutes: 5));

  String token = issueJwtHS256(claimSet, jwtKey);

  return token;
}

Map<String, String> get headers => {
      "Authorization": 'Bearer ' + getToken(),
    };

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
String getDate(date){
  String temp ="";
  if(date!=null&&date!=""){
    temp = DateFormat.yMMMMEEEEd().format(DateTime.parse(date.toString()));
  }else{
    temp ="Not Data";
  }
  return temp;
}