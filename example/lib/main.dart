import 'package:arborio/tree_view.dart';
import 'package:flutter/material.dart';

const treeViewKey = TreeViewKey<FileSystemElement>();

enum ElementType { file, folder }

// Define your data type
class FileSystemElement {
  FileSystemElement(this.name, this.type);
  final String name;
  final ElementType type;
}

// Create tree nodes
final nodes = [
  TreeNode<FileSystemElement>(
    const Key('root'),
    FileSystemElement('Documents', ElementType.folder),
    [
      TreeNode<FileSystemElement>(
        const Key('child1'),
        FileSystemElement('report.pdf', ElementType.file),
      ),
    ],
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: TreeView<FileSystemElement>(
            key: treeViewKey,
            nodes: nodes,
            builder: (context, node, isSelected, animation, select) => Row(
              children: [
                Icon(
                  node.data.type == ElementType.folder
                      ? Icons.folder
                      : Icons.file_copy,
                ),
                Text(node.data.name),
              ],
            ),
            expanderBuilder: (context, isExpanded, animation) =>
                RotationTransition(
              turns: animation,
              child: const Icon(Icons.chevron_right),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
}
