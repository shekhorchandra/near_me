// class DashboardChartItem {
//   final String label;
//   final double count;
//
//   const DashboardChartItem({
//     required this.label,
//     required this.count,
//   });
//
//   factory DashboardChartItem.fromJson(Map<String, dynamic> json) {
//     final rawCount = json["count"];
//
//     return DashboardChartItem(
//       label: json["label"]?.toString() ?? "",
//       count: rawCount is num ? rawCount.toDouble() : 0,
//     );
//   }
// }