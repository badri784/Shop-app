import 'package:flutter/material.dart';
import 'package:shop_app/models/grocery_item.dart';
import 'new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push<GroceryItem>(
                    MaterialPageRoute(builder: (ctx) => const NewItem()),
                  )
                  .then((GroceryItem? value) {
                    if (value == null) return;
                    setState(() {
                      _groceryItems.add(value);
                    });
                  });
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
      body: _groceryItems.isEmpty
          ? const Center(
              child: Text('No Items Added !', style: TextStyle(fontSize: 35)),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(_groceryItems[index].id),
                onDismissed: (_) {
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
            ),
    );
  }
}
