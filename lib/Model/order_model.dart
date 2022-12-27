import 'package:entemarket_delivery/Helper/string.dart';
import 'package:intl/intl.dart';

class Order_Model {
  String? id,
      name,
      mobile,
      latitude,
      longitude,
      delCharge,
      walBal,
      promo,
      promoDis,
      payMethod,
      total,
      subTotal,
      payable,
      address,
      taxAmt,
      taxPer,
      orderDate,
      dateTime,
      isCancleable,
      isReturnable,
      isAlrCancelled,
      isAlrReturned,
      rtnReqSubmitted,
      activeStatus,
      otp,
      deliveryBoyId,
      invoice,
      delDate,
      delTime,username,userfuid,useremail,userfcm_id,userlatitude,userlongitude,
      sellerlatitude,sellerlogtitude,timeData,earning,selleraddres,useraddress,sellername,sellerfcm,selleremail,sellerfuid,accept_reject_driver;

  List<OrderItem>? itemList;
  List<String?>? listStatus = [];
  List<String?>? listDate = [];

  Order_Model({
    this.id,
    this.accept_reject_driver,
    this.name,
    this.mobile,
    this.delCharge,
    this.walBal,
    this.promo,
    this.promoDis,
    this.payMethod,
    this.total,
    this.subTotal,
    this.payable,
    this.address,
    this.taxPer,
    this.taxAmt,
    this.orderDate,
    this.dateTime,
    this.itemList,
    this.listStatus,
    this.listDate,
    this.isReturnable,
    this.isCancleable,
    this.isAlrCancelled,
    this.isAlrReturned,
    this.rtnReqSubmitted,
    this.activeStatus,
    this.otp,
    this.invoice,
    this.latitude,
    this.longitude,
    this.delDate,
    this.delTime,
    this.deliveryBoyId,
    this.username,
    this.earning,
    this.selleraddres,
    this.useraddress,
    this.useremail,this.userfcm_id,this.sellername,this.sellerfuid,this.selleremail,this.sellerfcm,this.userfuid,this.userlatitude,this.userlongitude,this.sellerlatitude,this.sellerlogtitude,this.timeData
  });

  factory Order_Model.fromJson(Map<String, dynamic> parsedJson) {
    List<OrderItem> itemList = [];
    var order = (parsedJson[ORDER_ITEMS] as List?);
    // if (order == null || order.isEmpty)
    //   return null;
    // else
    itemList = order!.map((data) => OrderItem.fromJson(data)).toList();
    String date = parsedJson[DATE_ADDED];
    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    List<String?> lStatus = [];
    List<String?> lDate = [];

    itemList.forEach((element) {
      element.listStatus!.forEach((element) {
        lStatus.add(element);
      });
      element.listDate!.forEach((element) {
        lDate.add(element);
      });
    });

    // var allSttus = parsedJson[STATUS];
    // for (var curStatus in allSttus) {
    //   lStatus.add(curStatus[0]);
    //   lDate.add(curStatus[1]);
    // }
    return Order_Model(
        id: parsedJson[ID],
        name: parsedJson[USERNAME],
        mobile: parsedJson[MOBILE],
        delCharge: parsedJson[DEL_CHARGE],
        accept_reject_driver: parsedJson['accept_reject_driver'],
        walBal: parsedJson[WAL_BAL],
        promo: parsedJson[PROMOCODE],
        promoDis: parsedJson[PROMO_DIS],
        payMethod: parsedJson[PAYMENT_METHOD],
        total: parsedJson[FINAL_TOTAL],
        subTotal: parsedJson[TOTAL],
        payable: parsedJson[TOTAL_PAYABLE],
        address: parsedJson[ADDRESS],
        taxAmt: parsedJson[TOTAL_TAX_AMT],
        taxPer: parsedJson[TOTAL_TAX_PER],
        dateTime: parsedJson[DATE_ADDED],
        userfcm_id: parsedJson['userfcm_id'],
        userfuid: parsedJson['userfuid'],
        useremail: parsedJson['useremail'],
        username: parsedJson['username'],
        selleremail: parsedJson["selleremail"],
        sellerfcm: parsedJson["sellerfcm"],
        sellerfuid: parsedJson["sellerfuid"],
        sellername: parsedJson["sellername"],
        isCancleable: parsedJson[ISCANCLEABLE],
        isReturnable: parsedJson[ISRETURNABLE],
        isAlrCancelled: parsedJson[ISALRCANCLE],
        isAlrReturned: parsedJson[ISALRRETURN],
        rtnReqSubmitted: parsedJson[ISRTNREQSUBMITTED],
        userlatitude: parsedJson["userlatitude"],
        userlongitude: parsedJson["userlongitude"],
        sellerlatitude: parsedJson["sellerlatitude"],
        sellerlogtitude: parsedJson["sellerlogtitude"],
        useraddress: parsedJson["useraddress"],
        selleraddres: parsedJson["selleraddres"],
        orderDate: date,
        itemList: itemList,
        listStatus: lStatus,
        listDate: lDate,
        timeData:  "",
        earning:  "",
        activeStatus: parsedJson[ACTIVE_STATUS],
        otp: parsedJson[OTP],
        latitude: parsedJson[LATITUDE],
        longitude: parsedJson[LONGITUDE],
        delDate: parsedJson[DEL_DATE] != null
            ? DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(parsedJson[DEL_DATE]))
            : '',
        delTime: parsedJson[DEL_TIME] != null ? parsedJson[DEL_TIME] : '',
        deliveryBoyId: parsedJson[DELIVERY_BOY_ID]);
  }
}

