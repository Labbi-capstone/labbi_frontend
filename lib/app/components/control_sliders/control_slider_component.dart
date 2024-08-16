import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:labbi_frontend/app/components/control_panel_popup.dart';

class ControlSliderComponent extends StatefulWidget {
  final IconData icon;
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  ControlSliderComponent({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1000,
  });

  @override
  _ControlSliderState createState() => _ControlSliderState();
}

class _ControlSliderState extends State<ControlSliderComponent> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(widget.icon, size: 30),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label),
              Slider(
                value: _currentValue,
                min: widget.min,
                max: widget.max,
                onChanged: (value) {
                  setState(() {
                    _currentValue = value;
                  });
                  widget.onChanged(value);
                },
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => ControlPanelPopup(
                    currentValue: _currentValue,
                    icon: widget.icon,
                    label: widget.label));
          },
          child: const Icon(Icons.arrow_forward, size: 30),
        )
      ],
    );
  }
}
