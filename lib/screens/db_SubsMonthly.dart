import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_x/api/ApiConstant.dart';
import 'package:flutter_app_x/api/ApiHelperClass.dart';
import 'package:flutter_app_x/components/Avatar.dart';
import 'package:flutter_app_x/localization/AppTranslations.dart';
import 'package:flutter_app_x/pref/UserPref.dart';
import 'package:flutter_app_x/screens/e_CheckOut.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
//import 'package:flutter_calendar_carousel/classes/event.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
//   show CalendarCarousel;


class SubsMonthly extends StatefulWidget {
  @override
  _SubsMonthlyState createState() => _SubsMonthlyState();
}

class _SubsMonthlyState extends State<SubsMonthly> {
  final GlobalKey<ScaffoldState> mScaffoldState = new GlobalKey<ScaffoldState>();

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  List<Schedule> _scheduleList = new List();
  List _offDayList = new List();
  List<MyDate> _selectedDateList = new List();

  _getSchedule() async {
    _selectedDateList.add(new MyDate(context, DateTime.now(), TimeOfDay.now()));

    var _url = ApiConstant.GET_ALL_SCHEDULE;
    var response = await http.get(_url);
    var responseBody = jsonDecode(response.body);
    var schedules = responseBody['data'];
    List<Schedule> list = new List();
    for (var u in schedules) {
      Schedule schedule = new Schedule(
          schedule_id: u['id'],
          openning_time: u['opening_time'],
          clossing_time: u['closing_time'],
          day_name: u['day_name']);
      list.add(schedule);
    }

    var _offDay = _getOffDay(list);
    setState(() {
      _scheduleList = list;
      _offDayList = _offDay;
    });

    print('_getSchedule() : ${list.toString()}');
  }

