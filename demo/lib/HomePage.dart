import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState<HomePage> extends State {
  List<Item> _itemList = [];

  /// Toast
  _showToast() {
    ToastUtil.showErrorToast(context, "哈喽");
    ToastUtil.showSuccessToast(context, "哈喽");
    ToastUtil.showToast(context, text: "222");
  }

  @override
  void initState() {
    super.initState();
    _itemList = [Item(name: "toast", function: _showToast)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: itemBuilder,
          itemCount: _itemList.length,
        ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return InkWell(
      onTap: _itemList[index].function,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Text(_itemList[index].name),
      ),
    );
  }
}

class Item {
  final String name;
  final Function function;

  Item({this.name, this.function});
}
