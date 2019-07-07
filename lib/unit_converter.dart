import 'package:flutter/material.dart';
import 'dropdown.dart';
import 'category.dart';
import 'unit.dart';

const _padding = 16.0;
const _borderRadius = 16.0;

class UnitConverter extends StatefulWidget {
  final Category category;

  const UnitConverter({
    @required this.category,
  }) : assert(category != null);

  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _convertedValue = '';
  List<DropdownMenuItem> _unitMenuItems;
  bool _showValidationError = false;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }

  /// Creates fresh list of [DropdownMenuItem] widgets, given a list of [Unit]s.
  void _createDropdownMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.category.units) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      _unitMenuItems = newItems;
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s.
  void _setDefaults() {
    setState(() {
      _fromValue = widget.category.units[0];
      _toValue = widget.category.units[1];
    });
  }

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _updateConversion() {
    setState(() {
      _convertedValue =
          _format(_inputValue * (_toValue.conversion / _fromValue.conversion));
    });
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }

  Unit _getUnit(String unitName) {
    return widget.category.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputGroup = Padding(
      padding: EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            style: Theme.of(context).textTheme.display1,
            textDirection: TextDirection.rtl,
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
              labelStyle: Theme.of(context).textTheme.display1,
              labelText: 'Value',
              errorText: _showValidationError ? 'Invalid number entered' : null,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: _padding),
            child: Dropdown(
                _unitMenuItems, _fromValue.name, _updateFromConversion),
          )
        ],
      ),
    );

    final outputGroup = Padding(
      padding: EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_padding),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: _padding),
            child: Dropdown(
              _unitMenuItems,
              _toValue.name,
              _updateToConversion,
            ),
          )
        ],
      ),
    );

    final convertButton = Container(
      child: IconButton(
        icon: Icon(Icons.swap_vert),
        iconSize: 45.0,
        onPressed: () {},
      ),
    );

    final converter = ListView(children: [
      inputGroup,
      convertButton,
      outputGroup,
    ]);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.portrait) {
          return converter;
        } else {
          return Center(
            child: Container(
              width: 1000.0,
              child: converter,
            ),
          );
        }
      },
    );
  }
}
