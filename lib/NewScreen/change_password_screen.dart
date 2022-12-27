import 'dart:async';
import 'dart:convert';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:entemarket_delivery/Helper/Session.dart';
import 'package:entemarket_delivery/Helper/images.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:entemarket_delivery/NewScreen/login_screen.dart';
import 'package:http/http.dart' as http;

import '../Helper/color.dart';
import '../Helper/constant.dart';
import '../Helper/string.dart';
class ChangeScreen extends StatefulWidget {
    String? mobile = "mobile";
   ChangeScreen({Key? key,this.mobile}) : super(key: key);

  @override
  _ChangeScreenState createState() => _ChangeScreenState();
}

class _ChangeScreenState extends State<ChangeScreen> {
  TextEditingController oldPass = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController cPassController = new TextEditingController();
  bool selected = false, enabled = false, edit = false;
  bool _isNetworkAvail = true;

  String? name,
      email,
      mobile,
      address,
      image,
      curPass,
      newPass,
      confPass,
      loaction;

  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController? nameC,
      emailC,
      mobileC,
      addressC,
      curPassC,
      newPassC,
      confPassC;
  bool isSelected = false, isArea = true;
  bool _showCurPassword = false, _showPassword = false, _showCmPassword = false;
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }
  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      CUR_USERID = prefs.getString(ID);
      mobile = prefs.getString(MOBILE);
      name = prefs.getString(USERNAME);
      email = prefs.getString(EMAIL);
      address = prefs.getString(ADDRESS);
      image = prefs.getString(IMAGE);
    });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().colorBg1(),
      body: _isNetworkAvail?SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 100.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.5),
                colors: [
                  AppColor().colorBg1(),
                  AppColor().colorBg1(),
                ],
                radius: 0.8,
              ),
            ),
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              children: [
                Container(
                  height: 9.92.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(forgetBg),
                        fit: BoxFit.fill,
                      )),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 6.38.w,
                            height: 6.38.w,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 7.91.w),
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
                          width: 2.08.h,
                        ),
                        Container(
                          width: 65.w,
                          child: text(
                            "Change Password",
                            textColor: Color(0xffffffff),
                            fontSize: 14.sp,
                            fontFamily: fontMedium,
                            isCentered: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.52.h,
                      ),
                      widget.mobile=="mobile"?Container(
                        width: 83.33.w,
                        height: 6.79.h,
                        decoration: boxDecoration(
                          showShadow: true,
                          radius: 20.0,
                          bgColor: AppColor().colorBg1(),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.text,
                          controller: oldPass,
                          obscureText: true,
                          // controller: emailController,
                          style:TextStyle(
                            color: AppColor().colorTextFour(),
                            fontSize: 10.sp,
                          ),
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
                            labelText: 'Enter Your Old Password',
                            labelStyle: TextStyle(
                              color: AppColor().colorTextFour(),
                              fontSize: 10.sp,
                            ),
                            prefixIcon:  Padding(
                              padding: EdgeInsets.all(4.0.w),
                              child: Image.asset(
                                lock,
                                width: 2.04.w,
                                height:  2.04.w,
                                color: Color(0xffF4B71E),
                                fit: BoxFit.fill,
                              ),
                            ),
                            fillColor: AppColor().colorBg1() ,
                            enabled: true,
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().colorBg1(), width: 5.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ):SizedBox(),
                      SizedBox(
                        height: 2.52.h,
                      ),
                      Container(
                        width: 83.33.w,
                        height: 6.79.h,
                        decoration: boxDecoration(
                          showShadow: true,
                          radius: 20.0,
                          bgColor: AppColor().colorBg1(),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.text,
                          controller: passController,
                          obscureText: true,
                          // controller: emailController,
                          style:TextStyle(
                            color: AppColor().colorTextFour(),
                            fontSize: 10.sp,
                          ),
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
                            labelText: 'Enter New Password',
                            labelStyle: TextStyle(
                              color: AppColor().colorTextFour(),
                              fontSize: 10.sp,
                            ),
                            fillColor: AppColor().colorBg1() ,
                            enabled: true,
                            prefixIcon:  Padding(
                              padding: EdgeInsets.all(4.0.w),
                              child: Image.asset(
                                lock,
                                width: 2.04.w,
                                height:  2.04.w,
                                color: Color(0xffF4B71E),
                                fit: BoxFit.fill,
                              ),
                            ),
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().colorBg1(), width: 5.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.52.h,
                      ),
                      Container(
                        width: 83.33.w,
                        height: 6.79.h,

                        child:text(
                          "Your New Password must be Different From Your Previous Passwords.",
                          textColor: Color(0xffFD531F),
                          fontSize: 10.sp,
                          fontFamily: fontSemibold,
                          maxLine: 2
                        ) ,
                      ),
                      SizedBox(
                        height: 1.52.h,
                      ),
                      Container(
                        width: 83.33.w,
                        height: 6.79.h,
                        decoration: boxDecoration(
                          showShadow: true,
                          radius: 20.0,
                          bgColor: AppColor().colorBg1(),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.text,
                          controller: cPassController,
                          obscureText: true,
                          // controller: emailController,
                          style:TextStyle(
                            color: AppColor().colorTextFour(),
                            fontSize: 10.sp,
                          ),
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
                            labelText: 'Confirm New Password',
                            prefixIcon:  Padding(
                              padding: EdgeInsets.all(4.0.w),
                              child: Image.asset(
                                lock,
                                width: 2.04.w,
                                height:  2.04.w,
                                color: Color(0xffF4B71E),
                                fit: BoxFit.fill,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: AppColor().colorTextFour(),
                              fontSize: 10.sp,
                            ),
                            fillColor: AppColor().colorBg1() ,
                            enabled: true,
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().colorBg1(), width: 5.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                    ),

                SizedBox(
                  height: 3.02.h,
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        enabled = true;
                      });
                      await Future.delayed(Duration(milliseconds: 200));
                      setState(() {
                        enabled = false;
                      });
                      Navigator.pop(context);
                      //    Navigator.push(context, PageTransition(child: LoginScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));

                    },
                    child: ScaleAnimatedWidget.tween(
                      enabled: enabled,
                      duration: Duration(milliseconds: 200),
                      scaleDisabled: 1.0,
                      scaleEnabled: 0.9,
                      child: NewButton(
                        selected: edit,
                        width: 69.98.w,
                        textContent: "Save",
                        onPressed: ()async{
                          setState(() {
                            enabled = true;
                          });
                          await Future.delayed(Duration(milliseconds: 200));
                          setState(() {
                            enabled = false;
                          });
                          if(validatePass(passController.text)!=null){
                            setSnackbar(validatePass(passController.text).toString(), context);
                            return;
                          }
                          if(passController.text != cPassController.text){
                            setSnackbar("Both Password Doesn't Match", context);
                            return;
                          }
                          if(widget.mobile!="mobile"){
                            setState(() {
                              edit = true;
                            });
                            checkNetwork();
                          }else{
                            if(validatePass(oldPass.text)!=null){
                              setSnackbar("Enter Old Password", context);
                              return;
                            }
                            changePassWord();
                          }


                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.02.h,
                ),
              ],
            ),
          ),
        ),
      ):noInternet(context),
    );
  }
  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getResetPass();
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
  Future<void> changePassWord() async {
    var data = {USER_ID: CUR_USERID, USERNAME: name, EMAIL: email};
    if (passController.text != null && passController.text != "") {
      data[NEWPASS] = passController.text;
    }
    if (oldPass.text != null && oldPass.text != "") {
      data[OLDPASS] = oldPass.text;
    }

    if (address != null && address != "") {
      data[ADDRESS] = address;
    }

    http.Response response = await http
        .post(getUpdateUserApi, body: data, headers: headers)
        .timeout(Duration(seconds: timeOut));

    if (response.statusCode == 200) {
      var getdata = json.decode(response.body);

      bool error = getdata["error"];
      String? msg = getdata["message"];
      setState(() {
        edit = false;
      });
      setSnackbar(msg!, context);
      if (!error) {
        Navigator.pop(context);
        CUR_USERNAME = name;
      } else {
        Navigator.pop(context);
        setSnackbar(msg,context);
      }
    }
  }
  Future<void> getResetPass() async {
    try {
      var data = {
        MOBILENO: widget.mobile,
        NEWPASS: passController.text,
      };
      Response response =
      await post(getResetPassApi, body: data, headers: headers)
          .timeout(Duration(seconds: timeOut));
      setState(() {
        edit = false;
      });
      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          setSnackbar(PASS_SUCCESS_MSG,context);
          Future.delayed(Duration(seconds: 1)).then((_) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Login(),
            ));
          });
        } else {
          setSnackbar(msg!,context);
        }
      }
      setState(() {});
    } on TimeoutException catch (_) {
      setSnackbar(somethingMSg,context);
    }
  }
}
