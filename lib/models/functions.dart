
import 'package:http/http.dart';
import 'package:kioxkef/models/database.dart';
import 'offinedabase.dart';
   
saveList(String id,String nome,String descricao,String preco,String imageUrl,String fileSrc,String pathName,String idident,int tipo) async {
     
    List<Map<String,dynamic>> queryRowsCard = new List<Map<String,dynamic>>();
    queryRowsCard = await DatabaseHelper.instance.queryAll(1);

    for(int a=0;a < queryRowsCard.length;a++){
        if(queryRowsCard[a]['nome'] == nome){
          DatabaseHelper.instance.valuesupdate(queryRowsCard[a]['id'],queryRowsCard[a]['quantidade']+1);
          return;
        }
    }
       
    int i = await DatabaseHelper.instance.insert({
      'nome':''+nome.toString(),
      'descricao':descricao.toString(),
      'preco':preco.toString(),
      'imageUrl':imageUrl.toString(),
      'pathName':pathName.toString(),
      'tipo':tipo,
      'idident':idident.toString(),
      'quantidade':1
      });
      print('valor inserido:$i');
  }


saveListLocalBook(String nomeBook,String imgLink,String bookLink) async {
     int i = await DatabaseHelperLocal.instance.insert({
      'nomeBook':nomeBook.toString(),
      'imgLink':imgLink,
      'bookLink':bookLink.toString(),
      });
      print('valor inserido->:$i'+imgLink);
}

updateview(int id) async {
  String url = 'https://www.visualfoot.com/api/views/?id=$id';
  Response response = await get(url);
  // sample info available in response
  int statusCode = response.statusCode;
  Map<String, String> headers = response.headers;
  String contentType = headers['content-type'];
  String json = response.body;

}


