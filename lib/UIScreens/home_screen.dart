import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:train_schedule/Helpers/app_constants.dart';
import 'package:train_schedule/Models/search_result.dart';

import '../Helpers/flavou_config.dart';
import '../Helpers/network_helper.dart';
import '../Helpers/notification_helper.dart';
import '../Helpers/station_constants.dart';
import '../Models/vbd.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController ipAdressController = TextEditingController()
    ..text = 'Fetching Seats';
  SearchResult? searchResultModel;
  bool _isDialogShowing = true;
  bool initialLoad = true;
  String selectCoachNo = 'S1';
  Map<String, List<Vbd>> coachWiseMap = {};
  DateTime now = DateTime.now();
  String currentDate = '';
  int chartType = 2;

  List<Widget> availableCoach = [
    const Text('S1'),
    const Text('S2'),
    const Text('S3'),
    const Text('S4'),
    const Text('S5'),
    const Text('S6'),
    const Text('S7'),
    const Text('S8'),
  ];
  List<bool> selectedCoach = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<int> indexToBeRemoved = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy-MM-dd').format(now);
    getSeatInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            !_isDialogShowing
                ? Expanded(child: mainBlock())
                : buildDataLoder('Cooking fresh data...')
          ],
        ),
      ),
    ));
  }

  getSeatInfo() async {
    searchResultModel = null;
    _isDialogShowing = true;

    String url =
        '${FlavorConfig.instance.url()}www.irctc.co.in/online-charts/api/vacantBerth';
    // Paschim number
    // var body = json.encode({
    //   "trainNo": "12925",
    //   "boardingStation": "BVI",
    //   "remoteStation": "MMCT",
    //   "trainSourceStation": "MMCT",
    //   "jDate": "2023-05-28",
    //   "cls": "SL",
    //   "chartType": 2
    // });

    // Lokshati number
    var body = json.encode({
      'trainNo': '22927',
      'boardingStation': 'ADH',
      'remoteStation': 'BDTS',
      'trainSourceStation': 'BDTS',
      'jDate': currentDate,
      'cls': 'SL',
      'chartType': chartType
    });

    await FirebaseAnalytics.instance.logEvent(name: 'Calling API');
    try {
      final response = await getDio()
          .post(url,
              data: body,
              options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                },
              ))
          .catchError((onError) {
        print('Error 500');
        return onError as FutureOr<Response<dynamic>>;
      });

      if (response.statusCode == 200) {
        if (_isDialogShowing) {
          setState(() {
            _isDialogShowing = false;
            searchResultModel =
                SearchResult.fromJson(response.data as Map<String, dynamic>);
            if (searchResultModel != null &&
                searchResultModel!.vbd != null &&
                searchResultModel!.vbd!.isNotEmpty) {
              for (int mainIndex = 0;
                  mainIndex < searchResultModel!.vbd!.length;
                  mainIndex++) {
                bool seatFoundStartingBetweenBandarOrVirar = false;
                for (int fromIndex = 1; fromIndex <= 4; fromIndex++) {
                  if (searchResultModel!.vbd![mainIndex].from ==
                      stationCodeSequence[fromIndex]) {
                    seatFoundStartingBetweenBandarOrVirar = true;
                    break;
                  }
                }
                if (searchResultModel!.vbd![mainIndex].to == 'ADH' ||
                    searchResultModel!.vbd![mainIndex].to == 'BVI') {
                  seatFoundStartingBetweenBandarOrVirar = false;
                }
                if (!seatFoundStartingBetweenBandarOrVirar) {
                  indexToBeRemoved.add(mainIndex);
                }
                // data might be null, empty string or whitespace
                if (searchResultModel!.vbd![mainIndex].berthCode == null ||
                    searchResultModel!.vbd![mainIndex].berthCode!.isEmpty ||
                    searchResultModel!.vbd![mainIndex].berthCode! == ' ') {
                  searchResultModel!.vbd![mainIndex].berthCode =
                      calculateBerthCode(
                          searchResultModel!.vbd![mainIndex].berthNumber!);
                }
              }
              for (int removeIndex = indexToBeRemoved.length - 1;
                  removeIndex >= 0;
                  removeIndex--) {
                searchResultModel!.vbd!.removeAt(indexToBeRemoved[removeIndex]);
              }

              // sixfigure code to look and check to sort all seat numbers in accending
              for (var list in searchResultModel!.vbd!) {
                if (coachWiseMap[list.coachName] == null) {
                  coachWiseMap[list.coachName!] = [];
                }
                coachWiseMap[list.coachName]!.add(list);
              }
              coachWiseMap.forEach((key, value) {
                value
                    .sort(((a, b) => a.berthNumber!.compareTo(b.berthNumber!)));
              });

              // Logic to remove repeated seats
              coachWiseMap.forEach((key, value) {
                var list = value;

                List<int> indexToRemove = [];

                for (int i = 1; i < list.length; i++) {
                  if (list[i] == list[i - 1]) {
                    indexToRemove.add(i);
                  }
                }

                for (int i = indexToRemove.length - 1; i >= 0; i--) {
                  list.removeAt(indexToRemove[i]);
                }

                value = list;
              });

              // for (int printIndex = 0;
              //     printIndex < searchResultModel!.vbd!.length;
              //     printIndex++) {
              //   print("${searchResultModel!.vbd![printIndex].from}");
              //    print("${searchResultModel!.vbd![printIndex].berthNumber}");
              // }
            } else {
              if (chartType != 1) {
                chartType = 1;
                getSeatInfo();
              } else {
                return;
              }
            }
          });
        }
      } else {
        if (_isDialogShowing) {
          setState(() {
            _isDialogShowing = false;
          });
        }
        print('Error something went wrong');
        if (chartType != 1) {
          chartType = 1;
          getSeatInfo();
        } else {
          return;
        }
      }
    } on Exception catch (error) {
      if (_isDialogShowing) {
        setState(() {
          _isDialogShowing = false;
        });
      }
      print('Exception occure');
      return error as FutureOr<Response<dynamic>>;
    }
  }

  Widget buildCoachNo() {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0; i < selectedCoach.length; i++) {
            selectedCoach[i] = i == index;
          }
          int coachNo = index + 1;
          selectCoachNo = 'S$coachNo';
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.blue[700],
      selectedColor: Colors.white,
      fillColor: Colors.blue[200],
      color: Colors.blue[400],
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 40,
      ),
      isSelected: selectedCoach,
      children: availableCoach,
    );
  }

  Column mainBlock() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        buildCoachNo(),
        const SizedBox(
          height: 20,
        ),
        chartType == 2
            ? const Text('Showing fresh data')
            : const Text(
                'Showing 1st chart, some seats might have been booked. Hope you select the vacant seat.\nBest of luck 🍀',
                textAlign: TextAlign.center,
              ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Total Seats in $selectCoachNo are ${coachWiseMap[selectCoachNo] == null ? 0 : coachWiseMap[selectCoachNo]!.length}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        listOfSeats()
      ],
    );
  }

  Widget listOfSeats() {
    if (searchResultModel!.vbd!.isEmpty) {
      return Expanded(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isItHighTime()
            ? Text(
                "I think there is someting wrong.\n You're on your own, best on luck 😂",
                style: medTxtStyleBoldPriBlue,
                textAlign: TextAlign.center,
              )
            : Text(
                'Please try again after some time, charts might not have been prepared!\n\nHave some food 🍕 , catch up with friends! 😌\n\n Usual time is around 7:15 pm or 7.30 pm',
                style: medTxtStyleBoldPriBlue,
                textAlign: TextAlign.center,
              ),
      ));
    }
    if (coachWiseMap[selectCoachNo] == null
        ? false
        : coachWiseMap[selectCoachNo]!.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
            itemCount: coachWiseMap[selectCoachNo]!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return buildInfoCard(
                  context, coachWiseMap[selectCoachNo]![index]);
            }),
      );
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'No Seats in this coach 💔',
            style: medTxtStyleSemiBoldBlack,
          ),
        ),
      );
    }
  }

  Widget buildInfoCard(BuildContext context, Vbd vbd) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5, top: 5),
      margin: const EdgeInsets.only(bottom: 0, left: 10, right: 10, top: 10),
      //color: getBgColorForRow(vbd.to!),
      decoration: BoxDecoration(
          color: getBgColorForRow(vbd.to!),
          border: Border.all(color: Colors.grey),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                stationNameMap[vbd.from] as String,
                style: smallTxtStyleBoldBlue,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                (stationNameMap[vbd.to] ?? vbd.to) as String,
                style: smallTxtStyleBoldBlue,
              )
            ],
          ),
          Text(
            vbd.berthNumber!.toString(),
            style: smallTxtStyleBoldPriBlue,
          ),
          Text(
            (vbd.berthCode!.endsWith('*')
                    ? vbd.berthCode
                    : berthCodes[vbd.berthCode]) as String? ??
                'Not mentioned',
            style: smallTxtStyleBoldBlue,
          )
        ],
      ),
    );
  }

  Color getBgColorForRow(String stationCode) {
    if (stationCode == 'VR') {
      return Colors.redAccent;
    }
    if (stationCode == 'PLG' || stationCode == 'SAH') {
      return Colors.yellowAccent;
    }
    return Colors.greenAccent;
  }

  String calculateBerthCode(int berthNumber) {
    int globalCount = 1;
    int berthCodeNumber = 1;
    while (globalCount != berthNumber) {
      globalCount++;
      berthCodeNumber++;
      if (berthCodeNumber > 8) {
        berthCodeNumber = 1;
      }
    }
    return ('${berthCodes[beathNumberAndType[berthCodeNumber]]} *');
  }

  bool isItHighTime() {
    DateTime currentTime = DateTime.now();
    DateTime timeLine =
        DateTime.now().copyWith(hour: 19, minute: 45, second: 0);
    if (currentTime.isBefore(timeLine)) {
      return false;
    } else {
      return true;
    }
  }
}
