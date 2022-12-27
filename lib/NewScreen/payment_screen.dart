import 'dart:async';
import 'dart:convert';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:entemarket_delivery/Helper/Session.dart';
import 'package:entemarket_delivery/Helper/color.dart';
import 'package:entemarket_delivery/Helper/images.dart';
import 'package:entemarket_delivery/Model/transaction_model.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../Helper/constant.dart';
import '../Helper/string.dart';

bool _isLoading = true;
bool isLoadingmore = true;
int offset = 0;
int total = 0;
List<TransactionModel> tranList = [];

class WalletHistory extends StatefulWidget {
  const WalletHistory({Key? key}) : super(key: key);

  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  bool selected = false, enabled = false, edit = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  bool _isNetworkAvail = true;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  ScrollController controller = ScrollController();
  List<TransactionModel> tempList = [];
  TextEditingController? amtC, bankDetailC;

  @override
  void initState() {
    super.initState();
    getUserDetail();
    getRequest();
    getTransaction();
    controller.addListener(_scrollListener);

    amtC = new TextEditingController();
    bankDetailC = new TextEditingController();
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          isLoadingmore = true;

          if (offset < total) getRequest();
        });
      }
    }
  }

  Future<Null> getTransaction() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var parameter = {
          LIMIT: perPage.toString(),
          OFFSET: offset.toString(),
          USER_ID: CUR_USERID,
        };

        Response response =
            await post(getFundTransferApi, headers: headers, body: parameter)
                .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);
          bool error = getdata["error"];
          String? msg = getdata["message"];

          if (!error) {
            total = int.parse(getdata["total"]);

            if ((offset) < total) {
              tempList.clear();
              var data = getdata["data"];
              tempList = (data as List)
                  .map((data) => TransactionModel.fromJson(data))
                  .toList();

              tranList.addAll(tempList);

              offset = offset + perPage;
            }
          } else {
            isLoadingmore = false;
          }
        }
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg, context);
        setState(() {
          _isLoading = false;
          isLoadingmore = false;
        });
      }
    } else
      setState(() {
        _isNetworkAvail = false;
      });

    return null;
  }
  Future<Null> getUserDetail() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        CUR_USERID = await getPrefrence(ID);

        var parameter = {ID: CUR_USERID};

        Response response =
        await post(getBoyDetailApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          var data = getdata["data"][0];
          setState(() {
            CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
            CUR_BONUS = data[BONUS];
          });

        }
        setState(() {
          _isLoading = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg,context);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
          _isLoading = false;
        });
    }

    return null;
  }
  Future<Null> getRequest() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var parameter = {
          LIMIT: perPage.toString(),
          OFFSET: offset.toString(),
          USER_ID: CUR_USERID,
        };

        Response response =
            await post(getWithReqApi, headers: headers, body: parameter)
                .timeout(Duration(seconds: timeOut));

        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);
          bool error = getdata["error"];
          String? msg = getdata["message"];

          if (!error) {
            total = int.parse(getdata["total"]);

            if ((offset) < total) {
              tempList.clear();
              var data = getdata["data"];
              tempList = (data as List)
                  .map((data) => TransactionModel.fromReqJson(data))
                  .toList();

              tranList.addAll(tempList);

              offset = offset + perPage;
            }
            await getTransaction();
          } else {
            isLoadingmore = false;
          }
        }
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg, context);
        setState(() {
          _isLoading = false;
          isLoadingmore = false;
        });
      }
    } else
      setState(() {
        _isNetworkAvail = false;
      });

    return null;
  }

  _showDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                            child: Text(
                              SEND_REQUEST,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: fontColor),
                            )),
                        Divider(color: lightBlack),
                        Form(
                            key: _formkey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: validateField,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        hintText: WITHDRWAL_AMT,
                                        hintStyle: Theme.of(this.context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                                color: lightBlack,
                                                fontWeight: FontWeight.normal),
                                      ),
                                      controller: amtC,
                                    )),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                    child: TextFormField(
                                      validator: validateField,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        hintText: BANK_DETAIL,
                                        hintStyle: Theme.of(this.context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                                color: lightBlack,
                                                fontWeight: FontWeight.normal),
                                      ),
                                      controller: bankDetailC,
                                    )),
                              ],
                            ))
                      ])),
              actions: <Widget>[
                ElevatedButton(
                    child: Text(
                      CANCEL,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ElevatedButton(
                    child: Text(
                      SEND_LBL,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: fontColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      final form = _formkey.currentState!;
                      if (form.validate()) {
                        form.save();
                        setState(() {
                          Navigator.pop(context);
                        });
                        sendRequest();
                      }
                    })
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().colorBg1(),
      body: SafeArea(
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
                            "Wallet History",
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
                  margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                  padding:
                      EdgeInsets.only(left: 2.91.w, right: 2.91.w, top: 2.67.h),
                  height: 22.26.h,
                  decoration: boxDecoration(
                    showShadow: true,
                    radius: 20.0,
                    bgColor: AppColor().colorBg1(),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.asset(
                        filter,
                        height: 2.26.h,
                        width: 2.26.h,
                      ),
                      Container(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                return filterDialog();
                              },
                              child: Center(
                                child: Image.asset(
                                  paymentIcon,
                                  height: 8.75.h,
                                  width: 21.94.w,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.12.h,
                            ),
                            text(
                              "Your Total Earning",
                              textColor: Color(0xff707070),
                              fontSize: 14.sp,
                              fontFamily: fontBold,
                            ),
                            SizedBox(
                              height: 1.02.h,
                            ),
                            text(
                              CUR_CURRENCY! + " " + CUR_BALANCE,
                              textColor: Color(0xff000000),
                              fontSize: 14.sp,
                              fontFamily: fontBold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                  width: 100.w,
                  child: text(
                    "Request For Money",
                    textColor: Color(0xff202442),
                    fontSize: 14.sp,
                    fontFamily: fontBold,
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                  padding: EdgeInsets.only(left: 2.91.w, right: 2.91.w),
                  height: 8.21.h,
                  decoration: boxDecoration(
                    showShadow: true,
                    radius: 20.0,
                    bgColor: AppColor().colorBg1(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 26.52.w,
                        height: 5.23.h,
                        child: TextFormField(
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.number,
                          controller: amtC,
                          style: TextStyle(
                            color: AppColor().colorTextFour(),
                            fontSize: 10.sp,
                          ),
                          inputFormatters: [],
                          decoration: InputDecoration(
                            labelText: '',
                            labelStyle: TextStyle(
                              color: AppColor().colorTextFour(),
                              fontSize: 10.sp,
                            ),
                            fillColor: AppColor().colorEdit(),
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
                      InkWell(
                        onTap: () async {
                          setState(() {
                            enabled = true;
                          });
                          await Future.delayed(Duration(milliseconds: 200));
                          setState(() {
                            enabled = false;
                          });
                          _showDialog();
                          setState(() {
                            offset = 0;
                            total = 0;
                            tranList.clear();
                          });

                          //    Navigator.push(context, PageTransition(child: LoginScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));
                        },
                        child: ScaleAnimatedWidget.tween(
                          enabled: enabled,
                          duration: Duration(milliseconds: 200),
                          scaleDisabled: 1.0,
                          scaleEnabled: 0.9,
                          child: Container(
                            width: 26.52.w,
                            height: 5.23.h,
                            decoration: boxDecoration(
                                radius: 15.0,
                                bgColor: AppColor().colorPrimaryDark()),
                            child: Center(
                              child: text(
                                "Request",
                                textColor: Color(0xffffffff),
                                fontSize: 10.sp,
                                fontFamily: fontRegular,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                  width: 100.w,
                  child: text(
                    "Payment History",
                    textColor: Color(0xff202442),
                    fontSize: 14.sp,
                    fontFamily: fontBold,
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(top: 1.87.h),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (offset < total)
                          ? tranList.length + 1
                          : tranList.length,
                      itemBuilder: (context, index) {
                        return (index == tranList.length && isLoadingmore)
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                height: 11.25.h,
                                width: 82.91.w,
                                decoration: boxDecoration(
                                  showShadow: true,
                                  radius: 20.0,
                                  bgColor: AppColor().colorBg1(),
                                ),
                                margin: EdgeInsets.only(
                                    left: 8.33.w,
                                    right: 8.33.w,
                                    bottom: 1.87.h),
                                padding: EdgeInsets.only(
                                    left: 3.05.w, right: 3.05.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 7.81.h,
                                      width: 7.81.h,
                                      child: Image(
                                        image: AssetImage(package),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 1.6.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: text(
                                                "Invoice ID : #${tranList[index].id!}",
                                                textColor: Color(0xff191919),
                                                fontSize: 10.5.sp,
                                                fontFamily: fontBold,
                                                overFlow: true),
                                          ),
                                          SizedBox(
                                            height: 1.9.h,
                                          ),
                                          Container(
                                            child: text(
                                                "Close Balance: ${tranList[index].clsBal!.toString()}",
                                                textColor: Color(0xff191919),
                                                fontSize: 7.5.sp,
                                                fontFamily: fontBold,
                                                overFlow: true),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                text(
                                                  "Amount : ",
                                                  textColor: Color(0xff000000),
                                                  fontSize: 7.5.sp,
                                                  fontFamily: fontBold,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                text(
                                                  "₹${tranList[index].amt!}",
                                                  textColor: Color(0xffF4B71E),
                                                  fontSize: 7.5.sp,
                                                  fontFamily: fontBold,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 1.05.w,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 1.9.h),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Image(
                                              image: AssetImage(tranList[index]
                                                              .status ==
                                                          "success" ||
                                                      tranList[index].status ==
                                                          ACCEPTED
                                                  ? greenIcon
                                                  : redIcon),
                                              fit: BoxFit.fill,
                                              height: 3.20.h,
                                              width: 3.20.h,
                                            ),
                                            text(
                                              tranList[index].status ==
                                                          "success" ||
                                                      tranList[index].status ==
                                                          ACCEPTED
                                                  ? "Received"
                                                  : "Pending",
                                              textColor: tranList[index]
                                                              .status ==
                                                          "success" ||
                                                      tranList[index].status ==
                                                          ACCEPTED
                                                  ? Color(0xff79A11D)
                                                  : Colors.red,
                                              fontSize: 7.5.sp,
                                              fontFamily: fontRegular,
                                            ),
                                            SizedBox(
                                              height: 0.7.h,
                                            ),
                                            text(
                                              "${tranList[index].date!}",
                                              textColor: Color(0xff000000),
                                              fontSize: 7.5.sp,
                                              fontFamily: fontSemibold,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                      }),
                ),
                SizedBox(
                  height: 4.02.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void filterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ButtonBarTheme(
            data: ButtonBarThemeData(
              alignment: MainAxisAlignment.center,
            ),
            child: AlertDialog(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                contentPadding: const EdgeInsets.all(0.0),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                      padding: EdgeInsets.only(top: 19.0, bottom: 16.0),
                      child: Text(
                        FILTER_BY,
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Divider(color: lightBlack),
                  TextButton(
                      child: Text(SHOW_TRANS,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: lightBlack)),
                      onPressed: () {
                        tranList.clear();
                        offset = 0;
                        total = 0;
                        setState(() {
                          _isLoading = true;
                        });
                        getTransaction();
                        Navigator.pop(context, 'option 1');
                      }),
                  Divider(color: lightBlack),
                  TextButton(
                      child: Text(SHOW_REQ,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: lightBlack)),
                      onPressed: () {
                        tranList.clear();
                        offset = 0;
                        total = 0;
                        setState(() {
                          _isLoading = true;
                        });
                        getRequest();
                        Navigator.pop(context, 'option 1');
                      }),
                  Divider(
                    color: white,
                  )
                ])),
          );
        });
  }

  Future<Null> sendRequest() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        CUR_USERID = await getPrefrence(ID);
        var parameter = {
          USER_ID: CUR_USERID,
          AMOUNT: amtC!.text.toString(),
          PAYMENT_ADD: bankDetailC!.text.toString()
        };
        print(parameter);
        Response response =
            await post(sendWithReqApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String msg = getdata["message"];

        if (!error) {
          CUR_BALANCE = double.parse(getdata["data"]).toStringAsFixed(2);
        }
        if (mounted) setState(() {});
        setSnackbar(msg, context);
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg, context);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
          _isLoading = false;
        });
    }

    return null;
  }
}
