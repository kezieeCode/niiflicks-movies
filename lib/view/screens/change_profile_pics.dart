import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';

void main() {
  runApp(MaterialApp(
    home: SampleScreen(),
  ));
}

class SampleScreen extends StatefulWidget {
  @override
  _SampleScreenState createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  // File _image;
  final picker = ImagePicker();
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        tmpFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Future uploadImage() async {
    // var pickedFile = await picker.getImage(source: ImageSource.gallery);
    // tmpFile = File(pickedFile.path);
    var url = 'https://niiflicks.com/niiflicks/apis/user/profilepicture.php';

    var data = {'thumbnail': tmpFile};
    var response = await http.put(Uri.parse(url), body: data);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithBackBtn(
          ctx: context,
          title: Text('Edit Profile'.toUpperCase(),
              style: TextStyle(
                  color: Colors.red, fontFamily: 'Montserrat-Regular')),
          bgColor: Colors.black,
          icon: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              ))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlineButton(
                onPressed: () => getImage(), child: Text('Select Picture')),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Flexible(
                  child: tmpFile != null
                      ? Image.file(tmpFile)
                      : Text('Upload Image here')),
            ),
            OutlineButton(
                onPressed: () {
                  uploadImage();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Profile Picture changed succesfully'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 10),
                    action: SnackBarAction(
                      label: '',
                      onPressed: () {},
                    ),
                  ));
                },
                child: Text('Upload Picture')),
          ],
        ),
      ),
    );
  }
}
