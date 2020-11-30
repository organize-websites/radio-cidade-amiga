import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:io';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'dart:async';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sobre.dart';
import 'politica.dart';
import 'conteudo.dart';

void main() {runApp(
  MaterialApp(  
  title: 'Rádio Cidade Amiga',
	 theme: ThemeData(
	   primarySwatch: Colors.purple[800],
         ),
         home: HomePage(),
      )
    );
}

Future<Album> fetchAlbum() async { 
  var response =
      await http.get('http://audio.digitalmash.com.br/api-json/VG5wRmQwMUJQVDA9KzM=');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['musica_atual'],
    );
  }
}

class HomePage extends StatefulWidget {
  
  HomePage({Key key}) : super(key: key);

  var playerState = FlutterRadioPlayer.flutter_radio_paused;

  var volume = 0.8;
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
 

  loadPosts() async {
    fetchAlbum().then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  showSnack() {
    return scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('New content loaded'),
      ),
    );
  }
 
  Future<Null> _handleRefresh() async {
    print(fetchAlbum());
    fetchAlbum().then((res) async {
      _postsController.add(res);
      showSnack();
      return null;
    });
  }

  Timer timer;  
  int counter = 0;

  Future<Album> futureAlbum;

  _HomePageState({Key key});

  FlutterRadioPlayer _flutterRadioPlayer = new FlutterRadioPlayer();

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Compartilhar App',
        text: 'Conheça o app da Rádio Cidade Amiga',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.organizeapps.radiocidadeamiga',
        chooserTitle: ' ');
  }   

  @override
  void initState() { 
    _postsController = new StreamController();
    loadPosts();   
    super.initState();      
    initRadioService();     
    futureAlbum = fetchAlbum();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
  }

  Future<void> initRadioService() async {
    try {
      await _flutterRadioPlayer.init(
          "Rádio Cidade Amiga", "Ao Vivo", "http://player.stream2.com.br/proxy/7100/stream", "true");          
    } on PlatformException {
      print("Não foi possivel acessar a radio agora...");
    }
  }

  _exit() async{
    if (await _flutterRadioPlayer.isPlaying()){_flutterRadioPlayer.stop(); exit(0);} else {exit(0);}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(      
      home: Scaffold(        
        appBar: AppBar(backgroundColor: Colors.white, iconTheme: IconThemeData(color: Color.fromRGBO(40, 52, 138, 1.0)),),
        body: 
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('imagens/bg.png'), fit: BoxFit.cover)),
          child:
          CustomScrollView(
          slivers: 
          <Widget>[
            SliverList(
              delegate: 
              SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(top: 75.0, bottom: 140.0, left: 60.0, right: 60.0),
                    child: Image.asset('imagens/logo-white.png'),
                  )
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              delegate: 
              SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: _launchURL3,
                      child:
                      Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('imagens/instagram.png'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),                    
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: _launchURL2,
                      child:
                      Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('imagens/facebook.png'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: _launchURL,
                      child:
                      Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('imagens/whatsapp.png'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Conteudo()));},
                      child:
                      Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('imagens/conteudo.png'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ), 
            ),
            SliverList(
              delegate: 
              SliverChildListDelegate(
                [                  
                  Slider(
                  activeColor: Colors.white,  
                  value: widget.volume,
                  min: 0,
                  max: 1.0,
                  onChanged: (value) => setState(() {
                        widget.volume = value;
                        _flutterRadioPlayer.setVolume(widget.volume);
                      }
                    )
                  ),
                  Text('VOLUME: ' + (widget.volume * 100).toStringAsFixed(0), textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: Center(
                      child: StreamBuilder(                                               
                        stream: Stream.periodic(Duration(seconds: 5))
                        .asyncMap((futureAlbum) => fetchAlbum()),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.title, style: TextStyle(color: Colors.white, fontSize: 20.0), textAlign: TextAlign.center,);
                          } else if (snapshot.hasError) {
                            return Text("Rádio Cidade Amiga", style: TextStyle(color: Colors.white, fontSize: 20.0), textAlign: TextAlign.center,);
                          }

                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
        drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: FlatButton(
                    child: Image.asset('imagens/ic_launcher.png'),
                    onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
                    color: Colors.transparent,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('HOME'),
                onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
              ),
              ListTile(
                leading: Icon(FontAwesome.whatsapp),
                title: Text('WHATSAPP'),
                onTap: _launchURL,
              ),
              ListTile(
                leading: Icon(FontAwesome.facebook),
                title: Text('FACEBOOK'),
                onTap: _launchURL2,
              ),
              ListTile(
                leading: Icon(FontAwesome.instagram),
                title: Text('INSTAGRAM'),
                onTap: _launchURL3,
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('LIGUE PRA GENTE'),
                onTap: _launchURL4,
              ),
              ListTile(
                leading: Icon(Icons.apps),
                title: Text('CONTEUDO'),
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Conteudo()));},
              ),
              ListTile(
                leading: Icon(Icons.web),
                title: Text('NOSSO SITE'),
                onTap: _launchURL5,
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('COMPARTILHAR'),
                onTap: share,
              ),
              ListTile(
                leading: Icon(Icons.copyright),
                title: Text('SOBRE O APP'),
                onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SobreOApp()));
                        },
              ),
              ListTile(
                leading: Icon(Icons.public),
                title: Text('POLÍTICA DE PRIVACIDADE'),
                onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PoliticaDePrivacidade()));
                        },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: IconButton(
                        icon: Icon(Icons.home, color: Color.fromRGBO(40, 52, 138, 1.0), size: 40),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
                      ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: StreamBuilder(
                              stream: _flutterRadioPlayer.isPlayingStream,
                              initialData: widget.playerState,
                              builder:
                                  (BuildContext context, AsyncSnapshot<String> snapshot) {
                                String returnData = snapshot.data;
                                print("object data: " + returnData);
                                switch (returnData) {
                                  case FlutterRadioPlayer.flutter_radio_stopped:
                                    return RaisedButton(
                                        child: Text("Ouça Agora!"),
                                        onPressed: () async {
                                          await initRadioService();
                                        });
                                    break;
                                  case FlutterRadioPlayer.flutter_radio_loading:
                                    return Text("Carregando...");
                                  case FlutterRadioPlayer.flutter_radio_error:
                                    return RaisedButton(
                                        child: Text("Tentar Novamente ?"),
                                        onPressed: () async {
                                          await initRadioService();
                                        });
                                    break;
                                  default:
                                    return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          IconButton(
                                              onPressed: () async {
                                                print("button press data: " +
                                                    snapshot.data.toString());
                                                await _flutterRadioPlayer.playOrPause();
                                              },
                                              icon: snapshot.data ==
                                                      FlutterRadioPlayer
                                                          .flutter_radio_playing
                                                  ? Icon(Icons.pause, color: Color.fromRGBO(40, 52, 138, 1.0), size: 40)
                                                  : Icon(Icons.play_arrow, color: Color.fromRGBO(40, 52, 138, 1.0), size: 40)),
                                          ]);
                                    break;
                                }
                              }),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: IconButton(
                        icon: Icon(Icons.exit_to_app, color: Color.fromRGBO(40, 52, 138, 1.0), size: 40),
                        onPressed: _exit,
                      ),
            ),
          )
        ],
      ),
      ),
    );
  }
}



_launchURL() async {
  const url = 'http://wa.me/554836450577&text=';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL2() async {
  const url = 'fb://page/133547203439552/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL3() async {
  const url = 'instagram://user?username=radiocidadeamiga';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL4() async {
  const url = 'tel:+554836450577';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL5() async {
  const url = 'https://radiocidadeamiga.com.br/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


