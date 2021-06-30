import 'package:flutter/material.dart';
import 'package:flutter_chat/models/UserModel.dart';
import 'package:flutter_chat/services/Auth.dart';
import 'package:flutter_chat/utils/palette.dart';
import 'package:flutter_chat/utils/toast.dart';
import 'package:flutter_chat/widgets/Logo.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  final Function toggle;
  Register({required this.toggle});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _email = "";
  String _password = "";
  String _username = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AuthUser _authUser;
  
  @override
  Widget build(BuildContext context) {
    _authUser = Provider.of<AuthUser>(context);
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: Form(
            key: _formKey,
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
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign up with ",
                        ),
                        TextSpan(
                          text: "Converse",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      _username = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "User Name",
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      _email = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette().appBarColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      _password = val;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette().appBarColor,
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic res = _authUser
                            .registerUsingEmail(_username, _email, _password);
                        if (res == null) {
                          showToast(context, "Something Went Wrong");
                        }
                        if (res.runtimeType == String) {
                          showToast(context, res);
                        }
                        if (res.runtimeType == UserModel) {
                          showToast(context, "Registered Successfully");
                          widget.toggle();
                        }
                      }
                    },
                    child: Text("Register"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    InkWell(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
