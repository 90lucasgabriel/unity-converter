import 'package:flutter/material.dart';
import 'dropdown.dart';
import 'unit.dart';

const _padding = 16.0;
const _borderRadius = 16.0;
String dropdownValue = 'Lucas';

class ConverterRoute extends StatefulWidget {
  final String title;
  final ColorSwatch color;
  final List<Unit> units;

  const ConverterRoute({
    @required this.title,
    @required this.color,
    @required this.units,
  })  : assert(title != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
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
    for (var unit in widget.units) {
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
      _fromValue = widget.units[0];
      _toValue = widget.units[1];
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
    return widget.units.firstWhere(
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
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.display1,
        ),
        centerTitle: true,
        backgroundColor: widget.color,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            inputGroup(context),
            convertButton(context),
            outputGroup(context),
          ],
        ),
      ),
    );
  }

  Widget inputGroup(BuildContext context) {
    return Padding(
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
              labelText: 'Valor',
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
  }

  Widget outputGroup(BuildContext context) {
    return Padding(
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
  }

  Widget convertButton(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.swap_vert),
        iconSize: 45.0,
        onPressed: () {},
      ),
    );
  }

  List getUnit(BuildContext context) {
    return widget.units.map((Unit unit) {
      return Container(
        color: widget.color,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      );
    }).toList();
  }
}
