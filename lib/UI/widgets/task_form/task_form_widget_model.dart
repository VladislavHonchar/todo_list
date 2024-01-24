import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class TaskFormWidgetModel {
  int groupKey;
  var taskText = '';

  TaskFormWidgetModel({required this.groupKey});
  void saveTasks(BuildContext context) async{
    if(taskText.isEmpty) return;
    if(!Hive.isAdapterRegistered(1)){
      Hive.registerAdapter(GroupAdapter());
    }
    if(!Hive.isAdapterRegistered(2)){
      Hive.registerAdapter(TaskAdapter());
    }
    final task = Task(text: taskText, isDone: false);
    final taskBox = await Hive.openBox<Task>('tasks_box');
    await taskBox.add(task);
    final groupsBox = await Hive.openBox<Group>('groups_box');
    final group = groupsBox.get(groupKey);
    group?.addTask(taskBox, task);
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider({super.key, required this.child, required this.model}) : super(child: child);

  final Widget child;

  static TaskFormWidgetModelProvider? watch(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context){
    final widget = context.getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
    ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false;
  }
}