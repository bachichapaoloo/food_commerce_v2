import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_state.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_event.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_option.dart';

class AddOnManagerPage extends StatefulWidget {
  const AddOnManagerPage({super.key});

  @override
  State<AddOnManagerPage> createState() => _AddOnManagerPageState();
}

class _AddOnManagerPageState extends State<AddOnManagerPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadAdminData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add-on Groups'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddEditGroupDialog(context))],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminLoaded) {
            final groups = state.addOnGroups;
            if (groups.isEmpty) {
              return const Center(child: Text('No add-on groups. Create one!'));
            }
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return ListTile(
                  title: Text(group.name),
                  subtitle: Text(
                    '${group.options.length} options | Min: ${group.minSelection}, Max: ${group.maxSelection}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context.read<AdminBloc>().add(DeleteAddOnGroup(group.id)),
                  ),
                  onTap: () => _showAddEditGroupDialog(context, group: group),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddEditGroupDialog(BuildContext context, {AddOnGroup? group}) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminBloc>(),
        child: _AddOnGroupDialog(group: group),
      ),
    );
  }
}

class _AddOnGroupDialog extends StatefulWidget {
  final AddOnGroup? group;
  const _AddOnGroupDialog({this.group});

  @override
  State<_AddOnGroupDialog> createState() => _AddOnGroupDialogState();
}

class _AddOnGroupDialogState extends State<_AddOnGroupDialog> {
  late TextEditingController _nameController;
  late TextEditingController _minController;
  late TextEditingController _maxController;
  final List<AddOnOption> _tempOptions = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group?.name ?? '');
    _minController = TextEditingController(text: widget.group?.minSelection.toString() ?? '0');
    _maxController = TextEditingController(text: widget.group?.maxSelection.toString() ?? '1');
    if (widget.group != null) {
      _tempOptions.addAll(widget.group!.options);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.group == null ? 'New Add-on Group' : 'Edit Add-on Group'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Group Name (e.g. Size)'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    decoration: const InputDecoration(labelText: 'Min Select'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    decoration: const InputDecoration(labelText: 'Max Select'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._tempOptions.map(
              (o) => ListTile(
                title: Text(o.name),
                trailing: Text(o.priceModifier > 0 ? '+${o.priceModifier}' : ''),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            TextButton.icon(icon: const Icon(Icons.add), label: const Text('Add Option'), onPressed: _addOption),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final newGroup = AddOnGroup(
              id: widget.group?.id ?? '', // Ideally format empty for new, backend ignores or generates
              name: _nameController.text,
              minSelection: int.parse(_minController.text),
              maxSelection: int.parse(_maxController.text),
              options: List.from(_tempOptions),
            );
            context.read<AdminBloc>().add(CreateAddOnGroup(newGroup));
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _addOption() {
    // Simplified: Just asking for name and price
    String name = '';
    String price = '0';
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Add Option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (v) => name = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Price Modifier'),
              keyboardType: TextInputType.number,
              onChanged: (v) => price = v,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (name.isNotEmpty) {
                setState(() {
                  _tempOptions.add(
                    AddOnOption(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      priceModifier: double.tryParse(price) ?? 0,
                    ),
                  );
                });
              }
              Navigator.pop(c);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
