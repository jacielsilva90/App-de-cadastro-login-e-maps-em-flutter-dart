
//import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart' as path;
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; ////arquivo separado
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toastification/toastification.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

//background image
final List<String> imgList = [
  'assets/moto1.png',
  'assets/moto2.png',
  'assets/moto3.png',
];
//redes sociais
final Uri _url = Uri.parse("https://www.instagram.com/jacismith90/");
final Uri _url2 = Uri.parse("https://www.instagram.com/jaciel.silva.18/");
final Uri _url3 = Uri.parse("https://www.facebook.com/jacielap.silvajaci?locale=pt_BR");
final Uri _url4 = Uri.parse("https://www.facebook.com/Jacielsilvasmith?locale=pt_BR");
final Uri _url5 = Uri.parse("https://mail.google.com/mail/u/0/#inbox");
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
Future<void> _launchUrl2() async {
  if (!await launchUrl(_url2)) {
    throw Exception('Could not launch $_url2');
  }
}
Future<void> _launchUrl3() async {
  if (!await launchUrl(_url3)) {
    throw Exception('Could not launch $_url3');
  }
}
Future<void> _launchUrl4() async {
  if (!await launchUrl(_url4)) {
    throw Exception('Could not launch $_url4');
  }
}
Future<void> _launchUrl5() async {
  if (!await launchUrl(_url5)) {
    throw Exception('Could not launch $_url5');
  }
}

//map
late GoogleMapController mapController;
final LatLng _center=const LatLng(45.521563,-122.677433);
void _onMapCreated(GoogleMapController controller){
  mapController=controller;
}

////contatto
final _emailController = TextEditingController();
final _messageController = TextEditingController();

//variáveis de controller de cadastro
final TextEditingController _controller1 = TextEditingController(); //captura nome_l
final TextEditingController _controller2 = TextEditingController(); //captura email
final _controller3 = TextEditingController(); //captura senha
final _controller4 = TextEditingController(); //captura tel
double? _controller4valor=double.tryParse(_controller4.text);

////login
final _emailControllerlg = TextEditingController();
final _passwordController = TextEditingController();

//firestore conexao
class DBFirestore{
  DBFirestore._(); //construtor nomeado privado.
  static final DBFirestore _instance=DBFirestore._(); //Cria a única instância permitida do seu objeto.
  final FirebaseFirestore _firestore=FirebaseFirestore.instance; //Inicia a conexão real com o banco de dados.
  static FirebaseFirestore get(){ //qualquer tela ou classe pode chamar para acessar o objeto do Firestore
    return DBFirestore._instance._firestore;
  }
}

String msgapp = " ";
String msgcadastro = " ";


final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
Future<void> cadastrarloja(String nome_l,String email,String senha,double tel) async {
  try {
    UserCredential userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    await userCredential.user!.updateDisplayName(nome_l);
    Get.snackbar('salvo', 'salvo');
        toastification.show(
          title: Text('salvo'),
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds:3),
        );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      Get.snackbar('senha fraca', '$e');
        toastification.show(
          title: Text('$e'),
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds:3),
        );
    } else if (e.code == 'email-already-in-use') {
      Get.snackbar('conta existente', '$e');
        toastification.show(
          title: Text('$e'),
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds:3),
        );
    }
  } catch (e) {
    Get.snackbar('erro', '$e');
        toastification.show(
          title: Text('$e'),
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds:3),
        );
  }
}

Future<User?> _submitLogin(String email, String senha) async {
    //API serviço de autenticação
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      toastification.show(
        title: Text('erro de login: $e'),
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds:3),
      );
      Get.snackbar('erro de login', '$e');
    }
  return null;
}

Future<void> deslogar()async{
  return FirebaseAuth.instance.signOut();
}

void carregarMarcadores(){
  Set<Marker>marcadoreslocal={};
  Marker marcadorIfpi=Marker(
    markerId: MarkerId('ifpi'),
    position:LatLng(-5.088544046019581,-42.81123803149089),
  );
  marcadoreslocal.add(marcadorIfpi);
}

LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high, // Suas configurações vão aqui
  distanceFilter: 100,
);
void localizacaoAtual() async {
  Position position =await Geolocator.getCurrentPosition(
    locationSettings: locationSettings,
  );
  Get.snackbar('Localização:', '$position');
}

class MyApp extends StatelessWidget {//materialapp
  const MyApp({super.key});
  @override //sobrecrita do metodo build() de statelesswidget
  Widget build(BuildContext context) { //constroi o widget materialapp
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'appz', 
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple),),
        home:RoteadorTela(),
        initialRoute:'/',
        routes: <String, WidgetBuilder>{ //routes:{
          '/cadastro':(BuildContext context)=>Cadastro(), //pode ser so: (context)
          //'/login':(BuildContext context)=>LoginScreen(), 
          '/Alterar_senha':(BuildContext context)=>AlterarSenha(), 
          '/maps':(BuildContext context)=>Maps(),
        },

      ),
    );
  }
}

//realiza a mudança de tela para painel logado
class RoteadorTela extends StatelessWidget{
  const RoteadorTela({super.key});
  @override
  Widget build(BuildContext context){
    return StreamBuilder<User?>(
      stream:FirebaseAuth.instance.userChanges(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          return Painel();
        }else{
          return MyHomePage(title: 'Home');
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget { //tela principal 
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState(); //cria a classe _myhomepagestate()
}
class _MyHomePageState extends State<MyHomePage> {
  final _formKey2 = GlobalKey<FormState>();
  //form contato
  bool _isLoading = false;
  Future<void> sendEmail() async {
      setState(() {
        _isLoading = true;
      });
      try {
        // Mapeia os dados do formulário para o template do EmailJS
        Map<String, dynamic> templateParams = {
          'user_email': _emailController.text,
          'message': _messageController.text,
        };
        // Envia o e-mail
        await emailjs.send(
          'service_id', 
          'template_id', 
          templateParams,
          const emailjs.Options(
            publicKey: 'sua key', 
          ),
        );
        toastification.show(
          title: Text('salvo'),
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds:3),
        );
        Get.snackbar('salvo', 'salvo');
        msgapp='salvo';
        _isLoading;
        
      } catch (error) {
        toastification.show(
          title: Text('erro $error'),
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds:3),
        );
        Get.snackbar('erro', '$error');
        msgapp='erro $error';
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
  }
  @override //sobrescreve build() da claasse pai
  Widget build(BuildContext context) { // constroi o widget scaffold
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 240, 240, 240),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text('  Menu - Depozitomedia'),
            ),
            //ListTile(
              //title: Text(' Depozitomedia peças'),
            //),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(' Home'),
              onTap: () { // Ação ao clicar no item
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              title: Text(' Cadastro'),
              onTap: () { // Ação ao clicar no item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cadastro()),
                  );
              },
            ),
            
            ListTile(
              title: Text(' Alterar senha'),
              onTap: () { // Ação ao clicar no item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlterarSenha()),
                  );
              },
            ),
            ListTile(
              title: Text(' Maps'),
              onTap: () { // Ação ao clicar no item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Maps()),
                  );
              },
            ),
            ListTile(
              title: Text(' Contatos'),
              onTap: () { // Ação ao clicar no item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Contatos()),
                  );
              },
            ),            
            Text(''),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('voltar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,        
        title: const Text('Depozitomedia peças'), //(widget.title),
        centerTitle: true,
        actions: <Widget>[
          Icon(Icons.local_grocery_store),
        ],
      ),
      body:Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/motocapa.png'),
              fit: BoxFit.cover,
            ),     
          ),
          child: Column(
            children: [
              
              CarouselSlider(
                options: CarouselOptions(
                  height: 100.0,
                  autoPlay: true, 
                  enlargeCenterPage: true, //aumenta foto central
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
                items: imgList.map((item) => Builder( //imgList.map<Widget>((item) {}).toList(), 
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Image(
                        image:AssetImage(item),
                        fit: BoxFit.cover,
                        width:100,
                        height:100,
                      ),
                    );
                  },
                )).toList(),
              ),
              
              Row( //login e logoifpi
                mainAxisAlignment: .center,
                children:[
                  
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Instituto_Federal_do_Piau%C3%AD_-_Marca_Vertical_2015.svg/500px-Instituto_Federal_do_Piau%C3%AD_-_Marca_Vertical_2015.svg.png',
                    width: 100,
                    height: 120,
                  ),
                  
                  ColoredBox(//login
                    color:Colors.white, 
                    child:SizedBox(
                      width:400,
                      height:165,
                      child:Column(
                        children:[
                          Form(
                            key: _formKey2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                
                                TextFormField(
                                  controller: _emailControllerlg,
                                  decoration: InputDecoration(labelText: 'E-mail'),
                                  validator:(value){
                                    if(value==null || value.isEmpty ){
                                      return 'email invalido';
                                    }
                                    return null;                                
                                  },
                                ),
                                
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(labelText: 'Senha'),
                                  //obscureText: true,
                                  validator:(value){
                                    if(value==null || value.isEmpty || value.length<6 ){
                                      return 'senha curta';
                                    }
                                    return null;                                
                                  },
                                ),
                                
                                ElevatedButton(
                                  onPressed:()async{
                                    await _submitLogin(_emailControllerlg.text, _passwordController.text);
                                  } ,
                                  child: Text('Login'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),  
                ],
              ),
              
              Form(//contato
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    SizedBox(
                      width: 300,
                      height:120,
                      child:Column(
                        mainAxisAlignment: .center,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: '  E-mail'),
                            validator: (value) => value!.isEmpty ? 'Insira seu e-mail' : null,
                          ),
                          TextFormField(
                            controller: _messageController,
                            decoration: const InputDecoration(labelText: '  Mensagem'),
                            validator: (value) => value!.isEmpty ? 'Insira uma mensagem' : null,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: sendEmail,
                      child: const Text('Enviar ao suporte'),
                    ),
                  ],
                ),
              ),

              //ColoredBox(color:Colors.grey, child:Text('  Redes sociais  ', style:TextStyle(fontWeight:FontWeight.w900),),),
              Row( //redes sociais
                mainAxisAlignment: .center,
                children:[
                  ElevatedButton(
                    onPressed: _launchUrl,
                    child: Text('@jacismith90'),
                  ),
                  
                  ElevatedButton(
                    onPressed: _launchUrl5,
                    child: Text('jaciel.silva.18@gmail.com'),
                  ),
                ],
              ),
              
              
            ],
          ), 
        ),
      ),
    );
  }
}

