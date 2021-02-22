import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../generated/l10n.dart';
import '../styles/colors.dart';
import '../utils/adapt_screen.dart';

class WidgetProyect {
  Widget listMoney(BuildContext context, String comment, bool type,
      bool typeProfile, int size, String id, bool send) {
    //AdaptScreen.initAdapt(context);
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          comment,
          style: TextStyle(
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: AdaptScreen.screenWidth() * 0.07),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          type != true
              ? AppLocalizations.of(context).colombianpeso
              : AppLocalizations.of(context).americandollar,
          style: TextStyle(
              color: Colors.grey, fontSize: AdaptScreen.screenWidth() * 0.05),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          typeProfile == true
              ? AppLocalizations.of(context).stream
              : AppLocalizations.of(context).ahorro,
          style: TextStyle(
              color: Colors.grey, fontSize: AdaptScreen.screenWidth() * 0.05),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          size.toString(),
          style: TextStyle(
              color: Colors.grey, fontSize: AdaptScreen.screenWidth() * 0.05),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          id,
          style: TextStyle(fontSize: AdaptScreen.screenWidth() * 0.05),
        ),
        SizedBox(
          height: 10,
        ),
        send == true
            ? SizedBox()
            : RaisedButton(
                elevation: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 85.0, vertical: 25.0),
                  child: Text(AppLocalizations.of(context).sendMoney,
                      style: TextStyle(
                          color: AppColors.fontColor, fontSize: 15.0)),
                ),
                color: AppColors.mainColor,
                onPressed: () {
                  final FirebaseAuth auth = FirebaseAuth.instance;

                  final User user = auth.currentUser;
                  final uid = user.uid;
                  // here you write the codes to input the data into firestore

                  var _firebaseRefUser = FirebaseDatabase()
                      .reference()
                      .child('user')
                      .child(uid)
                      .child(type == true ? "current" : "thrift");
                  _firebaseRefUser.child("money").once().then((value) {
                    print("prueba1:_ " + value.value.toString());
                    int buy = int.parse(value.value.toString()) - size;
                    if (buy <= 0) {
                      Fluttertoast.showToast(
                          msg:
                              AppLocalizations.of(context).insufficientbalance);
                    } else {
                      _firebaseRefUser.set({
                        "money": buy,
                      });

                      var _firebaseRef = FirebaseDatabase()
                          .reference()
                          .child('user')
                          .child(id)
                          .child(type == true ? "current" : "thrift");

                      _firebaseRef.child("money").once().then((value) {
                        print("prueba1:_ " + value.value.toString());
                        int buy = int.parse(value.value.toString()) + size;
                        _firebaseRef.set({
                          "money": buy,
                        });
                      });
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context).operationSucefull);
                      Navigator.popAndPushNamed(context, 'main');
                    }
                  });
                }),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget widgetAppbar(BuildContext context, String title) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.mainColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      centerTitle: true,
    );
  }
}
