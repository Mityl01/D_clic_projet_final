import 'package:flutter/material.dart';
import 'package:projetfinal/Outils/databaseManager.dart';

class PageNUtilisateur extends StatefulWidget {
  const PageNUtilisateur({super.key});

  @override
  State<PageNUtilisateur> createState() => _PageNUtilisateurState();
}

class _PageNUtilisateurState extends State<PageNUtilisateur> {

  final _db = DatabaseManager.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Mes Notes', style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child:  Form(
            key: _formKey,
            child:Column(
              children: [
                Icon( Icons.person, size: 100, color: Colors.blue,),

                Text('Créer un compte', style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),

                SizedBox(height: 20),

                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
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
                    prefixIcon: Icon(Icons.lock_outline),
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

                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: 'Confirmer le mot de passe',
                    border: OutlineInputBorder(),
                  
                  ),
                  obscureText: true,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Veillez remplir ce champ';
                    }
                    else if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
              
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      // Traitement de la connexion
                      await _db.insertUtilisateur(_usernameController.text, _passwordController.text);
                      _afficherMessage('Compte créé avec succès');
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Enregistrer', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),

                SizedBox(height: 20),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Deja inscrit ?', style: TextStyle(color: Colors.blue),))

              ],
            )
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _afficherMessage (String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
