import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:kioxkef/components/download_alert.dart';
import 'package:kioxkef/models/functions.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:kioxkef/util/const.dart';
import 'package:kioxkef/views/Cardcompras.dart';
import 'package:kioxkef/views/paySucess.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Pay extends StatefulWidget {

  @override
  _PayState createState() => _PayState();
  final String url,nome,id,capa,preco,titulo,descricao;
  Pay(this.url,this.nome,this.id,this.capa,this.preco,this.titulo,this.descricao);
}

class _PayState extends State<Pay> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _path;
  Future<bool> _isonCard;

  bool concluido = false,isonCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: primaryColor,
       title: Text("Pagamento"),
         actions: [
             Icon(Icons.more_vert,color: Colors.white,)
          ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
      child:Column(
        mainAxisSize: MainAxisSize.max,
        children: [
           pageTitle("Detalhes do Produto",context),
          _horiBox(widget.titulo,widget.capa,widget.preco),
           pageTitle("Método de Pagamento",context),
          cardList(Colors.grey,"Paypal","****@gmail.com"),
          cardList(primaryColor,"Referência Multcaixa","****@gmail.com"),
           cardList(Colors.grey,"Transferência Bancária","IBAN: 832 749 832 8974"),
            cardList(Colors.grey,"Mastercard","****@gmail.com"),

            Expanded(
              child:Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                loginButton("Adicionar no Carrinho",Colors.green,false, () async => setCarrinho()),
                loginButton("Continuar",primaryColor,true, () async => startDownload(widget.url,widget.nome))
              ],
            )
          )
          
        ],
       )
      ),
    );
  }

Widget cardList(Color cor,String label,String email){
  return Card(
    elevation:0.5,
    shadowColor:Colors.grey[800],
    child: ListTile(
      title: Text("$label"),
      subtitle: Text("$email"),
      trailing: Icon(Icons.add_circle_outline,color: cor,),
      onTap: (){

      },
    ),
  
  );
}
Widget _horiBox(String titulo,String imageUrl,String preco){
  FlutterMoneyFormatter precoProduto = FlutterMoneyFormatter(amount: double.parse(preco));
  return  GestureDetector(
    onTap:(){
     
    },
    child:
  Card( 
  color: Colors.white,
  borderOnForeground:true,
  shadowColor:Colors.grey[100],
  child:CachedNetworkImage(
    imageUrl: "$imageUrl",
    imageBuilder: (context, imageProvider) => Container(
    width: MediaQuery.of(context).size.width,
    height: 110,
    child: Row(
      children: [
        Container(
          width: 130,
          height: 150,
         decoration: BoxDecoration(
           borderRadius:BorderRadius.all(Radius.circular(10)),
           image: DecorationImage(image: imageProvider,fit: BoxFit.cover,),
        ),
        ),
        
        Expanded(
          child:Container(
          width: 200,
          height: 200,
          padding:EdgeInsets.all(15),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child:RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        style:subtitle,
                        text: "$titulo"),
                  ),
                ),

                Text((precoProduto.output.nonSymbol != "0.00"?precoProduto.output.nonSymbol+"AOA":"Gratuito"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: precoProduto.output.nonSymbol != "0.00"?primaryColor:Colors.green),),

            ],
          ),
        )

        )
      ],
    ),
  ),
  placeholder: (context, url) => shimerEfect(context),
    errorWidget: (context, url, error) => Icon(Icons.error),
  )));
 }

void setCarrinho() async{
  final SharedPreferences prefs = await _prefs;
   setState(() {
       saveList(widget.id,widget.titulo,widget.descricao,widget.preco,widget.capa,widget.url,"carrinho","carrinho",1);
       isonCard =  !isonCard;
        _isonCard = prefs.setBool(widget.titulo+'_carrinho', isonCard).then((bool success) {
        return isonCard;
        });
   });

  Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (context)=> CardCompras()));

  }

Widget loginButton(String labelText,Color cor,bool isSubmited,Function callback){
  return Padding(padding: EdgeInsets.all(10),
  child:SizedBox(
          width: MediaQuery.of(context).size.width-20, //Full width
          height: 60,
    child:FlatButton(
       color: cor,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed:() async{
      //  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>  MainPage()),(Route<dynamic> route) => false);
      callback();
    },
   padding:EdgeInsets.all(0.0),
   child:
   Text("$labelText",style: TextStyle(color:Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)
 )
   ));
}

startDownload(String url, String filename) async {

      Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (Platform.isAndroid) {
      Directory(appDocDir.path.split('Android')[0] + '${Constants.appName}').createSync();
    }

    String path = Platform.isIOS
        ? appDocDir.path + '/$filename.epub'
        : appDocDir.path.split('Android')[0] +
            '${Constants.appName}/$filename.epub';

    print(path);
    File file = File(path);
    if (!await file.exists()) {
      await file.create();
        concluido = true;

    } else {
      await file.delete();
      await file.create();
      concluido = true;
       
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: url,
        path: path,
      ),
    ).then((v) async {

     final SharedPreferences prefs = await _prefs;
     final String pathaved = path;
      if (v != null) {
        setState(() {
          concluido = true;
        _path = prefs.setString(filename, pathaved).then((bool success) {
          return pathaved;
        });

      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context) => PaySucess(pathaved, widget.nome,widget.id,widget.capa,widget.preco,widget.titulo)));

      });
     }
    });
  }
}
