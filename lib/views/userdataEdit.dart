import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:http/http.dart' as http; 

class UserEdit extends StatefulWidget {

  final String email;

  UserEdit(this.email);
   
  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  
   List userdataList = new List();
 
  final nomeedit = TextEditingController();
  final emailedit = TextEditingController();
  final numeroedit = TextEditingController();
  final moradaedit = TextEditingController();
  final localizacaoedit = TextEditingController();
  bool isloading = false;
  @override
  void initState() {
    super.initState();

    getUserData(widget.email);

  }



  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        title: Text("Editar Conta"),
      ),
      body: SingleChildScrollView(child:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(height: 40,),
              Badge(
                position: BadgePosition.topEnd(),
                badgeColor:Colors.white,
                badgeContent:Icon(Icons.edit,color: primaryColor,),
                child:Container(
                width: 150,
                height: 150,
              decoration: BoxDecoration(
                color:Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(image: NetworkImage("https://png.pngtree.com/png-vector/20191003/ourmid/pngtree-user-login-or-authenticate-icon-on-gray-background-flat-icon-ve-png-image_1786166.jpg"),fit: BoxFit.cover)
              ),
              ),),
              
               SizedBox(height: 10,),
              inputlista("Carregando...",false,nomeedit,Icons.person),
               SizedBox(height: 10,),
              inputlista("Carregando...",false,emailedit,Icons.alternate_email),
               SizedBox(height: 10,),
              inputlista("Carregando...",false,numeroedit,Icons.phone),
               SizedBox(height: 10,),
              inputlista("Carregando...",false,moradaedit,Icons.pin_drop),
                SizedBox(height: 10,),
              loginButton("Alterar Senha",Colors.grey,Colors.white,(){

              }),
                 SizedBox(height: 20,),
                loginButton("Gravar Alterações",primaryColor,Colors.white,(){
              })
            ],
          ),
      ),
    ));
  }


  Widget inputlista(String label,bool isObcure,TextEditingController controller,IconData icon){
  return Padding(
    padding: EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 10),
    child:TextField(
    controller: controller,
    style: TextStyle(fontSize: 15.0, color: Colors.black),
    textAlign: TextAlign.center,
    obscureText: isObcure,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      hintText: '$label',
      hintStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold,fontSize: 20),
      fillColor: Color.fromRGBO(237, 237, 237,1),
      filled: true,
      contentPadding: const EdgeInsets.all(20.0),
      border:OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(5.0),),
    ),

    ),
  )
  );

}

  Widget loginButton(String labelText,Color cor,Color corTexto,Function submit){
  return SizedBox(
          width: MediaQuery.of(context).size.width-40, //Full width
          height: 60,
    child:FlatButton(
       color: cor,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed:() async{
        submit();
       FocusScopeNode currentFocus = FocusScope.of(context);
       if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
    },
   padding:EdgeInsets.all(0.0),
   child:isloading? SpinKitWave(color: Colors.white,size: 40.0,):
   Text("$labelText",style: TextStyle(color:corTexto, fontSize: 13, fontWeight: FontWeight.bold),),
 )
   );
}

 getUserData(String email) async{
  final response =await http.get("https://www.visualfoot.com/api/getUserData.php?email=$email");
    if (response.statusCode == 200) {
      userdataList = json.decode(response.body) as List;
      
       setState(() {
          nomeedit.text = userdataList[0]['nome']+' '+ userdataList[0]['sobrenome'];
          emailedit.text = userdataList[0]['email'];
          numeroedit.text = userdataList[0]['telemovel'];
          moradaedit.text = userdataList[0]['morada'];
       });

    } else {
      throw Exception('Failed to load photos');
    }
 }


}