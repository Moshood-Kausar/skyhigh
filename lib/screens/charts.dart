// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skyhigh/services/api_sevices.dart';
import 'package:skyhigh/services/base_api.dart';
import 'package:skyhigh/services/models/charts_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  Charts _selectedChartType = Charts.bar;
  USState state = USState.Alabama;
  Segment segment = Segment.consumer;
  Category category = Category.furniture;
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
                          value: state,
                          items: USState.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) => context
                              .read<ChartProvider>()
                              .filterByState(value ?? USState.Alabama),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: DropdownButtonFormField(
                          value: category,
                          items: Category.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.value,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) => context
                              .read<ChartProvider>()
                              .filterByCategory(value ?? Category.furniture),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: DropdownButtonFormField(
                          value: segment,
                          items: Segment.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.value,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) => context
                              .read<ChartProvider>()
                              .filterBySegment(value ?? Segment.consumer),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SegmentedButton<Charts>(
                    onSelectionChanged: (p0) => setState(() {
                      _selectedChartType = p0.first;
                    }),
                    segments: const <ButtonSegment<Charts>>[
                      ButtonSegment<Charts>(
                        value: Charts.bar,
                        label: Text(
                          'BAR',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      ButtonSegment<Charts>(
                        value: Charts.pie,
                        label: Text(
                          'PIE',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      ButtonSegment<Charts>(
                        value: Charts.composite,
                        label: Text(
                          'COMPOSITE',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      ButtonSegment<Charts>(
                        value: Charts.timeSeries,
                        label: Text(
                          'TIME SERIES',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                    selected: <Charts>{_selectedChartType},
                  ),
                  const SizedBox(height: 20),
                  if (_selectedChartType == Charts.bar)
                    SizedBox(
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: [
                          BarSeries<ChartsModel, String>(
                              dataSource: value.filteredTimeSeries,
                              xValueMapper: (ChartsModel data, _) =>
                                  data.orderDate,
                              yValueMapper: (ChartsModel data, _) =>
                                  data.sales),
                        ],
                      ),
                    ),
                  if (_selectedChartType == Charts.pie)
                    SizedBox(
                      child: SfCircularChart(
                        series: [
                          DoughnutSeries<ChartsModel, String>(
                            // pointColorMapper:(datum, index) => Colors.red,
                            dataSource: value.filteredTimeSeries,
                            xValueMapper: (datum, index) => datum.orderDate,
                            yValueMapper: (datum, index) => datum.sales,
                          )
                        ],
                      ),
                    ),
                  if (_selectedChartType == Charts.composite)
                    SizedBox(
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <StackedBarSeries<ChartsModel, String>>[
                          StackedBarSeries(
                            dataSource: value.filteredTimeSeries,
                            xValueMapper: (datum, index) => datum.orderDate,
                            yValueMapper: (datum, index) => datum.sales,
                          ),
                          StackedBarSeries(
                            dataSource: value.filteredTimeSeries,
                            xValueMapper: (datum, index) => datum.shipDate,
                            yValueMapper: (datum, index) => datum.sales,
                          ),
                        ],
                      ),
                    ),
                  if (_selectedChartType == Charts.timeSeries)
                    SizedBox(
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(),
                        series: <ChartSeries>[
                          LineSeries<ChartsModel, DateTime>(
                            dataSource: value.filteredTimeSeries,
                            xValueMapper: (datum, index) => datum.parseDate(),
                            yValueMapper: (datum, index) => datum.sales,
                          )
                        ],
                      ),
                    )
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
  List<ChartsModel> _timeseries = [];
  List<ChartsModel> filteredTimeSeries = [];
  USState state = USState.Alabama;
  Segment segment = Segment.consumer;
  Category category = Category.furniture;

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
        _timeseries = r;
        filteredTimeSeries = r
            .where((element) =>
                element.state == state.name &&
                element.category == category.value &&
                element.segment == segment.value)
            .toList();
        log(r.toString(), name: 'response');
        notifyListeners();
      },
    );
  }

  filterByState(USState filterState) {
    state = filterState;
    filteredTimeSeries = _timeseries
        .where((element) =>
            element.state == state.name &&
            element.category == category.value &&
            element.segment == segment.value)
        .toList();
    notifyListeners();
  }

  filterBySegment(Segment filterSegment) {
    segment = filterSegment;
    filteredTimeSeries = _timeseries
        .where((element) =>
            element.state == state.name &&
            element.category == category.value &&
            element.segment == segment.value)
        .toList();
    notifyListeners();
  }

  filterByCategory(Category filterCategory) {
    category = filterCategory;
    filteredTimeSeries = _timeseries
        .where((element) =>
            element.state == state.name &&
            element.category == category.value &&
            element.segment == segment.value)
        .toList();
    notifyListeners();
  }
}
