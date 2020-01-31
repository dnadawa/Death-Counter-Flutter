import 'package:death_counter/home.dart';
import 'package:death_counter/main.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_ads/native_ad_param.dart';
import 'package:native_ads/native_ad_view.dart';

class PlayGame extends StatefulWidget {
  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
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
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-2118340185089535~1800470902');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 35,
              width: 35,
              child: Image(
                image: AssetImage('images/logo.png'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text("Count Down Death"),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'IF YOU COULD FIND OUT EXACTLY WHEN YOU\'RE GOING TO DIE... WOULD YOU WANT TO KNOW?',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: NativeAdView(
                  onParentViewCreated: (_) {},
                  androidParam: AndroidParam()
                    ..placementId =
                        "ca-app-pub-2118340185089535/9362146598" // test
                    ..packageName = "com.pjapp.countdowndeath"
                    ..layoutName = "native_ad_layout"
                    ..attributionText = "AD",
                  onAdImpression: () => print("onAdImpression!!!"),
                  onAdClicked: () => print("onAdClicked!!!"),
                  onAdFailedToLoad: (Map<String, dynamic> error) =>
                      print("onAdFailedToLoad!!! $error"),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/intro.jpg'), fit: BoxFit.fill),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Would you like to join and play a game ?',
                  style: TextStyle(fontSize: 14),
                ),
                RaisedButton(
                  onPressed: () {
                    print('clicked');
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) {
                        myInterstitial
                          ..load()
                          ..show();
                        return RestartWidget(child: Home());
                      }),
                    );
                  },
                  color: Colors.teal,
                  child: Text(
                    'Play',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
