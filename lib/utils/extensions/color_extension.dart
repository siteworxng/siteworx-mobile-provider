import 'package:flutter/material.dart';
import 'package:provider/screens/cash_management/cash_constant.dart';
import 'package:provider/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constant.dart';

extension colorExt on String {
  Color get getPaymentStatusBackgroundColor {
    switch (this) {
      case BOOKING_STATUS_PENDING:
        return pending;
      case BOOKING_STATUS_ACCEPT:
        return accept;
      case BOOKING_STATUS_ON_GOING:
        return on_going;
      case BOOKING_STATUS_IN_PROGRESS:
        return in_progress;
      case BOOKING_STATUS_HOLD:
        return hold;
      case BOOKING_STATUS_CANCELLED:
        return cancelled;
      case BOOKING_STATUS_REJECTED:
        return rejected;
      case BOOKING_STATUS_FAILED:
        return failed;
      case BOOKING_STATUS_COMPLETED:
        return completed;
      case BOOKING_STATUS_PENDING_APPROVAL:
        return pendingApprovalColor;
      case BOOKING_STATUS_WAITING_ADVANCED_PAYMENT:
        return waiting;

      default:
        return defaultStatus;
    }
  }

  Color get getBookingActivityStatusColor {
    log(this.validate().replaceAll(' ', '_').toLowerCase());
    switch (this.validate().replaceAll(' ', '_').toLowerCase()) {
      case ADD_BOOKING:
        return add_booking;
      case ASSIGNED_BOOKING:
        return assigned_booking;
      case TRANSFER_BOOKING:
        return transfer_booking;
      case UPDATE_BOOKING_STATUS:
        return update_booking_status;
      case CANCEL_BOOKING:
        return cancel_booking;
      case PAYMENT_MESSAGE_STATUS:
        return payment_message_status;

      default:
        return defaultActivityStatus;
    }
  }

  Color get getCashPaymentStatusBackgroundColor {
    Color text = Colors.transparent;
    if (this == APPROVED_BY_HANDYMAN) {
      text = add_booking;
    } else if (this == SEND_TO_PROVIDER) {
      text = assigned_booking;
    } else if (this == PENDING_BY_PROVIDER) {
      text = add_booking;
    } else if (this == APPROVED_BY_PROVIDER) {
      text = completed;
    } else if (this == PENDING_BY_ADMIN) {
      text = add_booking;
    } else if (this == APPROVED_BY_ADMIN) {
      text = completed;
    } else if (this == SEND_TO_ADMIN) {
      text = assigned_booking;
    }
    return text;
  }

  Color get getJobStatusColor {
    switch (this) {
      case BOOKING_STATUS_PENDING:
        return pending;
      case BOOKING_STATUS_ACCEPT:
        return accept;
      case BOOKING_STATUS_ON_GOING:
        return on_going;
      case BOOKING_STATUS_IN_PROGRESS:
        return in_progress;
      case BOOKING_STATUS_HOLD:
        return hold;
      case BOOKING_STATUS_CANCELLED:
        return cancelled;
      case BOOKING_STATUS_REJECTED:
        return rejected;
      case BOOKING_STATUS_FAILED:
        return failed;
      case BOOKING_STATUS_COMPLETED:
        return completed;
      case BOOKING_STATUS_PENDING_APPROVAL:
        return pendingApprovalColor;
      case BOOKING_STATUS_WAITING_ADVANCED_PAYMENT:
        return waiting;

      default:
        return defaultStatus;
    }
  }
}
