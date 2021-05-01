import 'package:flutter_ebook_app/models/usuario.dart';
import 'package:retrofit/retrofit.dart';

import 'package:dio/dio.dart' hide Headers;
import '../main.dart';

part 'ebook_api.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:3000/api/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("usuario/{id}")
  Future<List<Usuario>> getUsuario(@Path() String id);
}
