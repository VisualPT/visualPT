import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class EmailService {
  final serviceId = "service_1j62fhe";
  final templateId = "template_95smzbm";
  final userId = "_SUuxjVW52hmODTRs";
  final Map<String, String> headers = {
    'origin': 'http://localhost',
    'Content-type': 'application/json'
  };
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

  Future<Response> sendAssessmentPDF(Map<String, String> templateParams) async {
    Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(
        {
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': templateParams
        },
      ),
    );
    _logEmail(response.body);
    return response;
  }

  void _logEmail(String message) {
    log(name: "Email Logger", message);
  }
}
