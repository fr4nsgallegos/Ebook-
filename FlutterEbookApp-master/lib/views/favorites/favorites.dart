import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ebook_app/components/book.dart';
import 'package:flutter_ebook_app/models/category.dart';
import 'package:flutter_ebook_app/session/session_heper.dart';
import 'package:flutter_ebook_app/util/router.dart';
import 'package:flutter_ebook_app/view_models/favorites_provider.dart';
import 'package:flutter_ebook_app/views/favorites/mobile_pdf.dart';
import 'package:flutter_ebook_app/views/genre/genre.dart';
import 'package:flutter_ebook_app/views/genre/genre_fav.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
    'FBFIC029000': 'shortStory',
    'FBFIC028000': 'sciFi',
    'FBFIC002000': 'actionAdventure',
    'FBFIC022000': 'mystery',
    'FBFIC027000': 'romance',
    'FBFIC015000': 'horror',
    'FBFIC000000': 'fiction',
    'FBFIC019000': "Litearary",
    'FBFIC009000': "Fantasy",
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
    auxList.forEach((element) {
      count[element] = count.containsKey(element) ? count[element] + 1 : 1;
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

  // final pdf = pw.Document();
  Future<void> hacerPDF() async {
    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Center(
    //         child: pw.Text("Hello World"),
    //       ); // Center
    //     },
    //   ),
    // );
    // final output = await getTemporaryDirectory();

    PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 30;
    final page = document.pages.add();
    // page.graphics.drawString(
    //     "FRANS GALLEGOS MENDOZA", PdfStandardFont(PdfFontFamily.helvetica, 30));
    PdfSection section = document.sections.add();
    section.pageSettings.rotate = PdfPageRotateAngle.rotateAngle0;
    section.pageSettings.size = const Size(300, 400);

//Draw simple text on the page
    section.pages.add().graphics.drawString(
        'Rotated by 0 degrees', PdfStandardFont(PdfFontFamily.helvetica, 15),
        brush: PdfBrushes.black, bounds: const Rect.fromLTWH(20, 20, 0, 0));
    double top = 40;

    SessionHelper().favoriteListPdf.forEach((element) {
      String text = "${element.title} con la categoria: ${element.category}";
      page.graphics.drawString(
          text, PdfStandardFont(PdfFontFamily.helvetica, 15),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(40, top + 15, 500, 40),
          format: PdfStringFormat(
              textDirection: PdfTextDirection.rightToLeft,
              alignment: PdfTextAlignment.right,
              paragraphIndent: 35));
    });
    page.graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: Rect.fromLTWH(40, 40, 500, 40));

    // String text =
    //     'asdasdasdasdasd asasd asd asdku hasi hasidh asiuhdask jhasdlk jaslidj ashd asiuh daskjh daskuh dasikuh dasikuhd asku haskudh askuhd askudh askudh askduh';

//Draw text

    List<int> bytes = document.save();
    document.dispose();
    saveAndLaunchFile(bytes, 'OUT.pdf');
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
  String txtMasFav;
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
                          "https://catalog.feedbooks.com/publicdomain/browse/top.atom?cat?+${favoritosList[index].term}";

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
                  "https://catalog.feedbooks.com/publicdomain/browse/top.atom?cat?+$nombreMasFav";
              MyRouter.pushPage(
                context,
                GenreFav(
                  title: "LIBROS RECOMENDADOS ${categories[nombreMasFav]}",
                  url: urlMasFav,
                ),
              );
            },
            child: Text("LIBROS RECOMENDADOS ${categories[nombreMasFav]}"),
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            color: Colors.blueAccent,
            onPressed: () {
              hacerPDF();
            },
            child: Text("Generar PDF"),
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics.drawString('Welcome to PDF Succinctly!',
        PdfStandardFont(PdfFontFamily.helvetica, 30));

    page.graphics.drawImage(
        PdfBitmap(await _readImageData('Pdf_Succinctly.jpg')),
        Rect.fromLTWH(0, 100, 440, 550));

    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 30),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Roll No';
    header.cells[1].value = 'Name';
    header.cells[2].value = 'Class';

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = '1';
    row.cells[1].value = 'Arya';
    row.cells[2].value = '6';

    row = grid.rows.add();
    row.cells[0].value = '2';
    row.cells[1].value = 'John';
    row.cells[2].value = '9';

    row = grid.rows.add();
    row.cells[0].value = '3';
    row.cells[1].value = 'Tony';
    row.cells[2].value = '8';

    grid.draw(
        page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'Output.pdf');
  }
}

Future<Uint8List> _readImageData(String name) async {
  final data = await rootBundle.load('images/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
