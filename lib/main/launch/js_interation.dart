import 'dart:convert';
import 'package:cityCloud/r.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:oktoast/oktoast.dart';

class JSInterationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JSInterationPageState();
  }
}

class JSInterationPageState extends State<JSInterationPage> {
  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toast',
        onMessageReceived: (JavascriptMessage message) {
          showToast(message.message);
        });
  }

  WebViewController _controller;
  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString(R.assetsFilesTest);
    _controller
        .loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets();
          },
          javascriptChannels: <JavascriptChannel>[
            _alertJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('js://webview')) {
              showToast('JS调用了Flutter By navigationDelegate');
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
        );
      }),
      floatingActionButton: jsButton(),
    );
  }

  Widget jsButton() {
    return FloatingActionButton(onPressed: () async {
      _controller.evaluateJavascript('callJS("visible")').then((result) {});
    });
  }
}
