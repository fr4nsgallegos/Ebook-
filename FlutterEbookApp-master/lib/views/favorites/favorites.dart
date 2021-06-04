import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ebook_app/components/book.dart';
import 'package:flutter_ebook_app/models/category.dart';
import 'package:flutter_ebook_app/session/session_heper.dart';
import 'package:flutter_ebook_app/util/router.dart';
import 'package:flutter_ebook_app/view_models/favorites_provider.dart';
import 'package:flutter_ebook_app/views/genre/genre.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  @override
  void deactivate() {
    super.deactivate();
    getFavorites();
  }

  getFavorites() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          Provider.of<FavoritesProvider>(context, listen: false).getFavorites();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (BuildContext context, FavoritesProvider favoritesProvider,
          Widget child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Favorites',
            ),
          ),
          body: favoritesProvider.posts.isEmpty
              ? _buildEmptyListView()
              : _buildGridView(favoritesProvider),
        );
      },
    );
  }

  _buildEmptyListView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/empty.png',
            height: 300.0,
            width: 300.0,
          ),
          Text(
            'Nothing is here',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String tittleCat = SessionHelper().tituloCategoria;
  String codCat = SessionHelper().codCategoria;
  String url;
  _buildGridView(FavoritesProvider favoritesProvider) {
    String url = "https://catalog.feedbooks.com/top.atom?cat?+$codCat";

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              shrinkWrap: true,
              itemCount: favoritesProvider.posts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 200 / 340,
              ),
              itemBuilder: (BuildContext context, int index) {
                Entry entry =
                    Entry.fromJson(favoritesProvider.posts[index]['item']);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: BookItem(
                    img: entry.link[1].href,
                    title: entry.title.t,
                    entry: entry,
                  ),
                );
              },
            ),
          ),
          Text(
            "Categoría recomendada",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  MaterialButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      MyRouter.pushPage(
                        context,
                        Genre(
                          title: tittleCat,
                          url: url,
                        ),
                      );
                    },
                    child: Text(tittleCat),
                    height: 20,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
