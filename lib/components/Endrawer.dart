import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:kioxkef/views/Cardcompras.dart';
import 'package:kioxkef/views/desejosLista.dart';
import 'package:kioxkef/views/searchPage.dart';


class EndDrawerPage extends StatelessWidget {
    
    final String nomeUser,cartTotalProduts;
    EndDrawerPage(this.nomeUser,this.cartTotalProduts);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("images/pattner.jpg"),fit:BoxFit.cover)
            ),
            child: FlatButton(onPressed: (){
               Navigator.pop(context);
               Navigator.push(context,MaterialPageRoute(builder: (context) => CardCompras()));
            }, child:Column(
               mainAxisAlignment: MainAxisAlignment.end,
               crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Badge(
                  position: BadgePosition.topEnd(),
                  badgeColor:Colors.red,
                  badgeContent: Text((cartTotalProduts).toString(),style: TextStyle(color: Colors.white),),
                  child: Icon(Icons.shopping_cart,size: 80, color: Colors.white,),
                  ),
               
                 Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  alignment: Alignment.centerRight,
                      child:Text("Ver Carrinho",style: TextStyle(color: Colors.white, fontSize: 20))
                      )
                 ],
            ),)

          ),
           listItem("Procura",Feather.search,(){
            Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (context) => Pesquisa()));
           }),
         listItem("Lista de Desejos",Feather.flag,(){
             Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (context) => WishlistWidget()));
         }),
         listItem("Biblioteca",Feather.bookmark,(){}),
         listItem("Historico",Icons.history,(){}),
        ],

      ),

    );
  }

  Widget listItem(String titulo,IconData iconPrefix,Function submit){
    return ListTile(
            title: Text("$titulo"),
            trailing:Icon(iconPrefix),
            onTap: (){
              submit();
            },
      );
  }
}