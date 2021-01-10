import 'dart:math';

String dateFormatted(DateTime date) {
  String day = date.day.toString();
  String month = date.month.toString();
  if (day.length == 1) day = "0" + day;
  if (month.length == 1) month = "0" + month;
  String formatted = ("$day/$month/${date.year}");
  return formatted;
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
