import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/UI/widgets/tasks/tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  final int groupKey;
  const TasksWidget({super.key, required this.groupKey});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    if (model != null) {
      return TasksWidgetModelProvider(model: model ,child: _TasksWidgetBody());
    }else{
      return Center(child: const CircularProgressIndicator());
    }
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.group?.name ?? "Task";
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed:() => model?.showForm(context),
        child: const  Icon(Icons.add), 
        ),
    );
  }
}
class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
  final groupsCount = 
  TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _TaskListRowWidget(indexInList: index,);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1,);
      },
      itemCount: groupsCount,
    );

  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;

  const _TaskListRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];
    final icon = task.isDone ? Icons.done : null;
    final style = task.isDone ? TextStyle(decoration: TextDecoration.lineThrough): null;
    return Slidable(
      endActionPane: ActionPane(motion: const  BehindMotion(), children: [
        SlidableAction(
        onPressed: (context) => model.deleteTask(indexInList),
        icon: Icons.delete,
        label: 'Delete',
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,)
      ]),
      child: ListTile(
        onTap: () => model.doneToggle(indexInList),
        title: Text(task.text, style: style,),
        trailing: Icon(icon),
      ),
    );
  }
}