class Cadastro extends StatelessWidget {
  Cadastro({super.key});
  void dispose() {
    _controller1.dispose(); // Limpa a memória ao fechar a tela
    _controller2.dispose();
    _controller3.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 240, 240, 240),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text('  Menu - Depozitomedia'),
            ),
            //ListTile( title: Text(' Depozitomedia'), ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(' Home'),
              onTap: () { // Ação ao clicar no item
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushNamed(context, '/');
              },
            ),
           
            ListTile(
              title: Text(' Maps'),
              onTap: () { // Ação ao clicar no item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Maps()),
                  );
              },
            ),
            Text(''),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('voltar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,        
        title: const Text('Cadastro - Formulario'), //(widget.title),
        centerTitle: true,
      ),
      body:Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/motocapa.png'),
              fit: BoxFit.cover,
            ),     
          ),
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 130.0,
                  autoPlay: true, 
                  enlargeCenterPage: true, //aumenta foto central
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
                items: imgList.map((item) => Builder( //imgList.map<Widget>((item) {}).toList(), 
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Image(
                        image:AssetImage(item),
                        fit: BoxFit.cover,
                        width:100,
                        height:100,
                      ),
                    );
                  },
                )).toList(),
              ),
              ColoredBox(
                color:Colors.white, 
                child:SizedBox(
                  width:450,
                  height:230,
                  child:Column(
                    children:[
                      TextField(
                        controller:_controller1,
                        style:TextStyle(
                          fontSize:12,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                          border: UnderlineInputBorder(),
                          label: Text(' Nome: '),
                        ),
                      ),
                      TextField(
                        controller:_controller2,
                        style:TextStyle(
                          fontSize:12,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                          border: UnderlineInputBorder(),
                          label: Text(' Email: '),
                        ),
                        //if(value==null || value.isEmpty){ },
                      ),
                      TextField(
                        controller:_controller3,
                        //obscureText: true,
                        style:TextStyle(
                          fontSize:12,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                          border: UnderlineInputBorder(),
                          label: Text(' Senha: '),
                        ),
                        //if(value.legth<6){},
                      ),
                      TextField(
			                  controller:_controller4,
                        style:TextStyle(
                          fontSize:12,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                          border: UnderlineInputBorder(),
                          label: Text(' Tel: '),
                        ),
                        //if(value.legth != 11){},
                      ),
                      ElevatedButton(
                        onPressed:()async{
                          await cadastrarloja(
                            _controller1.text,
                            _controller2.text,
                            _controller3.text,
                            _controller4valor ?? 0
                          );
                        },
                        child: Text('Enviar'),
                      ),
                    ],
                  ),
                ),
              ),
              Text(msgcadastro, style:TextStyle(fontSize:8,),),
              ElevatedButton( //button voltar
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('voltar'),
              ),
           
            ],
          ), 
        ),
      ),
    );

  }
}

