import 'dart:async';
import 'dart:convert';

import 'package:animated_widgets/animated_widgets.dart';

import 'package:entemarket_delivery/Helper/Session.dart';

import 'package:entemarket_delivery/Helper/color.dart';
import 'package:entemarket_delivery/Helper/constant.dart';
import 'package:entemarket_delivery/Helper/images.dart';
import 'package:entemarket_delivery/Helper/string.dart';

import 'package:entemarket_delivery/Model/earning_model.dart';
import 'package:entemarket_delivery/Model/notification_model.dart';
import 'package:entemarket_delivery/Model/transaction_model.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class EarningHistory extends StatefulWidget {
  const EarningHistory({Key? key}) : super(key: key);

  @override
  _EarningHistoryState createState() => _EarningHistoryState();
}

class _EarningHistoryState extends State<EarningHistory> {
  List<MoneyModel> earnList = [];
  bool loading = true;
  bool _isNetworkAvail = true;
  String selected = "All";
  List<String> filter = ["All", "Today", "Weekly", "Monthly"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEarning();
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
                  width: 100.w,
                  child: text(
                    "Earning History",
                    textColor: Color(0xff202442),
                    fontSize: 14.sp,
                    fontFamily: fontBold,
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Wrap(
                  spacing: 3.w,
                  children: filter.map((e) {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          selected = e.toString();
                        });
                        var now = new DateTime.now();
                        var now_1w = now.subtract(Duration(days: 7));
                        var now_1m = new DateTime(now.year, now.month-1, now.day);
                        if(selected == "Today"){
                            for(int i=0;i<earnList.length;i++){
                              DateTime date = DateTime.parse(earnList[i].transaction_date);
                              if(now.day == date.day && now.month==date.month){
                                setState(() {
                                    earnList[i].show = true;
                                });
                              }else{
                                setState(() {
                                  earnList[i].show = false;
                                });
                              }
                            }
                        }
                        if(selected == "Weekly"){
                          for(int i=0;i<earnList.length;i++){
                            DateTime date = DateTime.parse(earnList[i].transaction_date);
                            if(now_1w.isBefore(date)){
                              setState(() {
                                earnList[i].show = true;
                              });
                            }else{
                              setState(() {
                                earnList[i].show = false;
                              });
                            }
                          }
                        }
                        if(selected == "Monthly"){
                          for(int i=0;i<earnList.length;i++){
                            DateTime date = DateTime.parse(earnList[i].transaction_date);
                            if(now_1m.isBefore(date)){
                              setState(() {
                                earnList[i].show = true;
                              });
                            }else{
                              setState(() {
                                earnList[i].show = false;
                              });
                            }
                          }
                        }
                        if(selected == "All"){
                          for(int i=0;i<earnList.length;i++){
                            setState(() {
                              earnList[i].show = true;
                            });
                          }
                        }
                      },
                      child: Chip(
                          side: BorderSide(color: MyColor.primary),
                          backgroundColor: selected==e?MyColor.primary:Colors.transparent,
                          shadowColor: Colors.transparent,
                          label: text(e,
                              fontFamily: fontMedium,
                              fontSize: 10.sp,
                              textColor: selected==e?Colors.white:Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(top: 1.87.h),
                  child: earnList.length>0?ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: earnList.length,
                      itemBuilder: (context, index) {
                        return earnList[index].show?Container(
                            height: 11.25.h,
                            width: 82.91.w,
                            decoration: boxDecoration(
                              showShadow: true,
                              radius: 20.0,
                              bgColor: AppColor().colorBg1(),
                            ),
                            margin: EdgeInsets.only(
                                left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
                            padding:
                                EdgeInsets.only(left: 3.05.w, right: 3.05.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            "Invoice ID : #${earnList[index].id}",
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
                                            "Transaction Type: ${earnList[index].transaction_type.toString()}",
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
                                              "₹${earnList[index].amount}",
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
                                          image: AssetImage(
                                              earnList[index].status ==
                                                      "success"
                                                  ? greenIcon
                                                  : redIcon),
                                          fit: BoxFit.fill,
                                          height: 3.20.h,
                                          width: 3.20.h,
                                        ),
                                        text(
                                          earnList[index].status == "success"
                                              ? "Received"
                                              : "Pending",
                                          textColor: earnList[index].status ==
                                                  "success"
                                              ? Color(0xff79A11D)
                                              : Colors.red,
                                          fontSize: 7.5.sp,
                                          fontFamily: fontRegular,
                                        ),
                                        SizedBox(
                                          height: 0.7.h,
                                        ),
                                        text(
                                          "${getDate(earnList[index].transaction_date)}",
                                          textColor: Color(0xff000000),
                                          fontSize: 7.5.sp,
                                          fontFamily: fontSemibold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )):SizedBox();
                      }):Center(child: text("No History",textColor: Colors.black,fontSize: 14.sp,fontFamily: fontMedium)),
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

  Future<Null> getEarning() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        CUR_USERID = await getPrefrence(ID);

        var parameter = {"user_id": CUR_USERID};

        Response response =
            await post(getMoneyApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        print(getdata);
        if (!error) {
          for (var v in getdata["data"]) {
            setState(() {
              earnList.add(new MoneyModel(
                  v['id'],
                  v['transaction_type'],
                  v['user_id'],
                  v['order_id'],
                  v['type'],
                  v['txn_id'],
                  v['payu_txn_id'].toString(),
                  v['amount'],
                  v['status'],
                  v['currency_code'].toString(),
                  v['payer_email'].toString(),
                  v['message'],
                  v['transaction_date'],
                  v['date_created'],true));
            });
          }
        }
        setSnackbar(msg.toString(), context);
        setState(() {
          loading = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg, context);
        setState(() {
          loading = false;
        });
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
          loading = false;
        });
    }

    return null;
  }
}
