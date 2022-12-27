import 'dart:async';
import 'dart:convert';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:entemarket_delivery/Helper/color.dart';
import 'package:entemarket_delivery/NewScreen/change_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:entemarket_delivery/Helper/Session.dart';
import 'package:entemarket_delivery/Helper/images.dart';
import '../Helper/constant.dart';
import '../Helper/string.dart';


class ForgetScreen extends StatefulWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  bool status = false;
  bool selected = false, enabled = false, edit = false;
  bool _isNetworkAvail = true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

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
      body: _isNetworkAvail
          ?SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.5),
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
                        image: AssetImage("images/forget_bg.png"),
                        fit: BoxFit.fill,
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                            width: 100.w,
                            height: 4.0.h,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 5.w, top: 1.h),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  back1,
                                  height: 4.0.h,
                                  width: 8.w,
                                ))),
                        SizedBox(
                          height: 2.08.h,
                        ),
                        text(
                          "",
                          textColor: Color(0xffffffff),
                          fontSize: 22.sp,
                          fontFamily: fontMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(top: 16.h),
                  width: 83.33.w,
                  decoration:
                  boxDecoration(radius: 50.0, bgColor: Color(0xffffffff)),
                  child:firstSign(context),
                ),

              ],
            ),
          ),
        ),

      ):noInternet(context),
      persistentFooterButtons: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top:  2.96.h, bottom: 2.h),
            child: InkWell(
              onTap: () async {
                setState(() {
                  enabled = true;
                  selected = true;
                });
                await Future.delayed(Duration(milliseconds: 200));
                setState(() {
                  enabled = false;
                });
                //  Navigator.push(context, PageTransition(child: ForgetScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));
              },
              child: ScaleAnimatedWidget.tween(
                enabled: enabled,
                duration: Duration(milliseconds: 200),
                scaleDisabled: 1.0,
                scaleEnabled: 0.9,
                child: NewButton(
                  selected: edit,
                  width: 69.98.w,
                  height: 7.h,
                  textContent: "Send",
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
                    setState(() {
                      edit = true;
                    });
                    if(showField){
                      _onFormSubmitted();
                    }else{
                      checkNetwork();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
  Widget firstSign(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 4.32.h,
        ),
        Center(
          child: Image.asset(
            forgetIcon,
            height: 16.09.h,
            width: 29.72.w,
          ),
        ),

        Center(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.sp),
              child: text(
                  "Enter the Mobile associated with your account we will send you a otp.",
                  textColor: AppColor().colorTextPrimary(),
                  fontSize: 9.sp,
                  fontFamily: fontRegular,
                  isCentered: true,
                  maxLine: 3)),
        ),
        SizedBox(
          height: 1.87.h,
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
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    onChanged: (val){
                      setState(() {
                        showField = false;
                      });
                    },
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Mobile Number',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          phone,
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                          color: primary,
                        ),
                      ),
                      suffixIcon: phoneController.text.length == 10
                          ? Container(
                          width: 10.w,
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.96.h,
        ),
        showField?Column(
          children: [
            SizedBox(
              height: 2.96.h,
            ),
            otpLayout(),
            SizedBox(
              height: 1.87.h,
            ),
            resendText(),
          ],
        ):SizedBox(),

        SizedBox(
          height: 2.96.h,
        ),
      ],
    );
  }
  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getVerifyUser();
    } else {
      setState(() {
        edit = false;
      });
      Future.delayed(Duration(seconds: 2)).then((_) async {
        setState(() {
          _isNetworkAvail = false;
        });
      });
    }
  }
  Future<void> getVerifyUser() async {
    try {
      var data = {MOBILE: phoneController.text,"forgot_otp":"true"};
      print(data);
      Response response =
      await post(getVerifyUserApi, body: data, headers: headers)
          .timeout(Duration(seconds: timeOut));
      print(response.body);
      var getdata = json.decode(response.body);

      bool? error = getdata["error"];
      String? msg = getdata["message"];
      otpGet = getdata["data"].toString();
      print(getdata);
      if (!error!) {
        setPrefrence(MOBILE, phoneController.text);
        setPrefrence(COUNTRY_CODE, "91");
        setState(() {
          showField = true;
          edit = false;
        });
       /* setPrefrence(MOBILE, phoneController.text);
        setPrefrence(COUNTRY_CODE, "91");
        setState(() {
          edit = false;
        });
        getSingature();
        _onVerifyCode();*/
      } else {
        setState(() {
          edit = false;
        });
        setSnackbar(msg!,context);
      }
    } on TimeoutException catch (_) {
      setState(() {
        edit = false;
      });
      setSnackbar(somethingMSg,context);
    }
  }
  Widget otpLayout() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          start: 50.0,
          end: 50.0,
        ),
        child: Center(
            child: PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black),
                  colorBuilder: FixedColorBuilder(MyColor.primary),
                ),
                currentCode: otp,
                codeLength: 4,
                onCodeChanged: (String? code) {
                  otp = code;
                },
                onCodeSubmitted: (String code) {
                  otp = code;
                })));
  }

  Widget resendText() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          bottom: 30.0, start: 25.0, end: 25.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Didn't get the code? ",
            style: Theme.of(context).textTheme.caption!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
          InkWell(
              onTap: () async {
               // checkNetworkOtp();
                checkNetwork();
              },
              child: Text(
                "Resend OTP",
                style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.normal),
              ))
        ],
      ),
    );
  }
  String? password;
  String? otp;
  bool isCodeSent = false,showField = false;
  late String _verificationId;
  String signature = "";
  bool _isClickable = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> checkNetworkOtp() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      if (_isClickable) {
        _onVerifyCode();
      } else {
        setSnackbar("Request new OTP after 60 seconds",context);
      }
    } else {
      if (mounted) setState(() {});

      Future.delayed(Duration(seconds: 60)).then((_) async {
        bool avail = await isNetworkAvailable();
        if (avail) {
          if (_isClickable)
            _onVerifyCode();
          else {
            setSnackbar("Request new OTP after 60 seconds",context);
          }
        } else {
          setSnackbar("Something went wrong",context);
        }
      });
    }
  }
  Future<void> getSingature() async {
    signature = await SmsAutoFill().getAppSignature;
    await SmsAutoFill().listenForCode;
  }

  void _onVerifyCode() async {
    if (mounted)
      setState(() {
        isCodeSent = true;
        showField = true;
      });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential value) {
        if (value.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeScreen(
                mobile: phoneController.text,
              ),
            ),
          );
        } else {
          setSnackbar("Request new OTP after 60 seconds",context);
        }
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setSnackbar("OTP is not correct",context);

      if (mounted)
        setState(() {
          isCodeSent = false;
        });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      if (mounted)
        setState(() {
          _verificationId = verificationId;
        });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      if (mounted)
        setState(() {
          _isClickable = true;
          _verificationId = verificationId;
        });
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
  String otpGet = "";
  void _onFormSubmitted() async {
    String code = otp!.trim();
    if(otpGet==code){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeScreen(
            mobile: phoneController.text,
          ),
        ),
      );
    }else{
      setState(() {
        edit = false;
      });
      setSnackbar("Wrong OTP. Please check Your OTP",context);
    }
   /* if (code.length == 6) {
      AuthCredential _authCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);

      _firebaseAuth
          .signInWithCredential(_authCredential)
          .then((UserCredential value) async {
        if (value.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeScreen(
                mobile: phoneController.text,
              ),
            ),
          );
        } else {
          setSnackbar("Request new OTP after 60 seconds",context);
        }
      }).catchError((error) async {
        setSnackbar("Wrong OTP. Please check Your OTP",context);
      });
    } else {
      setSnackbar("Please Enter OTP!",context);
    }*/
  }
}
