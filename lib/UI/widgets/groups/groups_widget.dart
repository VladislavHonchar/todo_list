import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/UI/widgets/groups/groups_module.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupWidgetBody());
  }
  @override
  void dispose() async {
    _model.dispose();
    super.dispose();
  }
}

class _GroupWidgetBody extends StatelessWidget {
  const _GroupWidgetBody({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group'),
      ),
      body: const  _GroupListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed:() => GroupsWidgetModelProvider.read(context)?.model.showForm(context),
        child: const  Icon(Icons.add), 
        ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({super.key});

  @override
  Widget build(BuildContext context) {
  final groupsCount = 
  GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _GroupListRowWidget(indexInList: index,);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1,);
      },
      itemCount: groupsCount,
    );

  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;

  const _GroupListRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context)!.model;
    final group = model.groups[indexInList];
    return Slidable(
      endActionPane: ActionPane(motion: const  BehindMotion(), children: [
        SlidableAction(
        onPressed: (context) => model.deleteGroup(indexInList),
        icon: Icons.delete,
        label: 'Delete',
        backgroundColor: const Color(0xFFFE4A49),
        foregroundColor: Colors.white,)
      ]),
      child: ListTile(
        onTap: () => model.showTasks(context, indexInList),
        title: Text(group.name),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