/* Este classe nao foi usada
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 240, 240, 240),
      body:Center(
        child: Container(
          child: Column(
            children: [
              Text('  Depozitomedia  ', style:TextStyle(fontWeight:FontWeight.w900),),

              ColoredBox(
                color:Colors.white, 
                child:SizedBox(
                  width:440,
                  height:175,
                  child:Column(
                    children:[
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _emailControllerlg,
                              decoration: InputDecoration(labelText: 'E-mail'),
                              validator:(value){
                                if(value==null || value.isEmpty ){
                                  return 'email invalido';
                                }
                                return null;                                
                              },
                            ),
                            
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(labelText: 'Senha'),
                              //obscureText: true,
                              validator:(value){
                                if(value==null || value.isEmpty || value.length<6 ){
                                  return 'senha curta';
                                }
                                return null;                                
                              },
                            ),
                            
                            ElevatedButton(
                              onPressed:()async{
                                await _submitLogin(_emailControllerlg.text, _passwordController.text);
                              } ,
                              child: Text('Entrar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),        
            ],
          ), 
        ),
      ),

    );
  }
}
*/

class Painel extends StatelessWidget {
  const Painel({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 240, 240, 240),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text('  Menu - Depozitomedia'),
            ),
            
            ListTile(
              leading: Icon(Icons.home),
              title: Text(' Home'),
              onTap: () { // Ação ao clicar no item
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushNamed(context, '/');
              },
            ),
          
            ListTile(
              title: Text(' Maps'),
              onTap: () { // Ação ao clicar no item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Maps()),
                  );
              },
            ),
            Text(''),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('voltar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,        
        title: const Text('Depozitomedia peças - Painel'), //(widget.title),
        centerTitle: true,
      ),
      body:Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/motocapa.png'),
              fit: BoxFit.cover,
            ),     
          ),
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 170.0,
                  autoPlay: true, 
                  enlargeCenterPage: true, //aumenta foto central
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
                items: imgList.map((item) => Builder( //imgList.map<Widget>((item) {}).toList(), 
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Image(
                        image:AssetImage(item),
                        fit: BoxFit.cover,
                        width:100,
                        height:100,
                      ),
                    );
                  },
                )).toList(),
              ),
              Text(''),

              ColoredBox(
                color:Colors.white,
                child: Text(' Encontre peças de motocicletas aqui '),
              ),
              Text('Pesquisar'),
              Row(
                mainAxisAlignment: .center,
                children:[
                  ElevatedButton(
                    onPressed: _launchUrl2,
                    child: Text('@jaciel.silva.18'),
                  ),
                  ElevatedButton(
                    onPressed: _launchUrl3,
                    child: Text('Jaci ap silva'),
                  ),
                  ElevatedButton(
                    onPressed: _launchUrl4,
                    child: Text('Jaciel silva smith'),
                  ),
                ],
              ),
              Text(''),
              Row(
                mainAxisAlignment: .center,
                children:[                  
                  ElevatedButton(
                    onPressed: (){
                      deslogar();
                    },
                    child: Text('logout'),
                  ),
                ],
              ),


            ],
          ), 
        ),
      ),
    );

        
  }
}

