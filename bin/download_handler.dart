import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

class DownloadHandler {
  DownloadHandler();
  Future<Response> downloadAudio(Request r) async {
    final urlX = await r.readAsString();
    print(urlX);
    final rquest = jsonDecode(urlX);
    print(rquest['url']);

    final response = await http.get(Uri.parse(rquest['url']));
    if (response.statusCode == 200) {
      final rbody = response.body;
      var lista = rbody.codeUnits;

      var lastresponse = await transcribeAudio(lista);

      return Response.ok(lastresponse);
    } else {
      print('Failed to download file.');
    }
    return Response.badRequest();
  }

  transcribeAudio(List<int> file) async {
    String subscriptionKey = '<Your Key>';
    String bearer = '<Your token>';

    final uri = Uri.parse(
        "https://eastus.api.cognitive.microsoft.com/speechtotext/v3.1/transcriptions");

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $bearer',
      HttpHeaders.contentTypeHeader: 'application/json',
      'Ocp-Apim-Subscription-Key': subscriptionKey
    };

    String stringAx = '''
    {
      "contentUrls":[
                "https://dl.dropboxusercontent.com/s/4oxen1t9ho00ba0/test2_en-US_en-US_F.mp3?dl=0",
      ]
      ,
      "locale": "en-US",
      "displayName": "My Transcription",
      "properties": {
        "wordLevelTimestampsEnabled": true,
        "languageIdentification": {
          "candidateLocales": ["en-US", "de-DE", "es-ES"],
        }
      },
    }
    ''';

    final response = await http.post(uri, headers: headers, body: stringAx);
    print(response.body);
    return response.body;
  }
}
