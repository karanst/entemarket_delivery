import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:entemarket_delivery/Helper/Session.dart';
import 'package:entemarket_delivery/Helper/app_btn.dart';
import 'package:entemarket_delivery/Helper/color.dart';
import 'package:entemarket_delivery/Helper/constant.dart';
import 'package:entemarket_delivery/Helper/images.dart';
import 'package:entemarket_delivery/Helper/push_notification_service.dart';
import 'package:entemarket_delivery/Helper/string.dart';
import 'package:entemarket_delivery/Model/notification_model.dart';
import 'package:entemarket_delivery/Model/order_model.dart';
import 'package:entemarket_delivery/NewScreen/login_screen.dart';
import 'package:entemarket_delivery/Screens/Authentication/login.dart';
import 'package:entemarket_delivery/NewScreen/payment_screen.dart';
import 'package:entemarket_delivery/Screens/order_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class OrderHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateOrderHistory();
  }
}

int? total, offset;
List<Order_Model> orderList = [];
bool _isLoading = true;
bool isLoadingmore = true;
bool isLoadingItems = true;
String address="",bankName="",accountNumber="",ifscCode= "",accountName = "";
class StateOrderHistory extends State<OrderHistory> with TickerProviderStateMixin {
  int curDrwSel = 0;

  bool _isNetworkAvail = true;
  List<Order_Model> tempList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  String? profile;
  ScrollController controller = ScrollController();
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
    awaitingPayment
  ];
  String? activeStatus;
  double calculateDistance(lat1, lon1, lat2, lon2,index) {
    if(lat1!=""&&lat1!=null&&lon1!=""&&lon1!=null&&lat2!=""&&lat2!=null&&lon2!=""&&lon2!=null){

      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((double.parse(lat2.toString()) - double.parse(lat1.toString())) * p) /
              2 +
          c(double.parse(lat1.toString()) * p) *
              c(double.parse(lat2.toString()) * p) *
              (1 -
                  c((double.parse(lon2.toString()) -
                      double.parse(lon1.toString())) *
                      p)) /
              2;
      double km = 12742 * asin(sqrt(a));
      for(int i =0;i<earningList.length;i++){
        if(km>=double.parse(earningList[i].min_km)&&km<=double.parse(earningList[i].max_km)){
          orderList[index].earning = earningList[i].delivery_charge.toString();
        }
      }
      return 12742 * asin(sqrt(a));
    }else{
      double km = 1;
      for(int i =0;i<earningList.length;i++){
        if(km>=double.parse(earningList[i].min_km)&&km<=double.parse(earningList[i].max_km)){
          orderList[index].earning = earningList[i].delivery_charge.toString();

        }
      }
      return 0.0;
    }


  }
  @override
  void initState() {
    offset = 0;
    total = 0;
    orderList.clear();
    getEarning();
    //getUserDetail();
    getSetting();
    getOrder();


    getFid();

    final pushNotificationService = PushNotificationService(context: context);
    pushNotificationService.initialise();

    buttonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: buttonController!,
      curve: Interval(
        0.0,
        0.150,
      ),
    ));
    controller.addListener(_scrollListener);

    super.initState();
  }
  TextEditingController searchController = new TextEditingController();
  String _searchText = "", _lastsearch = "";
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightWhite,
      body: _isNetworkAvail
          ? _isLoading
          ? shimmer()
          : RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: SafeArea(
            child: SingleChildScrollView(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "Order History",
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
                      orderList.length>0?ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orderList.length,
                          itemBuilder: (context,index){
                            Order_Model? item;
                            Order_Model model = orderList[index];
                            Color back;

                            if ((model.itemList![0].status!) == DELIVERD)
                              back = Colors.green;
                            else if ((model.itemList![0].status!) == SHIPED)
                              back = Colors.orange;
                            else if ((model.itemList![0].status!) == CANCLED ||
                                model.itemList![0].status! == RETURNED)
                              back = Colors.red;
                            else if ((model.itemList![0].status!) == PROCESSED)
                              back = Colors.indigo;
                            else if (model.itemList![0].status! == WAITING)
                              back = Colors.black;
                            else
                              back = Colors.cyan;
                            try {
                              item =
                              orderList.isEmpty ? null : orderList[index];
                              if (isLoadingmore &&
                                  index == (orderList.length - 1) &&
                                  controller.position.pixels <= 0) {
                                getOrder();
                              }
                            } on Exception catch (_) {}
                            return InkWell(
                              onTap: ()async{
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderDetail(model: orderList[index])),
                                );
                                setState(() {
                                  getUserDetail();
                                });
                              },
                              child: Container(
                                width: 90.33.w,
                                margin: EdgeInsets.only(bottom:1.87.h,left: 2.w,right: 2.w,
                                ),
                                decoration:
                                boxDecoration(radius: 32.0, bgColor: AppColor().colorBg1()),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 3.44.w,right: 3.44.w,top: 3.90.h,),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 6.81.h,
                                              width: 6.81.h,
                                              child: Image(
                                                image:AssetImage("images/card_person.png"),
                                                fit: BoxFit.fill,
                                              )),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            text(
                                                              "Order #${item!.id.toString()} |",
                                                              textColor: Color(0xff191919),
                                                              fontSize: 13.sp,
                                                              fontFamily: fontBold,
                                                            ),
                                                            text(
                                                              calculateDistance(
                                                                  model.latitude.toString(),
                                                                  model.longitude.toString(),
                                                                  model.sellerlatitude.toString(),
                                                                  model.sellerlogtitude.toString(),index)
                                                                  .toStringAsFixed(2) +
                                                                  "Km",
                                                              textColor: Color(0xff13CE3F),
                                                              fontSize: 13.sp,
                                                              fontFamily: fontBold,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width:  3.34.w,),
                                                      Container(
                                                        child:  text(
                                                          "${item.orderDate}",
                                                          textColor: Color(0xff191919),
                                                          fontSize: 7.sp,
                                                          fontFamily: fontRegular,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(height:  1.54.h,),
                                                Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 8),
                                                        padding:
                                                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                        decoration: BoxDecoration(
                                                            color: back,
                                                            borderRadius:
                                                            const BorderRadius.all(Radius.circular(4.0))),
                                                        child: Text(
                                                          capitalize(model.itemList![0].status!),
                                                          style: const TextStyle(color: white),
                                                        ),
                                                      ),
                                                      SizedBox(width:  3.34.w,),
                                                      text(
                                                        "Earning Amount : ₹${item.earning.toString()}",
                                                        textColor: Color(0xffBF2330),
                                                        fontSize: 7.sp,
                                                        fontFamily: fontBold,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: 4.44.w,vertical: 1.50.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 2.5.h,
                                              width: 2.5.h,
                                              child: Image(
                                                image:AssetImage("images/yellow_location.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(width: 1.w,),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  text(
                                                    "Pick up Point",
                                                    textColor: Color(0xff191919),
                                                    fontSize: 7.5.sp,
                                                    fontFamily: fontBold,
                                                  ),
                                                  Container(
                                                    width: 60.w,
                                                    child: text(
                                                      address,
                                                      textColor: Color(0xffAEABAB),
                                                      fontSize: 9.sp,
                                                      fontFamily: fontRegular,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: 4.44.w,vertical: 1.50.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 2.5.h,
                                              width: 2.5.h,
                                              child: Image(
                                                image:AssetImage("images/red_location.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(width: 1.w,),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  text(
                                                    "Drop Point",
                                                    textColor: Color(0xff191919),
                                                    fontSize: 7.5.sp,
                                                    fontFamily: fontBold,
                                                  ),
                                                  Container(
                                                    width: 60.w,
                                                    child: text(
                                                      item.address.toString(),
                                                      textColor: Color(0xffAEABAB),
                                                      fontSize: 9.sp,
                                                      fontFamily: fontRegular,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }):Container(
                        height: 30.h,
                        child: Center(child: text("No Order Available",fontSize: 14.sp,fontFamily: fontBold,textColor: Colors.black)),),
                      /* orderList.isEmpty
                          ? isLoadingItems
                          ? const Center(
                          child: CircularProgressIndicator())
                          : const Center(child: Text(noItem))
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: (offset! < total!)
                            ? orderList.length + 1
                            : orderList.length,
                        physics:
                        const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return (index == orderList.length &&
                              isLoadingmore)
                              ? const Center(
                              child:
                              CircularProgressIndicator())
                              : orderItem(index);
                        },
                      )*/
                      isLoadingItems
                          ? Center(
                        child: Container(
                          padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : Container(),
                    ])),
          ))
          : noInternet(context),
    );
  }

  void filterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ButtonBarTheme(
            data: const ButtonBarThemeData(
              alignment: MainAxisAlignment.center,
            ),
            child: AlertDialog(
                elevation: 2.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                contentPadding: const EdgeInsets.all(0.0),
                content: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                        padding:
                        EdgeInsetsDirectional.only(top: 19.0, bottom: 16.0),
                        child: Text(
                          'Filter By',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: fontColor),
                        )),
                    Divider(color: lightBlack),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: getStatusList()),
                      ),
                    ),
                  ]),
                )),
          );
        });
  }

  List<Widget> getStatusList() {
    return statusList
        .asMap()
        .map(
          (index, element) => MapEntry(
        index,
        Column(
          children: [
            Container(
              width: double.maxFinite,
              child: TextButton(
                  child: Text(capitalize(statusList[index]),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: lightBlack)),
                  onPressed: () {
                    setState(() {
                      activeStatus = index == 0 ? null : statusList[index];
                      isLoadingmore = true;
                      offset = 0;
                      isLoadingItems = true;
                    });

                    getOrder();

                    Navigator.pop(context, 'option $index');
                  }),
            ),
            const Divider(
              color: lightBlack,
              height: 1,
            ),
          ],
        ),
      ),
    )
        .values
        .toList();
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          isLoadingmore = true;

          if (offset! < total!) getOrder();
        });
      }
    }
  }



  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _refresh() {
    offset = 0;
    total = 0;
    orderList.clear();

    setState(() {
      _isLoading = true;
      isLoadingItems = false;
    });
    orderList.clear();
    return getOrder();
  }

  logOutDailog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  content: Text(
                    LOGOUTTXT,
                    style: Theme.of(this.context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: fontColor),
                  ),
                  actions: <Widget>[
                    TextButton(
                        child: Text(
                          LOGOUTNO,
                          style: Theme.of(this.context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }),
                    TextButton(
                        child: Text(
                          LOGOUTYES,
                          style: Theme.of(this.context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                              color: fontColor, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          clearUserSession();

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Login()),
                                  (Route<dynamic> route) => false);
                        })
                  ],
                );
              });
        });
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
                  getOrder();
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
  List<EarningModel>  earningList = [];
  Future<Null> getEarning() async {
    await App.init();
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        CUR_USERID = await getPrefrence(ID);

        var parameter = {"user_id": CUR_USERID};

        Response response =
        await post(getEarningApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          for(var v in getdata['data']){
            setState(() {
              earningList.add(new EarningModel(v['id'].toString(), v['min_km'].toString(), v['max_km'].toString(), v['delivery_charge'].toString()));
            });
          }
        }
        setState(() {
          _isLoading = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
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
  Future<Null> getOrder() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      if (offset == 0) {
        orderList = [];
      }
      try {
        CUR_USERID = await getPrefrence(ID);
        CUR_USERNAME = await getPrefrence(USERNAME);

        var parameter = {
          USER_ID: CUR_USERID,
          LIMIT: perPage.toString(),
          OFFSET: offset.toString(),
          SEARCH: _searchText.trim(),
        };
        print(parameter);
        if (activeStatus != null) {
          if (activeStatus == awaitingPayment) activeStatus = "awaiting";
          parameter[ACTIVE_STATUS] = activeStatus;
        }

        Response response =
        await post(getOrdersApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        total = int.parse(getdata["total"]);

        if (!error) {
          if (offset! < total!) {
            tempList.clear();
            var data = getdata["data"];

            tempList = (data as List)
                .map((data) => Order_Model.fromJson(data))
                .toList();

            orderList.addAll(tempList);

            offset = offset! + perPage;
          }
        }
        if (mounted)
          setState(() {
            _isLoading = false;
            isLoadingItems = false;
          });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
        setState(() {
          _isLoading = false;
          isLoadingItems = false;
        });
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
          _isLoading = false;
          isLoadingItems = false;
        });
    }

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
        print(getBoyDetailApi);
        print(parameter);
        print(headers);
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        print("4234"+getdata.toString());
        if (!error) {
          var data = getdata["data"][0];
          print(data);
          CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
          CUR_BONUS = data[BONUS];
          driverEmail = data[EMAIL];
          driverName = data[USERNAME];
          address = data['address'];
          bankName = data['bank_no'];
          accountName = data['account_name'];
          accountNumber = data['account_no'];
          ifscCode = data['ifsc_code'];
          isSwitched = data['active']=="1"?true:false;
          callChat();
        }
        setState(() {
          _isLoading = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
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

  Widget orderItem(int index) {
    Order_Model model = orderList[index];
    Color back;

    if ((model.itemList![0].status!) == DELIVERD)
      back = Colors.green;
    else if ((model.itemList![0].status!) == SHIPED)
      back = Colors.orange;
    else if ((model.itemList![0].status!) == CANCLED ||
        model.itemList![0].status! == RETURNED)
      back = Colors.red;
    else if ((model.itemList![0].status!) == PROCESSED)
      back = Colors.indigo;
    else if (model.itemList![0].status! == WAITING)
      back = Colors.black;
    else
      back = Colors.cyan;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Order No.${model.id!}"),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: back,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(4.0))),
                      child: Text(
                        capitalize(model.itemList![0].status!),
                        style: const TextStyle(color: white),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.person, size: 14),
                          Expanded(
                            child: Text(
                              model.name != null && model.name!.isNotEmpty
                                  ? " ${capitalize(model.name!)}"
                                  : " ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.call,
                            size: 14,
                            color: fontColor,
                          ),
                          Text(
                            " ${model.mobile!}",
                            style: const TextStyle(
                                color: fontColor,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      onTap: () {
                        _launchCaller(index);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.money, size: 14),
                        Text(" Payable: ${CUR_CURRENCY!} ${model.payable!}"),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.payment, size: 14),
                        Text(" ${model.payMethod!}"),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, size: 14),
                    Text(" Order on: ${model.orderDate!}"),
                  ],
                ),
              )
            ])),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetail(model: orderList[index])),
          );
          setState(() {
            /* _isLoading = true;
             total=0;
             offset=0;
orderList.clear();*/
            getUserDetail();
          });
          // getOrder();
        },
      ),
    );
  }

  _launchCaller(index) async {
    var url = "tel:${orderList[index].mobile}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _detailHeader() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: fontColor,
                    ),
                    Text(ORDER),
                    Text(
                      total.toString(),
                      style: const TextStyle(
                          color: fontColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )),
        ),
        Expanded(
          flex: 3,
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: fontColor,
                  ),
                  Text(BAL_LBL),
                  Text(
                    "${CUR_CURRENCY!} $CUR_BALANCE",
                    style: const TextStyle(
                        color: fontColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.wallet_giftcard,
                    color: fontColor,
                  ),
                  const Text(BONUS_LBL),
                  Text(
                    CUR_BONUS!,
                    style: const TextStyle(
                        color: fontColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getSetting() async {
    try {
      CUR_USERID = await getPrefrence(ID);

      var parameter = {TYPE: CURRENCY};

      Response response =
      await post(getSettingApi, body: parameter, headers: headers)
          .timeout(Duration(seconds: timeOut));
      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          CUR_CURRENCY = getdata["currency"];
        } else {
          setSnackbar(msg!);
        }
      }
    } on TimeoutException catch (_) {
      setSnackbar(somethingMSg);
    }
  }
  Future<Null> getFid() async {
    await App.init();
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        CUR_USERID = await getPrefrence(ID);

        var parameter = {"user_id": CUR_USERID};

        Response response =
        await post(getUserApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          var data = getdata["data"][0];
          App.localStorage.setString("firebaseUid", data['fuid']);
        }
        setState(() {
          _isLoading = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
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
  Future<Null> updateFid(fid) async {
    await App.init();
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        CUR_USERID = await getPrefrence(ID);

        var parameter = {"user_id": CUR_USERID,  "fuid": fid,};

        Response response =
        await post(getUpdateApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          App.localStorage.setString("firebaseUid", fid.toString());
        }
        setState(() {
          _isLoading = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
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
  String  driverEmail = "";
  String  driverName = "";
  callChat() async {
    await App.init();
    try {
      UserCredential data =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: driverEmail,
        password: "12345678",
      );
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: driverName,
          id: data.user!.uid,
          imageUrl: 'https://i.pravatar.cc/300?u=$driverEmail',
          lastName: "",
        ),
      );
      updateFid( data.user!.uid);
    } catch (e) {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: driverEmail,
        password: "12345678",
      );
      // App.localStorage.setString("firebaseUid", credential.user!.uid);
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: driverName,
          id: credential.user!.uid,
          imageUrl: 'https://i.pravatar.cc/300?u=$driverEmail',
          lastName: "",
        ),
      );
      updateFid(credential.user!.uid);
      print(e.toString());
    }
  }
}
