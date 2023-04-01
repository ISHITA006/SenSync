import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  final Map<String, int>? moodChartData;
  SimpleTimeSeriesChart({Key? key, this.moodChartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TimeSeriesMood, DateTime>> seriesList = _getMoodData(moodChartData);
    return new charts.TimeSeriesChart(seriesList,
        animate: true,
        // Optionally pass in a [DateTimeFactory] used by the chart. The factory
        // should create the same type of [DateTime] as the data provided. If none
        // specified, the default creates local date time.
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesMood, DateTime>> _getMoodData(moodChartData) {
    List<TimeSeriesMood> data = [];
    moodChartData.forEach((key, value) {
      var newPoint = new TimeSeriesMood(DateTime.parse(key), value);
      data.add(newPoint);
    });

    return [
      new charts.Series<TimeSeriesMood, DateTime>(
        id: 'Mood',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesMood mood, _) => mood.time,
        measureFn: (TimeSeriesMood mood, _) => mood.mood,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesMood {
  final DateTime time;
  final int mood;

  TimeSeriesMood(this.time, this.mood);
}