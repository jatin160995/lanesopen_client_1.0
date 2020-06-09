import 'package:client/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  String url;
  String title;
  WebviewScreen(this.url, this.title);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title,
          style: TextStyle(
            color: darkText
          ),),
          backgroundColor: white,
          iconTheme: IconThemeData(color: darkText),
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: widget.url))
          ],
        ));
  }
}