  _getOffDay(List list) {
    var _dayList = new List();
    var _offDayIdList = new List();
    var _fullWeekDayList = [
      'monday',
      ' tuesday ',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    list.forEach((value) {
      _dayList.add(value.day_name.toLowerCase().trim());
    });
    _fullWeekDayList.forEach((dayName) {
      var value = dayName.toLowerCase().trim();
      bool a = _dayList.toSet().toList().contains(value);
      if (!a) {
        if (value == 'monday'.toLowerCase()) {
          _offDayIdList.add('1');
        } else if (value == 'tuesday'.toLowerCase()) {
          _offDayIdList.add('2');
        } else if (value == 'wednesday'.toLowerCase()) {
          _offDayIdList.add('3');
        } else if (value == 'thursday'.toLowerCase()) {
          _offDayIdList.add('4');
        } else if (value == 'friday'.toLowerCase()) {
          _offDayIdList.add('5');
        } else if (value == 'saturday'.toLowerCase()) {
          _offDayIdList.add('6');
        } else if (value == 'sunday'.toLowerCase()) {
          _offDayIdList.add('7');
        }
      }
    });

    print('-------_offDayIdList : $_offDayIdList------------');

    return _offDayIdList;
  }

  @override
  void initState() {
    super.initState();
    _getSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: mScaffoldState,
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: new Text(
            AppTranslations.of(context).text("monthly_wash"),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if(_selectedDateList.length<5){
                _selectedDateList
                    .add(new MyDate(context, DateTime.now(), TimeOfDay.now()));
              }else{
                final snackBar = SnackBar(content: Text('You can select maximum 5'));
                mScaffoldState.currentState.showSnackBar(snackBar);
              }
            });
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.only(left: 20.0, right: 20.0, bottom: 12.0, top: 0),
          child: MaterialButton(
            child: new Text(
              AppTranslations.of(context).text("continue"),
              style: const TextStyle(
                color: Colors.black,
                letterSpacing: 5.0,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              /*
                * save service time & date /1
                *
                *
                * service_dateTime: dateTime
                * comment: _commentEditingController.text
                *
                *
                * */
              Fluttertoast.showToast(
                  msg: " Loading.... ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0);

              _saveData(_selectedDateList).then((_) {
                Fluttertoast.cancel();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CheckOut()));
              });
              print(
                  '----datetime list : ${_selectedDateList.toString()} ---------');
            },
            elevation: 4.0,
            minWidth: double.infinity,
            height: 48.0,
            color: Colors.white,
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(12.0),
            child: ListView(
              children: <Widget>[
                Avatar("assets/photos/date.png"),
                Container(
                  padding:
                  EdgeInsets.only(left: 12.0, bottom: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _selectedDateList.length,
                      itemBuilder: (context, index) {
                        return new _DateTimePicker(
                          labelText: AppTranslations.of(context).text("date"),
                          scheduleList: _scheduleList,
                          offDayList: _offDayList,
                          selectedDate: _selectedDate(index),
                          selectedTime: _selectedDateList[index].time,
                          selectDate: (DateTime date) {
                            setState(() {
                              _date = date;
                              // userDateList[index] = new MyDate(context, date, _timeOne);
                              _selectedDateList[index].date = date;
                            });
                          },
                          selectTime: (TimeOfDay time) {
                            setState(() {
                              _time = time;
                              _selectedDateList[index].time = time;
                            });
                          },
                        );
                      }),
                )
              ],
            )));
  }

  Future _saveData(var list) async {
    var body = jsonEncode(list);
    print('serialize_dateTime API body : $body');

    var response = await http.post(
      ApiConstant.ARRAY_TO_STRING,
      body: {'serialize_array': '$body'},
    );
    var jsonResponse = json.decode(response.body);
    var data = jsonResponse['data'];

    UserPref.savePref('serialize_dateTime', data);
    UserPref.savePref('dateTime',
        '${list.toString().replaceAll('[', "").replaceAll(']', '')}');
    UserPref.savePref('service_nature',
        '${AppTranslations.of(context).text("one_time_wash")}');

    print('serialize_dateTime : $data');
  }

  _selectedDate(int index) {
    var initDate = _selectedDateList[index].date;
    for (int i = 0; i < _offDayList.length; i++) {
      if (_offDayList.contains(initDate.weekday.toString())) {
        initDate = initDate.add(Duration(days: 1));
      }
    }
    print('------initDate : $initDate----------');
    _selectedDateList[index].date = initDate;
    return initDate;
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime,
      this.scheduleList,
      this.offDayList})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;
  final List<Schedule> scheduleList;
  final List offDayList;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 30)),
      selectableDayPredicate: (DateTime val) {
        return !offDayList.contains(val.weekday.toString());
      },
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    var openning_time;
    var clossing_time;
    var _fullWeekDayList = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];

    for (int i = 0; i < scheduleList.length; i++) {
      print(
          'LHS : ${scheduleList[i].day_name} == RHS : ${_fullWeekDayList[selectedDate.weekday - 1]}');
      if (scheduleList[i].day_name.toLowerCase().trim() ==
          _fullWeekDayList[selectedDate.weekday - 1]) {
        openning_time = int.parse(scheduleList[i].openning_time.split(':')[0]);
        clossing_time = int.parse(scheduleList[i].clossing_time.split(':')[0]);
        print(
            'openning_time : $openning_time || clossing_time : $clossing_time');
      }
    }

    var _intiValue = TimeOfDay.now().hour;

    if (_intiValue > openning_time && _intiValue < clossing_time) {
      _intiValue = selectedTime.hour;
      openning_time = DateTime.now().hour;
      print('----------| current hour=$_intiValue |-------------');
      print('---------openning_time : ${openning_time}-------------');
      print('---------clossing_time : ${clossing_time}-------------');
    } else if (_intiValue < openning_time) {
      _intiValue = openning_time;
      print('----- current hour=$_intiValue -----|-----|--------');
      print('---------openning_time : $openning_time-------------');
      print('---------clossing_time : $clossing_time-------------');
    } else if (_intiValue > clossing_time) {
      _intiValue = clossing_time;
      print('--------|-----|------ current hour=$_intiValue ------');
      print('---------openning_time : $openning_time-------------');
      print('---------clossing_time : $clossing_time-------------');
    }

    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: openning_time,
            maxValue: clossing_time,
            title: new Text("Pick a new time"),
            initialIntegerValue: _intiValue,
          );
        }).then((int picked) {
      if (picked != null &&
          picked != openning_time &&
          picked != clossing_time) {
        selectTime(TimeOfDay(hour: picked, minute: selectedTime.minute));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class MyDate {
  DateTime date;
  TimeOfDay time;
  DateFormat _dateFormat = DateFormat.yMd();
  BuildContext _context;

  MyDate(this._context, this.date, this.time);

  Map toJson() {
    return {
      'date': _dateFormat.format(date),
      'time': time.format(_context),
    };
  }

  @override
  String toString() {
    return '${DateFormat("y/M/d").format(date)} at ${time.format(_context)} \n';
  }
}
