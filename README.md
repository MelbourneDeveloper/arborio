# Arborio

An elegant, flexible Treeview with Animation. Display hierarchical data in Flutter.

![Logo](/example/assets//images/arborio_small.png)

![Sample](/images/sample.gif)

Check out the live sample app [here](https://melbournedeveloper.github.io/arborio/)

## Features

- 🌳 Hierarchical data display with unlimited nesting
- ✨ Smooth animations for expand/collapse operations
- 🎨 Fully customizable node and expander appearance
- 🔑 Global key support for programmatic control
- 🎯 Type-safe with generics support
- 📱 Responsive and mobile-friendly

## Basic Usage

Here's a simple example of how to create a tree view:

```dart
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

// Create the TreeView
TreeView<FileSystemElement>(
  nodes: nodes,
  builder: (context, node, isSelected, animation, select) {
    return Row(
      children: [
        Icon(node.data.type == ElementType.folder 
          ? Icons.folder 
          : Icons.file_copy),
        Text(node.data.name),
      ],
    );
  },
  expanderBuilder: (context, isExpanded, animation) {
    return RotationTransition(
      turns: animation,
      child: const Icon(Icons.chevron_right),
    );
  },
)
```

## Using TreeViewKey

The `TreeViewKey` allows programmatic control of the tree view:

```dart
// Create a key
final treeViewKey = TreeViewKey<FileSystemElement>();

// Use it in your TreeView
TreeView<FileSystemElement>(
  key: treeViewKey,
  // ... other parameters
)

// Later, control the tree view
treeViewKey.currentState?.expandAll();  // Expand all nodes
treeViewKey.currentState?.collapseAll(); // Collapse all nodes
```

## Node Management

You can dynamically add or remove nodes:

```dart
// Add a new node
setState(() {
  nodes.add(
    TreeNode(
      const Key('newNode'),
      FileSystemElement('New Folder', ElementType.folder),
    ),
  );
});

// Remove a node
setState(() {
  nodes.removeWhere((node) => node.key == const Key('nodeToRemove'));
});
```

## Handling Node Events

```dart
TreeView<FileSystemElement>(
  onExpansionChanged: (node, expanded) {
    print('Node ${node.data.name} is now ${expanded ? 'expanded' : 'collapsed'}');
  },
  onSelectionChanged: (node) {
    print('Selected node: ${node.data.name}');
  },
  // ... other parameters
)
```

## Customizing Node Appearance

The `builder` parameter gives you full control over node appearance, along with an animation variable so you can respond to changes over time:

```dart
builder: (context, node, isSelected, animation, select) {
  return InkWell(
    onTap: () => select(node),
    child: Container(
      color: isSelected ? Colors.blue.withOpacity(0.1) : null,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          if (node.data.type == ElementType.folder)
            RotationTransition(
              turns: animation,
              child: const Icon(Icons.folder),
            )
          else
            const Icon(Icons.file_copy),
          const SizedBox(width: 8),
          Text(node.data.name),
        ],
      ),
    ),
  );
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the BSD 3-Clause - see the LICENSE file for details.
