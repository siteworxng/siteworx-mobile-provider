//region Actions
import 'package:provider/main.dart';
import 'package:nb_utils/nb_utils.dart';

const HANDYMAN_APPROVED_CASH = "handyman_approved_cash";
const HANDYMAN_SEND_PROVIDER = "handyman_send_provider";
const PROVIDER_APPROVED_CASH = "provider_approved_cash";
const PROVIDER_SEND_ADMIN = "provider_send_admin";
const ADMIN_APPROVED_CASH = "admin_approved_cash";
//endregion

//region Status
const APPROVED_BY_HANDYMAN = "approved_by_handyman"; //- Handyman approved the request
const SEND_TO_PROVIDER = "send_to_provider"; //- Request sent to the provider
const SEND_TO_ADMIN = "send_to_admin"; //Request sent to the admin
const PENDING_BY_PROVIDER = "pending_by_provider"; //- Request pending with the provider
const APPROVED_BY_PROVIDER = "approved_by_provider"; //- Provider approved the request
const PENDING_BY_ADMIN = "pending_by_admin"; //- Request pending with the admin
const APPROVED_BY_ADMIN = "approved_by_admin"; //- Admin approved the request
//endregion

const TODAY = "today";
const YESTERDAY = "yesterday";
const CUSTOM = "custom";
const CASHES = "cash";
const BANK = "bank";

String handleStatusText({required String status}) {
  String text = "";
  if (status == APPROVED_BY_HANDYMAN) {
    text = languages.approvedByHandyman;
  } else if (status == SEND_TO_PROVIDER) {
    text = languages.sentToProvider;
  } else if (status == PENDING_BY_PROVIDER) {
    text = languages.pendingByProvider;
  } else if (status == APPROVED_BY_PROVIDER) {
    text = languages.approvedByProvider;
  } else if (status == PENDING_BY_ADMIN) {
    text = languages.pendingByAdmin;
  } else if (status == APPROVED_BY_ADMIN) {
    text = languages.approvedByAdmin;
  } else if (status == SEND_TO_ADMIN) {
    text = languages.sentToAdmin;
  }
  return text.capitalizeEachWord();
}

String handleBankText({required String status}) {
  String text = "";
  if (status == CASHES) {
    text = CASHES;
  } else if (status == BANK) {
    text = BANK;
  }
  return text.capitalizeEachWord();
}
