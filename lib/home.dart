import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:death_counter/choose-card.dart';
import 'package:death_counter/text.dart';
import 'package:death_counter/toast.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-2118340185089535/4235062555',
    size: AdSize.banner,
    targetingInfo: MobileAdTargetingInfo(
      keywords: <String>[],
      testDevices: <String>[], // Android emulators are considered test devices
    ),
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  int days;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    firstTime();
    super.initState();
    print('Started');
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-2946850357131537~8739245665");

    myBanner
      ..load()
      ..show();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    print('disposed');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.detached) {
      print('existing');
      ToastBar(text: "Exsiting", color: Colors.red).show();
    }
  }

  SharedPreferences x;
  firstTime() async {
    x = await SharedPreferences.getInstance();

    if (x.getBool('isSeen') == null) {
      await x.setBool('isSeen', true);
      await x.setInt('days', 1545177600);
    }

    setState(() {
      days = x.getInt('days');
      x.setInt('new', days);
    });

    print(days);
  }

  @override
  Widget build(BuildContext context) {
    print("dates is $days");
    var _countDown = days != null
        ? Countdown(
            duration: Duration(seconds: x.getInt('days')),
            builder: (BuildContext ctx, Duration remaining) {
              x.setInt('days', remaining.inSeconds);

              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Image(
                            image: AssetImage("images/home.png"),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: RaisedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChooseCard(
                                            remaining: remaining.inSeconds,
                                          )),
                                );
                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                      'images/logo.png',
                                    ),
                                  ),
                                  Text(
                                    "Play",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CountDownText(
                        time: (remaining.inDays ~/ 365).toString(),
                        color: Colors.red,
                        suffix: 'YRS',
                      ),
                    ),
                    CountDownText(
                      time: ((remaining.inDays % 365)).toString(),
                      suffix: "DAY",
                      color: Colors.red,
                    ),
                    CountDownText(
                      time: (remaining.inHours % 24).toString(),
                      suffix: "HRS",
                      color: Colors.white,
                    ),
                    CountDownText(
                      time: (remaining.inMinutes % 60).toString(),
                      suffix: "MIN",
                      color: Colors.white,
                    ),
                    CountDownText(
                      time: (remaining.inSeconds % 60).toString(),
                      suffix: "SEC",
                      color: Colors.white,
                    ),
                    RaisedButton(
                      color: Colors.black,
                      child: Text(
                        'Refresh',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      onPressed: () {
                        int newdays = x.getInt('new');
                        x.setInt('days', newdays);
                        RestartWidget.restartApp(context);
                      },
                    )
                  ],
                ),
              );
            })
        : Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );

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
      body: _countDown,
    );
  }
}
