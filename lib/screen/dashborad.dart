import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:project_tracking/widgets/totalproject.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../database/userDatabase.dart';
import '../repository/login_repository.dart';
import '../widgets/compelte_project_table.dart';
import '../widgets/info_card.dart';

import 'Incompelted_project.dart';
import 'LoginScreen.dart';
import 'constants.dart';

late TooltipBehavior _tooltipBehavior, _tooltipBehavior1;
final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM');

enum Options { search, upload, copy, exit }

class DashBoard extends StatefulWidget {
  String ssoNumber;
  String token;

  DashBoard({Key? key, required this.ssoNumber, required this.token})
      : super(key: key);

  @override
  State<DashBoard> createState() => _DashboardState(ssoNumber, token);
}

class _DashboardState extends State<DashBoard> {
  var _popupMenuItemIndex = 0;
  Color _changeColorAccordingToMenuItem = Colors.red;
  String ssoNumber;
  String token;
  String orderType = "All";
  int totalproject = 0;
  int compete = 0;
  int incompete = 0;
  var completedlist;
  var incompletedlist;

  String monthselect = formatter.format(DateTime.now());
  String? monthofYear;

  late List<ChartData> chartData;

  _DashboardState(this.ssoNumber, this.token);

  LoginRespository loginResposito = new LoginRespository();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior1 = TooltipBehavior(enable: true);
    loginResposito.fetchAlbumTotalProject(orderType, token).then((value) {
      setState(() {
        totalproject = value;
      });
    });

    loginResposito.fetchAlbumCompleteProject(orderType, token).then((value) {
      setState(() {
        compete = value["projectStepsList"].length;
        completedlist = value["projectStepsList"];
      });
    });

