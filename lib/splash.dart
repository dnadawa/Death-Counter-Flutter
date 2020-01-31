import 'dart:async';

import 'package:death_counter/policy.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: 'ca-app-pub-2118340185089535/7119126634',
    targetingInfo: MobileAdTargetingInfo(
      keywords: <String>[],
      testDevices: <String>[], // Android emulators are considered test devices
    ),
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    OneSignal.shared.init("ac82a7e7-af3e-4573-b4e9-5c23e93d4a68", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-2118340185089535~1800470902');

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) {
          myInterstitial
            ..load()
            ..show();
          return Policy();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(70),
            child: Image.asset(
              'images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
          CircularProgressIndicator(
            backgroundColor: Colors.black,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      ),
    );
  }
}
