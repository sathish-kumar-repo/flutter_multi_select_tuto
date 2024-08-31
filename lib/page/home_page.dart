import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multiselect_scope/multiselect_scope.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> _items;
  late MultiselectController _multiselectController;
  late Random random;
  @override
  void initState() {
    super.initState();
    random = Random();
    _items = List.generate(20, (index) => 'Item $index');
    _multiselectController = MultiselectController();
  }

  @override
  void dispose() {
    super.dispose();
    _multiselectController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Select'),
      ),
      body: MultiselectScope<String>(
        controller: _multiselectController,
        dataSource: _items,
        // Set this to true if you want automatically
        // clear selection when user tap back button
        clearSelectionOnPop: true,
        // When you update [dataSource] then selected indexes will update
        // so that the same elements in new [dataSource] are selected
        keepSelectedItemsBetweenUpdates: true,
        initialSelectedIndexes: const [1, 3],
        onSelectionChanged: (indexes, items) {
          debugPrint(
            'Custom listener invoked! Indexes: $indexes Items: $items',
          );
          return;
        },

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Getting link to controller
                    final controller = MultiselectScope.controllerOf(context);
                    final itemIsSelected = controller.isSelected(index);
                    return InkWell(
                      onLongPress: () {
                        if (!controller.selectionAttached) {
                          controller.select(index);
                        }
                      },
                      onTap: () {
                        if (controller.selectionAttached) {
                          controller.select(index);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // Colorize item depend on selected it or not
                          color: itemIsSelected
                              ? Theme.of(context).primaryColor
                              : null,
                          child: Text(
                            _items[index],
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Wrap(
                children: [
                  RawMaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    fillColor: Colors.blueGrey,
                    onPressed: () {
                      setState(() {
                        final randItem = 'RandItem${random.nextInt(256)}';

                        final randomIndex =
                            _items.isEmpty ? 0 : random.nextInt(_items.length);
                        _items.insert(randomIndex, randItem);
                      });
                    },
                    child: const Text('Add rand'),
                  ),
                  RawMaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    fillColor: Colors.lightGreen,
                    onPressed: () {
                      setState(() {
                        if (_items.length == 1) {
                          _items.removeAt(0);
                        } else {
                          _items.removeAt(random.nextInt(_items.length - 1));
                        }
                      });
                    },
                    child: const Text('Remove rand'),
                  ),
                  RawMaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    fillColor: Colors.blueGrey,
                    child: const Text('Delete'),
                    onPressed: () {
                      setState(() {
                        final itemsToRemove = _multiselectController
                            .getSelectedItems()
                            .cast<String>();

                        _items = _items
                            .where(
                                (element) => !itemsToRemove.contains(element))
                            .toList();
                      });
                    },
                  ),
                  RawMaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    fillColor: Colors.lightGreen,
                    onPressed: () {
                      _multiselectController.select(0);
                    },
                    child: const Text('Select 0'),
                  ),
                  RawMaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    fillColor: Colors.amber,
                    onPressed: () {
                      _multiselectController.selectAll();
                    },
                    child: const Text('Select all'),
                  ),
                  RawMaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    fillColor: Colors.tealAccent,
                    onPressed: () {
                      _multiselectController.invertSelection();
                    },
                    child: const Text('Invert'),
                  ),
                  RawMaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    fillColor: Colors.deepPurpleAccent,
                    onPressed: () {
                      _multiselectController.clearSelection();
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
