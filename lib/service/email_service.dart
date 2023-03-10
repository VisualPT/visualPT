import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class EmailService {
  final serviceId = "service_1j62fhe";
  final templateId = "template_95smzbm";
  final userId = "_SUuxjVW52hmODTRs";
  final Map<String, String> headers = {
    'origin': 'http://localhost',
    'Content-type': 'application/json'
  };
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

  Future<bool> sendAssessmentPDF(Map<String, String> templateParams) async {
    try {
      await http
          .post(
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
      )
          .then((response) {
        _logEmail(response.body);
        return response.body == 'OK';
      });
    } catch (e) {
      _logEmail(http.Response(e.toString(), 404).toString());
      return false;
    }
    return false;
  }

  void _logEmail(String message) {
    log(name: "Email Logger:", message);
  }
}
