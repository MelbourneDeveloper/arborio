// ignore_for_file: public_member_api_docs

import 'package:arborio/tree_view.dart';
import 'package:flutter/material.dart';

enum ElementType { file, folder }

class FileSystemElement {
  FileSystemElement(this.name, this.type);

  final String name;
  final ElementType type;
}

const defaultExpander = Icon(Icons.chevron_right);
const arrowRight = Icon(Icons.arrow_right);
const doubleArrow = Icon(Icons.double_arrow);
const fingerPointer = Text(
  '👉',
  style: TextStyle(fontSize: 16),
);

enum DisplayStyle { modern, retro, crazy }

// Initialize your tree nodes with FileSystemElement type
List<TreeNode<FileSystemElement>> fileTree() => [
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
