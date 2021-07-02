import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pixhub/data/data.dart';
import 'package:pixhub/model/wallpaper_model.dart';
import 'package:pixhub/widgets/colors.dart';
import 'package:pixhub/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Search extends StatefulWidget {
  final String searchQuery;
  Search({this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  bool fetched = false;
  String noimage;
  TextEditingController searchController = new TextEditingController();
  List<WallpaperModel> wallpapers = [];

  getSearchWallpapers(String query) async {
    wallpapers.clear();
    var response = await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/search?query=${query}&per_page=100'),
        headers: {"Authorization": apiKey});

    // print("reponse.body ${response.body.toString()}");
    noimage = response.body;
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
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
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
              Container(
                decoration: BoxDecoration(
                    color: c1, borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 24),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        cursorColor: c3,
                        style: TextStyle(color: c3),
                        decoration: InputDecoration(
                          hintText: "search",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: c3),
                          labelStyle: TextStyle(color: c3),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        getSearchWallpapers(searchController.text);
                      },
                      child: Container(
                          child: Icon(
                        Icons.search,
                        color: c3,
                      )),
                    )
                  ],
                ),
              ),
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
