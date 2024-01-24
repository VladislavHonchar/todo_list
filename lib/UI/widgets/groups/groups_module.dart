import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/UI/navigation/main_navigation.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class GroupsWidgetModel extends ChangeNotifier{
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();
  
  GroupsWidgetModel(){
    _setup();
  }

  void showForm(BuildContext context){
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }
  void showTasks(BuildContext context, int groupIndex) async {
    if(!Hive.isAdapterRegistered(1)){
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    final groupKey = box.keyAt(groupIndex) as int;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tasks, arguments: groupKey);
  }

  void deleteGroup(int groupIndex) async{
    if(!Hive.isAdapterRegistered(1)){
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    await box.getAt(groupIndex)?.tasks?.deleteAllFromHive();
    await box.deleteAt(groupIndex);
  }

  void _readGroupFromHive(Box<Group> box){
    _groups = box.values.toList();
      notifyListeners();
  }

  void _setup() async{
    if(!Hive.isAdapterRegistered(1)){
      Hive.registerAdapter(GroupAdapter());
    }
    if(!Hive.isAdapterRegistered(2)){
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>('tasks_box');
    final box = await Hive.openBox<Group>('groups_box');
    _readGroupFromHive(box);
    box.listenable().addListener(() => _readGroupFromHive(box));
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