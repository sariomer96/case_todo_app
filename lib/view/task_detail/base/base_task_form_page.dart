import 'package:flutter/material.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
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
  DateTime? selectedDate;

  String selectedCategory = 'Varsayılan';
  final List<String> categories = [
    'Varsayılan',
    'Kişisel',
    'Eğitim',
    'Finans'
  ];

  String selectedPriority = 'Düşük';
  final List<String> priorityLevels = ['Düşük', 'Orta', 'Yüksek', 'Acil'];

  final Map<String, Color> priorityColors = {
    'Düşük': Colors.green,
    'Orta': Colors.blue,
    'Yüksek': Colors.orange,
    'Acil': Colors.red,
  };

 

@override
void initState() {
  super.initState();
  nameController = TextEditingController();
  commentController = TextEditingController();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final task = context.read<TaskFormViewModel>().task;
    if (task != null) {
      nameController.text = task.taskName;
      commentController.text = task.taskComment ?? '';
      selectedDate = task.lastDate != null
          ? DateTime.tryParse(task.lastDate!)
          : null;
      selectedCategory = task.category ?? 'Varsayılan';
      selectedPriority = task.priority ?? 'Düşük';
      setState(() {});  
    }
  });
}
  Task createTaskModel(TaskFormViewModel taskViewModel) {
    return taskViewModel.createModel(
      nameController.text,
      commentController.text,
      selectedDate?.toString() ?? '',
      selectedPriority,
      selectedCategory,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    commentController.dispose();
    super.dispose();
  }
 
  String get buttonText;
 Future<bool> onButtonPressed(TaskFormViewModel taskViewModel, HomeViewModel homeViewModel);

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
          Padding(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: commentController,
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
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2025),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            icon: Icon(
              Icons.calendar_month,
              size: IconTheme.of(context).size,
            ),
            label: Text(
              selectedDate == null
                  ? 'Bitiş Tarihi Ekle'
                  : 'Seçilen Tarih: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const Text('Kategori'),
          Wrap(
            spacing: 8,
            children: categories.map((cat) {
              return ChoiceChip(
                label: Text(cat),
                selected: selectedCategory == cat,
                onSelected: (selected) {
                  setState(() {
                    selectedCategory = cat;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('ÖNCELİK'),
          Wrap(
            spacing: 8,
            children: priorityLevels.map((priority) {
              final color = priorityColors[priority] ?? Colors.grey;
              return ChoiceChip(
                avatar: Icon(
                  Icons.flag_sharp,
                  color: color,
                ),
                label: Text(priority),
                labelStyle: const TextStyle(),
                selected: selectedPriority == priority,
                selectedColor: color.withOpacity(0.2),
                checkmarkColor: Colors.transparent,
                onSelected: (selected) {
                  setState(() {
                    selectedPriority = priority;
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
                  bool isSuccess = await onButtonPressed(taskViewModel, homeViewModel);


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
}