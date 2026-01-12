import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../../../../core/utils/pulse_mapper.dart';

class ProfilePulseChart extends StatelessWidget {
  final List<PulsePoint> pulsePoints;

  const ProfilePulseChart({super.key, required this.pulsePoints});

  @override
  Widget build(BuildContext context) {
    // Filter out zero values for a cleaner chart (or keep them as gaps)
    final spots = _buildSpots();
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 3.5,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white.withValues(alpha: 0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      String text = '';
                      if (value == 1) text = 'Low';
                      if (value == 2) text = 'Mid';
                      if (value == 3) text = 'High';
                      return Text(
                        text,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= pulsePoints.length) return const SizedBox();
                      final date = pulsePoints[index].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _formatDay(date),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                touchCallback: (event, response) {
                  if (event is FlTapUpEvent) {
                    HapticFeedback.lightImpact();
                  }
                },
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.black87,
                  tooltipRoundedRadius: 12,
                  getTooltipItems: (spots) => spots.map((spot) {
                    final point = pulsePoints[spot.spotIndex];
                    return LineTooltipItem(
                      '${point.label.isNotEmpty ? point.label : "No entry"}\n${_formatFullDate(point.date)}',
                      GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  preventCurveOverShooting: true,
                  color: Colors.white,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      final value = spot.y;
                      return FlDotCirclePainter(
                        radius: 5,
                        color: PulseMapper.getPulseColor(value),
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blueAccent.withValues(alpha: 0.3),
                        Colors.blueAccent.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    return List.generate(pulsePoints.length, (i) {
      return FlSpot(i.toDouble(), pulsePoints[i].value);
    });
  }

  String _formatDay(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _formatFullDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}
