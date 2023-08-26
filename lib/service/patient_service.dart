import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/_service.dart';

class PatientService extends DataStoreService<Patient> {
  PatientService();

  // @override
  // Future<Patient> read(Map<String, dynamic> params) async {
  //   final email = params["email"];
  //   final patients = await Amplify.DataStore.query(Patient.classType,
  //       where: Patient.PROVIDER_CONTACT.eq(email).and());
  //   return patients.first;
  // }
}
