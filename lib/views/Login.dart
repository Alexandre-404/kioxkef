import 'dart:convert';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kioxkef/views/cadastro.dart';
import 'package:kioxkef/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
   Future<String> _email,_nome;

    final _formKey = GlobalKey<FormState>();
    final _senhaController = TextEditingController();
    final _emailController = TextEditingController();

    final _scafoldkey = GlobalKey<ScaffoldState>();
    bool isloading = false;

    Future<void> _login() async{
     if(_senhaController.text == "" || _emailController.text == ""){
         falha();
       return;
     }
     final response = await http.post('https://www.visualfoot.com/api/login.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
       'use_email': _emailController.text,
       'use_senha': _senhaController.text,
    }),

  );

    var encodeFirst = json.encode(response.body);
    var data = json.decode(encodeFirst);

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
   
    Future<void> _checkSession(String nome,String email) async {
       final SharedPreferences prefs = await _prefs;
    //final int counter = (prefs.getInt('counter') ?? 0) + 1;
      if(prefs.getString("email") != null){
         print(prefs.getString("email")+prefs.getString("nome"));
         Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>  HomeView(prefs.getString("nome"),prefs.getString("email"))),(Route<dynamic> route) => false);
      }
    }

    Future<void> _saveSession(String nome) async {
    final SharedPreferences prefs = await _prefs;
    //final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _email = prefs.setString("email", _emailController.text).then((bool success) {
        return  _email;
      });
        _nome = prefs.setString("nome", nome).then((bool success) {
        return  _nome;
      });
    });
  }

@override
  void initState() {
    super.initState();
      _email = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('email'));
    });
      _nome = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('nome'));
    });

     _checkSession(_nome.toString(),_email.toString());
  }


  @override
Widget build(BuildContext context) {
  return Scaffold( 
    key: _scafoldkey,
    body:SingleChildScrollView(
          child:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            // color:Color.fromRGBO(115, 115, 115, 1)
          ),
          child: Column(
            children: [

          Container(
             width: MediaQuery.of(context).size.width,
             height: MediaQuery.of(context).size.height /2.2,
             child: Column(
              children: [
               logo(),
               textLogo()
              ], 
             ),
            ),

            Container(
             width: MediaQuery.of(context).size.width-25,
             height: MediaQuery.of(context).size.height /3,
             decoration: BoxDecoration(
             color: Color.fromRGBO(175, 175, 175,.3),
             borderRadius: BorderRadius.all(Radius.circular(10))
             ),
             child: Column(
               children: [
                 Form(
                 key: _formKey,
                 child: Column(
                 children: <Widget>[
                     Text(""),
                     inputlista("Nome de Utilizador",false),
                     inputlista("Palavra-Passe",true),
                     loginButton("Iniciar Sessao",Color.fromRGBO(253, 172, 66,1),true,Colors.white,(){
                        _login();
                         setState(() {
                          isloading = true;
                         });
                     }),
                     loginButton("Não tem Conta? Crie uma aqui",Colors.transparent,false,Colors.black,(){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => Cadastro()));
                     })
                   ]
                    )
                 )
               ],
             ),
            )
            ], 
          ),
        )
  )
);
}

Widget loginButton(String labelText,Color cor,bool isSubmited,Color corTexto,Function submit){
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
   child:isSubmited? isloading? SpinKitWave(color: Colors.white,size: 40.0,):
   Text("$labelText",style: TextStyle(color:corTexto, fontSize: 15, fontWeight: FontWeight.bold),):
   Text("$labelText",style: TextStyle(color:corTexto, fontSize: 13, fontWeight: FontWeight.bold),),
 )
   );
}

Widget logo(){
  return Container(
   alignment: Alignment(0,1),
   width: MediaQuery.of(context).size.width,
   height: 300,
  //  color: Colors.red,
   child: Container(
     width:300,
     height:150,
     alignment: Alignment.center,
     child: Image.asset('images/logo.png')
   ),
  );
}

Widget textLogo(){
  return Container(
    // color: Colors.red,
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width-10,
    height: 50,
    child: Text(' A sua livraria na palma da mão. \n Inicio de sessão',textAlign:TextAlign.center, style: TextStyle(color:Color.fromRGBO(253, 172, 66,1), fontSize: 15)),
  );
}

Widget inputlista(String label,bool isObcure){
  return Padding(
    padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
    child:TextField(
    controller: isObcure?_senhaController:_emailController,
    style: TextStyle(fontSize: 15.0, color: Colors.white),
    textAlign: TextAlign.left,
    obscureText: isObcure,
    decoration: InputDecoration(
      suffixIcon: isObcure?Icon(Feather.eye,color: Colors.white,):Icon(Feather.user,color: Colors.white,),
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

     
    void sucesso(String nome,String email){
      _scafoldkey.currentState.showSnackBar(
        SnackBar( content: Text("Login feito com sucesso!"),
        backgroundColor: Colors.green, duration: Duration(seconds: 3),)
      );
      Future.delayed(Duration(seconds: 2)).then((_){
          setState(() {
            isloading = false;
            });
          _saveSession(nome);
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>  HomeView(nome,email)),(Route<dynamic> route) => false);
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

