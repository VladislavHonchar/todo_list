import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class TasksWidgetModel extends ChangeNotifier{
  int groupKey;
  late final Future<Box<Group>> _groupBox;
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();
  Group? _group;
  Group? get group => _group;

  TasksWidgetModel({
    required this.groupKey,
  }){
    _setup();
  }

  void showForm(BuildContext context){
    Navigator.of(context).pushNamed('/groups/tasks/form', arguments: groupKey);
  }
  void _loadGroup() async{
    final box = await _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }
  void _readTasks() {
    _tasks = _group?.tasks ?? <Task>[];
      notifyListeners();
  }
  void _setupListenTasks() async{
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: [groupKey]).addListener(_readTasks);
  }

  void _setup() async{
    if(!Hive.isAdapterRegistered(1)){
      Hive.registerAdapter(GroupAdapter());
    }
    if(!Hive.isAdapterRegistered(2)){
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>('tasks_box');
    _groupBox =  Hive.openBox<Group>('groups_box');
    _loadGroup();
    _setupListenTasks();
  }

  void deleteTask(int groupIndex) async {
    await _group?.tasks?.deleteFromHive(groupIndex);
    _group?.save();
  }

  void doneToggle(int groupIndex) async {
    final task = group?.tasks?[groupIndex];
    final currentState = task?.isDone ?? false;
    task?.isDone = !currentState;
    await task?.save();
    notifyListeners();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider({super.key,required this.model, required this.child}) : super(child: child, notifier: model);

  final Widget child;

  static TasksWidgetModelProvider? watch(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context){
    final widget = context.getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
    ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }

}