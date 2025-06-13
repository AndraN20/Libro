import 'package:flutter/material.dart';

class ReaderSettingsDialog extends StatefulWidget {
  final double initialFontSize;
  final String initialFontFamily;
  final Color initialBgColor;
  final void Function(double fontSize, String fontFamily, Color bgColor)
  onSettingsChanged;

  const ReaderSettingsDialog({
    super.key,
    required this.initialFontSize,
    required this.initialFontFamily,
    required this.initialBgColor,
    required this.onSettingsChanged,
  });

  @override
  State<ReaderSettingsDialog> createState() => _ReaderSettingsDialogState();
}

class _ReaderSettingsDialogState extends State<ReaderSettingsDialog> {
  late double _fontSize;
  late String _fontFamily;
  late Color _bgColor;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
    _fontFamily = widget.initialFontFamily;
    _bgColor = widget.initialBgColor;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Font size
              const Text(
                'Dimensiune text',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...[14.0, 16.0, 18.0, 20.0].map(
                (size) => RadioListTile<double>(
                  title: Text('${size.toInt()}'),
                  value: size,
                  groupValue: _fontSize,
                  onChanged: (v) => setState(() => _fontSize = v!),
                ),
              ),
              const Divider(),

              // Font family
              const Text('Font', style: TextStyle(fontWeight: FontWeight.bold)),
              ...['serif', 'sans-serif', 'monospace'].map(
                (font) => RadioListTile<String>(
                  title: Text(font),
                  value: font,
                  groupValue: _fontFamily,
                  onChanged: (v) => setState(() => _fontFamily = v!),
                ),
              ),
              const Divider(),

              // Background color
              const Text(
                'Culoare fundal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...[
                {'color': Colors.white, 'label': 'Alb'},
                {'color': Colors.black87, 'label': 'Închis'},
                {'color': Color(0xFFFAF0E6), 'label': 'Sepia'},
              ].map((opt) {
                final c = opt['color'] as Color;
                return RadioListTile<Color>(
                  title: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(opt['label'] as String),
                    ],
                  ),
                  value: c,
                  groupValue: _bgColor,
                  onChanged: (v) => setState(() => _bgColor = v!),
                );
              }).toList(),
              const SizedBox(height: 8),

              // OK button
              ElevatedButton(
                onPressed: () {
                  widget.onSettingsChanged(_fontSize, _fontFamily, _bgColor);
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
