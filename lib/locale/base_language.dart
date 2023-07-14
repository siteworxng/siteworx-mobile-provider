import 'package:flutter/material.dart';

abstract class Languages {
  static Languages of(BuildContext context) => Localizations.of<Languages>(context, Languages)!;

  String planAboutToExpire(int days);

  String get appName;

  String get provider;

  String get lblShowingOnly4Handyman;

  String get lblRecentlyOnlineHandyman;

  String get lblStartDrive;

  String get handyman;

  String get signIn;

  String get signUp;

  String get hintFirstNameTxt;

  String get hintLastNameTxt;

  String get hintContactNumberTxt;

  String get hintEmailAddressTxt;

  String get hintUserNameTxt;

  String get hintReenterPasswordTxt;

  String get confirm;

  String get forgotPassword;

  String get alreadyHaveAccountTxt;

  String get rememberMe;

  String get forgotPasswordTitleTxt;

  String get resetPassword;

  String get editProfile;

  String get saveChanges;

  String get camera;

  String get language;

  String get appTheme;

  String get bookingHistory;

  String get logout;

  String get afterLogoutTxt;

  String get chooseTheme;

  String get selectCountry;

  String get selectState;

  String get selectCity;

  String get changePassword;

  String get passwordNotMatch;

  String get doNotHaveAccount;

  String get hintNewPasswordTxt;

  String get hintOldPasswordTxt;

  String get review;

  String get notification;

  String get accept;

  String get decline;

  String get noDataFound;

  String get pending;

  String get darkMode;

  String get lightMode;

  String get systemDefault;

  String get confirmationRequestTxt;

  String get notAvailable;

  String get lblGallery;

  String get cantLogin;

  String get pleaseContactAdmin;

  String get lblOk;

  String get paymentStatus;

  String get paymentMethod;

  String get hintAddress;

  String get quantity;

  String get lblYes;

  String get lblNo;

  String get lblReason;

  String get lblSelectHandyman;

  String get lblAssign;

  String get lblCall;

  String get lblAssignHandyman;

  String get lblAssigned;

  String get viewAll;

  String get lblMonthlyRevenue;

  String get lblRevenue;

  String get lblAddHandyman;

  String get lblBooking;

  String get lblTotalBooking;

  String get lblTotalService;

  String get lblTotalHandyman;

  String get lblTotalRevenue;

  String get lblPayment;

  String get lblBookingID;

  String get lblPaymentID;

  String get lblAmount;

  String get hintAddService;

  String get hintServiceName;

  String get hintSelectCategory;

  String get hintSelectType;

  String get hintSelectStatus;

  String get hintPrice;

  String get hintDiscount;

  String get hintDuration;

  String get hintDescription;

  String get hintSetAsFeature;

  String get hintAdd;

  String get hintChooseImage;

  String get customer;

  String get lblProfile;

  String get lblAllHandyman;

  String get lblTime;

  String get lblMyService;

  String get lblAllService;

  String get lblChat;

  String get selectAddress;

  String get btnSave;

  String get editAddress;

  String get lblUpdate;

  String get lblEdit;

  String get lblDelete;

  String get lblServiceAddress;

  String get lblServices;

  String get lblEditService;

  String get selectImgNote;

  String get lblDurationHr;

  String get lblDurationMin;

  String get lblWaitForAcceptReq;

  String get lblAddServiceAddress;

  String get errorPasswordLength;

  String get hintPassword;

  String get hintRequired;

  String get lblUnAuthorized;

  String get btnVerifyId;

  String get confirmationUpload;

  String get toastSuccess;

  String get lblSelectDoc;

  String get lblAddDoc;

  String get lblRateUs;

  String get lblTermsAndConditions;

  String get lblPrivacyPolicy;

  String get lblHelpAndSupport;

  String get lblAbout;

  String get lblProviderType;

  String get lblMyCommission;

  String get lblTaxes;

  String get lblTaxName;

  String get lblMyTax;

  String get lblLoginTitle;

  String get lblLoginSubtitle;

  String get lblSignupTitle;

  String get lblSignupSubtitle;

  String get lblSignup;

  String get lblUserType;

  String get lblPurchaseCode;

  String get lblRating;

  String get lblOff;

  String get lblHr;

  String get lblDate;

  String get lblAboutHandyman;

  String get lblAboutCustomer;

  String get lblPaymentDetail;

  String get lblId;

  String get lblMethod;

  String get lblStatus;

  String get lblPriceDetail;

  String get lblSubTotal;

