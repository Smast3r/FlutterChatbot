import 'package:ibm_watson_assistant/ibm_watson_assistant.dart';
import 'package:dotenv/dotenv.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  // final WW = Watson() ;
  // WW.getAccess() ;

  final myVar = Stt() ;
  myVar.Try();
}

class Watson {

  Future<void> getAccess() async {
    
    final auth = new IbmWatsonAssistantAuth(
      assistantId: '4df2089e-f560-43eb-a530-02e9dbc6e1e6',
      url: 'https://api.eu-gb.assistant.watson.cloud.ibm.com/instances/571388a0-f2e4-46d9-8134-0ad4601e0827',
      apikey: '2aIlA6njbGyQLQMFKu-08yoCoye919lO9pOPfPYNMfiV',
    );

    final bot = IbmWatsonAssistant(auth);
    final sessionId = await bot.createSession();
   // print(sessionId);

    final botRes = await bot.sendInput('hello', sessionId: sessionId);
    print(botRes.output!.generic!.first.text);
    print(botRes.responseText);


  }
}

class Stt {

  Future<void> Try() async {
    stt.SpeechToText speech = stt.SpeechToText();
    await Future.delayed(Duration(seconds: 1));
    print(speech);
    speech.stop();
  }
}

