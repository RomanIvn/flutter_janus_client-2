import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:janus_client/JanusTransport.dart';
import 'dart:io';

void main() {
  RestJanusTransport rest = RestJanusTransport(url: 'https://master-janus.onemandev.tech/rest');

  group('RestJanusTransport', () {
    test('Create a new Session', () async {
      var response = await rest.post({"janus": "create", "transaction": "sdhbds"});
      rest.sessionId = response['data']['id'];
      expect(response['janus'], 'success');
    });

    test('Attach A Plugin', () async {
      Map<String, dynamic> request = {"janus": "attach", "plugin": "janus.plugin.videoroom", "transaction": "random for attaching plugin"};
      var response = await rest.post(request);

      expect(response['janus'], 'success');
    });
  });
}
