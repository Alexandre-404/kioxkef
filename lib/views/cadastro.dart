import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  bool isloading = false;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
   Future<String> _email,_nome;


  final _nomeUsuario = TextEditingController();
   final _sobrenomeUsuario = TextEditingController();
  final _emailController = TextEditingController();
  final _numeroTelemovel = TextEditingController();
  final _senhaController = TextEditingController();
  final _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldkey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Criar Conta"),
        elevation: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            inputlista("Primero Nome",false,_nomeUsuario,Feather.user_plus),
            inputlista("Último Nome",false,_sobrenomeUsuario,Icons.person_outline),
            inputlista("Email",false,_emailController,Feather.git_merge),
            inputlista("+244",false,_numeroTelemovel,Feather.phone),
            inputlista("Senha",false,_senhaController,Feather.lock),
            loginButton(context,"CRIAR CONTA",Colors.amber,Colors.white,(){
                 _cadastrar();
                 isloading = true;
            }),
             SizedBox(
              height: 10,
            ),
             loginButton(context,"JÁ TEM UMA CONTA?",Colors.green,Colors.white,(){
             
            })
          ],
        )
      ),
    );
  }

  Widget inputlista(String label,bool isObcure,TextEditingController controler,IconData icon){
  return Padding(
    padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
    child:TextField(
    controller: controler,
    style: TextStyle(fontSize: 15.0, color: Colors.white),
    textAlign: TextAlign.left,
    obscureText: isObcure,
    decoration: InputDecoration(
      suffixIcon: Icon(icon),
      hintText: '$label',
      hintStyle: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
      fillColor: Color.fromRGBO(175, 175, 175, .5),
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

  Widget loginButton(BuildContext context, String labelText,Color cor,Color corTexto,Function submit){
  return SizedBox(
          width: MediaQuery.of(context).size.width-20, //Full width
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

  Future<void> _cadastrar() async{
     if(_senhaController.text == "" || _emailController.text == ""){
         falha();
       return;
     }
     final response = await http.post('https://www.visualfoot.com/api/conta.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
       'use_nome': _nomeUsuario.text,
       'use_sobrenome': _sobrenomeUsuario.text,
       'use_email': _emailController.text,
       'use_telemovel': _numeroTelemovel.text.toString(),
       'use_senha': _senhaController.text,
    }),

  );

    var encodeFirst = json.encode(response.body);
    var data = json.decode(encodeFirst);
    
    print(data.toString());

    if(data.toString().replaceAll('"', '') == 'erro')
    {
      falha();
    }else{
      print(data.toString());

        if(data == "erro"){
           falha();
         return;
        }
      if(!data.toString().contains(','))
      return;
      sucesso(data.toString().split(',')[0],data.toString().split(',')[1]);   
    }
  }

  void sucesso(String nome,String email){
      _scafoldkey.currentState.showSnackBar(
        SnackBar( content: Text("Cadastro feito com sucesso!"),
        backgroundColor: Colors.green, duration: Duration(seconds: 3),)
      );
      Future.delayed(Duration(seconds: 2)).then((_){
          setState(() {
            isloading = false;
            });
          _saveSession();
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>  HomeView(nome,email)),(Route<dynamic> route) => false);
      });
   
    }

  Future<void> _saveSession() async {
    final SharedPreferences prefs = await _prefs;
    //final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _email = prefs.setString("email", _emailController.text).then((bool success) {
        return  _email;
      });
        _nome = prefs.setString("nome", _nomeUsuario.text+" "+_sobrenomeUsuario.text).then((bool success) {
        return  _nome;
      });
    });
  }

  void falha(){
        _scafoldkey.currentState.showSnackBar(
        SnackBar( content: Text("Dados invalidos ,Porfavor insere os dados correctamente"),
           backgroundColor: Colors.redAccent, duration: Duration(seconds: 4),)
      );
       Future.delayed(Duration(seconds: 2)).then((_){
         setState(() {
            isloading = false;
         });
      });
    
  }


}