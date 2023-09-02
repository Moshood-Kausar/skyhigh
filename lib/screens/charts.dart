// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skyhigh/services/api_sevices.dart';
import 'package:skyhigh/services/base_api.dart';
import 'package:skyhigh/services/models/charts_model.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  Charts _selectedChartType = Charts.bar;
  @override
  void initState() {
    super.initState();
    context.read<ChartProvider>().getTimeSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ChartProvider>(
          builder: (context, value, child) {
            if (value.states == States.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (value.states == States.error) {
              return const Center(
                child: Text(
                  'Unable to get Charts. Kindly Refresh',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              );
            } else {
              return Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          items: USState.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: DropdownButtonFormField(
                          items: Category.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.value,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: DropdownButtonFormField(
                          items: Segment.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.value,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SegmentedButton<Charts>(
                    on
                    segments: const <ButtonSegment<Charts>>[
                      ButtonSegment<Charts>(
                        value: Charts.bar,
                        label: Text('BAR'),
                      ),
                      ButtonSegment<Charts>(
                        value: Charts.pie,
                        label: Text('PIE'),
                      ),
                      ButtonSegment<Charts>(
                        value: Charts.composite,
                        label: Text('COMPOSITE'),
                      ),
                      ButtonSegment<Charts>(
                        value: Charts.timeSeries,
                        label: Text('TIME SERIES'),
                      ),
                    ],
                    selected: <Charts>{_selectedChartType},
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

enum States { loading, error, success }

enum USState {
  Alabama,
  Alaska,
  Arizona,
  Arkansas,
  California,
  Colorado,
  Connecticut,
  Delaware,
  Florida,
  Georgia,
  Hawaii,
  Idaho,
  Illinois,
  Indiana,
  Iowa,
  Kansas,
  Kentucky,
  Louisiana,
  Maine,
  Maryland,
  Massachusetts,
  Michigan,
  Minnesota,
  Mississippi,
  Missouri,
  Montana,
  Nebraska,
  Nevada,
  NewHampshire,
  NewJersey,
  NewMexico,
  NewYork,
  NorthCarolina,
  NorthDakota,
  Ohio,
  Oklahoma,
  Oregon,
  Pennsylvania,
  RhodeIsland,
  SouthCarolina,
  SouthDakota,
  Tennessee,
  Texas,
  Utah,
  Vermont,
  Virginia,
  Washington,
  WestVirginia,
  Wisconsin,
  Wyoming,
}

enum Segment {
  corporate("Corporate"),
  homeOffice("Home Office"),
  consumer("Consumer");

  final String value;
  const Segment(this.value);
}

enum Category {
  officeSupplies("Office Supplies"),
  furniture("Furniture"),
  technology("Technology");

  final String value;
  const Category(this.value);
}

enum Charts {
  bar('Bar'),
  pie('Pie'),
  composite('Composite'),
  timeSeries('Time Series');

  final String value;
  const Charts(this.value);
}

class ChartProvider extends ChangeNotifier {
  States states = States.loading;
  List<ChartsModel> timeseries = [];

  final api = ApiService();

  getTimeSeries() async {
    final response = await api.chartApi();
    response.fold(
      (l) {
        states = States.error;
        notifyListeners();
      },
      (r) {
        states = States.success;
        timeseries = r;
        log(r.toString(), name: 'response');
        notifyListeners();
      },
    );
  }

  List<ChartsModel> filterTimeSeries(
      {USState? state, Segment? segment, Category? category}) {
    return [];
  }
}
