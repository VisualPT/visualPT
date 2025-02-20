import 'package:mockito/annotations.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors_plus;

@GenerateMocks([
  sensors_plus.SensorsPlatform,
  sensors_plus.AccelerometerEvent,
  sensors_plus.Sensors,
  sensors_plus.SensorInterval,
])
void main() {}
