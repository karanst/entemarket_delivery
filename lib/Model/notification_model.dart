
import 'package:entemarket_delivery/Helper/string.dart';
import 'package:intl/intl.dart';

class Notification_Model {
  String? id, title, desc, img, type_id, date;

  Notification_Model(
      {this.id, this.title, this.desc, this.img, this.type_id, this.date});

  factory Notification_Model.fromJson(Map<String, dynamic> json) {
    String date = json[DATE_SEND];

    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    return new Notification_Model(
        id: json[ID],
        title: json[TITLE],
        desc: json[MESSAGE],
        img: json[IMAGE],
        type_id: json[TYPE_ID],
        date: date);
  }
}
class EarningModel{
  String id,min_km,max_km,delivery_charge;

  EarningModel(this.id, this.min_km, this.max_km, this.delivery_charge);
}
