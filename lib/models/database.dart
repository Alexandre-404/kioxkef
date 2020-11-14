import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class DatabaseHelper{
   static final _dbName = "kioxkedata.db";
   static final _dbVersion = 1;
   static final tableName = "desejosLista";

   DatabaseHelper._privateConstructor();
   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
   String id, nome, descricao, preco, imageUrl, fileSrc, pathName, idident;

   Database _database;

   Future<Database> get database async{
     if(_database!=null) return _database;

     _database = await _initiateDatabase();
     return _database;
   }

  _initiateDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,_dbName);
   return await openDatabase(path,version: _dbVersion,onCreate: _onCreate);
  }
  
  Future _onCreate(Database db,int version){
    db.execute(
      '''CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY,
      nome TEXT NOT NULL,
      descricao TEXT  NOT NULL,
      preco TEXT NOT NULL,
      imageUrl TEXT NOT NULL,
      pathName TEXT NOT NULL,
      tipo INTEGER NOT NULL,
      idident TEXT NOT NULL
    ) '''
    );
  }

   Future<int> insert(Map<String,dynamic> row) async{
     Database db = await instance.database;
     return await db.insert(tableName, row);
   }

   Future<List<Map<String,dynamic>>> queryAll(int separator) async{
     Database db = await instance.database;
     return await db.rawQuery('SELECT * FROM desejosLista WHERE tipo="$separator" ');
   }

  Future<int> update(Map<String,dynamic> row) async{
    Database db = await instance.database;
    int id = row['id'];
      return await db.update(tableName, row,where: '$id = ?',whereArgs: [id]);
  }

   Future<int> delete(int id) async{
       Database db = await instance.database;
       return await db.delete(tableName,where:'id=?',whereArgs: [id]);
   }



}