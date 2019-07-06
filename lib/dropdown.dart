import 'package:flutter/material.dart';

const _padding = 16.0;

class Dropdown extends StatefulWidget {
  final List<DropdownMenuItem> menus;
  final String currentValue;
  final ValueChanged<dynamic> onChanged;

  const Dropdown(
    this.menus,
    this.currentValue,
    this.onChanged,
  );

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: Colors.grey[700],
          ),
          borderRadius: BorderRadius.circular(16.0)),
      padding: EdgeInsets.all(_padding),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: false,
          child: DropdownButton(
            value: widget.currentValue,
            onChanged: widget.onChanged,
            iconSize: 40.0,
            iconEnabledColor: Colors.grey[800],
            style: Theme.of(context).textTheme.headline,
            items: widget.menus,
          ),
        ),
      ),
    );
  }
}
