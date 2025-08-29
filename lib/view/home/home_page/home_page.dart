import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/Constants/constants.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/add_task/add_task_page/add_task_page.dart';
import 'package:spexco_todo_app/view/edit_task/edit_task_page/edit_task_page.dart';
import 'package:spexco_todo_app/view/edit_task/edit_task_view_model/edit_task_view_model.dart';
import 'package:spexco_todo_app/view/widgets/task_form_bottom_sheet.dart';
import 'package:spexco_todo_app/view/widgets/task_list_widget.dart';

enum TaskPageEnum {
  addForm,
  editForm,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.read<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: Column(
        children: [
          _searchFilter(viewModel),
          const TaskListView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const TaskFormBottomSheet(
                selectedFormPage: TaskPageEnum.addForm),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openFilterSheet(BuildContext context, HomeViewModel viewModel) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Filter",
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    centerTitle: true,
                    title: const Text("Filtrele"),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Constants.padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          const Text(
                            "Kategoriler",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Selector<HomeViewModel, String?>(
                            selector: (context, vm) => vm.selectedCategory,
                            builder: (context, selectedCategory, child) {
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: Constants.categories.map((cat) {
                                  return ChoiceChip(
                                    showCheckmark: true,
                                    label: Text(cat),
                                    selected: selectedCategory == cat,
                                    onSelected: (selected) {
                                      final viewModel =
                                          Provider.of<HomeViewModel>(context,
                                              listen: false);
                                      viewModel.setCategory(cat);
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Öncelik Seviyesi",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Selector<HomeViewModel, String?>(
                              selector: (context, vm) => vm.selectedPriority,
                              builder: (context, selectedPriority, child) {
                                return Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: Constants.priorityColors.keys
                                      .map((priority) {
                                    return ChoiceChip(
                                      showCheckmark: true,
                                      label: Text(priority),
                                      labelStyle: TextStyle(
                                        color:
                                            Constants.priorityColors[priority],
                                      ),
                                      selected: viewModel.selectedPriority ==
                                          priority,
                                      selectedColor: Constants
                                          .priorityColors[priority]
                                          ?.withOpacity(0.2),
                                      onSelected: (selected) {
                                        viewModel.setPriority(priority);
                                      },
                                    );
                                  }).toList(),
                                );
                              }),
                          TextButton(
                              onPressed: () {
                                viewModel.setPriority('');
                                viewModel.setCategory('');
                              },
                              child: const Text('Filtreyi Temizle')),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  /// search filter
                                  await viewModel
                                      .filterByCategoryWithPriority();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Listele',
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: const Offset(1, 0), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Row _searchFilter(HomeViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Constants.padding),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  constraints: const BoxConstraints(
                    minHeight: 45,
                  ),
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: Constants.padding * 2),
                  ),
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          controller.clear();
                          viewModel.searchTask('');
                          setState(() {});
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _openFilterSheet(context, viewModel),
                    ),
                  ],
                  onChanged: (value) async {
                    await viewModel.searchTask(value);
                    setState(() {});
                  },
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return const Iterable<Widget>.empty();
              },
            ),
          ),
        ),
      ],
    );
  }
}
