import 'package:zakat_app/util/countries.dart';
import 'package:zakat_app/util/country.dart';
import 'package:flutter/widgets.dart';

class CountryPickerUtils {
  static Country getCountryByIsoCode(String isoCode) {
    try {
      return countryList.firstWhere(
        (country) => country.isoCode!.toLowerCase() == isoCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception("The initialValue provided is not a supported iso code!");
    }
  }

  static String getFlagImageAssetPath(String isoCode) {

    debugPrint("Hellllllllllllllllllllllllllllllllllllllllllllllllllllll${"assets/${isoCode.toLowerCase()}.png"}");
    return "assets/${isoCode.toLowerCase()}.png";
  }

  static Widget getDefaultFlagImage(Country country) {
    return Image.asset(
      CountryPickerUtils.getFlagImageAssetPath(country.isoCode!),
      height: 20.0,
      width: 30.0,
      fit: BoxFit.fill,
    );
  }
  static Country getCountryByPhoneCode(String phoneCode) {
    try {
      return countryList.firstWhere(
        (country) => country.phoneCode!.toLowerCase() == phoneCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception(
          "The initialValue provided is not a supported phone code!");
    }
  }
}
