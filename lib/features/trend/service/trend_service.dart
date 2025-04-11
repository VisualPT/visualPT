import 'package:intl/intl.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/models/ModelProvider.dart';

enum TimePeriod {
  days,
  weeks,
  months,
  years,
}

class TrendService {
  static Duration _getDuration(TimePeriod timePeriod, int scale) {
    switch (timePeriod) {
      case TimePeriod.years:
        return Duration(days: scale * 365);
      case TimePeriod.months:
        return Duration(days: scale * 30);
      case TimePeriod.weeks:
        return Duration(days: scale * 7);
      case TimePeriod.days:
        return Duration(days: scale);
    }
  }

  static List<int> _createCounts(int scale) {
    return List<int>.filled(scale, 0);
  }

  static int _calculateIndex(DateTime createdAt, TimePeriod timePeriod) {
    DateTime now = DateTime.now();
    int index;

    switch (timePeriod) {
      case TimePeriod.years:
        index = now.year - createdAt.year;
        break;
      case TimePeriod.months:
        index =
            (now.year - createdAt.year) * 12 + (now.month - createdAt.month);
        break;
      case TimePeriod.weeks:
        index = ((now.difference(createdAt).inDays) ~/ 7);
        break;
      case TimePeriod.days:
        index = now.difference(createdAt).inDays;
        break;
    }
    return index;
  }

  static List<String> _generateXAxisLabels(TimePeriod timePeriod, int scale) {
    return List.generate(scale, (index) {
      final date = DateTime.now().subtract(Duration(
          days: (scale - index - 1) *
              (timePeriod == TimePeriod.days
                  ? 1
                  : timePeriod == TimePeriod.weeks
                      ? 7
                      : timePeriod == TimePeriod.months
                          ? 30
                          : 365)));
      return timePeriod == TimePeriod.days
          ? '${date.day} ${DateFormat('MMMM').format(date)}'
          : timePeriod == TimePeriod.weeks
              ? '${(DateTime.now().difference(date).inDays ~/ 7) + 1} Week(s) ago'
              : timePeriod == TimePeriod.months
                  ? DateFormat('MMM').format(date) // Shortened to 3 letters
                  : date.year.toString();
    });
  }

  // Assessments over the last 6 months
  static Future<Map<String, dynamic>> getAssessments(
      {TimePeriod timePeriod = TimePeriod.months, int scale = 6}) async {
    Duration duration = _getDuration(timePeriod, scale);

    final response = await ApiService.list(Assessment.classType,
        limit: 1000,
        where: Assessment.CREATEDAT
            .between(DateTime.now().subtract(duration), DateTime.now()),
        getAll: true);

    final assessments = response.data?.items ?? [];

    final assessmentCounts = _createCounts(scale);
    for (var assessment in assessments) {
      if (assessment == null) continue;
      final createdAt = assessment.createdAt.getDateTimeInUtc().toLocal();
      int index = _calculateIndex(createdAt, timePeriod);

      // Adjust index based on the difference, most recent is at the end of the list
      if (index >= 0 && index < assessmentCounts.length) {
        assessmentCounts[assessmentCounts.length - index - 1]++;
      }
    }

    final chartOptions = {
      "title": {
        "text": "Assessments over the last $scale ${timePeriod.name}",
        'textStyle': {'color': 'black'},
      },
      "backgroundColor": false,
      "xAxis": {
        "type": "category",
        "data": _generateXAxisLabels(timePeriod, scale),
      },
      "yAxis": {"type": "value"},
      "series": [
        {"data": assessmentCounts, "type": "bar"}
      ]
    };

    return chartOptions;
  }

  // New patients over the last 6 months
  static Future<Map<String, dynamic>> getNewPatients(
      {TimePeriod timePeriod = TimePeriod.months, int scale = 6}) async {
    Duration duration = _getDuration(timePeriod, scale);

    final response = await ApiService.list(Profile.classType,
        limit: 1000,
        where: Profile.CREATEDAT
            .between(DateTime.now().subtract(duration), DateTime.now()),
        getAll: true);

    final profiles = response.data?.items ?? [];
    final profileCounts = _createCounts(scale);
    for (var profile in profiles) {
      if (profile == null) continue;
      final createdAt = profile.createdAt.getDateTimeInUtc().toLocal();
      int index = _calculateIndex(createdAt, timePeriod);

      // Adjust index based on the difference
      if (index >= 0 && index < profileCounts.length) {
        profileCounts[profileCounts.length - index - 1]++;
      }
    }

    final chartOptions = {
      "title": {
        "text": "New patients over the last $scale ${timePeriod.name}",
        'textStyle': {'color': 'black'},
      },
      "backgroundColor": false,
      "xAxis": {
        "type": "category",
        "data": _generateXAxisLabels(timePeriod, scale),
      },
      "yAxis": {"type": "value"},
      "series": [
        {"data": profileCounts, "type": "bar"}
      ]
    };

    return chartOptions;
  }

  // Minutes of trials captured over the last 6 months
  static Future<Map<String, dynamic>> getDurationOfTrials(
      {TimePeriod timePeriod = TimePeriod.months, int scale = 6}) async {
    Duration duration = _getDuration(timePeriod, scale);

    final response = await ApiService.list(Trial.classType,
        limit: 1000,
        where: Trial.CREATEDAT
            .between(DateTime.now().subtract(duration), DateTime.now()),
        getAll: true);

    final trials = response.data?.items ?? [];
    final trialCounts = _createCounts(scale);
    for (var trial in trials) {
      if (trial == null) continue;
      final createdAt = trial.createdAt.getDateTimeInUtc().toLocal();
      int index = _calculateIndex(createdAt, timePeriod);

      // Adjust index based on the difference
      if (index >= 0 && index < trialCounts.length) {
        trialCounts[trialCounts.length - index - 1] +=
            (trial.duration / 60).round();
      }
    }

    final chartOptions = {
      "title": {
        "text": "Minutes of trials over the last $scale ${timePeriod.name}",
        'textStyle': {'color': 'black'},
      },
      "backgroundColor": false,
      "xAxis": {
        "type": "category",
        "data": _generateXAxisLabels(timePeriod, scale),
      },
      "yAxis": {"type": "value"},
      "series": [
        {"data": trialCounts, "type": "bar"}
      ]
    };

    return chartOptions;
  }
}
