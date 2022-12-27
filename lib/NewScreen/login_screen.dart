

import 'dart:async';
import 'dart:convert';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:entemarket_delivery/Helper/Session.dart';
import 'package:entemarket_delivery/Helper/color.dart';
import 'package:entemarket_delivery/Helper/constant.dart';
import 'package:entemarket_delivery/Helper/images.dart';
import 'package:entemarket_delivery/NewScreen/forget_screen.dart';
import 'package:entemarket_delivery/Screens/home.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import '../Helper/string.dart';







class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool selected = false, enabled = false, edit = false;
  String? password,
      mobile,
      username,
      email,
      id,
      balance,
      image,
      address,
      city,
      area,
      pincode,
      fcm_id,
      srorename,
      storeurl,
      storeDesc,
      accNo,
      accname,
      bankCode,
      bankName,
      latitutute,
      longitude,
      taxname,
      tax_number,
      pan_number,
      status,
      storeLogo;
  bool _isNetworkAvail = true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    setState(() {
      phoneController.text = "6854785965";
      passController.text = "12345678";
    });
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.1),
                colors: [
                  AppColor().colorBg1(),
                  AppColor().colorBg2(),
                ],
                radius: 0.8,
              ),
            ),
            padding: MediaQuery.of(context).viewInsets,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 22.65.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(loginBg),
                    fit: BoxFit.fill,
                  )),
                  child: Center(
                    child: text(
                      "",
                      textColor: Color(0xffffffff),
                      fontSize: 22.sp,
                      fontFamily: fontMedium,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(top: 16.h),
                  width: 83.33.w,
                  height:47.96.h,
                  decoration:
                      boxDecoration(radius: 50.0, bgColor: Color(0xffffffff),showShadow: true),
                  child: firstSign(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget firstSign(BuildContext context){
    return _isNetworkAvail
        ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          SizedBox(
            height: 6.05.h,
          ),
          Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 69.99.w,
                    height: 6.46.h,
                    child: TextFormField(
                      cursorColor: Colors.red,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      style:TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      onSaved: (String? value) {
                        mobile = value;
                      },
                      inputFormatters: [],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().colorEdit(),
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                        labelText: 'Mobile Number',
                        labelStyle: TextStyle(
                          color: AppColor().colorTextFour(),
                          fontSize: 10.sp,
                        ),
                        fillColor: AppColor().colorEdit() ,
                        enabled: true,
                        filled: true,
                        prefixIcon:  Container(
                          padding: EdgeInsets.all(4.0.w),
                          child: Image.asset(
                            phone,
                            width: 1.04.w,
                            height:  1.04.w,
                            fit: BoxFit.fill,
                            color: primary,
                          ),
                        ),
                        suffixIcon: phoneController.text.length == 10
                            ? Container(
                            width: 1.04.w,
                            alignment: Alignment.center,
                            child: FaIcon(
                              FontAwesomeIcons.check,
                              color: AppColor().colorPrimary(),
                              size: 10.sp,
                            ))
                            : SizedBox(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().colorEdit(), width: 5.0),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height:1.55.h,
                  ),
                  Container(
                    width: 69.99.w,
                    height: 6.46.h,
                    child: TextFormField(
                      cursorColor: Colors.red,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: passController,
                      style:TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      onSaved: (String? value) {
                        password = value;
                      },
                      inputFormatters: [],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().colorEdit(),
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: AppColor().colorTextFour(),
                          fontSize: 10.sp,
                        ),
                        fillColor: AppColor().colorEdit() ,
                        enabled: true,
                        filled: true,
                        prefixIcon:  Padding(
                          padding: EdgeInsets.all(4.0.w),
                          child: Image.asset(
                            lock,
                            width: 2.04.w,
                            height:  2.04.w,
                            fit: BoxFit.fill,
                            color: primary,
                          ),
                        ),
                        suffixIcon: passController.text.length > 7
                            ? Container(
                            width: 1.04.w,
                            alignment: Alignment.center,
                            child: FaIcon(
                              FontAwesomeIcons.check,
                              color: AppColor().colorPrimary(),
                              size: 10.sp,
                            ))
                            : SizedBox(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().colorEdit(), width: 5.0),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height:3.55.h,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          PageTransition(
                            child: ForgetScreen(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 500),
                          ));
                    },
                    child: Container(
                      width: 69.99.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          text(
                            "Forgot Password ?",
                            textColor: AppColor().colorTextThird(),
                            fontSize: 10.sp,
                            fontFamily: fontMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(
            height:4.75.h,
          ),
          Center(
            child:ScaleAnimatedWidget.tween(
                enabled: enabled,
                duration: Duration(milliseconds: 200),
                scaleDisabled: 1.0,
                scaleEnabled: 0.8,
                child: NewButton(
                  selected: edit,
                  width: 69.99.w,
                  textContent: "Log In",
                  onPressed: ()async{
                    setState(() {
                      enabled = true;
                    });
                    await Future.delayed(Duration(milliseconds: 200));
                    setState(() {
                      enabled = false;
                    });
                    if(validateMob(phoneController.text )!=null){
                      setSnackbar(validateMob(phoneController.text).toString(), context);
                      return;
                    }
                    if(validatePass(passController.text,)!=null){
                      setSnackbar(validatePass(passController.text,).toString(), context);
                      return;
                    }
                    setState(() {
                      edit = true;
                    });
                    checkNetwork();

                  },
                ),
            ),
          ),
          SizedBox(
            height:6.53.h,
          ),
      ],
    ):noInternet(context);
  }
  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: kToolbarHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            noIntImage(),
            noIntText(context),
            noIntDec(context),
            NewButton(
              selected: edit,
              textContent: "No Internet".toString(),
              onPressed: (){
                Future.delayed(Duration(seconds: 2)).then(
                      (_) async {
                    _isNetworkAvail = await isNetworkAvailable();
                    if (_isNetworkAvail) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget),
                      );
                    } else {

                      setState(
                            () {},
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> checkNetwork() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getLoginUser();
    } else {
      setState(() {
        edit = false;
      });
      Future.delayed(Duration(seconds: 2)).then(
            (_) async {
          setState(
                () {
              _isNetworkAvail = false;
            },
          );
        },
      );
    }
  }
  Future<void> getLoginUser() async {
    var data = {MOBILE: phoneController.text, PASSWORD: passController.text};
    try {
      var response = await post(getUserLoginApi, body: data, headers: headers)
          .timeout(Duration(seconds: timeOut));

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);

        bool error = getdata["error"];
        String? msg = getdata["message"];
        setState(() {
          edit = false;
        });
        if (!error) {
          setSnackbar(msg!,context);
          var i = getdata["data"][0];
          id = i[ID];
          username = i[USERNAME];
          email = i[EMAIL];
          mobile = i[MOBILE];
          print("data is ${id}");
          print("data is ${response.body}");
          CUR_USERID = id;
          CUR_USERNAME = username;

          saveUserDetail(id!, username!, email!, mobile!);
          setPrefrenceBool(isLogin, true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        } else {
          setSnackbar(msg!,context);
        }
      } else {
      }
    } on TimeoutException catch (_) {
      setState(() {
        edit = false;
      });
      setSnackbar(somethingMSg,context);
    }
  }
}
