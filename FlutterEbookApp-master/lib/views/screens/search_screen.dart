import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ebook_app/components/book_list_item.dart';
import 'package:flutter_ebook_app/models/category.dart';
import 'package:flutter_ebook_app/util/enum/api_request_status.dart';
import 'package:xml2json/xml2json.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool advanced = false;
  APIRequestStatus statusRequest;
  CategoryFeed categoryFeed;
  String filtro = 'titulos';
  String categoria = "todas";
  String palabraBuscar = '';
  final categories = {
    'shortStory': 'cat=FBFIC029000',
    'sciFi': 'cat=FBFIC028000',
    'actionAdventure': 'cat=FBFIC002000',
    'mystery': 'cat=FBFIC022000',
    'romance': 'cat=FBFIC027000',
    'horror': 'cat=FBFIC015000',
  };

  final txtController = TextEditingController();
  @override
  void initState() {
    super.initState();
    statusRequest = APIRequestStatus.unInitialized;
  }

  Future<CategoryFeed> getAuthor() async {
    Dio dio = Dio();
    updateSearch(APIRequestStatus.loading);
    String url = 'https://catalog.feedbooks.com/search.atom?';
    if (filtro == 'titulo' || filtro == 'titulos') {
      url = url + 'query=' + palabraBuscar;
    } else {
      url = url + 'author=' + palabraBuscar;
    }
    if (categoria != 'todas') {
      url = url + '&' + categories[categoria];
    }

    var res = await dio.get(url).catchError((e) {
      throw (e);
    });
    print(res);

    if (res.statusCode == 200) {
      Xml2Json xml2json = new Xml2Json();
      xml2json.parse(res.data.toString());
      var json = jsonDecode(xml2json.toGData());
      categoryFeed = CategoryFeed.fromJson(json);
      updateSearch(APIRequestStatus.loaded);
    } else {
      updateSearch(APIRequestStatus.error);
      throw ('Error ${res.statusCode}');
    }
    return categoryFeed;
  }

  Future<CategoryFeed> getSearch() async {
    Dio dio = Dio();
    updateSearch(APIRequestStatus.loading);
    var res = await dio
        .get('https://catalog.feedbooks.com/search.atom?query=' + palabraBuscar)
        .catchError((e) {
      throw (e);
    });
    print(res);

    if (res.statusCode == 200) {
      Xml2Json xml2json = new Xml2Json();
      xml2json.parse(res.data.toString());
      var json = jsonDecode(xml2json.toGData());
      categoryFeed = CategoryFeed.fromJson(json);
      updateSearch(APIRequestStatus.loaded);
    } else {
      updateSearch(APIRequestStatus.error);
      throw ('Error ${res.statusCode}');
    }
    return categoryFeed;
  }

  void updateSearch(APIRequestStatus temp) {
    setState(() {
      statusRequest = temp;
    });
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.blueAccent),
        padding: new EdgeInsets.all(20.0),
        child: Row(children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(color: Colors.white),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
              ],
              controller: txtController,
              decoration: InputDecoration(
                fillColor: Colors.white,

                hintText: "Ingresar busqueda",
                hintStyle: TextStyle(color: Colors.white),
                // border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                palabraBuscar = txtController.text;
              });
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.find_in_page),
          //   onPressed: () {
          //     setState(() {
          //       advanced = true;
          //       palabraBuscar = "";
          //       txtController.text = "";
          //     });
          //   },
          // ),
        ]),
      ),
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      palabraBuscar = newQuery;
    });
  }

  _buildNewSection(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      primary: false,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categoryFeed?.feed?.entry?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        Entry entry = categoryFeed.feed.entry[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: BookListItem(
            img: entry.link[1].href,
            title: entry.title.t,
            author: entry.author.name.t,
            desc: entry.summary.t,
            entry: entry,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBar(
        height: advanced == true ? 170 : 65,
        buildEmailTF: _buildSearchBox(),
        advanced: advanced,
      ),
      body: palabraBuscar.isEmpty
          ? null
          : FutureBuilder(
              future: advanced == false ? getSearch() : getAuthor(),
              initialData: [],
              builder: (context, snapshot) {
                return _buildNewSection(context, snapshot);
              }),
    );
  }
}

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final buildAdvancedSearchTF;
  final advanced;
  final buildEmailTF;

  const MyCustomAppBar({
    Key key,
    @required this.height,
    this.buildAdvancedSearchTF,
    this.advanced,
    this.buildEmailTF,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [advanced == true ? buildAdvancedSearchTF : buildEmailTF],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + 200);
}
