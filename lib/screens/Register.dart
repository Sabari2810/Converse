import 'package:flutter/material.dart';
import 'package:flutter_chat/models/UserModel.dart';
import 'package:flutter_chat/screens/SignIn.dart';
import 'package:flutter_chat/services/Auth.dart';
import 'package:flutter_chat/utils/toast.dart';
import 'package:flutter_chat/viewmodels/RegisterViewModel.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register with Flutter Chat"),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggle();
            },
            icon: Icon(
              Icons.login_outlined,
              color: Colors.white,
            ),
            label: Text(
              "Sign in",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                      border: OutlineInputBorder(), labelText: "User Name"),
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
                      border: OutlineInputBorder(), labelText: "Email"),
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
                      border: OutlineInputBorder(), labelText: "Password"),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic res = await RegistrationViewModel()
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
