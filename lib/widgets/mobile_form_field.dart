import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class MovileFormField extends StatefulWidget {
  final Function(String) setNumber;

  MovileFormField({super.key, required this.setNumber});

  @override
  State<MovileFormField> createState() => _MovileFormFieldState();
}

class _MovileFormFieldState extends State<MovileFormField> {
  String? _phoneNumber;

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          bottom: 10,
        ),
        child: TextFormField(
          style: TextStyle(color: Colors.white),

          // focusNode: focus,
          // validator: context.validator.email().build(),
          decoration: InputDecoration(
              labelText: 'phone number',
              labelStyle: TextStyle(color: Colors.white),
              suffixIconColor: Colors.white,
              prefixIcon: Container(
                padding: EdgeInsets.only(top: 8.0, right: 8),
                child: InkWell(
                  onTap: () {
                    showCountryPicker(
                        context: context,
                        countryListTheme: const CountryListThemeData(
                            bottomSheetHeight: 550,
                            searchTextStyle: TextStyle(color: Colors.white),
                            backgroundColor: Color(0xFF27001F),
                            textStyle: TextStyle(color: Colors.white)),
                        onSelect: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                        });
                  },
                  child: Text(
                    "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              suffixIcon: Icon(Icons.phone),
              iconColor: Colors.white),
          onFieldSubmitted: (value) {
            _phoneNumber = "+" + selectedCountry.phoneCode + value;
            widget.setNumber(_phoneNumber!);
          },

          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        )

        //  TextFormField(
        //     maxLines: 1,
        //     cursorColor: Colors.purple,
        //     style: const TextStyle(
        //       fontSize: 15,
        //       fontWeight: FontWeight.bold,
        //     ),
        //     textInputAction: TextInputAction.next,
        //     decoration: InputDecoration(
        //       hintText: "9876543210",
        //       // fillColor: Colors.purple.shade50,
        //       // filled: true,
        //       hintStyle: TextStyle(
        //         fontWeight: FontWeight.w500,
        //         fontSize: 15,
        //         color: Colors.grey.shade600,
        //       ),
        //       enabledBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //         borderSide: const BorderSide(color: Colors.black12),
        //       ),
        //       focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //         borderSide: const BorderSide(color: Colors.black12),
        //       ),
        //       prefixIcon: Container(
        //         padding: const EdgeInsets.all(8.0),
        //         child: InkWell(
        //           onTap: () {
        //             showCountryPicker(
        //                 context: context,
        //                 countryListTheme: const CountryListThemeData(
        //                   bottomSheetHeight: 550,
        //                 ),
        //                 onSelect: (value) {
        //                   setState(() {
        //                     selectedCountry = value;
        //                   });
        //                 });
        //           },
        //           child: Text(
        //             "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
        //             style: const TextStyle(
        //               fontSize: 18,
        //               color: Colors.black,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     onSaved: (value) {
        //       _phoneNumber = "+" + selectedCountry.phoneCode + value!;
        //       widget.setNumber(_phoneNumber!);
        //     },
        //   ),
        );
  }
}
