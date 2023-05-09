import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_tracking/repository/login_repository.dart';


import '../components/LoginScreenTopImage.dart';
import '../database/userDatabase.dart';
import '../model/token.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'constants.dart';

enum DialogState {
  LOADING,
  COMPLETED,
  DISMISSED,
}

class AddSSO extends StatefulWidget {
  @override
  State<AddSSO> createState() => _AddSSOState();
}

class _AddSSOState extends State<AddSSO> {
  Token? token;
  bool _isObscure = true;
  TextEditingController createbyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ssoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();

  String _selectedGender = 'SSO';
  var sampleList=[];
  final forenkey = GlobalKey<FormState>();

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
    UserDatabase.instance.getEmployee().then((result) {
      setState(() {
        token = result;
      });
    });
  }

  bool _isValid = false;

  void _saveForm() {
    setState(() {
      _isValid = forenkey.currentState!.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Image.asset("assets/images/login_bottom.png", width: 120),
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
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: Radio<String>(
                                    value: 'SSO',
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                      });
                                    },
                                  ),
                                  title: const Text('SSO'),
                                ),
                              ),
                              Expanded(
                                  child: ListTile(
                                leading: Radio<String>(
                                  value: 'BCO',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                                title: const Text('BCO'),
                              )),
                            ],
                          ),
                        ),
                        TextFieldContainer(
                          child: TextFormField(
                            controller: ssoController,
                            decoration: InputDecoration(
                              hintText: "Enter Order Number",
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child:
                                    Icon(Icons.ad_units, color: kPrimaryColor),
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
                            controller: customerNameController,
                            decoration: InputDecoration(
                              hintText: "Enter Customer Name",
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: Icon(Icons.person_outline,
                                    color: kPrimaryColor),
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
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Enter emailid",
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: Icon(Icons.mail, color: kPrimaryColor),
                              ),
                            ),
                            validator: (value) {
                              // Check if this field is empty
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }

                              // using regular expression
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return "Please enter a valid email address";
                              }

                              // the email is valid
                              return null;
                            },
                          ),
                        ),
                        TextFieldContainer(
                          child: TextFormField(
                            controller: createbyController,
                            decoration: InputDecoration(
                              hintText: "Create By",
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: Icon(Icons.person, color: kPrimaryColor),
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
                                    ? Icons.visibility
                                    : Icons.visibility_off),
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
                        _button(
                            context,
                            ssoController,
                            emailController,
                            createbyController,
                            passwordController,
                            customerNameController,
                            _selectedGender),
                        SizedBox(height: defaultPadding * 2),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _button(
      BuildContext context,
      TextEditingController ssonumber,
      TextEditingController emailid,
      TextEditingController createby,
      TextEditingController password,
      TextEditingController customername,
      String orderby) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      padding: EdgeInsets.only(bottom: defaultPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child:
        MaterialButton(
          onPressed: () {
            _saveForm();
            final form = forenkey.currentState;

            if (ActiveConnection == false) {
              _showDialog(context, "Internet is not connected",
                  "Please connect Internet ", "assets/images/waring.png");
            } else {
              if (emailid.text.isEmpty &&
                  createby.text.isEmpty &&
                  password.text.isEmpty &&
                  customername.text.isEmpty &&
                  ssonumber.text.isEmpty) {
                _showDialog(context, "Add SSO not Successful",
                    "Please Enter  All Value", "assets/images/waring.png");
              } else if (_isValid == false) {
                print('Invalid Email');
              } else {
                _showLoadingDialog(context, DialogState.LOADING);
                LoginRespository loginRespository = new LoginRespository();
                // _showLoadingDialog(context, DialogState.LOADING);
                loginRespository
                    .fetchAlbumAddSSO(ssonumber.text, customername.text,
                        emailid.text, capitalizeAllWord(createby.text), password.text, orderby)
                    .then((value) {
                  if (value != 3 && value != 0) {
                    UserDatabase.instance.getEmployee().then((data) {
                      _showLoadingDialog(context, DialogState.LOADING);
                      print(data);
                      token = data;
                     /* Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                  ssoNumber: data.ssoNumber,
                                  token: data.token)));*/


                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(
                          ssoNumber: data.ssoNumber,
                          token: data.token,
                        )),
                            (Route<dynamic> route) => false,
                      );
                    });
                  } else if (value == 3) {
                    Navigator.pop(context);
                    _showLoadingDialog(context, DialogState.DISMISSED);
                    /* _showDialog(context,
                      "SSO Number Already Existed",
                      "Please Enter Login using this SSO Number",
                        "assets/images/waring.png"
                    );*/
                  }
                });
              }
            }
          },
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: kPrimaryColor,
          child: Text(
            "Add Order",
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
                child: TextButton(
                // FlatButton(
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
                          child: Expanded(
                            child: Text(
                              "Add Order Number..",
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
