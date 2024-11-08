import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/sales_invoices_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SalesInvoiceController controller = Get.find<SalesInvoiceController>();

    return Obx(() {
      if (controller.salesData.isEmpty) {
        return Center(child: Text("No hay datos disponibles"));
      }

      final sortedDates = controller.salesData.keys.toList()..sort();

      return Scaffold(
        appBar: AppBar(title: Text("Sales Chart")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                maxY: controller.salesData.values.isNotEmpty
                    ? controller.salesData.values.reduce((a, b) => a > b ? a : b) * 1.3
                    : 50,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: 100000,
                      getTitlesWidget: (value, meta) {
                        String formattedValue =  (value / 1000).toStringAsFixed(1) + "K";
                        return Text(
                          formattedValue,
                          style: TextStyle(fontSize: 7.sp),  // Escalado dinámico de tamaño de fuente
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false), // Oculta etiquetas a la derecha
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
                          final date = sortedDates[value.toInt()];
                          return Text(
                            "${date.day}/${date.month}",
                            style: TextStyle(fontSize: 7.sp),
                          );
                        }
                        return const Text("");
                      },
                      interval: 2,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  sortedDates.length,
                  (index) {
                    final date = sortedDates[index];
                    final totalSales = controller.salesData[date] ?? 0;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: double.parse(totalSales.toStringAsFixed(0)),
                          color: Colors.blueAccent,
                          width: 25,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