  String get lblTax;

  String get lblCoupon;

  String get lblTotalAmount;

  String get lblOnBasisOf;

  String get lblCheckStatus;

  String get lblCancel;

  String get lblUnreadNotification;

  String get lblMarkAllAsRead;

  String get lblCloseAppMsg;

  String get lblAddress;

  String get lblType;

  String get lblHandymanType;

  String get lblFixed;

  String get lblHello;

  String get lblWelcomeBack;

  String get lblNoReviewYet;

  String get lblWaitingForResponse;

  String get lblConfirmPayment;

  String get lblDelivered;

  String get lblDay;

  String get lblYear;

  String get lblExperience;

  String get lblOf;

  String get lblSelectAddress;

  String get lblOppS;

  String get lblNoInternet;

  String get lblRetry;

  String get lblBookingSummary;

  String get lblServiceStatus;

  String get lblMemberSince;

  String get lblDeleteAddress;

  String get lblDeleteAddressMsg;

  String get lblChoosePaymentMethod;

  String get lblNoPayments;

  String get lblPayWith;

  String get lblProceed;

  String get lblPricingPlan;

  String get lblSelectPlan;

  String get lblMakePayment;

  String get lblRestore;

  String get lblForceDelete;

  String get lblActivated;

  String get lblDeactivated;

  String get lblNoDescriptionAvailable;

  String get lblFAQs;

  String get lblGetDirection;

  String get lblDeleteTitle;

  String get lblDeleteSubTitle;

  String get lblUpcomingServices;

  String get lblTodayServices;

  String get lblPlanExpired;

  String get lblPlanSubTitle;

  String get btnTxtBuyNow;

  String get lblChooseYourPlan;

  String get lblRenewSubTitle;

  String get lblReminder;

  String get lblRenew;

  String get lblCurrentPlan;

  String get lblValidTill;

  String get lblSearchHere;

  String get lblEarningList;

  String get lblSubscriptionTitle;

  String get lblPlan;

  String get lblCancelPlan;

  String get lblSubscriptionHistory;

  String get lblTrashHandyman;

  String get lblPlsSelectAddress;

  String get lblPlsSelectCategory;

  String get lblEnterHours;

  String get lblEnterMinute;

  String get lblSelectSubCategory;

  String get lblServiceProof;

  String get lblTitle;

  String get lblAddImage;

  String get lblSubmit;

  String get lblWalletHistory;

  String get lblServiceRatings;

  String get lblWallet;

  String get lblSelectUserType;

  String get lblIAgree;

  String get lblTermsOfService;

  String get lblLoginAgain;

  String get lblTermCondition;

  String get lblServiceTotalTime;

  String get lblHelpLineNum;

  String get lblReasonCancelling;

  String get lblReasonRejecting;

  String get lblFailed;

  String get lblDesignation;

  String get lblHandymanIsOffline;

  String get lblDoYouWantToRestore;

  String get lblDoYouWantToDeleteForcefully;

  String get lblDoYouWantToDelete;

  String get lblPleaseEnterMobileNumber;

  String get lblDangerZone;

  String get lblDeleteAccount;

  String get lblDeleteAccountConformation;

  String get lblUnderMaintenance;

  String get lblCatchUpAfterAWhile;

  String get lblRecheck;

  String get lblTrialFor;

  String get lblDays;

  String get lblFreeTrial;

  String get lblAtLeastOneImage;

  String get lblService;

  String get lblNewUpdate;

  String get lblOptionalUpdateNotify;

  String get lblAnUpdateTo;

  String get lblIsAvailableWouldYouLike;

  String get lblAreYouSureYouWantToAssignThisServiceTo;

  String get lblAreYouSureYouWantToAssignToYourself;

  String get lblAssignToMyself;

  String get lblFree;

  String get lblMyProvider;

  String get lblAvailableStatus;

  String get lblYouAre;

  String get lblEmailIsVerified;

  String get lblHelp;

  String get lblAddYourCountryCode;

  String get lblRegistered;

  String get lblRequiredAfterCountryCode;

  String get lblExtraCharges;

  String get lblAddExtraCharges;

  String get lblCompleted;

  String get lblAddExtraChargesDetail;

  String get lblEnterExtraChargesDetail;

  String get lblTotalCharges;

  String get lblSuccessFullyAddExtraCharges;

  String get lblChargeName;

  String get lblPrice;

  String get lblEnterAmount;

  String get lblHourly;

  String get noBookingTitle;

