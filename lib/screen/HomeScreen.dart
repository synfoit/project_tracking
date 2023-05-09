import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/userDatabase.dart';
import '../model/checklist.dart';
import '../model/token.dart';
import '../repository/login_repository.dart';
import 'LoginScreen.dart';
import 'constants.dart';

Token? userData;
Future<String>? customerName;
LoginRespository loginResposito = LoginRespository();

class HomeScreen extends StatefulWidget {
  String ssoNumber;
  String token;

  HomeScreen({Key? key, required this.ssoNumber, required this.token})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState(ssoNumber, token);
}

class _HomeScreenState extends State<HomeScreen> {
  bool? installation = false;
  bool? powerUpIOTesting = false;
  bool? loopCheckAndSystemType = false;
  bool? pilot = false;
  bool? handover = false;

  String ssoNumber;
  String? startDate;
  String token;
  Token? tDAta;
  String customerName = "customerName";
  String endDate = "";
  String? orderType;

  _HomeScreenState(this.ssoNumber, this.token);

  bool ActiveConnection = false;
  String T = "";

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    CheckUserConnection();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    UserDatabase.instance.getEmployee().then((value) {
      tDAta = value;
    });

    loginResposito.fetchAlbumProjectStep(ssoNumber, token).then((value) {
      setState(() {
        Checklist? list = value;
        installation = list!.installation;
        powerUpIOTesting = list.powerUpIOTesting;
        loopCheckAndSystemType = list.loopCheckAndSystemType;
        pilot = list.pilot;
        handover = list.handover;
        startDate = list.startDate.split('T')[0];
        customerName = list.customerName;
        orderType = list.orderType;
       /* try {
          if (list.endDate.isNotEmpty && list.endDate != null) {
            endDate = list.endDate.split('T')[0];
          }
        } catch (E) {}*/
      });

      //print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
        child: Scaffold(
          body: RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(ssoNumber: ssoNumber, token: token)));
                });
              },
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F4EF),
                  image: DecorationImage(
                    image: AssetImage(""),
                    alignment: Alignment.topRight,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  UserDatabase.instance.deleteUser(ssoNumber);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                  // do something
                                },
                              )
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Customer Name : ",
                                  style: TextStyle(
                                      color: kPrimaryColor.withOpacity(.5),
                                      decoration: TextDecoration.none,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text: capitalizeAllWord(customerName),
                                  style:
                                      kHeadingextStyle.copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Order Type : ",
                                  style: TextStyle(
                                      color: kPrimaryColor.withOpacity(.5),
                                      decoration: TextDecoration.none,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text: orderType,
                                  style:
                                      kHeadingextStyle.copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Order number : ",
                                  style: TextStyle(
                                      color: kPrimaryColor.withOpacity(.5),
                                      decoration: TextDecoration.none,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text: ssoNumber,
                                  style:
                                      kHeadingextStyle.copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Start Date : ",
                                  style: TextStyle(
                                      color: kPrimaryColor.withOpacity(.5),
                                      decoration: TextDecoration.none,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text: startDate,
                                  style:
                                      kHeadingextStyle.copyWith(fontSize: 20),
                                  //style: kHeadingextStyle.copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                         /* const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "End Date : ",
                                  style: TextStyle(
                                      color: kPrimaryColor.withOpacity(.5),
                                      decoration: TextDecoration.none,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text: endDate,
                                  style:
                                      kHeadingextStyle.copyWith(fontSize: 20),
                                  //style: kHeadingextStyle.copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text("Project Step",
                                        style: kTitleTextStyle),
                                    const SizedBox(height: 30),
                                    CourseContent(
                                      "01",
                                      "Installtion",
                                      installation!,
                                    ),
                                    CourseContent(
                                      '02',
                                      orderType == 'SSO'
                                          ? "Power up & I/O Testing"
                                          : "Commissioning",
                                      powerUpIOTesting!,
                                    ),
                                    CourseContent(
                                      '03',
                                      orderType == 'SSO'
                                          ? "Loopcheck & System Type"
                                          : "Testing And Loop Check",
                                      loopCheckAndSystemType!,
                                    ),
                                    CourseContent(
                                      '04',
                                      "Pilot",
                                      pilot!,
                                    ),
                                    CourseContent(
                                      '05',
                                      "Handover",
                                      handover!,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 4),
                                      blurRadius: 50,
                                      color: kTextColor.withOpacity(.1),
                                    ),
                                  ],
                                ),
                                child: Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (ActiveConnection == false) {
                                        _showLoadingDialog(
                                            context,
                                            "Internet is not connected",
                                            "Please connect Internet ",
                                            "assets/images/waring.png");
                                      } else {
                                        if (installation == true &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == false &&
                                            pilot == false &&
                                            handover == false) {
                                          loginResposito
                                              .fetchAlbumupdateProjectStep(
                                                  ssoNumber,
                                                  token,
                                                  installation,
                                                  powerUpIOTesting,
                                                  loopCheckAndSystemType,
                                                  pilot,
                                                  handover);
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is added ",
                                              "assets/images/sucess.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == false &&
                                            pilot == false &&
                                            handover == false) {
                                          loginResposito
                                              .fetchAlbumupdateProjectStep(
                                                  ssoNumber,
                                                  token,
                                                  installation,
                                                  powerUpIOTesting,
                                                  loopCheckAndSystemType,
                                                  pilot,
                                                  handover);
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is added ",
                                              "assets/images/sucess.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == true &&
                                            pilot == false &&
                                            handover == false) {

                                          loginResposito
                                              .fetchAlbumupdateProjectStep(
                                                  ssoNumber,
                                                  token,
                                                  installation,
                                                  powerUpIOTesting,
                                                  loopCheckAndSystemType,
                                                  pilot,
                                                  handover).then((value) {
                                                    if(value==200){

                                                      _showLoadingDialog(
                                                          context,
                                                          "Project Step",
                                                          "Project Step is added ",
                                                          "assets/images/sucess.png");
                                                    }

                                          });

                                        } else if (installation == true &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == true &&
                                            pilot == true &&
                                            handover == false) {
                                          loginResposito
                                              .fetchAlbumupdateProjectStep(
                                                  ssoNumber,
                                                  token,
                                                  installation,
                                                  powerUpIOTesting,
                                                  loopCheckAndSystemType,
                                                  pilot,
                                                  handover);
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is added ",
                                              "assets/images/sucess.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == true &&
                                            pilot == true &&
                                            handover == true) {
                                          _showLoadingDialog1(context,DialogState.LOADING);
                                          loginResposito
                                              .fetchAlbumupdateProjectStep(
                                                  ssoNumber,
                                                  token,
                                                  installation,
                                                  powerUpIOTesting,
                                                  loopCheckAndSystemType,
                                                  pilot,
                                                  handover).then((value) {
                                            if(value==200){
                                              Navigator.pop(context);
                                              _showLoadingDialog(
                                                  context,
                                                  "Project Step",
                                                  "Project Step is added ",
                                                  "assets/images/sucess.png");
                                            }

                                          });
                                        } else if (installation == false &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == false &&
                                            pilot == false &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == true &&
                                            pilot == true &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == false &&
                                            pilot == false &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == false &&
                                            pilot == false &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == false &&
                                            pilot == true &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == false &&
                                            pilot == true &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == false &&
                                            pilot == false &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == false &&
                                            pilot == true &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == true &&
                                            pilot == true &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == true &&
                                            pilot == false &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == false &&
                                            pilot == true &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == false &&
                                            pilot == true &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == true &&
                                            pilot == true &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == true &&
                                            pilot == true &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == true &&
                                            pilot == false &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == false &&
                                            pilot == false &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == true &&
                                            pilot == false &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == false &&
                                            pilot == true &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == true &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == false &&
                                            pilot == false &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == true &&
                                            pilot == false &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == true &&
                                            pilot == false &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == true &&
                                            pilot == false &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == true &&
                                            pilot == true &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == false &&
                                            pilot == true &&
                                            handover == false) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == false &&
                                            loopCheckAndSystemType == true &&
                                            pilot == false &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        } else if (installation == false &&
                                            powerUpIOTesting == true &&
                                            loopCheckAndSystemType == true &&
                                            pilot == false &&
                                            handover == true) {
                                          _showLoadingDialog(
                                              context,
                                              "Project Step",
                                              "Project Step is not in Sequence ",
                                              "assets/images/cancel.png");
                                        }
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: kPrimaryColor,
                                      ),
                                      child: Text(
                                        "Submit",
                                        style: kSubtitleTextSyule.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        onWillPop: showExitPopup);
  }

  CourseContent(String number, String title, bool isDone) {
    bool _isEnabled = isDone;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          Text(
            number,
            style: kHeadingextStyle.copyWith(
              color: kTextColor.withOpacity(.15),
              fontSize: 32,
            ),
          ),
          const SizedBox(width: 5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: kSubtitleTextSyule.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(left: 20),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kGreenColor.withOpacity(isDone ? .5 : 1),
            ),
            child: Checkbox(
              value: isDone,
              activeColor: kPrimaryColor,
              shape: const CircleBorder(),
              tristate: false,
              splashRadius: 30,
              onChanged: _isEnabled
                  ? null
                  : (bool? value) {
                      setState(() {
                        if (number == "01") {
                          installation = value;
                        } else if (number == "02") {
                          powerUpIOTesting = value;
                        } else if (number == "03") {
                          loopCheckAndSystemType = value;
                        } else if (number == "04") {
                          pilot = value;
                        } else if (number == "05") {
                          handover = value;
                        }
                      });
                    },
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> _showLoadingDialog(
      BuildContext context, String title, String subtitle, String image) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(padding),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox(context, title, subtitle, image),
          );
        });
  }

  contentBox(context, String title, String subtitle, String image) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      loginResposito
                          .fetchAlbumProjectStep(ssoNumber, token)
                          .then((value) {
                        setState(() {
                          Checklist? list = value;
                          installation = list!.installation;
                          powerUpIOTesting = list.powerUpIOTesting;
                          loopCheckAndSystemType = list.loopCheckAndSystemType;
                          pilot = list.pilot;
                          handover = list.handover;
                          startDate = list.startDate.split('T')[0];
                          customerName = list.customerName;
                          orderType = list.orderType;
                        /*  try {
                            if (list.endDate.isNotEmpty &&
                                list.endDate != null) {
                              endDate = list.endDate.split('T')[0];
                            }
                          } catch (E) {}*/
                        });

                        //print(value);
                      });

                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                  ssoNumber: ssoNumber, token: token)));
                    },
                    child: Text(
                      "ok",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset(image)),
          ),
        ),
      ],
    );
  }
  Future<dynamic> _showLoadingDialog1(BuildContext context, DialogState state) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            content: Container(
              width: 250.0,
              height: 150.0,
              child: state == DialogState.LOADING
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Expanded(
                      child: Text(
                        "All Step are completed",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          color: Color(0xFF5B6978),
                        ),
                      ),
                    ),
                  )
                ],
              )
                  : Center(
                child: Text('SSO Number Already Existed'),
              ),
            ),
          );
        });
  }

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }
}
