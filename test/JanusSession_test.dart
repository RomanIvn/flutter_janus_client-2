// import 'package:test/test.dart';

import 'package:janus_client/JanusClient.dart';
import 'package:janus_client/JanusSession.dart';
import 'package:janus_client/JanusTransport.dart';

void main() async {
  RestJanusTransport rest = RestJanusTransport(url: 'https://master-janus.onemandev.tech/rest');

  JanusClient j = JanusClient(transport: rest);

  JanusSession session = await j.createSession();
  print(session.sessionId);

  // group('RestJanusTransport', () {
  //   // test('Create a new Session', () async {
  //   //   var response =
  //   //   await rest.post({"janus": "create", "transaction": "sdhbds"});
  //   //   rest.sessionId = response['data']['id'];
  //   //   expect(response['janus'], 'success');
  //   // });
  //
  //   test('Create a new Session', () async {
  //     JanusClient j=JanusClient(transport:ws);
  //     // RestJanusTransport rest =
  //     // RestJanusTransport(url: 'https://master-janus.onemandev.tech/rest');
  //     JanusSession session=await j.createSession();
  //     print(session.sessionId);
  //   });

  // test('Attach A Plugin', () async {
  //   Map<String, dynamic> request = {
  //     "janus": "attach",
  //     "plugin": "janus.plugin.videoroom",
  //     "transaction": "random for attaching plugin"
  //   };
  //   var response = await rest.post(request);
  //   rest.handleId = response['data']['id'];
  //   expect(response['janus'], 'success');
  // });
  // });
}
