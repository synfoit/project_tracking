import 'dart:math';
import 'dart:ui';

import '../confing/server_Ip.dart';
import '../database/userDatabase.dart';
import '../model/checklist.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginRespository {
  Future<dynamic> fetchAlbumLogindata(String userid, String password) async {
    final http.Response response = await http.post(
      Uri.parse(ServerIp.serverip + 'generate-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': userid, 'password': password}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      var result =
          UserDatabase.instance.insertUser(jsonResponse['token'], userid);
      return result;
    } else {
      return 0;
    }
  }

  Future<dynamic> fetchAlbumAddSSO(String ssonumber, String customerName,
      String email_id, String createBy, String password, String orderBy) async {
    final http.Response response = await http.post(
      Uri.parse(ServerIp.serverip + 'user/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': ssonumber,
        'password': password,
        'email': email_id,
        'createdBy': createBy,
        'customerName': customerName,
        'orderType': orderBy
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 200) {
        final http.Response responselogin = await http.post(
          Uri.parse(ServerIp.serverip + 'generate-token'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'username': ssonumber, 'password': password}),
        );

        if (responselogin.statusCode == 200) {
          var jsonloginResponse = json.decode(responselogin.body);
          var loginresult = UserDatabase.instance
              .insertUser(jsonloginResponse['token'], ssonumber);
          return loginresult;
        } else {
          return 0;
        }
      } else if (jsonResponse['status'] == 404) {
        return 3;
      }
    } else {
      return 0;
    }
  }

  Future<String> fetchAlbumcustomerData(String ssonumber, String token) async {
    Map data = {
      'username': ssonumber,
    };

    final http.Response response =
        await http.post(Uri.parse(ServerIp.serverip + 'user/getCustomer'),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
            },
            body: data);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      return jsonResponse["customerName"];
    } else {
      return "";
    }
  }

  Future<int> fetchAlbumTotalProject(String ssonumber, String token) async {
    final http.Response response = await http.get(
      Uri.parse(ServerIp.serverip + 'user/getAllDetails'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      return jsonResponse.length;
    } else {
      return 0;
    }
  }

  Future<dynamic> fetchAlbumCompleteProject(
      String ssonumber, String token) async {
    final http.Response response = await http.get(
      Uri.parse(ServerIp.serverip + 'user/getCompletedProject'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      return jsonResponse;
    } else {
      return 0;
    }
  }

  Future<dynamic> fetchAlbumIncompleteProject(
      String ssonumber, String token) async {
    final http.Response response = await http.get(
      Uri.parse(ServerIp.serverip + 'user/getInProgressProject'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      return jsonResponse;
    } else {
      return 0;
    }
  }


  Future<int> fetchAlbumgetAllOrderType(String orderType, String token) async {
    Map data = {
      'orderType': orderType,
    };
    final http.Response response = await http.post(
      Uri.parse(ServerIp.serverip + 'user/getAllOrderType'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      }, body: data
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print("data$jsonResponse.length");
      return jsonResponse["projectStepsList"].length;
    } else {
      return 0;
    }
  }

  Future<dynamic> fetchAlbumgetCompleteOrderType(
      String orderType, String token) async {
    Map data = {
      'orderType': orderType,
    };
    final http.Response response = await http.post(
      Uri.parse(ServerIp.serverip + 'user/getCompleteOrderType'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      }, body: data
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      return jsonResponse;
    } else {
      return 0;
    }
  }

  Future<dynamic> fetchAlbumgetInProgressOrderTypet(
      String orderType, String token) async {
    Map data = {
      'orderType': orderType,
    };
    final http.Response response = await http.post(
      Uri.parse(ServerIp.serverip + 'user/getInProgressOrderType'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      }, body: data
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      return jsonResponse;
    } else {
      return 0;
    }
  }


  Future<List<ChartBarData>?> fetchAlbumMonthlist(
      String orderType, String token, String month) async {
    Map data = {"mondate": month};
    final http.Response response = await http.post(
        Uri.parse(ServerIp.serverip + 'user/getDataOfMonthAndYear'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: data);

    final List<ChartBarData> chartData = [];
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if(orderType=="All"){
      for (int i = 0; i < jsonResponse.length; i++) {
        Color? color;
        if (jsonResponse[i]["progress"] == 20) {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFF5252));

          chartData.add(chartBarData);
          color = Color(0xff000054);
        }
        else if (jsonResponse[i]["progress"] == 40) {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFF5252));

          chartData.add(chartBarData);
        }
        else if (jsonResponse[i]["progress"] == 60) {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFFFF00));

          chartData.add(chartBarData);
        }
        else if (jsonResponse[i]["progress"] == 80) {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFFFF00));

          chartData.add(chartBarData);
        }
        else if (jsonResponse[i]["progress"] == 100) {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFF69F0AE));
          chartData.add(chartBarData);
        }
      }}
      else if(orderType=="SSO"){
      for (int i = 0; i < jsonResponse.length; i++) {
        Color? color;
        if (jsonResponse[i]["progress"] == 20 && jsonResponse[i]["orderType"]=="SSO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFF5252));

          chartData.add(chartBarData);
          color = Color(0xff000054);
        }
        else if (jsonResponse[i]["progress"] == 40 && jsonResponse[i]["orderType"]=="SSO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFF5252));

          chartData.add(chartBarData);
        }
        else if (jsonResponse[i]["progress"] == 60 && jsonResponse[i]["orderType"]=="SSO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFFFF00));

          chartData.add(chartBarData);
        }
        else if (jsonResponse[i]["progress"] == 80 && jsonResponse[i]["orderType"]=="SSO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFFFF00));

          chartData.add(chartBarData);
        }
        else if (jsonResponse[i]["progress"] == 100 && jsonResponse[i]["orderType"]=="SSO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFF69F0AE));
          chartData.add(chartBarData);
        }
      }}
      else if(orderType=="BCO"){
      for (int i = 0; i < jsonResponse.length; i++) {
        Color? color;
        if (jsonResponse[i]["progress"] == 20 && jsonResponse[i]["orderType"]=="BCO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFF5252));

          chartData.add(chartBarData);
          color = Color(0xff000054);
        }
        else if (jsonResponse[i]["progress"] == 40 && jsonResponse[i]["orderType"]=="BCO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFF5252));

          chartData.add(chartBarData);
        }
        else if (jsonResponse[i]["progress"] == 60 && jsonResponse[i]["orderType"]=="BCO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFFFF00));

          chartData.add(chartBarData);
        }
        else if (jsonResponse[i]["progress"] == 80 && jsonResponse[i]["orderType"]=="BCO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFFFFFF00));

          chartData.add(chartBarData);
        }
        else if (jsonResponse[i]["progress"] == 100 && jsonResponse[i]["orderType"]=="BCO") {
          ChartBarData chartBarData = ChartBarData(jsonResponse[i]["username"],
              jsonResponse[i]["progress"], Color(0xFF69F0AE));
          chartData.add(chartBarData);
        }
      }}
      return chartData;
    }
  }

  Future<Checklist?> fetchAlbumProjectStep(
      String ssonumber, String token) async {
    Map data = {
      'username': ssonumber,
    };

    final http.Response response =
        await http.post(Uri.parse(ServerIp.serverip + 'user/getProjectStep'),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
            },
            body: data);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Checklist checklist = new Checklist(
        data["installation"],
        data["powerUpIOTesting"],
        data["loopCheckAndSystemType"],
        data["pilot"],
        data["handover"],
        data["startDate"],
        data["customerName"],
        data["orderType"]
      );

      return checklist;
    } else {
      return null;
    }
  }

  Future<int> fetchAlbumupdateProjectStep(
      String ssonumber,
      String token,
      bool? installation,
      bool? powerUpIOTesting,
      bool? loopCheckAndSystemType,
      bool? pilot,
      bool? handover) async {
    print(ssonumber + token);

    Map data = {
      "installation": installation,
      "powerUpIOTesting": powerUpIOTesting,
      "loopCheckAndSystemType": loopCheckAndSystemType,
      "pilot": pilot,
      "handover": handover,
      "username": ssonumber
    };

    final http.Response response = await http.put(
      Uri.parse(ServerIp.serverip + 'user/updateProjectStep'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse["status"];
    } else {
      return 0;
    }
  }
}

class ChartBarData {
  final String projectName;
  final int progress;
  Color color;

  ChartBarData(this.projectName, this.progress, this.color);
}
