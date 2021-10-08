import 'package:bank_todo/generated/l10n.dart';
import 'package:bank_todo/redux/app_state.dart';
import 'package:bank_todo/redux/models/login_view_model.dart';
import 'package:bank_todo/routes/assets_routes.dart';
import 'package:bank_todo/styles/colors.dart';
import 'package:bank_todo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  Utils utils = Utils();
  bool changePage = true;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, LoginViewModel>(
      converter: (store) => LoginViewModel.fromStore(store),
      distinct: false,
      builder: (_, viewModel) => Scaffold(
        backgroundColor: AppColors.mainColor,
        body: SafeArea(
          child: Container(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100.0),
                Row(
                  children: [
                    Container(
                      child: Center(
                        child: Image(
                          image: AssetImage(AssetsRoutes.loginIcon),
                          height: 120.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text("Bank",style: TextStyle(color: Colors.white,fontSize: 40),)
                  ],
                ),
                SizedBox(height: 30.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _emailField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _passwordField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _submitButtom(context, viewModel)
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
      onDidChange: (viewModel) {
        if (viewModel.loginError) {
          Fluttertoast.showToast(msg: AppLocalizations.of(context).apiError);
        } else {
          if (viewModel.user != null && changePage) {
            changePage = false;
            Navigator.of(context).pushNamed('main');
          }
        }
      },
    );
  }

  Widget _passwordField() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.visiblePassword,
          initialValue: password,
          style: TextStyle(color: Colors.white),
          obscureText: true,
          decoration: InputDecoration(
            labelStyle:   TextStyle(color: Colors.white.withOpacity(0.4)),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            labelText: AppLocalizations.of(context).password,
          ),
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          validator: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context).passwordHint;
            } else if (value.length < 3) {
              return AppLocalizations.of(context).passwordError;
            }
            return null;
          },
        ));
  }

  Widget _emailField() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          initialValue: email,
          decoration: InputDecoration(
            labelStyle:  TextStyle(color: Colors.white.withOpacity(0.4)),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            hintText: 'example@gmail.con',
            labelText: AppLocalizations.of(context).email,
          ),
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
          validator: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context).emailHint;
              ;
            } else if (!utils.validateEmail(email)) {
              return AppLocalizations.of(context).emailError;
            }
            return null;
          },
        ));
  }

  Widget _submitButtom(BuildContext context, LoginViewModel loginView) {
    return RaisedButton(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 85.0, vertical: 25.0),
          child: loginView.isLoading == true
              ? CircularProgressIndicator()
              : Text(AppLocalizations.of(context).signIn,
                  style: TextStyle(color: AppColors.mainColor, fontSize: 15.0)),
        ),
        color:Colors.white,
        onPressed: () {
          if (!_formKey.currentState.validate()) return;
          try {
            print("The user info $email and $password");
            changePage = true;
            loginView.login(email, password);
          } catch (e) {
            print("Error $e");
          }
        });
  }
}
