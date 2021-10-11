import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/models/http_exception.dart';
import 'package:shop_flutter_app/providers/auth.dart';

class authscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.deepOrange.withOpacity(0.5),
              Colors.amber.withOpacity(0.9)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          SingleChildScrollView(
            child: Container(
              height: devicesize.height,
              width: devicesize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                          transform: Matrix4.rotationZ(-8 * pi / 180)
                            ..translate(-10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.pink,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black26,
                                    offset: Offset(0, 2))
                              ]),
                          margin: EdgeInsets.only(bottom: 20),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                          child: Text(
                            "my shop",
                            style: TextStyle(
                              fontFamily: 'Anton',
                              fontSize: 50,
                              color: Colors.white,
                            ),
                          ))),
                  Flexible(
                    flex: devicesize.width > 600 ? 2 : 1,
                    child: authcard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class authcard extends StatefulWidget {
  const authcard({Key? key}) : super(key: key);

  @override
  _authcardState createState() => _authcardState();
}

enum authmode {
  signin,
  signup,
}

class _authcardState extends State<authcard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> keyform = GlobalKey();
  var _authmode = authmode.signin;
  Map<String, String> authmap = {'email': '', 'password': ''};
  var passwordcontroller = TextEditingController();
  var isloading = false;
  late AnimationController _animatedController;
  late Animation<Offset> slideanimation;
  late Animation<double> opacityanimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animatedController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    slideanimation = Tween<Offset>(
      begin: Offset(0, -0.15),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
        parent: _animatedController, curve: Curves.fastOutSlowIn));
    opacityanimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _animatedController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animatedController.dispose();
  }

  Future<void> submit() async {
    if (!keyform.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    keyform.currentState!.save();

    setState(() {
      isloading = true;
    });
    try {
      if (_authmode == authmode.signin) {
        await Provider.of<auth>(context, listen: false)
            .signin(authmap['email'] as String, authmap['password'] as String);
      }
      if (_authmode == authmode.signup) {
        await Provider.of<auth>(context, listen: false)
            .signup(authmap['email'] as String, authmap['password'] as String);
      }
    } on httpexception catch (error) {
      var errormessage = "Authentication failed";
      if (error.toString().contains("EMAIL_EXISTS")) {
        errormessage = "this email address is already in use.";
      }
      if (error.toString().contains("INVALID_EMAIL")) {
        errormessage = "this is not avalid email address.";
      }
      if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errormessage = "couldn't find a user with that email address.";
      }
      if (error.toString().contains("WEAK_PASSWORD")) {
        errormessage = "this password is too weak.";
      }
      if (error.toString().contains("INVALID_PASSWORD")) {
        errormessage = "invalid password.";
      }
      showerrormessage(error.toString());
    } catch (error) {
      const errormessage = "could not authenticate you please try again later";
    showerrormessage(errormessage);
    }

    setState(() {
      isloading = false;
    });
  }

  void switchauthmode() {
    if (_authmode == authmode.signin) {
      setState(() {
        _authmode = authmode.signup;
      });
      _animatedController.forward();
    } else {
      setState(() {
        _authmode = authmode.signin;
      });
      _animatedController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _authmode == authmode.signup ? 320 : 260,
          constraints: BoxConstraints(
              minHeight: _authmode == authmode.signup ? 320 : 260),
          width: devicesize.width * 0.75,
          padding: EdgeInsets.all(16),
          child: Form(
            key: keyform,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty || !val.contains("@")) {
                        return ("invalid email");
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        authmap['email'] = val!;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'password',
                    ),
                    obscureText: true,
                    controller: passwordcontroller,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 7) {
                        return ("please enter password at least 7 characters");
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        authmap['password'] = val!;
                      });
                    },
                  ),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight: _authmode == authmode.signup ? 60 : 0,
                      maxHeight: _authmode == authmode.signup ? 120 : 0,
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: opacityanimation,
                      child: SlideTransition(
                        position: slideanimation,
                        child: TextFormField(
                            obscureText: true,
                            enabled: _authmode == authmode.signup,
                            decoration:
                                InputDecoration(labelText: 'confirm password'),
                            validator: _authmode == authmode.signup
                                ? (val) {
                                    if (val != passwordcontroller.text) {
                                      return ("password not match! ");
                                    }
                                  }
                                : null),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (isloading) CircularProgressIndicator(),
                  RaisedButton(
                    child: Text(
                        _authmode == authmode.signup ? 'sign up' : 'signin'),
                    onPressed: submit,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    color: Colors.pink,
                    textColor: Colors.white,
                  ),
                  FlatButton(
                    onPressed: switchauthmode,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(_authmode == authmode.signup
                        ? 'switching to signin'
                        : 'switching to sign up'),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                    textColor: Colors.pink,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void showerrormessage(errormessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("an error occurred!"),
              content: Text(errormessage),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text("okey!"))
              ],
            ));
  }
}
