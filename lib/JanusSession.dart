import 'dart:async';
import 'package:janus_client/JanusPlugin.dart';
import 'package:janus_client/JanusTransport.dart';
import 'package:janus_client/JanusClient.dart';
import 'package:janus_client/utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'JanusClient.dart';

class JanusSession {
  int refreshInterval;
  JanusTransport transport;
  JanusClient context;
  int sessionId;
  Timer _keepAliveTimer;
  Map<int, JanusPlugin> _pluginHandles = {};

  JanusSession({this.refreshInterval, this.transport, this.context});

  Future<void> create() async {
    try {
      String transaction = getUuid().v4();
      Map<String, dynamic> request = {"janus": "create", "transaction": transaction, ...context.tokenMap, ...context.apiMap};
      Map<String, dynamic> response;
      RestJanusTransport rest = (transport as RestJanusTransport);
      response = await rest.post(request);
      if (response != null) {
        if (response.containsKey('janus') && response.containsKey('data')) {
          sessionId = response['data']['id'];
          rest.sessionId = sessionId;
        }
      } else {
        throw "Janus Server not live or incorrect url/path specified";
      }

      _keepAlive();
    } on WebSocketChannelException catch (e) {
      throw "Connection to given url can't be established\n reason:-" + e.message;
    } catch (e) {
      throw "Connection to given url can't be established\n reason:-" + e.toString();
    }
  }

  Future<JanusPlugin> attach(String pluginName) async {
    JanusPlugin plugin;
    int handleId;
    String transaction = getUuid().v4();
    Map<String, dynamic> request = {"janus": "attach", "plugin": pluginName, "transaction": transaction};
    request["token"] = context.token;
    request["apisecret"] = context.apiSecret;
    request["session_id"] = sessionId;
    Map<String, dynamic> response;
    print('using rest transport for creating plugin handle');
    RestJanusTransport rest = (transport as RestJanusTransport);
    response = await rest.post(request);
    print(response);
    if (response.containsKey('janus') && response.containsKey('data')) {
      handleId = response['data']['id'];
      rest.sessionId = sessionId;
    }

    plugin = JanusPlugin(plugin: pluginName, transport: transport, context: context, handleId: handleId, session: this);
    _pluginHandles[handleId] = plugin;
    await plugin.init();
    return plugin;
  }

  void dispose() {
    if (_keepAliveTimer != null) {
      _keepAliveTimer.cancel();
    }
    if (transport != null) {
      transport.dispose();
    }
  }

  _keepAlive() {
    if (sessionId != null) {
      Timer.periodic(Duration(seconds: refreshInterval), (timer) async {
        this._keepAliveTimer = timer;
        try {
          String transaction = getUuid().v4();
          Map<String, dynamic> response;
          RestJanusTransport rest = (transport as RestJanusTransport);
          response = await rest.post({"janus": "keepalive", "session_id": sessionId, "transaction": transaction, ...context.apiMap, ...context.tokenMap});
        } catch (e) {
          timer.cancel();
        }
      });
    }
  }
}
