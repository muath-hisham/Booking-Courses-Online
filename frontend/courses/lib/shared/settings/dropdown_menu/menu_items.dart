import 'package:flutter/material.dart';
import 'menu_item.dart';
import 'package:courses/shared/globals.dart' as globals;

class MenuItems {
  static const List<MenuItem> items = [
    itemCopy,
    itemShare
  ];

  static const List<MenuItem> itemsCorses = [
    itemDelete,
    itemEdit
  ];

  static const MenuItem itemCopy = MenuItem(
    text: 'Copy text',
    icon: Icons.copy,
  );

  static const MenuItem itemShare = MenuItem(
    text: 'Share link',
    icon: Icons.share,
  );

  static const MenuItem itemDelete = MenuItem(
    text: 'Delete course',
    icon: Icons.delete,
  );

  static const MenuItem itemEdit = MenuItem(
    text: 'Edit course',
    icon: Icons.edit,
  );
}
