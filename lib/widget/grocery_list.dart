import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/data/categories.dart';
import 'package:shop_app/models/category.dart';
import 'package:shop_app/models/grocery_item.dart';
import 'new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  bool isloading = true;
  List<GroceryItem> _groceryItems = [];
  _addeditem() async {
    final GroceryItem? newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));
    if (newItem == null) return;
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void loadedDate() async {
    try {
      final url = Uri.https(
        'flutter-test-d1fb7-default-rtdb.firebaseio.com',
        'text-test.json',
      );
      final res = await http.get(url);
      final List<GroceryItem> loadedata = [];
      final Map<String, dynamic> loadeditems = json.decode(res.body);
      for (var item in loadeditems.entries) {
        final Category category = categories.entries
            .firstWhere((e) => e.value.title == item.value['category'])
            .value;
        loadedata.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedata;
        isloading = false;
      });
    } catch (e) {
      setState(() {
        contant = const Center(
          child: Text("Field to fetch data please try agine later"),
        );
      });
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    loadedDate();
  }

  Widget contant = const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _addeditem();
            },
            icon: const Icon(Icons.add),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color.fromARGB(232, 7, 17, 59),
        title: const Text(
          "Grocery List",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: isloading
          ? contant
          : _groceryItems.isNotEmpty
          ? ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(_groceryItems[index].id),
                onDismissed: (_) {
                  final url = Uri.https(
                    'flutter-test-d1fb7-default-rtdb.firebaseio.com',
                    'text-test/${_groceryItems[index].id}.json',
                  );
                  http.delete(url);
                  setState(() {
                    _groceryItems.remove(_groceryItems[index]);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Card.outlined(
                    child: ListTile(
                      title: Text(
                        _groceryItems[index].name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: Container(
                        width: 24,
                        height: 24,
                        color: _groceryItems[index].category.color,
                      ),
                      trailing: Text(
                        _groceryItems[index].quantity.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: Text(
                "Not Items Added Yet",
                style: TextStyle(fontSize: 35),
              ),
            ),
    );
  }
}