    loginResposito.fetchAlbumIncompleteProject(orderType, token).then((value) {
      setState(() {
        incompete = value["projectStepsList"].length;
        incompletedlist = value["projectStepsList"];
      });
    });
    monthofYear = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: buildAppBar(context),
          body: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1), () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DashBoard(ssoNumber: ssoNumber, token: token)));
              });
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.03),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        // _buildTotalBody(context),
                        InfoCardt(
                          "Total",
                          totalproject,
                          Color(0xFFFF8C00),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: InfoCard(
                                "Completed",
                                compete,
                                Color(0xFF50E3C2),
                                completedlist,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return CompletedProjectTable(
                                            listdata: completedlist,
                                            listTitle: "Completed Project",
                                            ssoNumber: ssoNumber,
                                            token: token,
                                            days: "compilation Days");
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: InfoCard(
                              "In Progress",
                              incompete,
                              Color(0xFF5856D6),
                              incompletedlist,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return InCompletedProjectTable(
                                          listdata: incompletedlist,
                                          listTitle: "In Progress Project",
                                          ssoNumber: ssoNumber,
                                          token: token,
                                          days: " Working Days");
                                    },
                                  ),
                                );
                              },
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(height: 30),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 5.0,
                                    right: 5.0),
                                decoration: BoxDecoration(color: Colors.white),
                                child: Row(
                                  children: [
                                    Text(
                                      "Project Tracking",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Spacer(),
                                    FloatingActionButton.extended(
                                      onPressed: () async {
                                        var month = await SimpleMonthYearPicker
                                            .showMonthYearPickerDialog(
                                          context: context,
                                          barrierDismissible: true,
                                        );

                                        final String formatted =
                                            formatter.format(month);
                                        print(formatted);
                                        //_buildBody(context,formatted);
                                        setState(() {
                                          monthselect = formatted;
                                          monthofYear = formatted;
                                        });
                                      },
                                      label: Text(monthselect),
                                      icon: Icon(Icons.date_range),
                                    ),
                                  ],
                                ),
                              ),

                              _buildBodybar(context, monthofYear!),
                              SizedBox(height: 20),
                              //SafeArea(child: )
                              _buildBody(context)
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: showExitPopup);
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  FutureBuilder<List<ChartBarData>?> _buildBodybar(
      BuildContext context, String monthdate) {
    return FutureBuilder<List<ChartBarData>?>(
      future: loginResposito.fetchAlbumMonthlist(orderType, token, monthdate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<ChartBarData>? posts = snapshot.data;
          return _buildbarCharts(context, posts!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _buildbarCharts(BuildContext context, List<ChartBarData> posts) {
    /*   return SfCartesianChart(
      backgroundColor: Colors.white,
      tooltipBehavior: _tooltipBehavior,

      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<ChartBarData, String>(
          name: 'Project Process',
          dataSource: posts,
          xValueMapper: (ChartBarData data, _) => data.projectName,
          yValueMapper: (ChartBarData data, _) => data.progress,


        ),
      ],
      // ),
    );*/

    /* return SafeArea(
      child: SfCartesianChart(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        backgroundColor: Colors.white,
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}%',
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(size: 0)),
        series: <ChartSeries<ChartBarData, String>>[
          BarSeries<ChartBarData, String>(
            onCreateRenderer: (ChartSeries<ChartBarData, String> series) {
              return _CustomColumnSeriesRenderer(series);
            },
            dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.middle),
            dataSource: posts,
            width: 0.8,
            xValueMapper: (ChartBarData data, _) => data.projectName,
            yValueMapper: (ChartBarData data, _) => data.progress,
          )
        ],
      ),
    );*/

    return SafeArea(
      child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          backgroundColor: Colors.white,
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            labelRotation: -45,
            labelAlignment: LabelAlignment.start,
          ),
          primaryYAxis: NumericAxis(
              labelFormat: '{value}%',
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 0)),
          series: <CartesianSeries>[
            ColumnSeries<ChartBarData, String>(
                dataSource: posts,
                xValueMapper: (ChartBarData data, _) => data.projectName,
                yValueMapper: (ChartBarData data, _) => data.progress,
                // Map color for each data points from the data source
                pointColorMapper: (ChartBarData data, _) => data.color,
                enableTooltip: true)
          ]),
    );
  }

  FutureBuilder<List<ChartData>> _buildBody(BuildContext context) {
    return FutureBuilder<List<ChartData>>(
      future: fetchAlbupiechart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<ChartData>? posts = snapshot.data;
          return _buildCharts(context, posts!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _buildCharts(BuildContext context, List<ChartData>? posts) {
    return SfCircularChart(
      backgroundColor: Colors.white,
      title: ChartTitle(text: 'Project Radio'),
      tooltipBehavior: _tooltipBehavior1,
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
            dataSource: posts!,
            xValueMapper: (ChartData data, _) => data.name,
            yValueMapper: (ChartData data, _) => data.percent,
            pointColorMapper: (ChartData data, _) => data.color,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true)
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor.withOpacity(.03),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.logout,
          color: Colors.black,
        ),
        onPressed: () {
          UserDatabase.instance.deleteUser(ssoNumber);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
          // do something
        },
      ),
      actions: <Widget>[
        PopupMenuButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onSelected: (value) {
            _onMenuItemSelected(value as int);
          },
          itemBuilder: (ctx) => [
            _buildPopupMenuItem('All', Icons.all_inbox, Options.search.index),
            _buildPopupMenuItem(
                'SSO', Icons.file_present, Options.upload.index),
            _buildPopupMenuItem('BCO', Icons.offline_share, Options.copy.index),

          ],
        )
      ],
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          SizedBox(
            width: 10,
          ),
          Text(title),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value) {
    setState(() {
      _popupMenuItemIndex = value;
      if (value == 0) {
        orderType = "All";
        loginResposito.fetchAlbumTotalProject(orderType, token).then((value) {
          setState(() {
            totalproject = value;
          });
        });

        loginResposito.fetchAlbumCompleteProject(orderType, token).then((value) {
          setState(() {
            compete = value["projectStepsList"].length;
            completedlist = value["projectStepsList"];
          });
        });

        loginResposito.fetchAlbumIncompleteProject(orderType, token).then((value) {
          setState(() {
            incompete = value["projectStepsList"].length;
            incompletedlist = value["projectStepsList"];
          });
        });
      } else if (value == 1) {
        orderType = "SSO";
        loginResposito.fetchAlbumgetAllOrderType(orderType, token).then((value) {
          setState(() {
            totalproject = value;
          });
        });

        loginResposito.fetchAlbumgetCompleteOrderType(orderType, token).then((value) {
          setState(() {
            compete = value["projectStepsList"].length;
            completedlist = value["projectStepsList"];
          });
        });

        loginResposito.fetchAlbumgetInProgressOrderTypet(orderType, token).then((value) {
          setState(() {
            incompete = value["projectStepsList"].length;
            incompletedlist = value["projectStepsList"];
          });
        });
      } else if (value == 2) {
        orderType = "BCO";
        loginResposito.fetchAlbumgetAllOrderType(orderType, token).then((value) {
          setState(() {
            totalproject = value;
          });
        });

        loginResposito.fetchAlbumgetCompleteOrderType(orderType, token).then((value) {
          setState(() {
            compete = value["projectStepsList"].length;
            completedlist = value["projectStepsList"];
          });
        });

        loginResposito.fetchAlbumgetInProgressOrderTypet(orderType, token).then((value) {
          setState(() {
            incompete = value["projectStepsList"].length;
            incompletedlist = value["projectStepsList"];
          });
        });
      }
    });
  }

  Future<List<ChartData>> fetchAlbupiechart() async {
    double CompletedPer = ((100 * compete) / totalproject);
    double InCompletedPer = 100 - CompletedPer;

    String inString = CompletedPer.toStringAsFixed(2);
    double inDouble = double.parse(inString);

    String inString1 = InCompletedPer.toStringAsFixed(2);
    double inDouble1 = double.parse(inString1);

    final List<ChartData> chartData = [
      ChartData("Complete Project", inDouble, Color(0xFF69F0AE)),
      ChartData("In-Complete Project", inDouble1, Color(0xFFFF5252))
    ];
    return chartData;
  }

  FutureBuilder<int> _buildTotalBody(BuildContext context) {
    return FutureBuilder<int>(
      future: loginResposito.fetchAlbumTotalProject(ssoNumber, token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final int? posts = snapshot.data;
          return _buildTotalProject(context, posts!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _buildTotalProject(BuildContext context, int number) {
    return InfoCardt(
      "Total",
      number,
      Color(0xFFFF8C00),
    );
  }
/*FutureBuilder<String> _buildCompletedBody(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchAlbupiechart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final String posts = snapshot.data;
          return _buildCharts(context, posts!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  FutureBuilder<String> _buildIncompletedBody(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchAlbupiechart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final String posts = snapshot.data;
          return _buildCharts(context, posts!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }*/
}

class ChartData {
  final String name;
  final double percent;
  Color color;

  ChartData(this.name, this.percent, this.color);
}
