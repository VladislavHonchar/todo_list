import 'package:flutter/material.dart';
import 'package:todo_list/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  const TaskFormWidget({super.key});

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  TaskFormWidgetModel? _model;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TaskFormWidgetModel(groupKey: groupKey);
    }
  }
  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
      model: _model!,
      child: _TextFormWidgetBody(),);
  }
}
class _TextFormWidgetBody extends StatelessWidget {
  const _TextFormWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Task"),),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _TaskTextWidget(),
        )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => TaskFormWidgetModelProvider.read(context)?.model.saveTasks(context),
          child: const Icon(Icons.done),
          ),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.read(context)?.model;
    return TextField(
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Group name'
      ),
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () => model?.saveTasks(context),
    );
  }
}