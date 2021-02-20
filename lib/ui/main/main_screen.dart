import 'dart:async';

import 'package:bank_todo/generated/l10n.dart';
import 'package:bank_todo/redux/app_state.dart';
import 'package:bank_todo/redux/store.dart';
import 'package:bank_todo/redux/user/user_actions.dart';
import 'package:bank_todo/app/app_constants.dart';
import 'package:bank_todo/redux/user/user_state.dart';
import 'package:bank_todo/redux/weather/weather_actions.dart';
import 'package:bank_todo/redux/weather/weather_state.dart';
import 'package:bank_todo/styles/colors.dart';
import 'package:bank_todo/utils/adapt_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:money2/money2.dart';

import 'dart:math';
import 'dart:ui';

class MainScreen extends StatelessWidget {
  final String apiKey = '6ed5914d0446030f513756c4a11ab46d';
  TextStyle moneyStyle;
  TextStyle titleStyle;
  final bool revealWeather = false;

  @override
  Widget build(BuildContext context) {
    AdaptScreen.initAdapt(context);
    moneyStyle = TextStyle(
        color: AppColors.fontColor,
        fontSize: AdaptScreen.screenWidth() * 0.09,
        fontWeight: FontWeight.bold);
    titleStyle = TextStyle(
        color: AppColors.fontColor, fontSize: AdaptScreen.screenWidth() * 0.05);

    return Scaffold(
        body: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return RefreshIndicator(
                  onRefresh: () {
                    getLocation();
                    var action = RefreshItemsAction();
                    Redux.store
                        .dispatch(UpdateUserInfo(state.userState.user, action));
                    return action.completer.future;
                  },
                  child: state.userState.isLoading
                      ? CircularProgressIndicator()
                      : Stack(children: <Widget>[
                          Positioned(
                              top: -60.0, right: -35, child: _decorationBox()),
                          Container(
                            padding: EdgeInsets.all(15.0),
                          ),
                          Positioned(
                            top: AdaptScreen.screenHeight() * 0.02,
                            right: AdaptScreen.screenHeight() * 0.03,
                            child: SafeArea(
                              child: _accountInfo(
                                  context,
                                  state.userState.user.current.money,
                                  state.userState.user.thrift.money),
                            ),
                          ),
                          ListView(),
                          Positioned(
                              top: AdaptScreen.screenHeight() * 0.48,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context).hello} ${state.userState.user.name}, ${AppLocalizations.of(context).welcome}',
                                      style: TextStyle(
                                          fontSize:
                                              AdaptScreen.screenWidth() * 0.05),
                                    ),
                                    SizedBox(
                                        height:
                                            AdaptScreen.screenHeight() * 0.04),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Center(
                                          child: Container(
                                              width: AdaptScreen.screenWidth() *
                                                  0.95,
                                              height:
                                                  AdaptScreen.screenHeight() *
                                                      0.15,
                                              alignment: Alignment.center,
                                              color:
                                                  AppColors.boxAlternativeColor,
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    AdaptScreen.screenWidth() *
                                                        0.03,
                                                vertical:
                                                    AdaptScreen.screenHeight() *
                                                        0.02,
                                              ),
                                              child: state.weatherState
                                                          .current !=
                                                      null
                                                  ? _weather()
                                                  : state.weatherState.isLoading
                                                      ? CircularProgressIndicator()
                                                      : FlatButton(
                                                          onPressed: () {
                                                            getLocation();
                                                          },
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .seeMore,
                                                            style: titleStyle,
                                                          )))),
                                    ),
                                  ],
                                ),
                              )),
                        ]));
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: Icon(Icons.qr_code),
          backgroundColor: AppColors.mainColor,
        ));
  }

  Widget _weather() {
    return StoreConnector<AppState, WeatherState>(
      converter: (store) => store.state.weatherState,
      builder: (BuildContext context, WeatherState weatherState) {
        return weatherState.current != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    image: weatherState.current.current.weatherIcons[0],
                    placeholder: circularProgressIndicator,
                    placeholderScale: 1,
                  ),
                  Text(
                    "${weatherState.current.current.temperature} °C",
                    style: titleStyle,
                  ),
                ],
              )
            : CircularProgressIndicator();
      },
    );
  }

  Widget _decorationBox() {
    return Transform.rotate(
        angle: -pi / 5.0,
        child: Container(
          height: 360.0,
          width: 360.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80.0),
              gradient: LinearGradient(colors: [
                AppColors.boxAlternativeColor,
                AppColors.boxColor,
              ])),
        ));
  }

  Widget _accountInfo(BuildContext context, int current, int thrift) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(AppLocalizations.of(context).currentAccount, style: titleStyle),
          Container(
            width: AdaptScreen.screenWidth() * 0.7,
            alignment: Alignment.centerRight,
            child: Text("${Money.fromInt(current, AppConstants.localMoney)}",
                style: moneyStyle),
          ),
          Text(AppLocalizations.of(context).thriftAccount, style: titleStyle),
          Container(
            width: AdaptScreen.screenWidth() * 0.7,
            alignment: Alignment.centerRight,
            child: Text("${Money.fromInt(thrift, AppConstants.localMoney)}",
                style: moneyStyle),
          ),
        ]);
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await Redux.store.dispatch(StartLoadingWeatherAction(
        apiKey, position.latitude, position.longitude));
  }
}

class RefreshItemsAction {
  final Completer<Null> completer;

  RefreshItemsAction({Completer completer})
      : this.completer = completer ?? Completer<Null>();
}
