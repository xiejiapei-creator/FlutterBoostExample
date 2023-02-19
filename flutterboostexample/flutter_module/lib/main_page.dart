import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class MainPage extends StatefulWidget {
  final String? data;
  const MainPage({Key? key, this.data}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    print("进入到 Flutter 的商品列表页面");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              BoostNavigator.instance.pop();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: const Text("商品列表"),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.1),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: InkWell (
            child: Text(widget.data ?? ""),
              onTap: () {
                BoostNavigator.instance.push("Article");
              },
          ),
        ),
      ),
    );
  }
}
