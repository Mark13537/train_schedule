import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:train_schedule/Helpers/app_constants.dart';
import 'package:train_schedule/Models/search_result.dart';
import 'package:train_schedule/Models/train_config.dart';

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
  TextEditingController trainNoTxtController = TextEditingController();
  SearchResult? searchResultModel;
  bool _isDialogShowing = true;
  bool initialLoad = true;
  String selectCoachNo = '';
  Map<String, List<Vbd>> coachWiseMap = {};
  DateTime now = DateTime.now();
  String currentDate = '';
  String coachPrefix = 'S';
  List<String> availableCoach = [];
  List<bool> selectedCoach = [];
  List<int> indexToBeRemoved = [];
  bool isChat2 = true;
  late TrainConfig flyingMorningConfig,
      flyingReturnConfig,
      lokshaktiReturnConfig;

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy-MM-dd').format(now);

    flyingMorningConfig = TrainConfig(
        trainNo: '12922',
        boardingStation: 'DRD',
        jDate: currentDate,
        cls: '2S',
        chartType: 2,
        remoteStation: 'ST',
        trainSourceStation: 'ST');
    flyingReturnConfig = TrainConfig(
        trainNo: '12921',
        boardingStation: 'MMCT',
        jDate: currentDate,
        cls: '2S',
        chartType: 2,
        remoteStation: 'MMCT',
        trainSourceStation: 'MMCT');
    lokshaktiReturnConfig = TrainConfig(
        trainNo: '22927',
        boardingStation: 'ADH',
        jDate: currentDate,
        cls: 'SL',
        chartType: 2,
        remoteStation: 'BDTS',
        trainSourceStation: 'BDTS');

    getSeatInfo(trainConfig: lokshaktiReturnConfig);
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
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: [
                OutlinedButton(
                    onPressed: () {
                      getSeatInfo(trainConfig: flyingMorningConfig);
                    },
                    child: const Text('Flying Morning')),
                OutlinedButton(
                    onPressed: () {
                      getSeatInfo(trainConfig: flyingReturnConfig);
                    },
                    child: const Text('Flying Return')),
                OutlinedButton(
                    onPressed: () {
                      getSeatInfo(trainConfig: lokshaktiReturnConfig);
                    },
                    child: const Text('Lokshakti Return')),
              ],
            ),
            !_isDialogShowing
                ? Expanded(child: mainBlock())
                : buildDataLoder('Cooking fresh data...')
          ],
        ),
      ),
    ));
  }

  getSeatInfo({required TrainConfig trainConfig}) async {
    trainConfig.chartType == 1 ? isChat2 = false : true;
    searchResultModel = null;
    _isDialogShowing = true;

    selectCoachNo = '';
    coachWiseMap.clear();
    indexToBeRemoved.clear();

    availableCoach.clear();
    selectedCoach.clear();

    String url =
        '${FlavorConfig.instance.url()}www.irctc.co.in/online-charts/api/vacantBerth';
    var body = json.encode(trainConfig.toJson());

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
                bool crawlLisReverse = false;
                if (int.parse(trainConfig.trainNo) % 2 == 0) {
                  crawlLisReverse = true;
                }
                int start = crawlLisReverse ? 18 : 0;
                int end = crawlLisReverse ? 8 : 3;
                int step = crawlLisReverse ? -1 : 1;
                bool seatFoundAtFirst3Stops = false;
                for (int i = start;
                    crawlLisReverse ? i >= end : i <= end;
                    i += step) {
                  if (crawlLisReverse) {
                    if (searchResultModel!.vbd![mainIndex].to ==
                        stationCodeSequence[i]) {
                      indexToBeRemoved.add(mainIndex);
                      break;
                    }
                  } else {
                    if (searchResultModel!.vbd![mainIndex].from ==
                        stationCodeSequence[i]) {
                      seatFoundAtFirst3Stops = true;
                      break;
                    }
                  }
                }
                if (searchResultModel!.vbd![mainIndex].to == 'ADH' ||
                    searchResultModel!.vbd![mainIndex].to == 'BVI') {
                  seatFoundAtFirst3Stops = false;
                }
                if (!seatFoundAtFirst3Stops) {
                  indexToBeRemoved.add(mainIndex);
                  break;
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
              indexToBeRemoved = indexToBeRemoved.toSet().toList();
              for (int removeIndex = indexToBeRemoved.length - 1;
                  removeIndex >= 0;
                  removeIndex--) {
                searchResultModel?.vbd
                    ?.removeAt(indexToBeRemoved.elementAt(removeIndex));
              }

              // sixfigure code to look and check to sort all seat numbers in accending
              for (var list in searchResultModel!.vbd!) {
                if (coachWiseMap[list.coachName] == null) {
                  coachWiseMap[list.coachName!] = [];
                }
                coachWiseMap[list.coachName]!.add(list);
              }
              if (coachWiseMap.keys.isNotEmpty) {
                selectCoachNo = coachWiseMap.keys.first;
                coachPrefix = selectCoachNo[0];
                coachWiseMap.forEach((key, value) {
                  value.sort(
                      ((a, b) => a.berthNumber!.compareTo(b.berthNumber!)));
                });
              } else {
                print("it was emptu");
              }

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
              for (var element in coachWiseMap.keys) {
                availableCoach.add(element);
                selectedCoach.add(false);
              }
              availableCoach.sort();
              if (selectedCoach.isNotEmpty) {
                selectedCoach[0] = true;
              }

              // for (int printIndex = 0;
              //     printIndex < searchResultModel!.vbd!.length;
              //     printIndex++) {
              //   print("${searchResultModel!.vbd![printIndex].from}");
              //    print("${searchResultModel!.vbd![printIndex].berthNumber}");
              // }
            } else {
              if (trainConfig.chartType != 1) {
                trainConfig.chartType = 1;
                getSeatInfo(trainConfig: trainConfig);
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
        if (trainConfig.chartType != 1) {
          trainConfig.chartType = 1;
          getSeatInfo(trainConfig: trainConfig);
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
      return error as FutureOr<Response<dynamic>>;
    }
  }

  Widget buildCoachNo() {
    List<Widget> widgetList = [];
    for (var element in availableCoach) {
      widgetList.add(Text(element));
    }
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < availableCoach.length; i++) {
            selectedCoach[i] = i == index;
          }
          int coachNo = index;
          selectCoachNo = '$coachPrefix${availableCoach[coachNo][1]}';
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
      children: widgetList,
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
        isChat2
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
        child: Text(
          "Please try again after some time, charts might not have been prepared yet!\nIf the issue persists then I think there is something wrong.\n\nYou're on your own, best of luck 😂",
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
                (stationNameMap[vbd.from] ?? vbd.from).toString(),
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
            (vbd.berthNumber ?? 0).toString(),
            style: smallTxtStyleBoldPriBlue,
          ),
          Text(
            (vbd.berthCode!.endsWith('*')
                    ? vbd.berthCode
                    : berthCodes[vbd.berthCode]) as String? ??
                vbd.berthCode ??
                'NA',
            style: smallTxtStyleBoldBlue,
          )
        ],
      ),
    );
  }

  Color getBgColorForRow(String stationCode) {
    // if (stationCode == 'VR') {
    //   return Colors.redAccent;
    // }
    // if (stationCode == 'PLG' || stationCode == 'SAH') {
    //   return Colors.yellowAccent;
    // }
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
}
