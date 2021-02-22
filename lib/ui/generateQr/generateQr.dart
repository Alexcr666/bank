import 'package:bank_todo/generated/l10n.dart';
import 'package:bank_todo/redux/app_state.dart';
import 'package:bank_todo/redux/models/login_view_model.dart';
import 'package:bank_todo/routes/assets_routes.dart';
import 'package:bank_todo/styles/colors.dart';
import 'package:bank_todo/utils/utils.dart';
import 'package:bank_todo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../generated/l10n.dart';
import '../../utils/adapt_screen.dart';

class generateQrScreen extends StatefulWidget {
  final String id;
  final bool type;
  final bool typeProfile;
  final int size;
  final String comment;

  // In the constructor, require a Todo.
  generateQrScreen(
      {Key key,
      @required this.id,
      this.type,
      this.size,
      this.comment,
      this.typeProfile})
      : super(key: key);

  @override
  _generateQrScreenState createState() => _generateQrScreenState();
}

class _generateQrScreenState extends State<generateQrScreen> {
  final _formKey = GlobalKey<FormState>();

  Utils utils = Utils();
  bool changePage = true;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    String code = widget.id +
        "/" +
        widget.size.toString() +
        "/" +
        widget.type.toString() +
        "/" +
        widget.comment.toString() +
        "/" +
        widget.typeProfile.toString();
    return new StoreConnector<AppState, LoginViewModel>(
      converter: (store) => LoginViewModel.fromStore(store),
      distinct: false,
      builder: (_, viewModel) => Scaffold(
        appBar: WidgetProyect()
            .widgetAppbar(context, AppLocalizations.of(context).generateQr),
        body: SafeArea(
          child: Container(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: QrImage(
                    data: code,
                    version: QrVersions.auto,
                    size: 300,
                  ),
                ),
                WidgetProyect().listMoney(context, widget.comment, widget.type,
                    widget.typeProfile, widget.size, widget.id, true),
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
}
