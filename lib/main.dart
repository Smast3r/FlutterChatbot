

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:ibm_watson_assistant/ibm_watson_assistant.dart';
import 'package:text_to_speech/text_to_speech.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Talking bot",
      theme: ThemeData(
        primaryColor: Color(0xFF9e174c),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // here is the watson thing -

  final bot = IbmWatsonAssistant(IbmWatsonAssistantAuth(
    assistantId: '4df2089e-f560-43eb-a530-02e9dbc6e1e6',
    url:
        'https://api.eu-gb.assistant.watson.cloud.ibm.com/instances/571388a0-f2e4-46d9-8134-0ad4601e0827',
    apikey: '2aIlA6njbGyQLQMFKu-08yoCoye919lO9pOPfPYNMfiV',
  ));
  var sessionId;
  var botRes;

  bool _isVisible = true;
  bool refreshBtn = false;
  bool _inConversation = true;
  String _speech = '' ;
  bool _isListening = false ;

  void toggleShow() async {
    setState(() {
      _isVisible = !_isVisible;
      refreshBtn = _inConversation = true;
    });
    // estaplish to watson
    sessionId = await bot.createSession();
    botRes = await bot.sendInput('hello', sessionId: sessionId);


      TextToSpeech tts = TextToSpeech();
      String text = botRes.output.generic.first.text; //botRes.responseText;
      tts.setVolume(100.0);
      tts.speak(text);

// here we start to lesten
      stt.SpeechToText speech = stt.SpeechToText();
      var speech2 = await speech.initialize(
        debugLogging: true,
      );
      if (speech2) {
        await speech.listen(
          onResult: (sp) => setState(() {
            _speech = sp.recognizedWords ;
            print(sp);
          }),
        );
      }

  }

  void restart() async {
    if (sessionId != null) bot.deleteSession(sessionId);

    var tmp = await bot.createSession();
    setState(() {
      _isVisible = true;
      sessionId = tmp;
      _inConversation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFe5dae2),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Hello Talk to me !',
            style: TextStyle(color: Color(0xFFe5dae2)),
          ),
          leading: Visibility(
            visible: refreshBtn,
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                size: 30,
                color: Color(0xFF1a6c7d),
              ),
              onPressed: restart,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF1a6c7d),
                ),
                child: Image.asset('lib/images/robot_pic.png'),
              ),
            ),
            Visibility(
              visible: _isVisible,
              child: TextButton(
                onPressed: toggleShow,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF9e174c),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Start Conversation !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !_isVisible,
              child: TextButton(
                onPressed: toggleShow,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF9e174c),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    _speech,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
