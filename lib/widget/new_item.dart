import 'package:flutter/material.dart';
import 'package:shop_app/data/categories.dart';
import 'package:shop_app/models/category.dart';
import 'package:shop_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  Category _selectedCategory = categories[Categories.dairy]!;
  String _enteredName = '';
  var _enteredQuan = 0;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Item"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(9),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  maxLength: 50,
                  onSaved: (newValue) {
                    _enteredName = newValue!;
                  },
                  validator: (String? value) {
                    if (value == null ||
                        value.trim().length <= 1 ||
                        value.trim().length >= 50) {
                      return "Must be Between 1 and 50 char";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                        initialValue: '1',
                        onSaved: (newValue) {
                          _enteredQuan = int.parse(newValue!);
                        },
                        validator: (String? value) {
                          if (value == null ||
                              int.tryParse(value)! <= 0 ||
                              int.tryParse(value) == null) {
                            return "Must be Positive Number";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,

                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(category.value.title),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _formkey.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                        }

                        Navigator.of(context).pop(
                          GroceryItem(
                            id: DateTime.now().toString(),
                            name: _enteredName,
                            quantity: _enteredQuan,
                            category: _selectedCategory,
                          ),
                        );
                      },
                      child: const Text('Save New Item'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
