import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:kioxkef/components/Endrawer.dart';
import 'package:kioxkef/components/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:kioxkef/models/database.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:kioxkef/util/const.dart';
import 'package:kioxkef/views/detalhes.dart';
import 'package:kioxkef/views/tabs.dart';
import 'package:path_provider/path_provider.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
  final String nome,email;
  HomeView(this.nome,this.email);
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PageController pageviewController = new PageController();
  List<Map<String,dynamic>> desejolist = new List<Map<String,dynamic>>();
  List<Map<String,dynamic>> carrinhodata = new List<Map<String,dynamic>>();

  int _selectedIndex = 0;

   @override
  void initState() {
    super.initState();
    _fetchData();
    getTotalDb();
  }

List list = List();

List destaques = List();

var isLoading = false;
  @override
  Widget build(BuildContext context) {
    getTotalDb();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: primaryColor,
       title: Text("Kioxke"),
       leading:  IconButton(icon: Icon(Icons.sort), onPressed: () => _scaffoldKey.currentState.openDrawer(),),
       actions: [

           FlatButton(
             onPressed:() => _scaffoldKey.currentState.openEndDrawer(),
             child:Badge(
             position: BadgePosition.topEnd(),
             badgeColor:Colors.white,
             badgeContent: Text((desejolist.length).toString()),
             child: Icon(Icons.more_vert,color: Colors.white,),
            )
            ),

        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection:Axis.horizontal,
        controller: pageviewController,
        children: [
          _homeView(),
          Tabs()
        ],
      ),

     bottomNavigationBar: BottomNavigationBar(
       type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon:  Icon(Feather.home),
          title: Text('Inicio'),
        ),
        BottomNavigationBarItem(
          icon:Icon(Feather.book),
          title: Text('Livros'),
        ),
        BottomNavigationBarItem(
          icon:Icon(Feather.image),
          title: Text('Revistas'),
        ),
         BottomNavigationBarItem(
         icon:Icon(Feather.book_open),
          title: Text('Jornais'),
        ),
         BottomNavigationBarItem(
          icon:Icon(Feather.layout),
          title: Text('BD'),
        ),
      ],
      currentIndex: _selectedIndex, 
      selectedItemColor: primaryColor,
      onTap: _onItemTapped,
    ),
     drawer: DrawerPage(widget.nome,pageviewController,widget.email),
     endDrawer: EndDrawerPage(widget.nome,carrinhodata.length.toString()),
    );
  }

Widget _homeView(){
  return SingleChildScrollView(
        child:Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
           pageTitle("Destaques",context),
           Container(
            width: MediaQuery.of(context).size.width,
            height: 240,
             child: ListView.builder(
               scrollDirection: Axis.horizontal,
                itemCount: destaques.length,
                itemBuilder: (BuildContext context, int index) {
                  return verticalBox(context,destaques[index]['titulo'],destaques[index]['capa'],destaques[index]['autor'],destaques[index]['likes'],destaques[index]['src'],destaques[index]['preco'],destaques[index]['descricao'],destaques[index]['id']);
                })
             ),

        pageTitle("Mais Acessados",context),

         Container(
            width: MediaQuery.of(context).size.width,
            height: 190 * double.parse(list.length.toString()),
             child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return horizontalBox(context,list[index]['titulo'],list[index]['capa'],list[index]['autor'],list[index]['likes'],list[index]['src'],list[index]['preco'],list[index]['descricao'],list[index]['id']);
                })
         )
       ],

        )
      )
    );
}


void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
    pageviewController.jumpToPage(index);
  });
}


_fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("https://www.visualfoot.com/api/acessos.php?tipo=populares");
    if (response.statusCode == 200) {
      list = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }

     final dataget = await http.get("https://www.visualfoot.com/api/?catType=Livros");
    if (dataget.statusCode == 200) {
      destaques = json.decode(dataget.body) as List;

      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }

  }


 void getTotalDb() async{
    desejolist = await DatabaseHelper.instance.queryAll(0);
    carrinhodata= await DatabaseHelper.instance.queryAll(1);
    setState(() {
      
    });
 }

}