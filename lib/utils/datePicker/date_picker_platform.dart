import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>?> datePickerForAndroid(
    {required BuildContext context, DateTime? initialDate}) async {
  final date = await showDatePicker(
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.white,
          // ignore: deprecated_member_use

          colorScheme: const ColorScheme.light(
            primary: Colors.black,
          ),
          buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
    context: context,
    locale: const Locale('es'),
    fieldHintText: "dd/mm/yyyy",
    initialDate: initialDate ?? DateTime(2006, 12, 31),
    firstDate: DateTime(1930),
    lastDate: DateTime(2006, 12, 31),
  );

  if (date != null) {
    return {
      "date_": date,
      "date_string": DateFormat("dd/MM/yyyy").format(date)
    };
    /*_formatDate = date;
      txtFechaNac.text = DateFormat('dd/MM/yyyy').format(_formatDate!);*/

    /*fechaNac = */
  } else {
    return null;
  }
}

Future<Map<String, dynamic>?> datePickerForIos(
    {required BuildContext context, DateTime? initialDate}) async {
  String? dateString;
  DateTime? date;

  await showCupertinoModalPopup(
      context: context,
      builder: (builder) {
        return Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              initialDateTime: initialDate ?? DateTime(2006, 12, 31),
              mode: CupertinoDatePickerMode.date,
              
              use24hFormat: true,
              showDayOfWeek: false,
              onDateTimeChanged: (DateTime? newDate) {
                if (newDate != null) {
                  date = newDate;
                  dateString = DateFormat("dd/MM/yyyy").format(newDate);
                }
              },
            ),
          ),
        );
      });

  if (date != null && dateString != null) {
    return {"date": date, "date_string": dateString};
  } else {
    return null;
  }
}
