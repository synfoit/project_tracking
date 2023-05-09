import 'package:flutter/material.dart';

class Checklist {
  bool? installation;
  bool? powerUpIOTesting ;
  bool? loopCheckAndSystemType ;
  bool? pilot ;
  bool? handover;
  String startDate;
  String customerName;
  String orderType;

  Checklist(this.installation, this.powerUpIOTesting,this.loopCheckAndSystemType,this.pilot,this.handover,this.startDate,this.customerName,this.orderType);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'installation': installation,
      'powerUpIOTesting': powerUpIOTesting,
      'loopCheckAndSystemType':loopCheckAndSystemType,
      'pilot':pilot,
      'handover':handover,
      'startDate':startDate,
      'customerName':customerName,

      'orderType' :orderType
    };
    return map;
  }

  factory Checklist.fromMap(Map data) {
    return Checklist(
      data["installation"] as bool,
      data["powerUpIOTesting"] as bool,
      data["loopCheckAndSystemType"] as bool,
      data["pilot"] as bool,
      data["handover"] as bool,
      data["startDate"] as String,
      data["customerName"] as String,

      data["orderType"] as String


    );
  }






}