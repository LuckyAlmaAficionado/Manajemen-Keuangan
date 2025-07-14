import 'package:flutter/material.dart';

/// Widget global untuk memilih bulan dan tahun saja, tanpa memilih hari.
class MonthPickerField extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final String label;

  const MonthPickerField({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    this.label = 'Pilih Bulan',
  });

  Future<void> _selectMonth(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - 5, 1),
      lastDate: DateTime(now.year + 5, 12),
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectMonth(context),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          '${_monthName(selectedDate.month)} ${selectedDate.year}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }
}

/// Helper untuk menampilkan dialog pemilih bulan.
Future<DateTime?> showMonthPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  DateTime tempDate = initialDate;
  int selectedYear = tempDate.year;
  int selectedMonth = tempDate.month;
  final int minYear = DateTime.now().year - 2;
  final int maxYear = DateTime.now().year + 3;
  return showDialog<DateTime>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Pilih Bulan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Pilih tahun
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<int>(
                      value: selectedYear,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items:
                          List.generate(
                                maxYear - minYear + 1,
                                (index) => minYear + index,
                              )
                              .map(
                                (year) => DropdownMenuItem<int>(
                                  value: year,
                                  child: Text(year.toString()),
                                ),
                              )
                              .toList(),
                      onChanged: (year) {
                        if (year != null) {
                          setState(() {
                            selectedYear = year;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Pilih bulan
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<int>(
                      value: selectedMonth,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: List.generate(12, (index) => index + 1)
                          .map(
                            (month) => DropdownMenuItem<int>(
                              value: month,
                              child: Text(_monthName(month)),
                            ),
                          )
                          .toList(),
                      onChanged: (month) {
                        if (month != null) {
                          setState(() {
                            selectedMonth = month;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(
                            context,
                            DateTime(selectedYear, selectedMonth),
                          );
                        },
                        child: const Text('Pilih'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

String _monthName(int month) {
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return months[month - 1];
}
