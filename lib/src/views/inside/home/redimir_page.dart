import 'package:flutter/material.dart';
import 'package:kmello_app/src/models/country_model.dart';
import 'package:kmello_app/utils/list/country_list.dart';

class RedimirPage extends StatefulWidget {
  const RedimirPage({super.key});

  @override
  State<RedimirPage> createState() => _RedimirPageState();
}

class _RedimirPageState extends State<RedimirPage> {
  final txtControllerCode = TextEditingController();

  List<Country> countryList = countries;

  String codeCountry = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 2,
                child: Align(
                    alignment: Alignment.center,
                    child: Text("Código del país: "))),
            Expanded(
              flex: 1,
              child: TextField(
                  controller: txtControllerCode,
                  onChanged: (_) {
                    codeCountry = txtControllerCode.text;
                    Country country = countries.firstWhere(
                        (element) => element.dialCode == codeCountry);

                    debugPrint("country name: " + country.name);
                  }),
            ),
            if (txtControllerCode.text.isNotEmpty)
              Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ))
          ],
        ),
        Expanded(
            child: ListView.builder(
                itemCount: countryList.length,
                itemBuilder: (builder, index) {
                  return Container(
                    child: Text(countryList[index].name),
                  );
                }))
      ],
    );
  }
}
