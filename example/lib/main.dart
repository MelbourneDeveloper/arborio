// ignore_for_file: public_member_api_docs

import 'dart:ui';

import 'package:arborio/tree.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

enum ElementType { file, folder }

class FileSystemElement {
  FileSystemElement(this.name, this.type);

  final String name;
  final ElementType type;
}

// Initialize your tree nodes with FileSystemElement type
List<TreeNode<FileSystemElement>> nodes = [
  TreeNode<FileSystemElement>(
    const Key('Projects'),
    FileSystemElement('Projects', ElementType.folder),
    [
      TreeNode<FileSystemElement>(
        const Key('FlutterApp'),
        FileSystemElement('FlutterApp', ElementType.folder),
        [
          TreeNode<FileSystemElement>(
            const Key('lib'),
            FileSystemElement('lib', ElementType.folder),
            [
              TreeNode<FileSystemElement>(
                const Key('main.dart'),
                FileSystemElement('main.dart', ElementType.file),
              ),
              TreeNode<FileSystemElement>(
                const Key('app.dart'),
                FileSystemElement('app.dart', ElementType.file),
              ),
            ],
          ),
          TreeNode<FileSystemElement>(
            const Key('assets'),
            FileSystemElement('assets', ElementType.folder),
            [
              TreeNode<FileSystemElement>(
                const Key('logo.png'),
                FileSystemElement('logo.png', ElementType.file),
              ),
              TreeNode<FileSystemElement>(
                const Key('data.json'),
                FileSystemElement('data.json', ElementType.file),
              ),
            ],
          ),
        ],
      ),
      TreeNode<FileSystemElement>(
        const Key('PythonScripts'),
        FileSystemElement('PythonScripts', ElementType.folder),
        [
          TreeNode<FileSystemElement>(
            const Key('script.py'),
            FileSystemElement('script.py', ElementType.file),
          ),
        ],
      ),
    ],
  ),
  TreeNode<FileSystemElement>(
    const Key('Documents'),
    FileSystemElement('Documents', ElementType.folder),
    [
      TreeNode<FileSystemElement>(
        const Key('Resume.docx'),
        FileSystemElement('Resume.docx', ElementType.file),
      ),
      TreeNode<FileSystemElement>(
        const Key('Budget.xlsx'),
        FileSystemElement('Budget.xlsx', ElementType.file),
      ),
    ],
  ),
  TreeNode<FileSystemElement>(
    const Key('Music'),
    FileSystemElement('Music', ElementType.folder),
    [
      TreeNode<FileSystemElement>(
        const Key('Favorites'),
        FileSystemElement('Favorites', ElementType.folder),
        [
          TreeNode<FileSystemElement>(
            const Key('song1.mp3'),
            FileSystemElement('song1.mp3', ElementType.file),
          ),
          TreeNode<FileSystemElement>(
            const Key('song2.mp3'),
            FileSystemElement('song2.mp3', ElementType.file),
          ),
        ],
      ),
    ],
  ),
  TreeNode<FileSystemElement>(
    const Key('Photos'),
    FileSystemElement('Photos', ElementType.folder),
    [
      TreeNode<FileSystemElement>(
        const Key('Vacation'),
        FileSystemElement('Vacation', ElementType.folder),
        [
          TreeNode<FileSystemElement>(
            const Key('image1.jpg'),
            FileSystemElement('image1.jpg', ElementType.file),
          ),
          TreeNode<FileSystemElement>(
            const Key('image2.jpg'),
            FileSystemElement('image2.jpg', ElementType.file),
          ),
        ],
      ),
      TreeNode<FileSystemElement>(
        const Key('Family'),
        FileSystemElement('Family', ElementType.folder),
        [
          TreeNode<FileSystemElement>(
            const Key('photo1.jpg'),
            FileSystemElement('photo1.jpg', ElementType.file),
          ),
        ],
      ),
    ],
  ),
];

// The main app widget
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(
              double.infinity,
              56,
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AppBar(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  title: const Text('Awesome Treeview Sample'),
                  leading: const Icon(Icons.chevron_left),
                  elevation: 0,
                ),
              ),
            ),
          ),
          body: TreeView(
            animationCurve: Curves.easeInCirc,
            builder: (
              context,
              node,
              isSelected,
              expansionAnimation,
              select,
            ) =>
                switch (node.title.type) {
              (ElementType.file) => InkWell(
                  onTap: () => select(node),
                  // ignore: use_decorated_box
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                Colors.lightBlueAccent.withOpacity(0.6),
                                Colors.lightBlueAccent.withOpacity(0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Image.asset(
                            switch (
                                path.extension(node.title.name).toLowerCase()) {
                              ('.mp3') => 'assets/images/music.png',
                              ('.py') => 'assets/images/python.png',
                              ('.jpg') => 'assets/images/image.png',
                              ('.png') => 'assets/images/image.png',
                              ('.dart') => 'assets/images/dart.png',
                              ('.json') => 'assets/images/json.png',
                              (_) => 'assets/images/file.png'
                            },
                            width: 32,
                            height: 32,
                          ),
                          const SizedBox(width: 16),
                          Text(node.title.name),
                        ],
                      ),
                    ),
                  ),
                ),
              (ElementType.folder) => Row(
                  children: [
                    RotationTransition(
                      turns: expansionAnimation,
                      child: Image.asset(
                        'assets/images/folder.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(node.title.name),
                  ],
                ),
            },
            nodes: nodes,
            expanderIcon: const Icon(Icons.chevron_right),
          ),
        ),
      );
}
