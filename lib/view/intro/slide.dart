import 'package:flutter/material.dart';
import 'package:niiflicks/constant/assets_const.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: AssetsConst.SLIDER1_IMG,
    title: 'Hey There ',
    description:
        'Niiflicks aim to serve your entertainment needs by bringing you the best movies and shows.',
  ),
  Slide(
    imageUrl: AssetsConst.SLIDER2_IMG, //'assets/images/image2.jpg',
    title: 'First Step',
    description: 'First, simply register on the app to become a bonafide user.',
  ),
  Slide(
    imageUrl: AssetsConst.SLIDER3_IMG, //'assets/images/image3.jpg',
    title: 'Second Step',
    description:
        'Login to join the room and get the latest and the most thrilling movie experience ever.',
  ),
  Slide(
    imageUrl: AssetsConst.SLIDER4_IMG, //'assets/images/image3.jpg',
    title: 'Last Step',
    description:
        'Select your preferrable tv show or movie genre and enjoy the reality of entertainment',
  ),
];
