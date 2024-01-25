import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/UI/navigation/main_navigation.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/group.dart';

class GroupsWidgetModel extends ChangeNotifier{
  late final Future<Box<Group>> _box;
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();
  
  GroupsWidgetModel(){
    _setup();
  }

  void showForm(BuildContext context){
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final groupKey = (await _box).keyAt(groupIndex) as int;
    unawaited(Navigator.of(context).pushNamed(MainNavigationRouteNames.tasks, arguments: groupKey));
  }

  Future<void> deleteGroup(int groupIndex) async{
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(groupIndex);
  }

  Future<void> _readGroupFromHive() async {
    _groups = (await _box).values.toList();
      notifyListeners();
  }

  void _setup() async{
    _box = BoxManager.instance.openGroupBox();
    await _readGroupFromHive();
    (await _box).listenable().addListener(_readGroupFromHive);
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider(
    {
      super.key,
      required this.model, 
      required this.child
      }) : super(child: child, notifier: model);

  final Widget child;

  static GroupsWidgetModelProvider? watch(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context){
    final widget = context.getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
    ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}