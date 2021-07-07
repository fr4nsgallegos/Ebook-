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
  List<Category> favoritosList = [];
  @override
  void initState() {
    super.initState();
    getFavorites();
    masRepetido();
    eliminarDcuplicadosLista();
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

  final categories = {
    'shortStory': 'cat=FBFIC029000',
    'sciFi': 'cat=FBFIC028000',
    'actionAdventure': 'cat=FBFIC002000',
    'mystery': 'cat=FBFIC022000',
    'romance': 'cat=FBFIC027000',
    'horror': 'cat=FBFIC015000',
  };
  String nombreMasFav;
  String codMasFav;
  Future masRepetido() async {
    List<String> auxList = [];
    SessionHelper().listaCategoria.forEach((element) {
      auxList.add(element.term);
    });
    print(auxList.length);
    Map<String, int> count = {};
    await SessionHelper().listaCategoria.forEach((element) {
      count[element.term] =
          count.containsKey(element.term) ? count[element.term] + 1 : 1;
      print('${count.toString()}');
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaalaaa");

      print(count[2]);
      // print(SessionHelper().listaCategoria.asMap().toString());
    });
    int max = count[auxList[0]];
    for (int i = 0; i < auxList.length; i++) {
      if (count[auxList[i]] > max) {
        max = count[auxList[i]];
      }
    }
    print(max);
    print("asdasdasd");
    count.forEach((key, value) {
      if (value == max) {
        print("key = $key : value : $value");
        print(SessionHelper().listaCategoria.length);
        nombreMasFav = key;
        codMasFav = categories[key];
      }
    });
  }

  void eliminarDcuplicadosLista() {
    favoritosList = SessionHelper().listaCategoria;
    final titulos = favoritosList.map((e) => e.label).toSet();

    setState(() {
      favoritosList.retainWhere((element) => titulos.remove(element.label));
    });
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

  String url;
  String urlFavoritosgeneral = "https://catalog.feedbooks.com/search.atom?cat=";
  _buildGridView(FavoritesProvider favoritesProvider) {
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
            child: favoritosList.length == 0
                ? Text("No hay favoritos")
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: favoritosList.length,
                    itemBuilder: (context, index) {
                      urlFavoritosgeneral = urlFavoritosgeneral +
                          favoritosList[index].term +
                          "&cat=";

                      String url =
                          "https://catalog.feedbooks.com/top.atom?cat?+${favoritosList[index].term}";

                      print("sauiasdasd");
                      print(urlFavoritosgeneral);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          color: Colors.blueAccent,
                          onPressed: () {
                            MyRouter.pushPage(
                              context,
                              Genre(
                                title: favoritosList[index].label,
                                url: url,
                              ),
                            );
                          },
                          child: Text(favoritosList[index].label),
                          height: 20,
                        ),
                      );
                    },
                    // children: [

                    // ],
                  ),
          ),
          Text(
            "Libros recomendados",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            color: Colors.blueAccent,
            onPressed: () {
              String urlMasFav =
                  "https://catalog.feedbooks.com/top.atom?cat?+$codMasFav";
              MyRouter.pushPage(
                context,
                Genre(
                  title: "LIBROS RECOMENDADOS $nombreMasFav",
                  url: urlMasFav,
                ),
              );
            },
            child: Text("LIBROS RECOMENDADOS $nombreMasFav"),
            height: 20,
          ),
        ],
      ),
    );
  }
}
