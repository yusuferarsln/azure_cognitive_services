import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'download_handler.dart';
import 'handler.dart';

void main(List<String> args) async {
  print(pid);
  final app = Router();
  final handlerX = AzureHandler();
  final handlerZ = DownloadHandler();

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(app);

  app.post('/', handlerX.transcribeAudio);
  app.post('/down', handlerZ.downloadAudio);

  var server = await serve(
    handler,
    InternetAddress.anyIPv4,
    8080,
  );

  print('Server created ${server.address}');
}
