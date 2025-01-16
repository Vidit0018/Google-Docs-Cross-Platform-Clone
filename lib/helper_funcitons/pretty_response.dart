import 'dart:convert';

/// Function to pretty-print a JSON response
void printPrettyResponse(String responseBody) {
  try {
    final json = jsonDecode(responseBody); // Decode JSON string
    final prettyString = JsonEncoder.withIndent('  ').convert(json); // Pretty print
    print(prettyString);
  } catch (e) {
    print('Invalid JSON: $e');
    print('Original Response: $responseBody');
  }
}
