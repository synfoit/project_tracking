import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_tracking/model/token.dart';
import 'package:project_tracking/screen/dashborad.dart';

import '../components/LoginScreenTopImage.dart';
import '../database/userDatabase.dart';
import '../repository/login_repository.dart';

import 'HomeScreen.dart';
import 'add_sso.dart';
import 'constants.dart';

enum DialogState {
  LOADING,
  COMPLETED,
  DISMISSED,
}

class LoginScreen extends StatefulWidget {


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Token? token;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final forenkey = GlobalKey<FormState>();
  String _selectedGender = 'SSO';
  bool _isObscure = true;
  bool _validate = false;
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

  }
  bool _isValid = false;

  void _saveForm() {
    setState(() {
      _isValid = forenkey.currentState!.validate();
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/images/main_top.png",
                    width: 120,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child:
                      Image.asset("assets/images/login_bottom.png", width: 120),
                ),
                Form(
                  key: forenkey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        color: Colors.white,
                        borderOnForeground: true,
                        elevation: 10,
                        child: Column(
                          children: <Widget>[
                            const LoginScreenTopImage(),
                            TextFieldContainer(
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: "Enter Order Number",
                                  border: InputBorder.none,
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child:
                                        Icon(Icons.person, color: kPrimaryColor),
                                  ),
                                ),
                                validator: (value) {
                                  // Check if this field is empty
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                },
                              ),
                            ),
                            TextFieldContainer(
                              child: TextFormField(
                                obscureText: _isObscure,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText: "Enter Password",
                                  border: InputBorder.none,
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: Icon(Icons.lock, color: kPrimaryColor),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  // Check if this field is empty
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: defaultPadding),
                            _button(context, nameController, passwordController),
                            const SizedBox(height: defaultPadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't Have Order Number? "),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddSSO()));
                                    },
                                    child: const Text(
                                      "Add Order Number",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(height: defaultPadding * 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
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

  Widget _button(BuildContext context, TextEditingController nameController,
      TextEditingController passwordController) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: MaterialButton(
          onPressed: () {
            _saveForm();
            if (ActiveConnection == false) {
              _showDialog(context, "Internet is not connected",
                  "Please connect Internet ", "assets/images/waring.png");
            }
            else if (_isValid == false) {
              print('Enter Value');
            }
            else {
              if (nameController.text.isEmpty &&
                  nameController.text == null &&
                  passwordController.text.isEmpty &&
                  passwordController.text == null) {
                _showDialog(
                    context,
                    "User Name And password empty",
                    "Please Enter user name and password",
                    "assets/images/waring.png");
              } else {
                _showLoadingDialog(context, DialogState.LOADING);
                Future.delayed(Duration(seconds: 1));
                LoginRespository loginRespository = LoginRespository();
                loginRespository
                    .fetchAlbumLogindata(
                        nameController.text, passwordController.text)
                    .then((value) async {
                  if (value != 0) {
                    UserDatabase.instance.getUserData().then((value) {
                      if (value != 0) {
                        UserDatabase.instance.getEmployee().then((value) {
                          token = value;

                          if (value.ssoNumber.trim() == "Servilink") {
                            //Showing the progress dialog

                            //wait 5 seconds : just for testing purposes, you don't need to wait in a real scenario
                            /* Future.delayed(Duration(seconds: 5));
                          //call export data
                          MyDialog(state: DialogState.COMPLETED,);*/
                            //Pops the progress dialog
                            Navigator.pop(context);
                            //Shows the finished dialog
                           /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard(
                                        ssoNumber: value.ssoNumber,
                                        token: value.token)));*/


                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => DashBoard(
                                ssoNumber: value.ssoNumber,
                                token: value.token,
                              )),
                                  (Route<dynamic> route) => false,
                            );

                          } else {
                         /*   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ));*/

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen(
                                ssoNumber: value.ssoNumber,
                                token: value.token,
                              )),
                                  (Route<dynamic> route) => false,
                            );


                          }
                        });
                      }
                    });
                  } else {
                    _showDialog(
                        context,
                        "User Name And password worng",
                        "Please enter correct username and password",
                        "assets/images/waring.png");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                });
              }
            }
          },
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: kPrimaryColor,
          child: const Text(
            "LOGIN",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(
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

  Future<dynamic> _showLoadingDialog(BuildContext context, DialogState state) {
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
              height: 100.0,
              child: state == DialogState.LOADING
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Login...",
                            style: TextStyle(
                              fontFamily: "OpenSans",
                              color: Color(0xFF5B6978),
                            ),
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text('Data loaded with success'),
                    ),
            ),
          );
        });
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}

class SuccessfullDialog extends StatelessWidget {
  final String message, submessage;

  const SuccessfullDialog(
      {Key? key, required this.message, required this.submessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _showAlertDialog(context, message);
  }

  _showAlertDialog(BuildContext context, String msg) {
    // Create button
    Widget okButton = MaterialButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(msg),
      content: Text(submessage),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
