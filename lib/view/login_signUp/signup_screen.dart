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

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}
 
class _SignUpScreenState extends State<SignUpScreen> {
  LoginSignUpController loginSignUpController = new LoginSignUpController();

  TextEditingController nameTextEditingController = new TextEditingController();
  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
     unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    return 
        ChangeNotifierProvider<LoginSignUpController>(
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
                    return _signUpBodyWidget();
                    break;
                  case Status.IDLE:
                    break;
                }
                return _signUpBodyWidget();
              },
            ),
          );
  }

  Widget _signUpBodyWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                 padding: EdgeInsets.only(top: unitHeightValue* 20, bottom: unitHeightValue * 10, left: unitWidthValue * 10, right: unitWidthValue * 10),
                 margin: EdgeInsets.only(left: unitWidthValue * 30, right: unitWidthValue * 30),
                decoration: BoxDecoration(
                  color: whiteColor.withOpacity(0.6),
               
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    LineTextField(
                      hintText: "Name",
                      controller: nameTextEditingController,
                    ),
                    LineTextField(
                      hintText: "Username",
                      controller: usernameTextEditingController,
                    ),
                    LineTextField(
                      hintText: "Password",
                      controller: passwordTextEditingController,
                      obscureText: true,
                    ),
                    LineTextField(
                      hintText: "Confirm Password",
                      controller: confirmPasswordTextEditingController,
                      obscureText: true,
                    ),
                    LineTextField(
                      hintText: "E-Mail",
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ]
                )
              ),
              
              SizedBox(
                height: unitHeightValue * 10.0,
              ),
              Container(
                height: unitHeightValue * 50.0,
                width: unitWidthValue * 320.0,
                child: RaisedButton(
                  child: Text(
                    "Create my Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: unitHeightValue * 24.0,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (nameTextEditingController.text.isEmpty) {
                      Common.showErrorToastMsg("Please Enter Your Name");
                      return;
                    } else if (emailTextEditingController.text.isEmpty) {
                      Common.showErrorToastMsg("Please Enter Your Email");
                      return;
                    } else if (passwordTextEditingController.text.isEmpty) {
                      Common.showErrorToastMsg("Please Enter Your Password");
                      return;
                    } else if (confirmPasswordTextEditingController
                        .text.isEmpty) {
                      Common.showErrorToastMsg(
                          "Please Enter Your Confirm Password");
                      return;
                    }
                    _signUp();
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
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    FocusScope.of(context).requestFocus(
      new FocusNode(),
    );

    print("NAME : ${nameTextEditingController.text}");
    print("EMAIL : ${emailTextEditingController.text}");
    print("PASSWORD : ${passwordTextEditingController.text}");

    bool result = await loginSignUpController.userSignUpAPI(
        nameTextEditingController.text,
        emailTextEditingController.text,
        passwordTextEditingController.text);

    if (result != null && result) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);
    } else {
//      Common.showErrorToastMsg('signUpFailed');
    }
  }
}
