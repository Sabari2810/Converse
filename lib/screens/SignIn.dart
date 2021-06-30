import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat/services/Auth.dart';
import 'package:flutter_chat/utils/palette.dart';
import 'package:flutter_chat/utils/toast.dart';
import 'package:flutter_chat/widgets/Logo.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn({required this.toggle});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _email = "";
  String _password = "";

  late AuthUser _authUser;

  final GlobalKey<FormState> _signInKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _authUser = Provider.of<AuthUser>(context);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Logo(),
            SizedBox(
              height: 30,
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 25.0),
                  children: [
                    TextSpan(text: "Sign in to "),
                    TextSpan(
                      text: "Converse",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              key: _signInKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    validator: (val) => validateEmail(val!),
                    onChanged: (val) {
                      _signInKey.currentState!.validate();
                        _email = val;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Email"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    validator: (val) => validatePassword(val!),
                    onChanged: (val) {
                      _signInKey.currentState!.validate();
                        _password = val;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Password"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette().appBarColor,
              ),
              child: InkWell(
                onTap: () async {
                  if (_signInKey.currentState!.validate()) {
                    dynamic res =
                        await _authUser.sigInUsingEmail(_email, _password);
                    if (res.runtimeType == String) {
                      showToast(context, res);
                    } else if (res == null) {
                      showToast(context, "Something Went Wrong");
                    }
                  }
                },
                child: Text(
                  "Sign In",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                InkWell(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  dynamic validateEmail(String email) {
    if (email.length == 0) {
      return "Field cannot be empty";
    }
    return null;
  }

  dynamic validatePassword(String password) {
    if (password.length == 0) {
      return "Field cannot be empty";
    }
    return null;
  }
}
