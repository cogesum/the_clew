import 'package:clew_app/features/user/data/achive_data.dart';
import 'package:flutter/material.dart';

class AchivesWidget extends StatelessWidget {
  AchivesWidget({Key? key}) : super(key: key);
  final achiveData = AchiveData();
  List<Widget> _achiveWidgets = [];

  List<Widget> _generateAchives() {
    for (int i = 0; i < achiveData.achiveList.length; i++) {
      _achiveWidgets.add(_AchiveWidget(
        title: achiveData.achiveList[i].name,
        descriptions: achiveData.achiveList[i].description,
        urlSource: achiveData.achiveList[i].imgSourse,
        points: achiveData.achiveList[i].points,
      ));
    }
    return _achiveWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[1000],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
              width: 4,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Column(
                children: _generateAchives(),
              ),
            ],
          )),
      Positioned(
        top: 5,
        left: 20,
        child: Container(
          height: 20,
          width: 150,
          color: Colors.white,
          child: Text(
            "Достижения",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    ]);
  }
}

class _AchiveWidget extends StatelessWidget {
  _AchiveWidget(
      {Key? key,
      required this.title,
      required this.descriptions,
      required this.urlSource,
      required this.points})
      : super(key: key);
  String urlSource;
  String title;
  String descriptions;
  double points;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Row(children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Image.network(
              urlSource,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  descriptions,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      color: Colors.blue,
                      minHeight: 7,
                      value: 0.3,
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
