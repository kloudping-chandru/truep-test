import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:get/get.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: AppColors.primaryColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    Common.restaurantDetails.value.name!,
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Obx(() => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: BarChart(
                            mainBarData(),
                            swapAnimationDuration: animDuration,
                          ),
                        )),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
      {
    bool isTouched = false,
    Color barColor = const Color(0xff845bef),
    double width = 15,
    List<int> showTooltips = const [],
  })

  {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
           gradient: isTouched ? LinearGradient(colors: [Colors.yellow,Colors.yellow]) : LinearGradient(colors: [barColor,barColor]),
          width: width,
          borderSide: isTouched ? BorderSide(color: Colors.yellow, width: 1) : BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            gradient: LinearGradient(colors: [AppColors.addressColor,AppColors.addressColor]),
          ),
        ),

      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, double.parse(Common.monGraph.value), isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, double.parse(Common.tueGraph.value), isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, double.parse(Common.wedGraph.value), isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, double.parse(Common.thuGraph.value), isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, double.parse(Common.friGraph.value), isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, double.parse(Common.satGraph.value), isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, double.parse(Common.sunGraph.value), isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY - 1).toString(),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              switch (value.toInt()) {
                case 0:
                  return Text("M",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
                case 1:
                  return Text("T",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
                case 2:
                  return Text("W",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
                case 3:
                  return Text("T",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
                case 4:
                  return Text("F",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
                case 5:
                  return Text("S",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
                case 6:
                  return Text("S",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
                default:
                  return Text("M",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
              }
            },
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }


}
