import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:entemarket_delivery/Helper/Session.dart';
import 'package:entemarket_delivery/Helper/app_btn.dart';
import 'package:entemarket_delivery/Helper/color.dart';
import 'package:entemarket_delivery/Helper/constant.dart';
import 'package:entemarket_delivery/Helper/string.dart';
import 'package:entemarket_delivery/Model/order_model.dart';
import 'package:entemarket_delivery/NewScreen/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class OrderDetail extends StatefulWidget {
  final Order_Model? model;
  final Function? updateHome;

  const OrderDetail({
    Key? key,
    this.model,
    this.updateHome,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateOrder();
  }
}

class StateOrder extends State<OrderDetail> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController controller = ScrollController();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool _isNetworkAvail = true;
  List<String> statusList = [
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
    WAITING
  ];
  bool? _isCancleable, _isReturnable, _isLoading = true;
  bool _isProgress = false;
  String? curStatus;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController? otpC;
  OrderItem? orderItems;
  String? msg;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.model!.itemList!.length; i++) {
      widget.model!.itemList![i].curSelected =
          widget.model!.itemList![i].status;
    }

    if (widget.model!.payMethod == "Bank Transfer") {
      statusList.removeWhere((element) => element == PLACED);
    }

    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: buttonController!,
      curve: const Interval(
        0.0,
        0.150,
      ),
    ));
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: TRY_AGAIN_INT_LBL,
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  await buttonController!.reverse();
                  setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    Order_Model model = widget.model!;
    String? pDate, prDate, sDate, dDate, cDate, rDate;


    for(var i=0;i<widget.model!.itemList!.length;i++){
      msg = widget.model!.itemList![i].status;
      print("status msg here ${msg}");
    }
    for(var i=0;i<model.itemList!.length;i++){
      orderItems = model.itemList![i];
    }

    if (model.listStatus!.contains(PLACED)) {
      pDate = model.listDate![model.listStatus!.indexOf(PLACED)];

      if (pDate != null) {
        List d = pDate.split(" ");
        pDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(PROCESSED)) {
      prDate = model.listDate![model.listStatus!.indexOf(PROCESSED)];
      if (prDate != null) {
        List d = prDate.split(" ");
        prDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(SHIPED)) {
      sDate = model.listDate![model.listStatus!.indexOf(SHIPED)];
      if (sDate != null) {
        List d = sDate.split(" ");
        sDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(DELIVERD)) {
      dDate = model.listDate![model.listStatus!.indexOf(DELIVERD)];
      if (dDate != null) {
        List d = dDate.split(" ");
        dDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(CANCLED)) {
      cDate = model.listDate![model.listStatus!.indexOf(CANCLED)];
      if (cDate != null) {
        List d = cDate.split(" ");
        cDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(RETURNED)) {
      rDate = model.listDate![model.listStatus!.indexOf(RETURNED)];
      if (rDate != null) {
        List d = rDate.split(" ");
        rDate = d[0] + "\n" + d[1];
      }
    }

    _isCancleable = model.isCancleable == "1" ? true : false;
    _isReturnable = model.isReturnable == "1" ? true : false;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightWhite,
      /*appBar: getAppBar(ORDER_DETAIL, context,widget: widget.model!.userfuid!=""&&widget.model!.userfuid!=null&&widget.model!.userfuid!="0"?OutlinedButton(
        onPressed: () {
          userName = widget.model!.username.toString();
          userEmail =widget.model!.useremail.toString();
          fcmID = widget.model!.userfcm_id.toString();
          fid = widget.model!.userfuid.toString();
          callChat();
        },
        child: Text("Chat",  style: TextStyle(
          color: Colors.white,
        ),),
      ):SizedBox()),*/
      appBar: getAppBar(ORDER_DETAIL, context,widget: Container(
        margin: EdgeInsets.only(right: 5.91.w),
        child: PopupMenuButton(
            icon: Icon(Icons.chat,color: Colors.white,),
            iconSize:  32,
            color: Colors.white,
            onSelected: (val){
              if(val =="seller"){
                sellerName = model.sellername.toString();
                sellerEmail =model.selleremail.toString();
                sellerFcmID = model.sellerfcm.toString();
                sellerFid = model.sellerfuid.toString();
                if(sellerFid!=""&&sellerFid!=null&&sellerFid!="0"){
                  callChatSeller();
                }else{
                  setSnackbar("Currently Not Available",);
                }
              }else{
                userName = widget.model!.username.toString();
                userEmail =widget.model!.useremail.toString();
                fcmID = widget.model!.userfcm_id.toString();
                fid = widget.model!.userfuid.toString();

                if(fid!=""&&fid!=null&&fid!="0"){
                  callChat();
                }else{
                  setSnackbar("Currently Not Available",);
                }
              }
            },
            itemBuilder: (_) =><PopupMenuItem<String>>[
              PopupMenuItem(child: text("Seller",textColor: Colors.black),value: "seller",),
              PopupMenuItem(child: text("User",textColor: Colors.black),value: "user",),
            ]),
      ),),
      body: _isNetworkAvail
          ? Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Card(
                            elevation: 0,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "$ORDER_ID_LBL - ${model.id!}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                              color: lightBlack2),
                                        ),
                                        Text(
                                          model.orderDate!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                              color: lightBlack2),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      model.payMethod!="COD"?"$PAYMENT_MTHD -ONLINE":"$PAYMENT_MTHD - ${model.payMethod!}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(color: lightBlack2),
                                    ),
                                  ],
                                ))),
                        model.delDate != null && model.delDate!.isNotEmpty
                            ? Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Text(
                                    "$PREFER_DATE_TIME: ${model.delDate!} - ${model.delTime!}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(color: lightBlack2),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: DropdownButtonFormField(
                                              dropdownColor: lightWhite,
                                              isDense: true,
                                              iconEnabledColor: fontColor,
                                              //iconSize: 40,
                                              hint: Text(
                                                "Update Status",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                    color: fontColor,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              decoration: const InputDecoration(
                                                filled: true,
                                                isDense: true,
                                                fillColor: lightWhite,
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: fontColor),
                                                ),
                                              ),
                                              value: orderItems!.status,
                                              onChanged: (dynamic newValue) {
                                                setState(() {
                                                  orderItems!.curSelected =
                                                      newValue;
                                                });
                                              },
                                              items:
                                              statusList.map((String st) {
                                                return DropdownMenuItem<String>(
                                                  value: st,
                                                  child: Text(
                                                    capitalize(st),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2!
                                                        .copyWith(
                                                        color: fontColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        msg == "delivered" || statusMsg == "" ? SizedBox.shrink() :  RawMaterialButton(
                                          constraints:
                                          const BoxConstraints.expand(
                                              width: 42, height: 42),
                                          onPressed: () {
                                            if (model.otp != null &&
                                                // model.otp!.isNotEmpty &&
                                                model.otp != "0" &&
                                                orderItems!.curSelected ==
                                                    DELIVERD) {
                                              otpDialog(
                                                orderItems!.curSelected,
                                                model.otp,
                                                model.id,
                                                true,
                                              );
                                            } else {
                                              updateOrder(
                                                  orderItems!.curSelected,
                                                  model.id,
                                                  true,
                                                  model.otp
                                              );
                                            }
                                          },
                                          elevation: 2.0,
                                          fillColor: fontColor,
                                          padding:
                                          const EdgeInsets.only(left: 5),
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.send,
                                              size: 20,
                                              color: white,
                                            ),
                                          ),
                                          shape: const CircleBorder(),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                            : Container(),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.itemList!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            OrderItem orderItem = model.itemList![i];
                            return productItem(orderItem, model, i);
                          },
                        ),
                        sellerDetails(),
                        shippingDetails(),
                        priceDetails(),
                      ],
                    ),
                  ),
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: DropdownButtonFormField(
                          dropdownColor: lightWhite,
                          isDense: true,
                          iconEnabledColor: fontColor,

                          hint: new Text(
                            "Update Status",
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: fontColor,
                                    fontWeight: FontWeight.bold),
                          ),
                         decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            fillColor: lightWhite,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: fontColor),
                            ),
                          ),
                          value: widget.model!.activeStatus,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              curStatus = newValue;
                            });
                          },
                          items: statusList.map((String st) {
                            return DropdownMenuItem<String>(
                              value: st,
                              child: Text(
                                capitalize(st),
                                style: Theme.of(this.context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: fontColor,
                                        fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      constraints:
                          BoxConstraints.expand(width: 42, height: 42),
                      onPressed: () {
                        if (model.otp != null &&
                            model.otp!.isNotEmpty &&
                            model.otp != "0" &&
                            curStatus == DELIVERD)
                          otpDialog(
                              curStatus, model.otp, model.id, false, 0);
                        else
                          updateOrder(curStatus, int.parse(model.id!),
                              model.otp);
                      },
                      elevation: 2.0,
                      fillColor: fontColor,
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.send,
                          size: 20,
                          color: white,
                        ),
                      ),
                      shape: CircleBorder(),
                    )
                  ],
                ),
              )*/
            ],
          ),
          showCircularProgress(_isProgress, primary),
        ],
      )
          : noInternet(context),
    );
  }

  otpDialog(String? curSelected, String? otp, String? id, bool item) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(0.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  content: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                                padding:
                                const EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                                child: Text(
                                  OTP_LBL,
                                  style: Theme.of(this.context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(color: fontColor),
                                )),
                            const Divider(color: lightBlack),
                            Form(
                                key: _formkey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 0, 20.0, 0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return FIELD_REQUIRED;
                                            } else if (value.trim() != otp) {
                                              return OTPERROR;
                                            } else {
                                              return null;
                                            }
                                          },
                                          autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                          decoration: InputDecoration(
                                            hintText: OTP_ENTER,
                                            hintStyle: Theme.of(this.context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                color: lightBlack,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          controller: otpC,
                                        )),
                                  ],
                                ))
                          ])),
                  actions: <Widget>[
                    TextButton(
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
                    TextButton(
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
                            updateOrder(curSelected, id, item, otp);
                          }
                        })
                  ],
                );
              });
        });
  }

  _launchMap(lat, lng) async {
    var url = '';

    if (Platform.isAndroid) {
      url =
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving&dir_action=navigate";
    } else {
      url =
      "http://maps.apple.com/?saddr=&daddr=$lat,$lng&directionsmode=driving&dir_action=navigate";
    }
    await launch(url);
/*    if (await canLaunch(url)) {

    } else {
      throw 'Could not launch $url';
    }*/
  }

  Widget priceDetails() {
    return Card(
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(PRICE_DETAIL,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: fontColor, fontWeight: FontWeight.bold))),
              const Divider(
                color: lightBlack,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$PRICE_LBL :",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2)),
                    Text("${CUR_CURRENCY!} ${widget.model!.subTotal!}",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$DELIVERY_CHARGE :",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2)),
                    Text("+ ${CUR_CURRENCY!} ${widget.model!.delCharge!}",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$TAXPER (${widget.model!.taxPer!}) :",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2)),
                    Text("+ ${CUR_CURRENCY!} ${widget.model!.taxAmt!}",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$PROMO_CODE_DIS_LBL :",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2)),
                    Text("- ${CUR_CURRENCY!} ${widget.model!.promoDis!}",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$WALLET_BAL :",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2)),
                    Text("- ${CUR_CURRENCY!} ${widget.model!.walBal!}",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: lightBlack2))
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$TOTAL_PRICE :",
                        style: Theme.of(context).textTheme.button!.copyWith(
                            color: lightBlack, fontWeight: FontWeight.bold)),
                    Text("${CUR_CURRENCY!} ${widget.model!.total!}",
                        style: Theme.of(context).textTheme.button!.copyWith(
                            color: lightBlack, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ])));
  }

  Widget shippingDetails() {
    return Card(
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    children: [
                      Text(SHIPPING_DETAIL,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                              color: fontColor,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      widget.model!.latitude != "" &&
                          widget.model!.longitude != ""
                          ? Container(
                        height: 30,
                        child: IconButton(
                            icon: const Icon(
                              Icons.location_on,
                              color: fontColor,
                            ),
                            onPressed: () {
                              _launchMap(widget.model!.latitude,
                                  widget.model!.longitude);
                            }),
                      )
                          : Container()
                    ],
                  )),
              const Divider(
                color: lightBlack,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    widget.model!.name != null && widget.model!.name!.isNotEmpty
                        ? " ${capitalize(widget.model!.name!)}"
                        : " ",
                  )),
              Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
                  child: Text(capitalize(widget.model!.address!),
                      style: const TextStyle(color: lightBlack2))),
              InkWell(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.call,
                            size: 15,
                            color: fontColor,
                          ),
                          Text(" ${widget.model!.mobile!}",
                              style: const TextStyle(
                                  color: fontColor,
                                  decoration: TextDecoration.underline)),
                        ],
                      )),

                  onTap: (){
                    _launchCaller(widget.model!.mobile!);
                  }
              ),
            ])));
  }

  Widget sellerDetails() {
    return Card(
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    children: [
                      Text(SELLER_DETAILS,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                              color: fontColor,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      widget
                          .model!.sellerlatitude != "" &&
                          widget.model!.sellerlogtitude != ""
                          ? Container(
                        height: 30,
                        child: IconButton(
                            icon: const Icon(
                              Icons.location_on,
                              color: fontColor,
                            ),
                            onPressed: () {
                              _launchMap(
                                  widget
                                      .model!.sellerlatitude,
                                  widget.model!.sellerlogtitude);
                            }),
                      )
                          : Container(),
                    ],
                  )),
              const Divider(
                color: lightBlack,
              ),
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FadeInImage(
                        fadeInDuration: const Duration(milliseconds: 150),
                        image: NetworkImage(widget.model!.itemList![0].storeImage!),
                        height: 90.0,
                        width: 90.0,
                        placeholder: placeHolder(90),
                      )),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Text(
                                widget.model!.itemList![0].storeName != null &&
                                    widget.model!.itemList![0].storeName!
                                        .isNotEmpty
                                    ? " ${capitalize(widget.model!.itemList![0].storeName!)}"
                                    : " ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 3),
                              child: Text(capitalize(widget.model!.itemList![0].sellerAddress.toString()),
                                  style: const TextStyle(color: lightBlack2))),
                          InkWell(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.call,
                                        size: 15,
                                        color: fontColor,
                                      ),
                                      Text(" ${widget.model!.itemList![0].sellerMobileNumber.toString()}",
                                          style: const TextStyle(
                                              color: fontColor,
                                              decoration: TextDecoration.underline)),
                                    ],
                                  )),
                              onTap: (){
                                _launchCaller(widget.model!.itemList![0].sellerMobileNumber!);
                              }
                          ),
                        ],
                      ))
                ],
              ),
            ])));
  }

  Widget productItem(OrderItem orderItem, Order_Model model, int i) {
    List att = [], val = [];
    if (orderItem.attr_name!.isNotEmpty) {
      att = orderItem.attr_name!.split(',');
      val = orderItem.varient_values!.split(',');
    }

    return Card(
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage(
                          fadeInDuration: const Duration(milliseconds: 150),
                          image: NetworkImage(orderItem.image!),
                          height: 90.0,
                          width: 90.0,
                          placeholder: placeHolder(90),
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderItem.name ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                  color: lightBlack,
                                  fontWeight: FontWeight.normal),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            orderItem.attr_name!.isNotEmpty
                                ? ListView.builder(
                                physics:
                                const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: att.length,
                                itemBuilder: (context, index) {
                                  return Row(children: [
                                    Flexible(
                                      child: Text(
                                        att[index].trim() + ":",
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(color: lightBlack2),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        val[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(color: lightBlack),
                                      ),
                                    )
                                  ]);
                                })
                                : Container(),
                            Row(children: [
                              Text(
                                "$QUANTITY_LBL:",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(color: lightBlack2),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  orderItem.qty!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(color: lightBlack),
                                ),
                              )
                            ]),
                            Text(
                              "${CUR_CURRENCY!} ${orderItem.price!}",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: fontColor),
                            ),
                            /*widget.model!.itemList!.length >= 1
                                ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0),
                                      child: DropdownButtonFormField(
                                        dropdownColor: lightWhite,
                                        isDense: true,
                                        iconEnabledColor: fontColor,
                                        //iconSize: 40,
                                        hint: Text(
                                          "Update Status",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                              color: fontColor,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        decoration: const InputDecoration(
                                          filled: true,
                                          isDense: true,
                                          fillColor: lightWhite,
                                          contentPadding:
                                          EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 10),
                                          enabledBorder:
                                          OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: fontColor),
                                          ),
                                        ),
                                        value: orderItem.status,
                                        onChanged: (dynamic newValue) {
                                          setState(() {
                                            orderItem.curSelected =
                                                newValue;
                                          });
                                        },
                                        items:
                                        statusList.map((String st) {
                                          return DropdownMenuItem<String>(
                                            value: st,
                                            child: Text(
                                              capitalize(st),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(
                                                  color: fontColor,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  RawMaterialButton(
                                    constraints:
                                    const BoxConstraints.expand(
                                        width: 42, height: 42),
                                    onPressed: () {
                                      if (model.otp != null &&
                                          model.otp!.isNotEmpty &&
                                          model.otp != "0" &&
                                          orderItem.curSelected ==
                                              DELIVERD) {
                                        otpDialog(
                                            orderItem.curSelected,
                                            model.otp,
                                            model.id,
                                            true,
                                            i);
                                      } else {
                                        updateOrder(
                                            orderItem.curSelected,
                                            model.id,
                                            true,
                                            i,
                                            model.otp);
                                      }
                                    },
                                    elevation: 2.0,
                                    fillColor: fontColor,
                                    padding:
                                    const EdgeInsets.only(left: 5),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.send,
                                        size: 20,
                                        color: white,
                                      ),
                                    ),
                                    shape: const CircleBorder(),
                                  )
                                ],
                              ),
                            )
                                : Container()*/
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )));
  }

  String? statusMsg;
  Future<void> updateOrder(
      String? status, String? id, bool item, String? otp) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        setState(() {
          _isProgress = true;
        });

        var parameter = {
          ORDERID: id,
          STATUS: status,
          DEL_BOY_ID: CUR_USERID,
          OTP: otp
        };
        print("UPDATE ORDER PARAM" + parameter.toString());
        // if (item) parameter[ORDERITEMID] = widget.model!.itemList![index].id;

        print(parameter.toString());
        Response response =
        await post(updateOrderApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String msg = getdata["message"];
        setSnackbar(msg);
        if (!error) {
          if (item) {
            for(var i=0;i<widget.model!.itemList!.length;i++){
              widget.model!.itemList![i].status = status;
            }
            setState(() {
              statusMsg = msg;
            });
            // widget.model!.itemList![index].status = status;
          } else {
            widget.model!.activeStatus = status;
          }
        }

        setState(() {
          _isProgress = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
      }
    } else {
      setState(() {
        _isNetworkAvail = false;
      });
    }
  }

  void _launchCaller(String phoneNumber) async {
    var url = "tel:91$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      setSnackbar('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

  setSnackbar(String msg) {
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
  String userEmail = "paliwalpravin1@gmail.com", sellerEmail = "";
  String userName = "Praveen", sellerName = "",fid="",fcmID= "";
  String userLast = "", driverLast = "";
  String  sellerFid="",sellerFcmID= "";
  String uid = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  callChat() async {
    await App.init();
    if (App.localStorage.getString("firebaseUid") != null) {
      uid = App.localStorage.getString("firebaseUid").toString();
      var otherUser1 = types.User(
        firstName: userName,
        id: fid,
        imageUrl: 'https://i.pravatar.cc/300?u=$userEmail',
        lastName: "",
      );
      _handlePressed(otherUser1, context,fcmID);
    }
  }
  callChatSeller() async {
    await App.init();
    if (App.localStorage.getString("firebaseUid") != null) {
      uid = App.localStorage.getString("firebaseUid").toString();
      var otherUser1 = types.User(
        firstName: sellerName,
        id: sellerFid,
        imageUrl: 'https://i.pravatar.cc/300?u=$sellerEmail',
        lastName: "",
      );
      _handlePressed(otherUser1, context,sellerFcmID);
    }
  }
  _handlePressed(types.User otherUser, BuildContext context,String fcmID) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
          fcm: fcmID,
        ),
      ),
    );
  }
}
