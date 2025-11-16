import 'package:flutter/material.dart';
import 'package:projetfinal/Outils/databaseManager.dart';
import 'package:projetfinal/views/pageNUtilisateur.dart';
import 'package:projetfinal/views/pageNote.dart';

class PageConnexion extends StatefulWidget {
  const PageConnexion({super.key});

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {

  final _db = DatabaseManager.instance;
  
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void resetFrom (){
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Notes', style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 20),
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              child: Image(
                image:  AssetImage('assets/images/image_login.jpg'), 
                height: 150, width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
            children: [
              
              Text('Connexion', style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Veillez remplir ce champ';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  
                ),
                obscureText: true,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Veillez remplir ce champ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.maxFinite, 50),
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async{
                    // Action de connexion
                    if(_formKey.currentState!.validate()){
                      if( await _db.chkLogin(username: _usernameController.text, password: _passwordController.text)){
                        resetFrom();
                        _afficherMessage('Connexion reussie');
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PageNote()));
                      }
                      else {
                        _afficherMessage('Information de connexion invalide');
                      }
                    }
                  },
                  child: Text('Se connecter', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),

                SizedBox(height: 20),
                TextButton(onPressed: (){
                  resetFrom();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PageNUtilisateur()));
                }, child: Text('Pas de comptes ?', style: TextStyle( fontSize: 16, color: Colors.blue)) ),
              ],
            ),
          ),
        ],
      ), 
    ),
    );
  }

  void _afficherMessage (String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}