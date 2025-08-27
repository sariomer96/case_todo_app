import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/task_form_view_model.dart';
import 'package:provider/provider.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  DateTime? _selectedDate;

  String _selectedCategory = 'Varsayılan';
  final List<String> _categories = [
    'Varsayılan',
    'Kişisel',
    'Eğitim',
    'Finans'
  ];

  String _selectedPriority = 'Düşük';
  final List<String> _priority = ['Düşük', 'Orta', 'Yüksek', 'Acil'];

  final Map<String, Color> _priorityColors = {
    'Düşük': Colors.green,
    'Orta': Colors.blue,
    'Yüksek': Colors.orange,
    'Acil': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.read<TaskFormViewModel>();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _commentController,
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
          ),
          ElevatedButton.icon(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2025),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
            icon: Icon(
              Icons.calendar_month,
              size: IconTheme.of(context).size,
            ),
            label: Text(
              _selectedDate == null
                  ? 'Bitiş Tarihi Ekle'
                  : 'Seçilen Tarih: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const Text('Kategori'),
          Wrap(
            spacing: 8,
            children: _categories.map((cat) {
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
          ),
          const SizedBox(
            height: 16,
          ),
          const Text('ÖNCELİK'),
          Wrap(
            spacing: 8,
            children: _priority.map((priority) {
              final color = _priorityColors[priority] ?? Colors.grey;
              return ChoiceChip(
                avatar: Icon(
                  Icons.flag_sharp,
                  color: color,
                ),
                label: Text(priority),
                labelStyle: const TextStyle(),
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
          ),
          const SizedBox(height: 50),
          ElevatedButton(
              onPressed: taskViewModel.isLoading
                  ? null
                  : () async {
                      var newTask = taskViewModel.createModel(
                          _nameController.text,
                          _commentController.text,
                          _selectedDate.toString(),
                          _selectedPriority,
                          _selectedCategory);
      
                      bool isSuccess = await taskViewModel.addTask(newTask);
      
                      if (isSuccess) {
                        await homeViewModel.getAllTask();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Başarıyla oluşturuldu"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(" Oluşturma sırasında hata oluştu"),
                            backgroundColor: Colors.red,
                          ),
                        );
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
                  : const Text('Oluştur'))
        ],
      ),
    );
  }

  void createModel(String a) {
    //Task(task_name: task_name, task_comment: task_comment, last_date: last_date, priority: priority, category: category)
  }
}
