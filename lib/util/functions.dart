 String dateFormatted(DateTime date) {
    String day = date.day.toString();
    String month = date.month.toString();
    if (day.length == 1) day = "0" + day;
    if (month.length == 1) month = "0" + month;
    String formatted = ("$day/$month/${date.year}");
    return formatted;
  }