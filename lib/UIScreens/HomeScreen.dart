import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:train_schedule/Helpers/AppConstants.dart';
import 'package:train_schedule/Models/SearchResultModel.dart';

import '../Helpers/FlavouConfig.dart';
import '../Helpers/NetworkHelper.dart';
import '../Helpers/ShowNotificationHelper.dart';
import '../Helpers/StationConstants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController ipAdressController = TextEditingController()
    ..text = "Fetching Seats";
  SearchResultModel? searchResultModel;
  bool _isDialogShowing = true;
  bool initialLoad = true;
  String selectCoachNo = "S1";
  Map<String, List<Vbd>> coachWiseMap = {};
  DateTime now = DateTime.now();
  String currentDate = "";

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
      body: RefreshIndicator(
          child: Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                !_isDialogShowing
                    ? Expanded(child: mainBlock())
                    : buildDataLoder()
              ],
            ),
          ),
          onRefresh: () => Future.sync(() => getSeatInfo())),
    ));
  }

  getSeatInfo() async {
    searchResultModel = null;
    _isDialogShowing = true;

    String url =
        "${FlavorConfig.instance.url()}www.irctc.co.in/online-charts/api/vacantBerth";
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
      "trainNo": "22927",
      "boardingStation": "ADH",
      "remoteStation": "BDTS",
      "trainSourceStation": "BDTS",
      "jDate": currentDate,
      "cls": "SL",
      "chartType": 2
    });

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
        showInFlushBar(
          context,
          "Something went wrong.",
        );
      });

      if (response.statusCode == 200) {
        if (_isDialogShowing) {
          setState(() {
            _isDialogShowing = false;
            searchResultModel = SearchResultModel.fromJson(response.data);
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
                if (searchResultModel!.vbd![mainIndex].to == "ADH" ||
                    searchResultModel!.vbd![mainIndex].to == "BVI") {
                  seatFoundStartingBetweenBandarOrVirar = false;
                }
                if (!seatFoundStartingBetweenBandarOrVirar) {
                  indexToBeRemoved.add(mainIndex);
                }
              }
              for (int removeIndex = indexToBeRemoved.length - 1;
                  removeIndex >= 0;
                  removeIndex--) {
                searchResultModel!.vbd!.removeAt(indexToBeRemoved[removeIndex]);
              }
              // sixfigure code to look and check
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

              // for (int printIndex = 0;
              //     printIndex < searchResultModel!.vbd!.length;
              //     printIndex++) {
              //   print("${searchResultModel!.vbd![printIndex].from}");
              //    print("${searchResultModel!.vbd![printIndex].berthNumber}");
              // }
            }
          });
        }
      } else {
        if (_isDialogShowing) {
          setState(() {
            _isDialogShowing = false;
          });
        }
        showInFlushBar(
          context,
          "Something went wrong else.",
        );
      }
    } on DioError catch (e) {
      if (_isDialogShowing) {
        setState(() {
          _isDialogShowing = false;
        });
      }
      showInFlushBar(
        context,
        "Something went wrong.",
      );
    }
  }

  Center buildDataLoder() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SpinKitRing(
            lineWidth: 3,
            color: COLOR_PRIMARY_DARK,
            size: 40.0,
            duration: Duration(milliseconds: 1000),
          ),
          const SizedBox(height: 10),
          Text(
            "Getting data",
            style: semiBoldTxtStyle,
          ),
        ],
      ),
    );
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
          selectCoachNo = "S$coachNo";
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
        Text(
            "Total Seats in $selectCoachNo are ${coachWiseMap[selectCoachNo] == null ? 0 : coachWiseMap[selectCoachNo]!.length}"),
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
          "Please try again after some time, charts might not have been prepared!\n\nHave some food, catch up with friends ;-)",
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
            "No Seats here :( ",
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
      color: getBgColorForRow(vbd.to!),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ],
          color: COLOR_WHITE,
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                stationNameMap[vbd.from],
                style: smallTxtStyleBoldBlue,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                stationNameMap[vbd.to] ?? vbd.to,
                style: smallTxtStyleBoldBlue,
              )
            ],
          ),
          Text(
            vbd.berthNumber!.toString(),
            style: smallTxtStyleBoldPriBlue,
          ),
          Text(
            berthCodes[vbd.berthCode] ?? "Not mentioned",
            style: smallTxtStyleBoldBlue,
          )
        ],
      ),
    );
  }

  Color getBgColorForRow(String stationCode) {
    if (stationCode == "VR") {
      return Colors.redAccent;
    }
    if (stationCode == "PLG" || stationCode == "SAH") {
      return Colors.yellowAccent;
    }
    return Colors.greenAccent;
  }
}
