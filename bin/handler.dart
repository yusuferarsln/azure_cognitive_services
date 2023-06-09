import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

class AzureHandler {
  AzureHandler();

  String subscriptionKey = 'b849bd68bb2945b2b69fd912d9e48b87';
  String bearer =
      'eyJhbGciOiJFUzI1NiIsImtpZCI6ImtleTEiLCJ0eXAiOiJKV1QifQ.eyJyZWdpb24iOiJlYXN0dXMiLCJzdWJzY3JpcHRpb24taWQiOiIzNmE2OTVmYWYyZjI0ODE3ODIxNmNhMWQ0MWY1Y2JkNSIsInByb2R1Y3QtaWQiOiJTcGVlY2hTZXJ2aWNlcy5GMCIsImNvZ25pdGl2ZS1zZXJ2aWNlcy1lbmRwb2ludCI6Imh0dHBzOi8vYXBpLmNvZ25pdGl2ZS5taWNyb3NvZnQuY29tL2ludGVybmFsL3YxLjAvIiwiYXp1cmUtcmVzb3VyY2UtaWQiOiIvc3Vic2NyaXB0aW9ucy9hYjQ5ODJiOC1mNDgwLTQ4YjktODI1ZS0wMjQ3YjA0MzZhMzcvcmVzb3VyY2VHcm91cHMvR3JlZW5tdXNrL3Byb3ZpZGVycy9NaWNyb3NvZnQuQ29nbml0aXZlU2VydmljZXMvYWNjb3VudHMvZ21zcGVlY2hpbnN0YW5jZSIsInNjb3BlIjoic3BlZWNoc2VydmljZXMiLCJhdWQiOiJ1cm46bXMuc3BlZWNoc2VydmljZXMuZWFzdHVzIiwiZXhwIjoxNjgwMTg2NzAzLCJpc3MiOiJ1cm46bXMuY29nbml0aXZlc2VydmljZXMifQ.d_ZLlmulzv8ohOSuC1OgVJKUKA6SfT6UAM30phtc23YPPgBpf7y20K7GE8ZKMPNTv1y_8xZffjSU10pwUuuCow';

  Future<Response> transcribeAudio(Request r) async {
    final bytes = await r.read().toList();
    final body = bytes.expand((x) => x).toList();
    print(body);

    final uri = Uri.parse(
        "https://eastus.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US&format=simple");

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $bearer',
      HttpHeaders.contentTypeHeader: 'audio/mpeg',
      'Ocp-Apim-Subscription-Key': subscriptionKey
    };
    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return Response.ok(response.body);
    } else {
      throw Exception('Failed to transcribe audio');
    }
  }
}
