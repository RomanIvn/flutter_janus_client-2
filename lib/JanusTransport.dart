import 'dart:convert';
import 'package:janus_client/utils.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/io_client.dart';
import 'dart:io';

abstract class JanusTransport {
  String url;
  int sessionId;

  JanusTransport({this.url});

  void dispose();
}

class RestJanusTransport extends JanusTransport {
  RestJanusTransport({String url}) : super(url: url);

  /*
  * method for posting data to janus by using http client
  * */
  Future<dynamic> post(body, {int handleId}) async {
    var suffixUrl = '';
    if (sessionId != null && handleId == null) {
      suffixUrl = suffixUrl + "/$sessionId";
    } else if (sessionId != null && handleId != null) {
      suffixUrl = suffixUrl + "/$sessionId/$handleId";
    }
    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final mhttp = new IOClient(ioc);

      var response = (await mhttp.post(Uri.parse(url + suffixUrl), body: stringify(body))).body;
      return parse(response);
    } on JsonCyclicError {
      return null;
    } on JsonUnsupportedObjectError {
      return null;
    } catch (e) {
      return null;
    }
  }

  /*
  * private method for get data to janus by using http client
  * */
  Future<dynamic> get({handleId}) async {
    var suffixUrl = '';
    if (sessionId != null && handleId == null) {
      suffixUrl = suffixUrl + "/$sessionId";
    } else if (sessionId != null && handleId != null) {
      suffixUrl = suffixUrl + "/$sessionId/$handleId";
    }
    final ioc = new HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final mhttp = new IOClient(ioc);

    return parse((await mhttp.get(Uri.parse(url + suffixUrl))).body);
  }

  @override
  void dispose() {}
}
