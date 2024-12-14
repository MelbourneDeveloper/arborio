import 'package:arborio/tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Taxonomy data for testing biological classification
class Species {
  const Species({
    required this.name,
    required this.scientificName,
    this.description = '',
  });

  final String name;
  final String scientificName;
  // ignore: unreachable_from_main
  final String description;

  @override
  String toString() => '$name ($scientificName)';
}

/// File system data for testing directory structures
class FileSystemNode {
  const FileSystemNode({
    required this.name,
    required this.type,
    this.size = 0,
  });

  final String name;
  final FileType type;
  final int size;

  @override
  String toString() => name;
}

enum FileType { file, directory }

/// Organization data for testing company structures
class Employee {
  const Employee({
    required this.name,
    required this.title,
    this.department = '',
  });

  final String name;
  final String title;
  final String department;

  @override
  String toString() => '$name - $title';
}

void main() {
  group('TreeView Widget Tests - Taxonomy Data', () {
    final taxonomyData = [
      TreeNode<Species>(
        const ValueKey('mammals'),
        const Species(
          name: 'Mammals',
          scientificName: 'Mammalia',
          description: 'Warm-blooded vertebrates',
        ),
        [
          TreeNode<Species>(
            const ValueKey('primates'),
            const Species(
              name: 'Primates',
              scientificName: 'Primates',
              description: 'Mammals with complex brains',
            ),
            [
              TreeNode<Species>(
                const ValueKey('human'),
                const Species(
                  name: 'Human',
                  scientificName: 'Homo sapiens',
                  description: 'Modern humans',
                ),
              ),
              TreeNode<Species>(
                const ValueKey('chimp'),
                const Species(
                  name: 'Chimpanzee',
                  scientificName: 'Pan troglodytes',
                  description: 'Great apes',
                ),
              ),
            ],
          ),
          TreeNode<Species>(
            const ValueKey('carnivora'),
            const Species(
              name: 'Carnivora',
              scientificName: 'Carnivora',
              description: 'Meat-eating mammals',
            ),
            [
              TreeNode<Species>(
                const ValueKey('cat'),
                const Species(
                  name: 'Cat',
                  scientificName: 'Felis catus',
                  description: 'Domestic cats',
                ),
              ),
            ],
          ),
        ],
      ),
    ];

    testWidgets('renders taxonomy hierarchy correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TreeView<Species>(
              nodes: taxonomyData,
              builder: (context, node, isSelected, animation, select) =>
                  ListTile(
                title: Text(
                  node.data.name,
                  key: ValueKey('${node.data.name}_title'),
                ),
                subtitle: Text(node.data.scientificName),
                selected: isSelected,
                onTap: () => select(node),
              ),
              expanderBuilder: (context, isExpanded, animation) =>
                  RotationTransition(
                turns: animation,
                child: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('Mammals_title')), findsOneWidget);
      expect(find.text('Mammalia'), findsOneWidget);

      // Test expansion
      await tester.tap(find.byKey(const ValueKey('Mammals_title')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byKey(const ValueKey('Primates_title')), findsOneWidget);
      expect(find.byKey(const ValueKey('Carnivora_title')), findsOneWidget);

      await expectLater(
        find.byType(TreeView<Species>),
        matchesGoldenFile('goldens/taxonomy_tree_expanded.png'),
      );
    });
  });

  group('TreeView Widget Tests - File System', () {
    final fileSystemData = [
      TreeNode<FileSystemNode>(
        const ValueKey('root'),
        const FileSystemNode(
          name: 'root',
          type: FileType.directory,
        ),
        [
          TreeNode<FileSystemNode>(
            const ValueKey('documents'),
            const FileSystemNode(
              name: 'Documents',
              type: FileType.directory,
            ),
            [
              TreeNode<FileSystemNode>(
                const ValueKey('resume'),
                const FileSystemNode(
                  name: 'resume.pdf',
                  type: FileType.file,
                  size: 1024,
                ),
              ),
              TreeNode<FileSystemNode>(
                const ValueKey('notes'),
                const FileSystemNode(
                  name: 'notes.txt',
                  type: FileType.file,
                  size: 256,
                ),
              ),
            ],
          ),
          TreeNode<FileSystemNode>(
            const ValueKey('pictures'),
            const FileSystemNode(
              name: 'Pictures',
              type: FileType.directory,
            ),
            [
              TreeNode<FileSystemNode>(
                const ValueKey('vacation'),
                const FileSystemNode(
                  name: 'vacation.jpg',
                  type: FileType.file,
                  size: 2048,
                ),
              ),
            ],
          ),
        ],
      ),
    ];

    testWidgets('renders file system hierarchy correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TreeView<FileSystemNode>(
              nodes: fileSystemData,
              builder: (context, node, isSelected, animation, select) =>
                  ListTile(
                leading: Icon(
                  node.data.type == FileType.directory
                      ? Icons.folder
                      : Icons.insert_drive_file,
                ),
                title: Text(node.data.name),
                subtitle: node.data.type == FileType.file
                    ? Text('${node.data.size} KB')
                    : null,
                selected: isSelected,
                onTap: () => select(node),
              ),
              expanderBuilder: (context, isExpanded, animation) =>
                  RotationTransition(
                turns: animation,
                child: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
      );

      expect(find.text('root'), findsOneWidget);
      expect(find.byIcon(Icons.folder), findsWidgets);

      // Test expansion
      await tester.tap(find.text('root'));
      await tester.pumpAndSettle();

      expect(find.text('Documents'), findsOneWidget);
      expect(find.text('Pictures'), findsOneWidget);

      await expectLater(
        find.byType(TreeView<FileSystemNode>),
        matchesGoldenFile('goldens/file_system_tree_expanded.png'),
      );
    });
  });

  group('TreeView Widget Tests - Organization Structure', () {
    final organizationData = [
      TreeNode<Employee>(
        const ValueKey('ceo'),
        const Employee(
          name: 'John Smith',
          title: 'CEO',
          department: 'Executive',
        ),
        [
          TreeNode<Employee>(
            const ValueKey('cto'),
            const Employee(
              name: 'Jane Doe',
              title: 'CTO',
              department: 'Technology',
            ),
            [
              TreeNode<Employee>(
                const ValueKey('lead_dev'),
                const Employee(
                  name: 'Bob Wilson',
                  title: 'Lead Developer',
                  department: 'Engineering',
                ),
              ),
            ],
          ),
          TreeNode<Employee>(
            const ValueKey('cfo'),
            const Employee(
              name: 'Mike Johnson',
              title: 'CFO',
              department: 'Finance',
            ),
            [
              TreeNode<Employee>(
                const ValueKey('accountant'),
                const Employee(
                  name: 'Sarah Brown',
                  title: 'Senior Accountant',
                  department: 'Finance',
                ),
              ),
            ],
          ),
        ],
      ),
    ];

    testWidgets('renders organization hierarchy correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TreeView<Employee>(
              nodes: organizationData,
              builder: (context, node, isSelected, animation, select) =>
                  ListTile(
                leading: const Icon(Icons.person),
                title: Text(node.data.name),
                subtitle: Text('${node.data.title} - ${node.data.department}'),
                selected: isSelected,
                onTap: () => select(node),
              ),
              expanderBuilder: (context, isExpanded, animation) =>
                  RotationTransition(
                turns: animation,
                child: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
      );

      expect(find.text('John Smith'), findsOneWidget);
      expect(find.text('CEO - Executive'), findsOneWidget);

      // Test expansion
      await tester.tap(find.text('John Smith'));
      await tester.pumpAndSettle();

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('Mike Johnson'), findsOneWidget);

      await expectLater(
        find.byType(TreeView<Employee>),
        matchesGoldenFile('goldens/organization_tree_expanded.png'),
      );
    });
  });
}
