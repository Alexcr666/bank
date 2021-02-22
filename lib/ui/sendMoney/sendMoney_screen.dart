import 'package:bank_todo/generated/l10n.dart';
import 'package:bank_todo/redux/app_state.dart';
import 'package:bank_todo/redux/models/login_view_model.dart';
import 'package:bank_todo/routes/assets_routes.dart';
import 'package:bank_todo/styles/colors.dart';
import 'package:bank_todo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';

class sendMoneyScreen extends StatefulWidget {
  @override
  _sendMoneyScreenState createState() => _sendMoneyScreenState();
}

class _sendMoneyScreenState extends State<sendMoneyScreen> {
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
        body: SafeArea(
          child: Container(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 200.0),
                Container(
                  child: Center(
                    child: Image(
                      image: AssetImage(AssetsRoutes.loginIcon),
                      height: 120.0,
                    ),
                  ),
                ),
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
          obscureText: true,
          decoration: InputDecoration(
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
          keyboardType: TextInputType.emailAddress,
          initialValue: email,
          decoration: InputDecoration(
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
                  style: TextStyle(color: AppColors.fontColor, fontSize: 15.0)),
        ),
        color: AppColors.mainColor,
        onPressed: () {
          if (!_formKey.currentState.validate()) return;
          try {
            print("The user info $email and $password");
            loginView.login(email, password);
          } catch (e) {
            print("Error $e");
          }
        });
  }
}
