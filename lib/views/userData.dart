import 'dart:io';
import 'dart:io' as io;
import 'package:epub/epub.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:kioxkef/util/const.dart';
import 'package:kioxkef/views/userdataEdit.dart';
import 'package:path_provider/path_provider.dart';

class UserData extends StatefulWidget {
  final String nome;
  final String email;
  UserData(this.nome,this.email);

  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {


      List file = new List();

      @override
      void initState() {
        super.initState();
        _listofFiles();
      }


    void _listofFiles() async {
            Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (Platform.isAndroid) {
      Directory(appDocDir.path.split('Android')[0] + '${Constants.appName}').createSync();
    }

    String path = Platform.isIOS?appDocDir.path:
    appDocDir.path.split('Android')[0]+'${Constants.appName}/';
    //  ByteData bytes = await rootBundle.load(path);
    //  final buffer = bytes.buffer;
    //  List<int> listint = buffer.asInt8List(bytes.offsetInBytes,bytes.lengthInBytes);
     
        setState(() {
          file = Directory(path).listSync(followLinks:true);  //use your folder name insted of resume.
        });
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: primaryColor,
       title: Text("Minha Conta"), 
      ),
      body: SingleChildScrollView(child:Column(
        children: [

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/3,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage("https://png.pngtree.com/png-vector/20191003/ourmid/pngtree-user-login-or-authenticate-icon-on-gray-background-flat-icon-ve-png-image_1786166.jpg"),fit: BoxFit.cover)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Container(
                  padding: EdgeInsets.all(10),
                 width: MediaQuery.of(context).size.width,
                 height:100,
                 color: Color.fromRGBO(0, 0, 0,.7),
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                       Text(widget.nome.replaceAll('"',''),style: TextStyle(color:Colors.white,fontSize: 20),),
                        ListTile(
                          title:Text("Editar Conta ",style: TextStyle(color:Colors.white,fontSize: 15),),
                          leading: Icon(Icons.edit,color: Colors.amber),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context) => UserEdit(widget.email)));
                          },
                        ),

                   ],
                 ),
                ),
               
                ],
            ),
          ),

         pageTitle("Minha Biblioteca",context),
          Container(
            width: MediaQuery.of(context).size.width,
            height:260,
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: file.length,
                itemBuilder: (BuildContext context, int index){
                //return  listTile(file[index]);
                return file[index].toString().contains(".epub")?FutureBuilder<Widget>(
                future: listTile(file[index]),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot){
                    if(snapshot.hasData)
                      return snapshot.data;

                      return SpinKitWave(
                          color: primaryColor,
                          size: 30.0,
                          );
                      }

                    ):Text("");
                  }),
            ),
            



        ],
      )
    ));
  }


Future<Widget> listTile(File src) async{
  var targetFile = new io.File(src.path);
    List<int> bytes = await targetFile.readAsBytes();
    EpubBook epubBook = await EpubReader.readBook(bytes);
 return savedverticalBox(context,"https://www.visualfoot.com/api/files/eca-2019.jpg",epubBook.Title,(){
   openBook(src.path);
 });
  // onTap: (){
  //   
  // },

}

  openBook(String src) async{
    if (src.isNotEmpty) {
        EpubViewer.setConfig(
                identifier: 'androidBook',
                themeColor: Theme.of(context).accentColor,
                scrollDirection: EpubScrollDirection.HORIZONTAL,
                enableTts: false,
                allowSharing: true,
              );

            EpubViewer.open(
            src,lastLocation:EpubLocator.fromJson({
              "bookId": "2239",
              "href": "/OEBPS/ch06.xhtml",
              "created": 1539934158390,
              "locations": {
                "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
              }
            }), // first page will open up if the value is null
          );
    }

  }

}