class AlterarSenha extends StatelessWidget {
  const AlterarSenha({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 240, 240, 240),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text('  Menu - Depozitomedia'),
            ),
            
            ListTile(
              leading: Icon(Icons.home),
              title: Text(' Home'),
              onTap: () { // Ação ao clicar no item
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushNamed(context, '/');
              },
            ),
         
            ListTile(
              title: Text(' Maps'),
              onTap: () { // Ação ao clicar no item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Maps()),
                  );
              },
            ),
            Text(''),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('voltar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,        
        title: const Text('Alterar senha'), //(widget.title),
        centerTitle: true,
        actions: <Widget>[
          Icon(Icons.local_grocery_store),
        ],
      ),
      body:Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/motocapa.png'),
              fit: BoxFit.cover,
            ),     
          ),
          child: Column(
            children: [
              Text('  Depozitomedia  ', style:TextStyle(fontWeight:FontWeight.w900),),
              CarouselSlider(
                options: CarouselOptions(
                  height: 170.0,
                  autoPlay: true, 
                  enlargeCenterPage: true, //aumenta foto central
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
                items: imgList.map((item) => Builder( //imgList.map<Widget>((item) {}).toList(), 
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Image(
                        image:AssetImage(item),
                        fit: BoxFit.cover,
                        width:100,
                        height:100,
                      ),
                    );
                  },
                )).toList(),
              ),
              Text(''),
              Row(
                mainAxisAlignment: .center,
                children:[
                  Text(''),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('voltar'),
                  ),
                ],
              ),
              Text(''),
              Text(''),
              Text(''),
                
            ],
          ), 
        ),
      ),
    );

  }
}

class Maps extends StatelessWidget {
  const Maps({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 240, 240, 240),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text('  Menu - Depozitomedia'),
            ),
            
            ListTile(
              leading: Icon(Icons.home),
              title: Text(' Home'),
              onTap: () { // Ação ao clicar no item
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushNamed(context, '/');
              },
            ),
            
            ListTile(
              title: Text(' Maps'),
              onTap: () { // Ação ao clicar no item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Maps()),
                  );
              },
            ),
            Text(''),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('voltar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,        
        title: const Text('Maps'), //(widget.title),
        centerTitle: true,
      ),
      body:Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/motocapa.png'),
              fit: BoxFit.cover,
            ),     
          ),
          child: Column(
            children: [
              Row( //botao de voltar
                mainAxisAlignment:.center,
                children:[
                  Text(''),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('voltar'),
                  ),
                ],
              ),
              SizedBox( //maps
                width: double.infinity,
                height: 400.0,         
                child:GoogleMap(
                  myLocationButtonEnabled: true,
                  mapType:MapType.hybrid,
                  
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom:10.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('teresina'),
                      position: LatLng(-5.0892,-42.8016),
                      infoWindow: InfoWindow(
                        title:'Teresina',
                      ),
                    ),
                  },
                ),
              ),            
                
            ],
          ), 
        ),
      ),
    );

  }
}

class Contatos extends StatelessWidget {
  const Contatos({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 240, 240, 240),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text('  Menu - Depozitomedia'),
            ),
            
            ListTile(
              leading: Icon(Icons.home),
              title: Text(' Home'),
              onTap: () { // Ação ao clicar no item
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushNamed(context, '/');
              },
            ),
            
            ListTile(
              title: Text(' Maps'),
              onTap: () { // Ação ao clicar no item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Maps()),
                  );
              },
            ),
            Text(''),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('voltar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,        
        title: const Text('Contatos'), //(widget.title),
        centerTitle: true,
      ),
      body:Center(
        child: Column(
          children: [  
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('voltar'),
            ),
            Text('Contatos'),
          ],
        ), 
        
      ),
    );

  }
}
