// To parse this JSON data, do
//
//     final categoriaFav = categoriaFavFromJson(jsonString);

import 'dart:convert';

List<CategoriaFav> categoriaFavFromJson(String str) => List<CategoriaFav>.from(
    json.decode(str).map((x) => CategoriaFav.fromJson(x)));

String categoriaFavToJson(List<CategoriaFav> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriaFav {
  CategoriaFav({
    this.label,
    this.term,
    this.scheme,
  });

  String label;
  String term;
  String scheme;

  factory CategoriaFav.fromJson(Map<String, dynamic> json) => CategoriaFav(
        label: json["label"],
        term: json["term"],
        scheme: json["scheme"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "term": term,
        "scheme": scheme,
      };
}
