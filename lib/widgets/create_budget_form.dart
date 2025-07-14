import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manajemen_keuangan/models/budget.dart';
import 'package:manajemen_keuangan/models/category.dart';
import 'package:manajemen_keuangan/utils/currency_formatter.dart';
import 'package:manajemen_keuangan/widgets/month_picker_field.dart';

class CreateBudgetForm extends StatefulWidget {
  final Budget? budget; // Nullable for creating a new budget
  final Function(Budget) onSubmit;

  const CreateBudgetForm({super.key, this.budget, required this.onSubmit});

  @override
  State<CreateBudgetForm> createState() => _CreateBudgetFormState();
}

class _CreateBudgetFormState extends State<CreateBudgetForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late Category _selectedCategory;
  late DateTime _selectedDate;

  final List<Category> _categories = [
    Category.makanan,
    Category.transportasi,
    Category.belanja,
    Category.hiburan,
    Category.tagihan,
    Category.lainnya,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.budget?.name ?? '');
    _amountController = TextEditingController(
      text: widget.budget != null
          ? CurrencyFormatter.format(widget.budget!.amount)
          : '',
    );
    _selectedCategory = widget.budget?.category ?? _categories.first;
    _selectedDate = widget.budget?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newBudget = Budget(
        id: widget.budget?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        amount:
            double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0,
        category: _selectedCategory,
        date: _selectedDate,
        spent: widget.budget?.spent ?? 0,
      );
      widget.onSubmit(newBudget);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.budget == null ? 'Buat Budget Baru' : 'Edit Budget',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildAmountField(),
              const SizedBox(height: 16),
              _buildCategoryField(),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama Budget',
        hintText: 'Contoh: Budget Makanan Bulanan',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.label_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama budget tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(
        labelText: 'Jumlah Budget (Rp)',
        hintText: 'Contoh: 500.000',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        // Custom formatter for thousands separator
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text;
          if (text.isEmpty) {
            return newValue.copyWith(text: '');
          }
          final number = int.parse(text);
          final newString = CurrencyFormatter.format(number.toDouble());
          return newValue.copyWith(
            text: newString,
            selection: TextSelection.collapsed(offset: newString.length),
          );
        }),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Jumlah budget tidak boleh kosong';
        }
        if (double.tryParse(value.replaceAll('.', '')) == null) {
          return 'Format angka tidak valid';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<Category>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Kategori',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category_outlined),
      ),
      items: _categories.map((Category category) {
        return DropdownMenuItem<Category>(
          value: category,
          child: Row(
            children: [
              Icon(category.icon, color: category.color, size: 20),
              const SizedBox(width: 8),
              Text(category.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (Category? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedCategory = newValue;
          });
        }
      },
    );
  }

  Widget _buildDateField() {
    // return InkWell(
    //   onTap: () => _selectDate(context),
    //   child: InputDecorator(
    //     decoration: const InputDecoration(
    //       labelText: 'Bulan Untuk Budget',
    //       border: OutlineInputBorder(),
    //       prefixIcon: Icon(Icons.calendar_today),
    //     ),
    //     child: Text(
    //       '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
    //     ),
    //   ),
    // );
    return MonthPickerField(
      selectedDate: DateTime.now(),
      onChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: _submitForm,
          icon: const Icon(Icons.save),
          label: Text(widget.budget == null ? 'Simpan' : 'Update'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
