import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:io';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'dart:async';
import 'package:flutter_share/flutter_share.dart';
import 'homescreen.dart';
import 'politica.dart';
import 'package:url_launcher/url_launcher.dart';
import 'conteudo.dart';

class SobreOApp extends StatefulWidget {
  var playerState = FlutterRadioPlayer.flutter_radio_paused;

  var volume = 0.8;
  @override
  _SobreOAppState createState() => _SobreOAppState();
}

class _SobreOAppState extends State<SobreOApp> {
  FlutterRadioPlayer _flutterRadioPlayer = new FlutterRadioPlayer();
  @override
void initState(){
  super.initState();
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
}

Future<void> share() async {
    await FlutterShare.share(
        title: 'Compartilhar App',
        text: 'Conheça o app da Rádio Cidade Amiga',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.organizeapps.radiocidadeamiga',
        chooserTitle: ' ');
  }

  Future<void> initRadioService() async {
    try {
      await _flutterRadioPlayer.init(
          "Rádio Cidade Amiga", "Ao Vivo", "https://player.stream2.com.br/proxy/7100/stream", "true");
    } on PlatformException {
      print("Não foi possivel acessar a radio agora...");
    }
  }

  _exit() async{
    if (await _flutterRadioPlayer.isPlaying()){_flutterRadioPlayer.stop(); exit(0);} else {exit(0);}
  }

  void cancel(timer){}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rádio Cidade Amiga',
      theme: ThemeData.light(),
      home: Scaffold(
      appBar: 
      AppBar(backgroundColor: Colors.white, iconTheme: IconThemeData(color: Colors.black),),
      body: 
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Image.asset('imagens/ic_launcher.png'),
              ),
              Text(' ', style: TextStyle(color: Colors.white),),
              Text('Rádio Cidade Amiga', style: TextStyle(color: Colors.black),),
              Text('Criado pela Organize Websites!', style: TextStyle(color: Colors.black),),
              Text(' ', style: TextStyle(color: Colors.black),),
              Text('Versão 1.0.0', style: TextStyle(color: Colors.black),),
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
