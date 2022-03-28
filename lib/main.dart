import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:niiflicks/classes/live_tv.dart';
import 'package:niiflicks/classes/recent.dart';
import 'package:niiflicks/constant/string_const.dart';
import 'package:niiflicks/state/users.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:niiflicks/constant/assets_const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niiflicks/constant/color_const.dart';
import 'package:niiflicks/view/splash/splash_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:niiflicks/state/movie_detail_state.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';

const simplePeriodicTask = 'Movie at your finger tips';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();

  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await Workmanager().initialize(callbackDispatcher,
      isInDebugMode:
          false); //to true if still in testing lev turn it to false whenever you are launching the app
  await Workmanager().registerPeriodicTask("1", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 120), //when should it check the link
      initialDelay:
          Duration(seconds: 5), //duration before showing the notification
      constraints: Constraints(
        // requiresDeviceIdle: false,
        networkType: NetworkType.connected,
      ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();

final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin1 =
    FlutterLocalNotificationsPlugin();
// Future<List<Recent>> moviesList() async {
//   var uri = 'https://simplemovie.p.rapidapi.com/movie/list/recent';

//   var response = await http.get(Uri.parse(uri), headers: {
//     'x-rapidapi-key': '54955f88e7mshdd4f9ffx2678e1c8p19ce0djsnd6af5e47672f'
//   });
//   if (response.statusCode == 200) {
//     print(response.body);
//     return Recent.parseRecent(jsonDecode(response.body)["data"]);
//   } else {
//     print(response.body);
//     throw Exception('No data to display');
//   }
// }

Future instantNotifications(
    convert, _flutterLocalNotificationPlugin1, dated) async {
  var android = AndroidNotificationDetails("id", "name", "description",
      priority: Priority.high, importance: Importance.max);

  var ios = IOSNotificationDetails();
  var platform = new NotificationDetails(android: android, iOS: ios);
  await _flutterLocalNotificationPlugin1.show(
      0, "Watch Now:  $convert", '$dated', platform,
      payload: "Welcome to Niiflicks");
}

Future sportNotifications(
    sportData, _flutterLocalNotificationPlugin, dated) async {
  var android = AndroidNotificationDetails("id", "name", "description",
      priority: Priority.high, importance: Importance.max);

  var ios = IOSNotificationDetails();
  var platform = new NotificationDetails(android: android, iOS: ios);
  await _flutterLocalNotificationPlugin.show(
      0, "Watch Now:  $sportData", '$dated', platform,
      payload: "Welcome to Niiflicks");
}

// Future scheduledNotifications(
//     picture, convert, dated, _flutterLocalNotificationPlugin) async {
//   var intervals = RepeatInterval.values[1];
//   var bigPicture = BigPictureStyleInformation(
//     DrawableResourceAndroidBitmap('ini'),
//     largeIcon: DrawableResourceAndroidBitmap("ini"),
//     contentTitle: "Watch" '$convert',
//     summaryText: "$dated",
//   );
//   var android = AndroidNotificationDetails("id", "name", "description",
//       color: Colors.red,
//       enableLights: true,
//       enableVibration: true,
//       styleInformation: bigPicture);
//   var platform = new NotificationDetails(android: android);
//   await _flutterLocalNotificationPlugin.show(0, "$convert", "$dated", platform,
//       payload: "Welcome to Niiflicks");
// }

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
        FlutterLocalNotificationsPlugin();
    final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin1 =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('logo');
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);
    await _flutterLocalNotificationPlugin1.initialize(initializationSettings);
    await _flutterLocalNotificationPlugin.initialize(initializationSettings);

    // picking movies from api
    // var url = 'https://niiflicks.com/niiflicks/apis/movies/livetv.php';
    // var response = await http.get(Uri.parse(url));
    // var convert = jsonDecode(response.body)['data'];
    // if (response.statusCode == 200) {
    //   print(convert);
    //   // return LiveTvs.parseRecent(jsonDecode(response.body)["data"]);
    // } else {
    //   print(response.body);
    //   throw Exception('Never communicated with the server');
    // }

    var uri = 'https://niiflicks.com/niiflicks/apis/movies/livetv.php';
    var res = await http.get(Uri.parse(uri));
    var data1 = jsonDecode(res.body);
    var sportData;
    for (var i = 0; i < data1['data'].length; i++) {
      sportData = data1['data'][i]['name'];
      print(sportData);
    }

    var url = 'https://universal-studios1.p.rapidapi.com/cinema-movies.php';
    var response = await http.get(Uri.parse(url), headers: {
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    var data = jsonDecode(response.body);
    var convert = data['data'][1]['title'];
    print(convert);

    var picture = jsonDecode(response.body)['data'][2]['cover'];
    // var picture1 = jsonDecode(res.body)['data'][1]['cover'];
    var dated1 = jsonDecode(res.body)['data'][1]['date'];
    var dated = jsonDecode(response.body)['data'][2]['date'];

    print(picture);
    print(dated);
    // print(picture1);
    print(dated1);

    if (response.statusCode == 200) {
      // instantNotifications(convert, _flutterLocalNotificationPlugin1, dated);
      // instantNotifications(convert, _flutterLocalNotificationPlugin1, dated);
      sportNotifications(
          convert, _flutterLocalNotificationPlugin, "Watch Live: " + sportData);
    } else {
      print(response.body);
      print(res.body);
      throw Exception('No data to display');
    }

    return Future.value(true);
  });
}

class _MyAppState extends State<MyApp> {
  // instatnt Notifications

  String displayUser = "";
  ReceivePort _port = ReceivePort();
  void initState() {
    super.initState();
    // s
    callbackDispatcher();
    // initialize();

    // instantNotifications();
    // _checkUpdate();
    // scheduledNotifications();
  }

  @override
  Widget getView() {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MovieDetailsProvider>(
              create: (context) => MovieDetailsProvider()),
          ChangeNotifierProvider(create: (context) => UserLoggedProvider())
        ],
        child: Consumer<MovieDetailsProvider>(builder: (BuildContext context,
            MovieDetailsProvider provider, Widget child) {
          return MaterialApp(
            title: StringConst.APP_NAME,
            debugShowCheckedModeBanner: false,
            // darkTheme: ThemeData(brightness: Brightness.dark),
            theme: ThemeData(
              brightness: isDarkMode() ? Brightness.dark : Brightness.light,
              fontFamily: AssetsConst.ZILLASLAB_FONT,
              accentColor: ColorConst.APP_COLOR,
              // accentColorBrightness: Brightness.light,
              primarySwatch: ColorConst.APP_COLOR,
            ),
            home: SplashPage(),

            // DashboardScreen()
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    // SPManager.getThemeDark()
    return getView();
    // return
    //   ScopedModel(
    //   model: ThemeModel(),
    //   child: getView(),
    // );
  }
}
