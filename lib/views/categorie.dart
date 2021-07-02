import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pixhub/data/data.dart';
import 'package:pixhub/model/wallpaper_model.dart';
import 'package:pixhub/widgets/colors.dart';
import 'package:pixhub/widgets/widgets.dart';

class Categorie extends StatefulWidget {
  final String categorieName;
  Categorie({this.categorieName});
  _CategorieState createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];

  bool fetched = false;
  List<WallpaperModel> wallpapers = [];

  getSearchWallpapers(String query) async {
    var response = await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/search?query=${query}&per_page=100'),
        headers: {"Authorization": apiKey});

    // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      // print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel(
        photographer: element['photographer'],
        photographer_id: element['photographer_id'],
        photographer_url: element['photographer_url'],
        src: SrcModel(
          original: element['src']['original'],
          portrait: element['src']['portrait'],
          small: element['src']['small'],
        ),
      );
      wallpapers.add(wallpaperModel);
    });

    setState(() {
      fetched = true;
    });
  }

  @override
  void initState() {
    getSearchWallpapers(widget.categorieName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: c2,
      appBar: AppBar(
        backgroundColor: c2,
        title: brandName(),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: c3,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              fetched
                  ? wallpapersList(wallpapers: wallpapers, context: context)
                  : Container(
                      height: size.height - 250,
                      width: size.width,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: c1,
                      )),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
