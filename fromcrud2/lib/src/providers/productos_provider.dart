import 'dart:convert';
import 'dart:io';

import 'package:fromcrud2/src/models/producto_model.dart';
import 'package:fromcrud2/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

import 'package:http_parser/http_parser.dart'; //para el mediatype

class ProductosProvider {
  final String _url = 'https://flutter-proycts-default-rtdb.firebaseio.com';
  final _pref = new PreferenciasUsuario();
  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_pref.token}';

    final resp = await http.post(url, body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    //print(decodedData);
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_pref.token}';

    final resp = await http.put(url, body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    //print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_pref.token}';
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);

    final List<ProductoModel> productos = new List();

    //print(decodedData);
    if (decodedData == null) return [];

    decodedData.forEach((id, producto) {
      final prodTemp = ProductoModel.fromJson(producto);
      prodTemp.id = id;

      productos.add(prodTemp);
    });
    //print(productos[0].id);
    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/prodcutos/$id.json?auth=${_pref.token}';
    final resp = await http.delete(url);
    print(json.decode(resp.body));
    return 1;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dum0cdxqf/image/upload?upload_preset=eyagvpob');
    final mimeType = mime(imagen.path).split('/'); // imagen/jpg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    imageUploadRequest.files
        .add(file); //repitiendo esta linea se pueden subir multiples archivos
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }
    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}
