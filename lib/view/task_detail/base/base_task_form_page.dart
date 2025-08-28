import 'package:flutter/material.dart';
import 'package:spexco_todo_app/Constants/constants.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/add_task_page.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/add_task_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/task_form_view_model.dart';
import 'package:provider/provider.dart';

abstract class BaseTaskFormPage extends StatefulWidget {
  const BaseTaskFormPage({super.key});

  @override
  State<BaseTaskFormPage> createState();
}

abstract class BaseTaskFormPageState<T extends BaseTaskFormPage> extends State<T> {
  late TextEditingController nameController;
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    commentController = TextEditingController();

   WidgetsBinding.instance.addPostFrameCallback((_) {
  final viewModel = context.read<TaskFormViewModel>();

  if (viewModel.task != null) {
    
    nameController.text = viewModel.task!.taskName;
    commentController.text = viewModel.task!.taskComment ?? '';

    var selectedDate = viewModel.task!.lastDate != null
        ? DateTime.tryParse(viewModel.task!.lastDate!)
        : null;

    viewModel.setCategory(viewModel.task!.category ?? 'Varsayılan');
    viewModel.setPriority(viewModel.task!.priority ?? 'Düşük');
    viewModel.setDate(selectedDate);
  }
});

  }

  

  @override
  void dispose() {
    nameController.dispose();
    commentController.dispose();
    super.dispose();
  }

  String get buttonText;
  Future<bool> onButtonPressed();
  void onSuccess();
  void onError();

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskFormViewModel>();
    final homeViewModel = context.read<HomeViewModel>();
    
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          buildNameField(nameController),
          buildCommentField(commentController),
          buildDateButton(),
          const Text('Kategori'),
          buildCategoryChips(),
          const SizedBox(height: 16),
          const Text('ÖNCELİK'),
          buildPriorityChips(),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed:  
                 () async {
                    bool isSuccess = await onButtonPressed();

                    if (isSuccess) {
                      await homeViewModel.getAllTask();
                      
                      onSuccess();
                      Navigator.of(context).pop();
                    } else {
                      onError();
                    }
                  },
            child: taskViewModel.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  )
                : Text(buttonText),
          ),
        ],
      ),
    );
  }

  Wrap buildPriorityChips();

   Wrap buildCategoryChips();
    
 

  ElevatedButton buildDateButton();

  Padding buildCommentField(TextEditingController controller) {
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "Açıklama",
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 5,
            minLines: 3,
            keyboardType: TextInputType.multiline,
          ),
        );
  }

  Padding buildNameField(TextEditingController nameController) {
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Görev Adı",
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
  }
}
