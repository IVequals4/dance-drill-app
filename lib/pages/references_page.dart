import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/reference.dart';

class ReferencesPage extends StatefulWidget {
  const ReferencesPage({super.key});

  @override
  State<ReferencesPage> createState() => _ReferencesPageState();
}

class _ReferencesPageState extends State<ReferencesPage> {
  late Box<Reference> referenceBox;
  late List<Reference> references;

  @override
  void initState() {
    super.initState();

    referenceBox = Hive.box<Reference>('references');

    if (referenceBox.isEmpty) {
      referenceBox.addAll([
        Reference(
          name: 'Tone Whop',
          description: '&. Raise \n1. Step\n&. Heels out\n2. Heels back in',
          tags: ['litefeet', 'foundations', 'footwork'],
        ),
        Reference(
          name: 'Tic Tac Toe',
          description: 'Any tap to the joint',
          tags: ['litefeet', 'foundations', 'tictac'],
        ),
      ]);
    }

    references = referenceBox.values.toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));;
  }

  void pickRandomReferenceByTags() {
    if (references.isEmpty) return;

    final allTags = references.expand((r) => r.tags).toSet().toList()..sort();

    final selectedTags = <String>{};

    showDialog(
      context: context,
      builder: (_) {
        final screenWidth = MediaQuery.of(context).size.width;
        final dialogWidth = screenWidth * 0.8;

        return AlertDialog(
          title: const Text('Pick Tags'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: dialogWidth,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allTags.length,
                  itemBuilder: (context, index) {
                    final tag = allTags[index];
                    final isSelected = selectedTags.contains(tag);

                    return CheckboxListTile(
                      title: Text(tag),
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                List<Reference> filtered;

                if (selectedTags.isEmpty) {
                  filtered = List.from(references);
                } else {
                  filtered = references
                      .where(
                        (r) => selectedTags.every((t) => r.tags.contains(t)),
                      )
                      .toList();
                }

                Navigator.pop(context);

                if (filtered.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No references found with selected tags'),
                    ),
                  );
                  return;
                }

                final random = Random();
                final reference = filtered[random.nextInt(filtered.length)];

                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(reference.name),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: reference.tags
                                .map(
                                  (t) => Chip(
                                    label: Text(t),
                                    backgroundColor: Colors.orange.shade100,
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          Text(reference.description),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Pick Random'),
            ),
          ],
        );
      },
    );
  }

  void addReference() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        final screenWidth = MediaQuery.of(context).size.width;
        final dialogWidth = screenWidth * 0.8; 

        return AlertDialog(
          title: const Text('Add Reference'),
          content: SizedBox(
            width: dialogWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final tags = tagsController.text
                    .split(',')
                    .map((t) => t.trim().toLowerCase())
                    .where((t) => t.isNotEmpty)
                    .toList();

                final reference = Reference(
                  name: nameController.text,
                  description: descriptionController.text,
                  tags: tags,
                );

                referenceBox.add(reference);

                setState(() {
                  references = referenceBox.values.toList()
                  ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                });

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void editReference(int index) {
    final reference = references[index];

    final nameController = TextEditingController(text: reference.name);
    final descriptionController = TextEditingController(
      text: reference.description,
    );
    final tagsController = TextEditingController(
      text: reference.tags.join(', '),
    );

    showDialog(
      context: context,
      builder: (_) {
        final screenWidth = MediaQuery.of(context).size.width;
        final dialogWidth = screenWidth * 0.8; 

        return AlertDialog(
          title: const Text('Edit Reference'),
          content: SizedBox(
            width: dialogWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                reference.name = nameController.text;
                reference.description = descriptionController.text;
                reference.tags = tagsController.text
                    .split(',')
                    .map((t) => t.trim().toLowerCase())
                    .where((t) => t.isNotEmpty)
                    .toList();

                reference.save();

                setState(() {
                  references = referenceBox.values.toList()
                  ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void removeReference(int index) {
    references[index].delete();

    setState(() {
      references = referenceBox.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('References'),
        backgroundColor: Colors.orange,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: addReference,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickRandomReferenceByTags,
                    label: const Text('Pick Something'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: references.length,
              itemBuilder: (context, index) {
                final reference = references[index];

                return ReferenceContainer(
                  reference: reference,
                  onEdit: () => editReference(index),
                  onRemove: () => removeReference(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReferenceContainer extends StatelessWidget {
  final Reference reference;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const ReferenceContainer({
    super.key,
    required this.reference,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final screenWidth = MediaQuery.of(context).size.width;
        final dialogWidth = screenWidth * 0.85; 

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(reference.name),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: dialogWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: reference.tags
                        .map(
                          (t) => Chip(
                            label: Text(t), 
                            backgroundColor: Colors.orange.shade100,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(reference.description),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onEdit();
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onRemove();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reference.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: reference.tags
                  .map((tag) => Chip(label: Text(tag)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
