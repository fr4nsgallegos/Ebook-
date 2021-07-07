import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ebook_app/components/book_list_item.dart';
import 'package:flutter_ebook_app/models/category.dart';
import 'package:flutter_ebook_app/util/enum/api_request_status.dart';
import 'package:xml2json/xml2json.dart';

class SearchAdvanceScreen extends StatefulWidget {
  SearchAdvanceScreen({Key key}) : super(key: key);

  @override
  _SearchAdvanceScreenState createState() => _SearchAdvanceScreenState();
}

class _SearchAdvanceScreenState extends State<SearchAdvanceScreen> {
  bool advanced = false;
  APIRequestStatus statusReque;
  CategoryFeed category;
  String filtro = "titulos";
  String categoria = "todas";
  String s = "";
  String author = "autor";
  String idioma = "idiomas";
  final categories = {
    'shortStory': 'cat=FBFIC029000',
    'sciFi': 'cat=FBFIC028000',
    'actionAdventure': 'cat=FBFIC002000',
    'mystery': 'cat=FBFIC022000',
    'romance': 'cat=FBFIC027000',
    'horror': 'cat=FBFIC015000',
  };

  final queryController = TextEditingController();
  final autorController = TextEditingController();

  Widget _buildAdvancedSearchTF() {
    return Container(
      padding: new EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Wrap(children: [
        /*Container(
            width: 220,
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
              ],
              controller: queryController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search Data...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              //onChanged: (query) => updateSearchQuery(query),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                s = queryController.text;
              });
            },
          ),*/
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                ],
                controller: queryController,
                decoration: InputDecoration(
                  hintText: "Ingresar titulo",
                  hintStyle: TextStyle(
                    color: Colors.black.withAlpha(120),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black.withAlpha(120),
              ),
              onPressed: () {
                setState(() {
                  s = queryController.text;
                  autorController.text == null
                      ? author = "autor"
                      : author = autorController.text;
                  idioma = idioma;
                });
              },
            ),
            // IconButton(
            //   icon: Icon(Icons.find_in_page),
            //   onPressed: () {
            //     setState(() {
            //       advanced = false;
            //       s = "";
            //       queryController.text = "";
            //       author = "";
            //     });
            //   },
            // ),
          ],
        ),
        ListTile(
          title: Text("Idioma"),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          trailing: DropdownButton<String>(
            items: <String>['en', 'es', 'todos'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text("idioma"),
            onChanged: (value) {
              setState(() {
                idioma = value;
              });
            },
            value: idioma == 'idiomas' ? 'todos' : idioma,
          ),
        ),
        SizedBox(
          width: 25,
        ),
        ListTile(
          title: Text("Seleccionar categoria"),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: false,
              value: categoria,
              items: <String>[
                'todas',
                'shortStory',
                'sciFi',
                'actionAdventure',
                'mystery',
                'romance',
                'horror'
              ].map((item) {
                return new DropdownMenuItem<String>(
                  child: Container(
                    width: 150, //expand here
                    child: new Text(
                      item,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  value: item,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  categoria = value;
                });
              },
              hint: Container(
                width: 150, //and here
                child: Text(
                  "Select categoria Type",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.end,
                ),
              ),
              style:
                  TextStyle(color: Colors.black, decorationColor: Colors.red),
            ),
          ),
        ),
        TextField(
          keyboardType: TextInputType.visiblePassword,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
          ],
          controller: autorController,
          decoration: InputDecoration(
            hintText: "Ingresar Autor ",
            hintStyle: TextStyle(
              color: Colors.black.withAlpha(120),
            ),
            border: InputBorder.none,
          ),
        ),

        /*DropdownButton<String>(
            items: <String>['shortStory', 'sciFi', 'actionAdventure', 'mystery', 'romance', 'horror'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: categoria=='nada'?true: categoria,
            hint: Text("Seleccionar categoria"),
            onChanged: (value) {
              setState(() {
                categoria=value;
              });
            },
            
          ),*/
      ]),
    );
  }

  void updateSearch(APIRequestStatus temp) {
    setState(() {
      statusReque = temp;
    });
  }

  Future<CategoryFeed> getSearchAdvance() async {
    print("entrando a getsearchadvance");
    Dio dio = Dio();
    updateSearch(APIRequestStatus.loading);
    String url = 'https://catalog.feedbooks.com/search.atom?';
    print(filtro);
    print(categoria);
    print(idioma);
    print(author);
    if (filtro != 'titulo' || filtro != 'titulos') {
      url = url + 'query=' + s;
    }

    if (categoria != 'todas') {
      url = url + '&' + categories[categoria];
    }
    if (author != "autor" || author == "") {
      url = url + '&' + 'author=' + author;
    }
    if (idioma != "idioma" || idioma != "idiomas") {
      if (idioma == "idiomas") {
        url = url;
      } else {
        url = url + '&' + 'lang=' + idioma;
      }
    }
    var res = await dio.get(url).catchError((e) {
      throw (e);
    });
    print("aquiiiiiiiiii");
    print(url);
    print(res);

    if (res.statusCode == 200) {
      Xml2Json xml2json = new Xml2Json();
      xml2json.parse(res.data.toString());
      var json = jsonDecode(xml2json.toGData());
      category = CategoryFeed.fromJson(json);
      updateSearch(APIRequestStatus.loaded);
    } else {
      updateSearch(APIRequestStatus.error);
      throw ('Error ${res.statusCode}');
    }
    return category;
  }

  _buildNewSection(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      primary: false,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: category?.feed?.entry?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        Entry entry = category.feed.entry[index];

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
      appBar: AppBar(),
      body: Column(
        children: [
          _buildAdvancedSearchTF(),
          Expanded(
            child: s.isEmpty & author.isEmpty
                ? Container()
                : FutureBuilder(
                    future: getSearchAdvance(),
                    //  getAuthor(),
                    initialData: [],
                    builder: (context, snapshot) {
                      return _buildNewSection(context, snapshot);
                    }),
          )
        ],
      ),
    );
  }
}
