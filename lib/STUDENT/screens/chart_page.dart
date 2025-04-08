import 'package:emotional_learning_platform/STUDENT/APIs/graph_student.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatelessWidget {
  // Test data with names and marks
  // final List<Map<String, dynamic>> testData = [
  //   {'test': 'Test 1', 'marks': 75},
  //   {'test': 'Test 2', 'marks': 85},
  //   {'test': 'Test 3', 'marks': 90},
  //   {'test': 'Test 4', 'marks': 78},
  //   {'test': 'Test 5', 'marks': 88},
  //   {'test': 'Test 6', 'marks': 75},
  //   {'test': 'Test 7', 'marks': 85},
  //   {'test': 'Test 8', 'marks': 90},
  //   {'test': 'Test 9', 'marks': 78},
  //   {'test': 'Test 10', 'marks': 10},
  // ];

  ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,  // Assuming marks are out of 100
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32, // Space for y-axis labels
                  getTitlesWidget: (value, _) => Text(value.toInt().toString()),
                ),
              ),
              rightTitles: AxisTitles( // Hiding right titles
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, _) {
                    // Display test names based on index
                    int index = value.toInt();
                    return index < studentChart.value.length
                        ? Transform.rotate(
                            angle: -90 * 3.1415927 / 180,  // Rotate 90 degrees
                            child: Text(
                              studentChart.value[index].session.toString(),
                              style: TextStyle(
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          )
                        : const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: studentChart.value
                .asMap()
                .entries
                .map((entry) => BarChartGroupData(
                      x: entry.key, // Index of the test (integer)
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.score?.toDouble() ?? 0,  // Marks as double for the length
                          color: Colors.blue,
                        ),
                      ],
                    ))
                .toList(),
            gridData: FlGridData(show: false),  // Optionally hide the grid
          ),
        ),
      ),
    );
  }
}
