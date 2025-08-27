import 'package:flutter/material.dart';

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
      final List<String> _categories = ['Varsayılan','Kişisel', 'Eğitim', 'Finans'];

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
    return     Column(
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
                    controller: _commentController,
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
                      )  ,
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
                      )  ,
                 
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
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        const SizedBox(height: 16,),
                      const Text('ÖNCELİK'),

                     Wrap(
                         
                      spacing: 8,
                      children: _priority.map((priority) {
                        final color = _priorityColors[priority] ?? Colors.grey;
                        return ChoiceChip(
                          avatar:   Icon(Icons.flag_sharp,
                                    color: color,
                          ),
                          
                          label: Text(priority),
                          
                          labelStyle: const TextStyle(
                           
                          ),
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
        
                  
                  ElevatedButton(onPressed: (){}, child: const Text('Oluştur'))
          
              ],
          
    );
  }
}