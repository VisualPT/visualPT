import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:visualpt/models/FallHistory.dart';

class FormatUtil {
  static String date(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(dateTime);
  }

  static String time(DateTime dateTime) {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  static String duration(double durationInSeconds) {
    int minutes = durationInSeconds ~/ 60;
    double remainingSeconds = durationInSeconds % 60;
    //If the duration is less than a minute, return only the seconds
    if (minutes == 0) {
      return "${remainingSeconds.round()} seconds";
    }
    return "$minutes minutes ${remainingSeconds.round()} seconds";
  }

  /// Converts a String of a weight in lbs to kg and returns a formatted string
  static String weight(String value) {
    final double v = double.parse(value);
    final double kg = v * 0.453592;
    return "$v lbs / ${kg.toStringAsFixed(2)} kg";
  }

  static List<T> filterList<T>(List<T?>? items) {
    return items?.where((element) => element != null).toList().cast<T>() ?? [];
  }

  static int getAge(TemporalDate dob) {
    //Converts an Amplify TemporalDate to a difference in time by years and returns that as an int
    final now = TemporalDate.now();
    return now.getDateTime().year - dob.getDateTime().year;
  }

  static T castValue<T>(dynamic value, T typeSample) {
    if (typeSample is int) return int.tryParse(value.toString()) as T;
    if (typeSample is double) return double.tryParse(value.toString()) as T;
    if (typeSample is bool) return (value.toString() == 'true') as T;
    if (typeSample is FallHistory) {
      return FallHistory.values.firstWhere(
        (e) => e.name == value.toString(),
        orElse: () => FallHistory.NONE,
      ) as T;
    }
    return value as T;
  }
}
