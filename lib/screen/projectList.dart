

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../confing/server_Ip.dart';
import '../model/Project.dart';

Future<List<Project>> fetchDataReporting(String username) async {
  String url =ServerIp.serverip+
      "user/" + username;
  String userList = username;

  final responseleaddata = await http.get(Uri.parse(url));
  if (responseleaddata.statusCode == 200) {
    final List<dynamic> jsonResponsedata = json.decode(responseleaddata.body);


    var value = jsonResponsedata
        .map((dynamic i) => LeadData.fromJson(i as Map<String, dynamic>))
        .toList();

    return null;
  }
}
class ProjectList extends StatefulWidget {
  String ssoNumber;
  String token;

  ProjectList({Key? key, required this.ssoNumber, required this.token})
      : super(key: key);

  @override
  State<ProjectList> createState() => _ProjectListState(ssoNumber, token);
}

class _ProjectListState extends State<ProjectList> {
  String ssoNumber;
  String token;
  _ProjectListState(this.ssoNumber, this.token);
  @override
  Widget build(BuildContext context) {
    return  _buildBody(context, ssoNumber);
  }
  FutureBuilder<List<Project>> _buildBody(
      BuildContext context, String userName) {
    return FutureBuilder<List<Project>>(
      future: fetchDataReporting(userName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<Project> posts = snapshot.data;
          return _buildPosts(context, posts);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