  String get noBookingSubTitle;

  String get noNotificationTitle;

  String get noNotificationSubTitle;

  String get noHandymanAvailable;

  String get noHandymanYet;

  String get noHandymanSubTitle;

  String get noServiceFound;

  String get noServiceSubTitle;

  String get noServiceAddressTitle;

  String get noServiceAddressSubTitle;

  String get noSubscriptionPlan;

  String get noSubscriptionFound;

  String get noSubscriptionSubTitle;

  String get noTexesFound;

  String get noWalletHistoryTitle;

  String get noWalletHistorySubTitle;

  String get noExtraChargesHere;

  String get getYourFirstReview;

  String get ratingViewAllSubtitle;

  String get noDocumentFound;

  String get noDocumentSubTitle;

  String get noConversation;

  String get jobRequestList;

  String get bidList;

  String get bid;

  String get postJobTitle;

  String get postJobDescription;

  String get jobPrice;

  String get estimatedPrice;

  String get assignedProvider;

  String get giveYourEstimatePriceHere;

  String get pleaseEnterValidBidPrice;

  String get yourPriceShouldNotBeLessThan;

  String get enterBidPrice;

  String get myBid;

  String get inputMustBeNumberOrDigit;

  String get requiredAfterCountryCode;

  String get internetNotAvailable;

  String get pleaseTryAgain;

  String get somethingWentWrong;

  String get thisSlotIsNotAvailable;

  String get notes;

  String get timeSlotsNotes1;

  String get timeSlotsNotes2;

  String get timeSlotsNotes3;

  String get noSlotsAvailable;

  String get timeSlots;

  String get selectYourDay;

  String get chooseTime;

  String get copyTo;

  String get pleaseWaitWhileWeChangeTheStatus;

  String get myTimeSlots;

  String get day;

  String get pleaseSelectServiceAddresses;

  String get pleaseSelectImages;

  String get timeSlotAvailable;

  String get doesThisServicesContainsTimeslot;

  String get pleaseEnterTheDefaultTimeslotsFirst;

  String get chooseAction;

  String get chooseImage;

  String get removeImage;

  String get availableAt;

  String get clearChat;

  String get upcomingBookings;

  String get postJob;

  String get categoryBasedPackage;

  String get subTitleOfSelectService;

  String get enabled;

  String get disabled;

  String get doYouWantTo;

  String get enable;

  String get disable;

  String get package;

  String get packages;

  String get packageService;

  String get confirmationRemovePackage;

  String get packageName;

  String get selectService;

  String get addService;

  String get packageDescription;

  String get packagePrice;

  String get startDate;

  String get endDate;

  String get pleaseSelectService;

  String get pleaseEnterTheEndDate;

  String get editPackage;

  String get addPackage;

  String get areYouSureWantToDeleteThe;

  String get packageNotAvailable;

  String get includedInThisPackage;

  String get packageServicesWillAppearHere;

  String get showingFixPriceServices;

  String get pleaseSelectTheCategory;

  String get lblInvalidTransaction;

  String get youWillGetTheseServicesWithThisPackage;

  String get lblSearchFullAddress;

  String get lblPleaseSelectCity;

  String get lblChooseOneImage;

  String get lblNoTransactionFound;

  String get lblSubTitleNoTransaction;

  String get lblCheckOutWithCinetPay;

  String get yourPaymentFailedPleaseTryAgain;

  String get yourPaymentHasBeenMadeSuccessfully;

  String get lblTransactionFailed;

  String get lblTransactionCancelled;

  String get lblStripeTestCredential;

  String get lblYourCurrenciesNotSupport;

  String get lblSuccessFullyActivated;

  String get lblNoTaxesFound;

  String get lblConfirmationForDeleteMsg;

  String get lblImage;

  String get lblVideo;

  String get lblAudio;

  String get lblMessage;

  String get chatCleared;

  String get lblNoEarningFound;

  String get lblNoUserFound;

  String get lblTokenExpired;

  String get lblFailedToLoadPredictions;

  String get personalInfo;

  String get essentialSkills;

  String get knownLanguages;

  String get addEssentialSkill;

  String get addKnownLanguage;

  String get authorBy;

  String get views;

  String get deleteBlogTitle;

  String get enterBlogTitle;

  String get updateBlog;

  String get addBlog;

  String get blogs;

  String get noBlogsFound;

  String get aboutYou;

  String get pleaseAddKnownLanguage;

  String get pleaseAddEssentialSkill;

  String get published;

  String get clearChatMessage;

