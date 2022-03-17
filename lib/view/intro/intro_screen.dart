import 'package:niiflicks/model/theme_model.dart';
import 'package:niiflicks/view/home/login.dart';
import 'package:niiflicks/view/likemovie/movie_like.dart';
import 'package:flutter/material.dart';
import 'package:niiflicks/constant/color_const.dart';
import 'package:niiflicks/utils/sp/sp_manager.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:niiflicks/view/intro/slide.dart';
import 'package:niiflicks/view/intro/slide_dots.dart';
import 'package:niiflicks/view/intro/slide_item.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    print("INtro : ${ThemeModel.dark}");
    return Scaffold(
        body: FutureBuilder(
      future: SPManager.getOnboarding(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // On when user first time watch screen
        // if (!snapshot.hasData)
        return _crateUi(context);
      },

      // builder: (context) => _crateUi(context),
    ));
  }

  Widget _crateUi(BuildContext context) {
    Color color = ColorConst.WHITE_BG_COLOR;

    return Stack(
      children: <Widget>[
        Container(
          color: color,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: slideList.length,
                itemBuilder: (ctx, i) => SlideItem(i),
              ),
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 55),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < slideList.length; i++)
                          if (i == _currentPage)
                            SlideDots(true)
                          else
                            SlideDots(false)
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: getTxtBlackColor(
                    msg: 'SKIP', fontSize: 16, fontWeight: FontWeight.bold),
                onPressed: () {
                  // _setPrefValue();
                  navigationPushReplacement(context, Login());
                },
              ),
              FlatButton(
                child: getTxtBlackColor(
                    msg: _currentPage < 3 ? 'NEXT' : 'DONE',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                onPressed: () {
                  navigationPushReplacement(context, MovieLikeScreen());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _nextClick() {
    if (_currentPage < 3) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      navigationPushReplacement(context, MovieLikeScreen());
    }
  }
}
