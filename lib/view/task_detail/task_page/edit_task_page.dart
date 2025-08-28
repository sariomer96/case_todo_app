import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/Constants/constants.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/base/base_task_form_page.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/edit_task_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/task_form_view_model.dart';
 
 

class EditTaskPage extends BaseTaskFormPage {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskFormPageState();
}

class _EditTaskFormPageState extends BaseTaskFormPageState<EditTaskPage> {
  @override
  String get buttonText => 'Güncelle';
 
 String _selectedCategory = '';
  String _selectedPriority = '';

   @override
  Future<bool> onButtonPressed() async {
     var viewModel = context.read<EditTaskViewModel>();
    var updatedTask = viewModel.createModel(
      nameController.text, 
      commentController.text, 
      viewModel.selectedDate.toString(),
      _selectedPriority,
      _selectedCategory
      );

    updatedTask.id = viewModel.task?.id;  
    return await viewModel.editTask(updatedTask);
    
  }
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final viewModel = context.read<EditTaskViewModel>();
    final task = viewModel.task;

    if (task != null) {
      setState(() {
        nameController.text = task.taskName;
        commentController.text = task.taskComment ?? '';
        _selectedCategory = task.category ?? '';
        _selectedPriority = task.priority ?? '';
      var  date = task.lastDate != null
            ? DateTime.tryParse(task.lastDate!)
            : null;
            viewModel.setDate(date);
         
      });
    }
  });
}

  @override
  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Başarıyla Güncellendi"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Güncelleme sırasında hata oluştu"),
        backgroundColor: Colors.red,
      ),
    );
  }
 @override
  Wrap buildCategoryChips() {
    return Wrap(
      spacing: 8,
      children: Constants.categories.map((cat) {
        return ChoiceChip(
          label: Text(cat),
          selected: _selectedCategory == cat,
          onSelected: (selected) {
            setState(() {
              _selectedCategory = cat;
            });
          },
        );
      }).toList(),
    );
  }
  

  @override
  Wrap buildPriorityChips( ) {
       return Wrap(
          spacing: 8,
          children: Constants.priorityLevels.map((priority) {
            final color = Constants.priorityColors[priority] ?? Colors.grey;
            return ChoiceChip(
              avatar: Icon(
                Icons.flag_sharp,
                color: color,
              ),
              label: Text(priority),
              selected: _selectedPriority == priority,
              selectedColor: color.withOpacity(0.2),
              checkmarkColor: Colors.transparent,
              onSelected: (selected) {
                setState(() {
                    _selectedPriority = priority;
                });
              
              },
            );
          }).toList(),
        );
   
  } 
@override
ElevatedButton buildDateButton() {
  return ElevatedButton.icon(
    onPressed: () async {
      final viewModel = context.read<EditTaskViewModel>();
      final initialDate = viewModel.selectedDate ?? DateTime.now();
      
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2025),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        viewModel.setDate(pickedDate);  
      }
    },
    icon: const Icon(Icons.calendar_month),
    label: Consumer<EditTaskViewModel>(
      builder: (context, viewModel, _) {
        final selectedDate = viewModel.selectedDate;
        return Text(
          selectedDate != null
              ? 'Seçilen Tarih: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : 'Bitiş Tarihi',
        );
      },
    ),
  );
}

}