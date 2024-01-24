import 'package:flutter/material.dart';
import 'package:todo_list/UI/widgets/group_form/group_form_widget.dart';
import 'package:todo_list/UI/widgets/groups/groups_widget.dart';
import 'package:todo_list/UI/widgets/task_form/task_form_widget.dart';
import 'package:todo_list/UI/widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRouteNames{
  static const groups = '/';
  static const groupsForm = '/groupsform';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

class MainNavigation{
  final routes = <String, Widget Function(BuildContext)>{
        MainNavigationRouteNames.groups: (context) => const GroupsWidget(),
        MainNavigationRouteNames.groupsForm: (context) => const GroupFormWidget(),
        // MainNavigationRouteNames.tasks: (context) => const TasksWidget(),
        // MainNavigationRouteNames.tasksForm: (context) => const TaskFormWidget(),
  };
  final initialRoute = MainNavigationRouteNames.groups;
  Route<Object> onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case MainNavigationRouteNames.tasks:
      final groupKey = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context){
          return TasksWidget(groupKey: groupKey);
        }
        );
      case MainNavigationRouteNames.tasksForm:
      final groupKey = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context){
          return TaskFormWidget(groupKey: groupKey);
        }
        );
      default:
      const widget = Text('Navogation error!!');
      return MaterialPageRoute( builder: (context){ return widget;});
    }
  }
}