import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:http/http.dart' as http;

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {

  List colecao = new List();
  List populares = new List();
  List maislidos = new List();

 bool isLoading = false;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _fetchDataH();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
  length: 3,
  child: Scaffold(
    appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child:TabBar(
          labelColor: Colors.black,
          indicatorColor:primaryColor,
        tabs: [
          Tab(text: "Todos",),
          Tab(text: "Populares",),
          Tab(text: "Categorias",),
        ],
      ),
    ),
  
  body: TabBarView(
  children: [
    _boxView(context,"Coleção","Populares","Mais Lidos"),
    _boxView(context,"Mais Populares","Mais Recentes","Mais Lidos"),
    Icon(Icons.warning),
  ],    
    ),
  ),
  
); 
  }

Widget _boxView(BuildContext context, String titulo1,String titulo2,String titulo3){
  return SingleChildScrollView(
        child:Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
           pageTitle("$titulo1",context),
           
           Container(
            width: MediaQuery.of(context).size.width,
            height: 240,
             child: ListView.builder(
             scrollDirection: Axis.horizontal,
                itemCount: colecao.length,
                itemBuilder: (BuildContext context, int index) {
                  return colecao.length > 0? verticalBox(context,colecao[index]['titulo'],colecao[index]['capa'],colecao[index]['autor'],colecao[index]['likes'],colecao[index]['src'],colecao[index]['preco'],colecao[index]['descricao'],colecao[index]['id']):SizedBox();
                })
             ),

         pageTitle("$titulo2",context),
             Container(
            width: MediaQuery.of(context).size.width,
            height: 240,
             child: ListView.builder(
             scrollDirection: Axis.horizontal,
                itemCount: populares.length,
                itemBuilder: (BuildContext context, int index) {
                  return populares.length > 0?verticalBox(context,populares[index]['titulo'],populares[index]['capa'],populares[index]['autor'],populares[index]['likes'],populares[index]['src'],populares[index]['preco'],populares[index]['descricao'],populares[index]['id']):SizedBox();
                })
             ),
         pageTitle("$titulo3",context),
             Container(
            width: MediaQuery.of(context).size.width,
            height: 240,
             child: ListView.builder(
             scrollDirection: Axis.horizontal,
                itemCount: maislidos.length,
                itemBuilder: (BuildContext context, int index) {
                  return maislidos.length > 0?verticalBox(context,maislidos[index]['titulo'],maislidos[index]['capa'],maislidos[index]['autor'],maislidos[index]['likes'],maislidos[index]['src'],maislidos[index]['preco'],maislidos[index]['descricao'],maislidos[index]['id']):SizedBox();
                })
             ),
          ])
          )
        );
}


_fetchDataH() async {
    setState(() {
      isLoading = true;
    });
    final response =await http.get("https://www.visualfoot.com/api/acessos.php?tipo=colecao");
    if (response.statusCode == 200) {
      colecao = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }

    final popularesBody =await http.get("https://www.visualfoot.com/api/acessos.php?tipo=populares");
    if (popularesBody.statusCode == 200) {
      populares = json.decode(popularesBody.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }

    final maislidosBody =await http.get("https://www.visualfoot.com/api/acessos.php?tipo=maislidos");
    if (maislidosBody.statusCode == 200) {
      maislidos = json.decode(maislidosBody.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }


  }

}