import 'dart:math';

double sigmoid(double x) {
  return 1 / (1 + exp(-x));
}

// Safe division function to handle NaN or Infinity
double safeDivision(double numerator, double denominator) {
  if (denominator == 0 || numerator.isNaN || denominator.isNaN) {
    return 0.0;
  } else {
    final ratio = numerator / denominator * 100;
    if (ratio.isNaN || ratio.isInfinite) {
      return 0.0;
    } else {
      return ratio;
    }
  }
}
