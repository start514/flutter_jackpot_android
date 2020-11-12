import 'package:flutter/material.dart';
import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_rounded_textfield.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/view/home/home_screen.dart';
import 'package:flutterjackpot/view/login_signUp/login_signup_controller.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  LoginSignUpController loginSignUpController = new LoginSignUpController();

  TextEditingController nameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<LoginSignUpController>(
        create: (BuildContext context) {
          return loginSignUpController = new LoginSignUpController();
        },
        child: new Consumer<LoginSignUpController>(
          builder: (BuildContext context, LoginSignUpController controller,
              Widget child) {
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
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Trivia \$tax",
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0),
                child: layoutBuilderDot(blackColor),
              ),
              Text(
                "Five  Diamonds Media Group",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 10.0,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                decoration: BoxDecoration(
                  color: greenColor,
                  border: Border.all(
                    color: blackColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Trivia",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " Jackpots ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Prizes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              RoundedTextField(
                hintText: "Name",
                controller: nameTextEditingController,
              ),
              RoundedTextField(
                hintText: "E-Mail",
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
              ),
              RoundedTextField(
                hintText: "Password",
                controller: passwordTextEditingController,
                obscureText: true,
              ),
              RoundedTextField(
                hintText: "Confirm Password",
                controller: confirmPasswordTextEditingController,
                obscureText: true,
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 50.0,
                width: 120.0,
                child: RaisedButton(
                  child: Text(
                    "SIGN UP",
                    textAlign: TextAlign.center,
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
                  color: blackColor,
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
