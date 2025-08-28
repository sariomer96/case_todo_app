 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/Constants/constants.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/base/base_task_form_page.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/add_task_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/task_form_view_model.dart';

class AddTaskPage extends BaseTaskFormPage {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _TaskFormPageState();
}
class _TaskFormPageState extends BaseTaskFormPageState<AddTaskPage> {
  String _selectedCategory = 'Varsayılan';
  String _selectedPriority = 'Düşük';
  DateTime? _selectedDate;
  @override
  String get buttonText => 'Oluştur';
    

  @override
  Future<bool> onButtonPressed() async {
      var viewModel = context.read<AddTaskViewModel>();
    var newTask = viewModel.createModel(
      nameController.text,
       commentController.text,
        _selectedDate.toString(), 
        _selectedPriority,
         _selectedCategory);
    return await viewModel.addTask(newTask);
  }

  @override
  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Başarıyla oluşturuldu"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Oluşturma sırasında hata oluştu"),
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
      {
      return ElevatedButton.icon(
        onPressed: () async {
    final initialDate = _selectedDate ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  },
  icon: const Icon(Icons.calendar_month),
  label: Text(
    _selectedDate != null
        ? 'Seçilen Tarih: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
        : (_selectedDate == null
            ? 'Bitiş Tarihi'  
            : 'Seçilen Tarih: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
  ),
  );
    }
      
    }
}
