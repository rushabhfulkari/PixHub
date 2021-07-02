import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pixhub/data/data.dart';
import 'package:pixhub/model/categories_model.dart';
import 'package:pixhub/model/wallpaper_model.dart';
import 'package:pixhub/views/categorie.dart';
import 'package:pixhub/views/search.dart';
import 'package:pixhub/widgets/colors.dart';
import 'package:pixhub/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = new TextEditingController();
  bool fetched = false;

  getTrendingWallpapers() async {
    var response = await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=100'),
        headers: {"Authorization": apiKey});

    print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
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
    super.initState();
    getTrendingWallpapers();
    categories = getCategories();
    // print(categories);
  }

  Future<void> refresh() async {
    categories = getCategories();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: c2,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
        backgroundColor: c2,
      ),
      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        key: _refreshIndicatorKey,
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                          color: c4,
                          blurRadius: 5.0,
                        ),
                      ],
                      color: c1.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  margin: EdgeInsets.symmetric(horizontal: 16),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search(
                                        searchQuery: searchController.text,
                                      )));
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
                  height: 20,
                ),
                Container(
                  height: 80,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CategoriesTile(
                          title: categories[index].categorieName,
                          imgUrl: categories[index].imgUrl,
                        );
                      }),
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
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;
  CategoriesTile({@required this.title, @required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categorie(categorieName: title)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgUrl,
                  height: 50,
                  width: 100,
                  fit: BoxFit.cover,
                )),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8)),
              height: 50,
              width: 100,
              alignment: Alignment.center,
              child: Text(
                title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
