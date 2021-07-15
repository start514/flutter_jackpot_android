import 'package:flutter/material.dart';
import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_rounded_textfield.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/view/home/home_screen.dart';
import 'package:flutterjackpot/view/login_signUp/login_signup_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutterjackpot/utils/image_utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginSignUpController loginSignUpController = new LoginSignUpController();

  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
     unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    return Stack(
      children: [
        bgImage(context),
        Scaffold(
          backgroundColor: transparentColor,
          body: ChangeNotifierProvider<LoginSignUpController>(
            create: (BuildContext context) {
              return loginSignUpController = new LoginSignUpController();
            },
            child: new Consumer<LoginSignUpController>(
              builder: (BuildContext context, LoginSignUpController controller,
                  Widget? child) {
                if (loginSignUpController == null)
                  loginSignUpController = controller;

                switch (controller.getStatus) {
                  case Status.LOADING:
                    return controller.getLoader;
                  case Status.SUCCESS:
                    return HomeScreen();
                  case Status.FAILED:
                    return _loginBodyWidget();
                    break;
                  case Status.IDLE:
                    break;
                }
                return _loginBodyWidget();
              },
            ),
          ),
        )
      ]
    );
  }

  Widget _loginBodyWidget() {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
     unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: 
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 10, left:10, right: 10),
              margin: EdgeInsets.only(left:30, right:30),
              decoration: BoxDecoration(
                color: whiteColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: unitHeightValue * 30.0,
                    ),
                    LineTextField(
                      hintText: "E-Mail",
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    LineTextField(
                      hintText: "Password",
                      controller: passwordTextEditingController,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: unitHeightValue * 10.0,
                    ),
                    Container(
                      height: unitHeightValue * 50.0,
                      width: 120.0,
                      child: RaisedButton(
                        child: Text(
                          "SIGN IN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: unitHeightValue * 24.0,
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (emailTextEditingController.text.isEmpty) {
                            Common.showErrorToastMsg("Please Enter Your Email");
                            return;
                          } else if (passwordTextEditingController.text.isEmpty) {
                            Common.showErrorToastMsg("Please Enter Your Password");
                            return;
                          }
                          _login();
                        },
                        color: greenColor,
                        textColor: whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ],
                ),
            )
          ),
        )
      );
  }

  Future<void> _login() async {
    FocusScope.of(context).requestFocus(
      new FocusNode(),
    );

    print("EMAIL : ${emailTextEditingController.text}");
    print("PASSWORD : ${passwordTextEditingController.text}");

    bool result = await loginSignUpController.userLoginAPI(
        emailTextEditingController.text, passwordTextEditingController.text);

    if (result != null && result) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);
    } else {
//      Common.showErrorToastMsg('loginFailed');
    }
  }
}
