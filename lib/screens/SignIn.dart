import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/Wrapper.dart';
import 'package:flutter_chat/services/Auth.dart';
import 'package:flutter_chat/utils/toast.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  // const SignIn({Key? key}) : super(key: key);

  final Function toggle;

  SignIn({required this.toggle});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _email = "";
  String _password = "";

  late AuthUser _authUser;

  @override
  Widget build(BuildContext context) {

    _authUser = Provider.of<AuthUser>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("SignIn with Flutter Chat"),
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
              "Register",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
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
                onPressed: () async{
                  dynamic res = await _authUser.sigInUsingEmail(_email, _password);
                  if(res == "user-not-found"){
                    showToast(context, "Invalid User");
                  }
                  else if(res == null){
                    showToast(context, "Something Went Wrong");
                  }
                },
                child: Text("Sign In"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
