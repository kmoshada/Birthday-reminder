import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/birthday_provider.dart';
import '../../providers/theme_provider.dart';

class AddBirthdayScreen extends StatefulWidget {
  const AddBirthdayScreen({super.key});
  @override
  State<AddBirthdayScreen> createState() => _AddBirthdayScreenState();
}

class _AddBirthdayScreenState extends State<AddBirthdayScreen> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _selectedDate;
  int _remind = 0;

  @override
  Widget build(BuildContext context) {
    final accent = Provider.of<ThemeProvider>(context).accent;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Birthday')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent.withAlpha((255 * 0.25).round()), Colors.white],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(_nameController, 'Name', Icons.person),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: _buildTextField(
                  TextEditingController(
                    text:
                        _selectedDate == null
                            ? ''
                            : _selectedDate!.toLocal().toString().split(' ')[0],
                  ),
                  'Birthday Date',
                  Icons.calendar_today,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildTextField(_noteController, 'Note (optional)', Icons.note),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _remind,
              decoration: const InputDecoration(labelText: 'Remind'),
              items: const [
                DropdownMenuItem(value: 0, child: Text('On day')),
                DropdownMenuItem(value: 1, child: Text('1 day before')),
              ],
              onChanged: (v) => setState(() => _remind = v ?? 0),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: accent,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white.withAlpha(230),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide name and date')),
      );
      return;
    }
    await Provider.of<BirthdayProvider>(context, listen: false).addBirthday(
      name,
      _selectedDate!,
      note: _noteController.text.trim(),
      remindDaysBefore: _remind,
    );
    if (mounted) Navigator.of(context).pop();
  }
}
