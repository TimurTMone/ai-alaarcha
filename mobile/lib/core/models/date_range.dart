class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange(this.start, this.end);

  bool overlaps(DateTime checkIn, DateTime checkOut) {
    return checkIn.isBefore(end) && checkOut.isAfter(start);
  }

  List<DateTime> get occupiedDates {
    final dates = <DateTime>[];
    var d = DateTime(start.year, start.month, start.day);
    final last = DateTime(end.year, end.month, end.day);
    while (d.isBefore(last)) {
      dates.add(d);
      d = d.add(const Duration(days: 1));
    }
    return dates;
  }
}
