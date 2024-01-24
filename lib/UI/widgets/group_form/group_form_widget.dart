import 'package:flutter/material.dart';
import 'package:todo_list/UI/widgets/group_form/groupa_form_module.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({super.key});

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();
  
  @override
  Widget build(BuildContext context) {
    return  GroupFormWidgetModelProvider(
      model: _model,
      child: const _GroupFormWidgetBody());
  }
}
class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New group"),),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _GroupNameWidget(),
        )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => GroupFormWidgetModelProvider.read(context)?.model.saveGroup(context),
          child: const Icon(Icons.done),
          ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.read(context)?.model;
    return TextField(
      autofocus: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Group name'
      ),
      onChanged: (value) => model?.groupName = value,
      onEditingComplete: () => model?.saveGroup(context),
    );
  }
}