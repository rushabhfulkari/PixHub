import 'package:flutter/material.dart';
import 'package:pixhub/model/wallpaper_model.dart';
import 'package:pixhub/views/image_view.dart';
import 'package:pixhub/widgets/colors.dart';

Widget brandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          children: <TextSpan>[
            TextSpan(
                text: 'Pix',
                style: TextStyle(color: c3, fontWeight: FontWeight.bold)),
            TextSpan(
                text: 'Hub',
                style: TextStyle(color: c1, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ],
  );
}

Widget wallpapersList({List<WallpaperModel> wallpapers, context}) {
  if (wallpapers.length > 0) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: wallpapers.map((wallpaper) {
          return GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageView(
                        imgUrl: wallpaper.src.portrait,
                      ),
                    ));
              },
              child: Hero(
                tag: wallpaper.src.portrait,
                child: Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          wallpaper.src.portrait,
                          fit: BoxFit.cover,
                        )
                        // child: Image.network(wallpaper.src.potrait)

                        )
                    // : Container()

                    ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  } else {
    return Center(
      child: Text(
        "Wallpapers not Found",
        style: TextStyle(color: c3),
      ),
    );
  }
}