  String get all;

  String get accepted;

  String get onGoing;

  String get inProgress;

  String get hold;

  String get cancelled;

  String get rejected;

  String get failed;

  String get completed;

  String get pendingApproval;

  String get waiting;

  String get paid;

  String get advancePaid;

  String get advancePayAmountPer;

  String get enablePrePayment;

  String get enablePrePaymentMessage;

  String get invalidInput;

  String get remainingAmount;

  String get advancePayment;

  String get valueConditionMessage;

  String get withExtraAndAdvanceCharge;

  String get withExtraCharge;

  String get min;

  String get hour;

  String get lblChangeCountry;

  String get lblExample;

  String get active;

  String get inactive;

  String get use24HourFormat;

  String get successfullyActivated;

  String get providerHome;

  String get handymanHome;

  String get home;

  String get selectPlanSubTitle;

  String get userRole;

  String get paymentHistory;

  String get theService;

  String get areYouSureYouWantTo;

  String get selectDuration;

  String get thisServiceMayTake;

  String get priceAmountValidationMessage;

  String get lblFeatureBlog;

  String get changePasswordTitle;

  String get forgotPasswordSubtitle;

  String get badRequest;

  String get forbidden;

  String get pageNotFound;

  String get tooManyRequests;

  String get internalServerError;

  String get badGateway;

  String get serviceUnavailable;

  String get gatewayTimeout;

  String get requested;

  String get assigned;

  String get reload;

  String get noConversationSubTitle;

  String get noServiceAccordingToCoordinates;

  String get isNotValid;

  String get unlimited;

  String get upTo;

  String get amountToBeReceived; // Amount to be received
  String get yourCashPaymentForBookingId; // "Your cash payment for Booking Id"
  String get isAcceptedAsOn; //is accepted as on
  String get sendCashToProvider; // Send Cash to Provider
  String get sendCashToAdmin; // Send Cash to Admin
  String get cashPaymentApproval; // Cash Payment Approval
  String get approvedByHandyman; // Approved by Handyman
  String get sentToProvider; // Sent to Provider
  String get pendingByProvider; // Pending by Provider
  String get approvedByProvider; // Approved by Provider
  String get pendingByAdmin; // Pending by Admin
  String get approvedByAdmin; // Approved by Admin
  String get sentToAdmin; // Sent to Admin
  String get ofTransfer; // of Transfer
  String get refNumber; // Ref. Number
  String get todayCash; // Today's Cash
  String get cash; // Cash
  String get bank; // Bank
  String get handymanApprovedTheRequest; // Handyman approved the request
  String get requestSentToTheProvider; // Request sent to the provider
  String get requestSentToTheAdmin; // Request sent to the admin
  String get requestPendingWithTheProvider; // Request pending with the provider
  String get providerApprovedTheRequest; // Provider approved the request
  String get requestPendingWithTheAdmin; // Request pending with the admin
  String get adminApprovedTheRequest; // Admin approved the request
  String get today; //  Today
  String get yesterday; //  Yesterday
  String get customDate; //  Custom Date
  String get totalCash; // Total Cash
  String get tomorrow; // Tomorrow
  String get cashList; //Cash list
  String get sortBy; // Sort by
  String get noPaymentsFounds; // No Payments founds
  String get cashBalance; // Cash Balance
  String get close; // Close
  String get retryPaymentDetails; // Retry Payment Details
  String get totalAmountToPay; // Total amount to pay
  String get from; // From
  String get booking; // Booking
  String get choosePaymentMethod; // Choose Payment Method
  String get sendToAdmin; // Send to Admin
  String get sendToProvider; // Send to Provider
  String get detailsOfTheBank; // Details of the bank
  String get selectABankTransferMoneyAndEnterTheReferenceIDInTheTextFieldBelow; // Select a bank, transfer money, and enter the reference ID in the text field below.
  String get noBanksAvailable; // No banks available
  String get chooseCashOrContactAdminForBankInformation; // Choose cash or contact admin for bank information
  String get bankName; // Bank Name
  String get accountNumber; // Account number
  String get iFSCCode; // IFSC code
  String get bankAddress; // Bank address
  String get pleaseWaitWhileWeLoadBankDetails; // Please wait while we load bank details...
  String get cashPaymentConfirmation; // Cash Payment Confirmation
  String get remark; // Remark
  String get pleaseWaitWhileWeLoadChatDetails; // Please wait while we load chat details...
  String get isNotAvailableForChat; // is not available for chat
}
