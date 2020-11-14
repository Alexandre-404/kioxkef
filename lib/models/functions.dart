
import 'dart:io';
import 'package:http/http.dart';
import 'package:kioxkef/models/database.dart';
import 'package:kioxkef/util/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

   
  saveList(String id,String nome,String descricao,String preco,String imageUrl,String fileSrc,String pathName,String idident,int tipo) async {
     int i = await DatabaseHelper.instance.insert({
      'nome':''+nome.toString(),
      'descricao':descricao.toString(),
      'preco':preco.toString(),
      'imageUrl':imageUrl.toString(),
      'pathName':pathName.toString(),
      'tipo':tipo,
      'idident':idident.toString()
      });
      print('valor inserido:$i');
  }
  

updateview(int id) async {
  String url = 'https://www.visualfoot.com/api/views/?id=$id';
  Response response = await get(url);
  // sample info available in response
  int statusCode = response.statusCode;
  Map<String, String> headers = response.headers;
  String contentType = headers['content-type'];
  String json = response.body;
  print(json);
}

   
  // saveList(String id,String nome,String descricao,String preco,String imageUrl,String fileSrc,String pathName,String idident) async {
  //        Directory appDocDir = Platform.isAndroid? await getExternalStorageDirectory():await getApplicationDocumentsDirectory();

  //   if (Platform.isAndroid) {
  //        Directory(appDocDir.path.split('Android')[0] + '${Constants.appName}/$pathName/').createSync();
  //   }else{
  //        Directory(appDocDir.path + '/$pathName/').createSync();
  //   }

  //   String path = Platform.isIOS
  //       ? appDocDir.path + '/$pathName/$id'+'$idident.txt'
  //       : appDocDir.path.split('Android')[0]+'${Constants.appName}/$pathName/'+'$id'+'$idident.txt';

  //       final file = File(path);
  //       final text = '$id|$nome|$descricao|$preco|$imageUrl|$fileSrc';
  //       await file.writeAsString(text);
  //       print(file.path+'\n saved');
  // }