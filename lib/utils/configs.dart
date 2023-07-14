import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

const APP_NAME = 'Siteworx Provider';
const DEFAULT_LANGUAGE = 'en';

const primaryColor = Color(0xff8d161a);

const DOMAIN_URL = 'https://siteworx.diidol.com.ng'; // Don't add slash at the end of the url

const BASE_URL = "$DOMAIN_URL/api/";

/// You can specify in Admin Panel, These will be used if you don't specify in Admin Panel
const IOS_LINK_FOR_PARTNER = "";

const TERMS_CONDITION_URL = 'https://siteworx.ng/home/terms_and_conditions';
const PRIVACY_POLICY_URL = 'https://siteworx.ng/home/privacy_policy';
const INQUIRY_SUPPORT_EMAIL = 'siteworxsocials@gmail.com';

const GOOGLE_MAPS_API_KEY = 'AIzaSyCHJwjZjGSOBc18-3mJM8tCqD2roV3Nk9tQ';

const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';

DateTime todayDate = DateTime(2022, 8, 24);

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";

/// You can update OneSignal Keys from Admin Panel in Setting.
/// These keys will be used if you haven't added in Admin Panel.
const ONESIGNAL_APP_ID = 'dc2320b4-e36e-41ea-aefc-f24533be9c13';
const ONESIGNAL_REST_KEY = "ZWI4N2JkYmYtYTQwNi00Mzk0LTkzN2QtZTQyNzA5ZDY0ZDJm";
const ONESIGNAL_CHANNEL_ID = "91457b3d-a259-4491-a617-98a07dacc9d1";

Country defaultCountry() {
  return Country(
    phoneCode: '234',
    countryCode: 'NG',
    e164Sc: 234,
    geographic: true,
    level: 1,
    name: 'Nigeria',
    example: '8034477604',
    displayName: 'Nigeria (NG) [+234]',
    displayNameNoCountryCode: 'Nigeria (NG)',
    e164Key: '234-NG-0',
    fullExampleWithPlusSign: '+2348034477604',
  );
}
