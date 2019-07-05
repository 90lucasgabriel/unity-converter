import 'package:flutter/material.dart';
import 'unit.dart';

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
  @override
  Widget build(BuildContext context) {
    final unitWidgets = getUnit(context);

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
      body: ListView(
        children: unitWidgets,
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