class OrderItem {
  String? id,
      name,
      qty,
      price,
      subTotal,
      status,
      image,
      varientId,
      isCancle,
      isReturn,
      isAlrCancelled,
      isAlrReturned,
      rtnReqSubmitted,
      varient_values,
      attr_name,
      productId,
      item_otp,
      curSelected,
      sellerName,
      sellerMobileNumber,
      storeName,
      sellerAddress,
      storeLatitude,
      storeLongitude,
      accept_reject_driver,
      storeImage;

  List<String?>? listStatus = [];
  List<String?>? listDate = [];

  OrderItem(
      {this.qty,
        this.id,
        this.name,
        this.accept_reject_driver,
        this.price,
        this.subTotal,
        this.status,
        this.image,
        this.varientId,
        this.listDate,
        this.listStatus,
        this.isCancle,
        this.isReturn,
        this.isAlrReturned,
        this.isAlrCancelled,
        this.rtnReqSubmitted,
        this.attr_name,
        this.productId,
        this.varient_values,
        this.item_otp,
        this.curSelected,
        this.sellerName,
        this.storeName,
        this.sellerMobileNumber,
        this.sellerAddress,
        this.storeLatitude,
        this.storeLongitude,
        this.storeImage});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    List<String?> lStatus = [];
    List<String?> lDate = [];

    var allSttus = json[STATUS];
    for (var curStatus in allSttus) {
      lStatus.add(curStatus[0]);
      lDate.add(curStatus[1]);
    }
    return OrderItem(
        id: json[ID],
        qty: json[QUANTITY],
        name: json[NAME],
        image: json[IMAGE],
        accept_reject_driver: json['accept_reject_driver'],
        price: json[PRICE],
        subTotal: json[SUB_TOTAL],
        varientId: json[PRODUCT_VARIENT_ID],
        listStatus: lStatus,
        status: json[ACTIVE_STATUS],
        curSelected: json[ACTIVE_STATUS],
        listDate: lDate,
        isCancle: json[ISCANCLEABLE],
        isReturn: json[ISRETURNABLE],
        isAlrCancelled: json[ISALRCANCLE],
        isAlrReturned: json[ISALRRETURN],
        rtnReqSubmitted: json[ISRTNREQSUBMITTED],
        attr_name: json[ATTR_NAME],
        productId: json[PRODUCT_ID],
        item_otp: json[OTP],
        varient_values: json[VARIENT_VALUE],
        sellerName: json[SELLER_NAME],
        storeName: json[STORE_NAME],
        sellerAddress: json[SELLER_ADDRESS],
        storeLatitude: json[STORE_LATITUDE],
        storeLongitude: json[STORE_LONGITUDE],
        storeImage: json[STORE_IMAGE],
        sellerMobileNumber: json[SELLER_MOB_NUM]);
  }
}
