import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zurumi/data/admin_bank-details_model.dart';
import 'package:zurumi/data/api_client.dart';
import 'package:zurumi/data/crypt_model/bank_model.dart';
import 'package:zurumi/data/crypt_model/coin_list.dart';
import 'package:zurumi/data/crypt_model/asset_details_model.dart';
import 'package:zurumi/data/crypt_model/assets_list_model.dart';
import 'package:zurumi/data/crypt_model/check_quote_model.dart';
import 'package:zurumi/data/crypt_model/country_code.dart';
import 'package:zurumi/data/crypt_model/deposit_details_model.dart';
import 'package:zurumi/data/crypt_model/earning_his_model.dart';
import 'package:zurumi/data/crypt_model/earning_list_model.dart';
import 'package:zurumi/data/crypt_model/history_model.dart';
import 'package:zurumi/data/crypt_model/individual_user_details.dart';
import 'package:zurumi/data/crypt_model/kyc_update_model.dart';
import 'package:zurumi/data/crypt_model/login_model.dart';
import 'package:zurumi/data/crypt_model/message_data.dart';
import 'package:zurumi/data/crypt_model/open_order_list_model.dart';
import 'package:zurumi/data/crypt_model/orange_pay_details.dart';
import 'package:zurumi/data/crypt_model/quote_details_model.dart';
import 'package:zurumi/data/crypt_model/referral_his_model.dart';
import 'package:zurumi/data/crypt_model/stack_his_list_model.dart';
import 'package:zurumi/data/crypt_model/stake_list_model.dart';
import 'package:zurumi/data/crypt_model/support_ticket_model.dart';
import 'package:zurumi/data/crypt_model/swap_balance_model.dart';
import 'package:zurumi/data/crypt_model/trade_all_pair_list_model.dart';
import 'package:zurumi/data/crypt_model/user_details_model.dart';
import 'package:zurumi/data/crypt_model/user_wallet_balance_model.dart';
import 'package:zurumi/data/crypt_model/withdraw_model.dart';
import 'package:http/http.dart' as http;

import 'package:zurumi/data/crypt_model/common_model.dart';
import 'package:zurumi/data/crypt_model/trade_pair_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crypt_model/buycrypto_balance_model.dart';
import 'crypt_model/buycrypto_history_model.dart';
import 'crypt_model/buycrypto_list_model.dart';
import 'crypt_model/country_details_model.dart';
import 'crypt_model/instant_buy_submit_model.dart';
import 'crypt_model/profile_update_model.dart';
import 'crypt_model/swap_history_model.dart';
import 'crypt_model/swap_list_model.dart';
import 'crypt_model/trade_his_model.dart';
import 'crypt_model/upload_image_model.dart';

class APIUtils {
  static const crypto_baseURL = 'https://zurumi.com/';

  static const String regURL = 'api/register';
  static const String loginURL = 'api/login';

  static const String KycVerifyUrl = 'api/update-kyc';
  static const String KycfrontIDUrl = 'api/front-upload';
  static const String KycbackIDUrl = 'api/back-upload';
  static const String emailSendOTPUrl = 'api/send-otp';
  static const String verifyOTPUrl = 'api/verify-otp';
  static const String logoutUrl = 'api/logout';
  static const String countryCodesUrl = 'api/country';
  static const String tradePairURL = 'api/market';

  static const String tradeAllPairURL = 'api/tradepairlist';
  static const String forgotPasswordURL = 'api/resetpassword';
  static const String forgotPasswordVerifyURL = 'api/changeresetpassword';
  static const String userDetailsURL = 'api/userdetails';
  static const String assetsListURL = 'api/assets';
  static const String userWalletBalanceURL = 'api/assets';
  static const String assetDetailsURL = 'api/asset-details';
  static const String withdrawAssetURL = 'api/withdraw-asset';
  static const String checkQuotesURL = 'api/check-quote';
  static const String postTradeURL = 'api/posttrade';
  static const String doneOrdersURL = 'v1/orders/done';
  static const String cancelOrdersURL = 'api/cancelorder';
  static const String getOpenOrdersURL = 'api/openorders';
  static const String stopLimitUrl = 'api/post-trade';
  static const String userInfoUrl = 'api/userdetails';
  static const String depositInfoUrl = 'api/assetsdetails';
  static const String getQuoteInfoUrl = 'api/check-quote';
  static const String cancelTradeUrl = 'api/cancelorder';
  static const String tranHisUrl = 'api/transaction-histroy';
  static const String fiatDepUrl = 'v1/user/wire-instructions';
  static const String bankListUrl = 'api/list-bank';
  static const String addBankUrl = 'api/add-bank';
  static const String delBankUrl = 'api/delete-bank';
  static const String coinWithUrl = 'api/withdrawotp';
  static const String createTicketUrl = 'api/create-ticket';
  static const String supportListUrl = 'api/ticket-view';
  static const String messageListUrl = 'api/get-message';
  static const String sendNewMessageUrl = 'api/send-message';
  static const String verifyOTP = 'api/withdraw';
  static const String resendOTP = 'api/withdraw-resend-otp';
  static const String changePassUrl = 'api/change-password';
  static const String deactiveAccUrl = 'api/deactivateaccount';
  static const String countryDetailsUrl = 'api/country';
  static const String profileImageUploadUrl = 'api/profile-upload';
  static const String profileUpdateUrl = 'api/userdetails-update';
  static const String stacklistUrl = 'api/stakelist';
  static const String earninglistUrl = 'api/earnings';
  static const String earningHisUrl = 'api/earninghistory';
  static const String stakeSubUrl = 'api/stacksubmit';
  static const String stakeHisUrl = 'api/mystake';
  static const String refHisUrl = 'api/referralinfo';
  static const String stakeWithUrl = 'api/stakewithdraw';
  static const String swapListUrl = 'api/swaplist';
  static const String swapBalListUrl = 'api/listcoin';
  static const String instantSubmit = 'api/instantsubmit';
  static const String swapSubmit = 'api/instantsubmit';
  static const String swapHistory = 'api/swap-history';
  static const String enableTFA = 'api/enable-twofa';
  static const String disableTFA = 'api/disable-twofa';
  static const String validateOTPEmail = 'api/validate-otp';
  static const String adminBank = 'api/adminBank';
  static const String fiatDeposit = 'api/fiatdeposit';
  static const String payService = 'api/payServiceOM';
  static const String tradeHistory = 'api/tradehistory';
  // static const String instantBuySubmit = 'api/instantsubmit';
  static const String buyCryptoList = 'api/buycrypto-list';
  static const String getBalanceBuyCrypto = 'api/getbalance';
  static const String buyCryptoHistory = 'api/buycrypto-history';
  static const String getEncryptCode = 'api/encryptCode';
//static const String payURL="https://api.sandbox.orange-sonatel.com";
  static const String payURL = "https://api.orange-sonatel.com/";

  static const String paymentURL = "/oauth/token";
  static const String publicKeyURL = "/api/account/v1/publicKeys";
  static const String getOTPURL = "/api/eWallet/v1/payments/otp";
  static const String doPaymentURL = "/api/eWallet/v1/payments/onestep";
  static const String updatePaymentURL = 'api/updatePayment';

  static const String deactivateAccURL = 'api/deactivateAccount';
  static const String bioLoginURL = 'api/biologin';
  Future<dynamic> getAuthToke() async {
    // var emailbodyData = {
    //   'client_secret': '005b9675-e9cb-4ce8-b654-1c9fd7d8f892',
    //   'client_id': '8bb0269c-9ea3-4221-838d-ff11da76d48c',
    //   'grant_type': 'client_credentials',
    // };
    var emailbodyData = {
      'client_secret': 'a972ba62-d1f6-481d-a948-76bd4fb80195',
      'client_id': '07f37a64-5914-4a0c-8743-1c580f59ae24',
      'grant_type': 'client_credentials',
    };

    final response =
        await http.post(Uri.parse(payURL + paymentURL), body: emailbodyData);

    print(response.body);
    return json.decode(response.body);
  }

  Future<dynamic> getPublicKey(String token) async {
    final response = await http.get(Uri.parse(payURL + publicKeyURL),
        headers: {"authorization": "Bearer " + token});

    return json.decode(response.body);
  }

  Future<dynamic> getUserOTP(
      String token, String id, String encryptedPinCod) async {
    var bodyData = {
      'idType': 'MSISDN',
      'id': id,
      'encryptedPinCode': encryptedPinCod,
    };

    final response = await http.post(Uri.parse(payURL + getOTPURL),
        body: json.encode(bodyData),
        headers: {
          "authorization": "Bearer " + token,
          "Accept": "application/json",
          "Content-Type": "application/json",
        });

    return json.decode(response.body);
  }

  Future<dynamic> doCryproPayment(String token, String id, String otp,
      String amount, String coin, String ref) async {
//521446--live
    //485421--testing

    final response = await http.post(Uri.parse(payURL + doPaymentURL),
        body: jsonEncode({
          "customer": {"idType": "MSISDN", "id": id, "otp": otp},
          "partner": {
            "idType": "CODE",
            "id": '521446',
          },
          "amount": {
            "value": "$amount",
            "unit": "$coin",
          },
          "reference": "$ref",
        }),
        headers: {
          "authorization": "Bearer " + token,
          "Accept": "application/json",
          "Content-Type": "application/json",
        });

    return json.decode(response.body);
  }

  Future<dynamic> getEncryptCodeAPI(
    String pcode,
    String key,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bodyData = {
      'pcode': pcode,
      'key': key,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + getEncryptCode),
        body: bodyData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return json.decode(response.body);
  }

  Future<CommonModel> doVerifyRegister(String first_name, String last_name,
      String email, String password, String con_password, String refer) async {
    var emailbodyData = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'password': password,
      'passwordconfirmation': con_password,
      'referralid': refer,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + regURL),
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<Map<String, dynamic>> doLoginEmail(String email, String pass,
      String ip, String device, String location) async {
    print('function called');

    var emailbodyData = {
      'email': email,
      'password': pass,
      'ipaddr': ip,
      'device': device,
      'device_id': device,
      'location': location,
    };
    try {
      final response =
          await ApiService.post(crypto_baseURL + loginURL, emailbodyData);
      if (response['success'] == true) {
        // Fluttertoast.showToast(msg: App);
        return response;
      } else {
        Fluttertoast.showToast(msg: response['message']);
        return response;
      }
    } catch (e) {
      print("===> ${e.toString()}");
      rethrow;
    }
  }

  Future<LoginDetailsModel> doLoginBiometric(String email, String ip,
      String device, String location, String device_id) async {
    var emailbodyData = {
      'email': email,
      'ipaddr': ip,
      'device': device,
      'location': location,
      'remember_me': "1",
      'device_id': device_id,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + bioLoginURL),
        body: emailbodyData);

    print(response.body);

    return LoginDetailsModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> forgotPassword(String email) async {
    var emailbodyData = {
      'email': email,
    };

    final response = await http.post(
        Uri.parse(crypto_baseURL + forgotPasswordURL),
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doVerifyOTP(
      String email, String otp, String password, String confPass) async {
    var emailbodyData = {
      'email': email,
      "otp": otp,
      "password": password,
      "confirmpassword": confPass
    };

    final response = await http.post(
        Uri.parse(crypto_baseURL + forgotPasswordVerifyURL),
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> postTrade(String pair, String side, String type,
      String quantity, String price) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var emailbodyData = {
      'pair': pair,
      "side": side,
      "type": type,
      "quantity": quantity,
      "price": price,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + postTradeURL),
        body: emailbodyData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<IndividualUserDetailsModel> userDetailsInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(crypto_baseURL + userDetailsURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return IndividualUserDetailsModel.fromJson(json.decode(response.body));
  }

  Future<AssetsListModel> assetsListInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(crypto_baseURL + assetsListURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return AssetsListModel.fromJson(json.decode(response.body));
  }

  Future<UserWalletBalanceModel> walletBalanceInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      final response = await http
          .post(Uri.parse(crypto_baseURL + userWalletBalanceURL), headers: {
        "authorization": "Bearer ${preferences.getString("token")}"
      });
      debugPrint(
          "API CALL ==> ${crypto_baseURL + userWalletBalanceURL} Response ${response.body}  ${response.statusCode}");

      return UserWalletBalanceModel.fromJson(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  Future<AssetDetailsModel> assetDetails(
      String assetname, BuildContext context) async {
    var bodyData = {'asset': assetname};

    final response = await ApiService.post(
      crypto_baseURL + assetDetailsURL,
      bodyData,
      context: context,
    );

    return AssetDetailsModel.fromJson(response);
  }

  Future<CommonModel> withdrawAssetDetails(
      String assetname, String address, String amount) async {
    var bodyData = {'asset': assetname, 'address': address, 'amount': amount};

    final response = await http
        .post(Uri.parse(crypto_baseURL + withdrawAssetURL), body: bodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CheckQuoteModel> checkQuotesDetails(
      String pair, String side, String quantity) async {
    var bodyData = {'pair': pair, 'side': side, 'quantity': quantity};

    final response = await http.post(Uri.parse(crypto_baseURL + checkQuotesURL),
        body: bodyData);

    return CheckQuoteModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          crypto_baseURL + logoutUrl,
        ),
        headers: {"authorization": preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CountryCodeModelDetails> countryCodeDetils() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
        crypto_baseURL + countryCodesUrl,
      ),
    );

    return CountryCodeModelDetails.fromJson(json.decode(response.body));
  }

  Future<TradeAllPairListModel> getTradePair() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http
        .post(Uri.parse(crypto_baseURL + tradeAllPairURL), headers: {
      "authorization": "Bearer " + preferences.getString("token").toString()
    });

    debugPrint(
        "API CALL ==> ${crypto_baseURL + tradePairURL} Response ${response.body}  ${response.statusCode}");

    return TradeAllPairListModel.fromJson(json.decode(response.body));
  }

  Future<CoinListModel> getCoinList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      final response = await ApiService.get(crypto_baseURL + tradePairURL);
      // debugPrint(
      //     "API CALL ==> ${crypto_baseURL + tradePairURL} Response ${response['success']}  ${response['body']}");
      if (response['success']) {
        return CoinListModel.fromJson(response);
      } else {
        return CoinListModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<KycDetailsUpdateModel> updateKYCDetails(
    String fname,
    String lastname,
    String dob,
    String country,
    String city,
    String idproof,
    String idnumber,
    String expdate,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bodyData = {
      'first_name': fname,
      'last_name': lastname,
      'dob': dob,
      'country': country,
      'city': city,
      'id_type': idproof,
      'id_number': idnumber,
      'id_exp': expdate,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + KycVerifyUrl),
        body: bodyData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return KycDetailsUpdateModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> updateKycFrontUpload(
    String id,
    String image,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
        "POST", Uri.parse(crypto_baseURL + KycfrontIDUrl));
    request.headers['authorization'] =
        "Bearer " + preferences.getString("token").toString();
    request.headers['Accept'] = 'application/json';

    var pic = await http.MultipartFile.fromPath("front_upload_id", image);

    request.files.add(pic);

    request.fields['kycid'] = id;

    http.Response response =
        await http.Response.fromStream(await request.send());

    return CommonModel.fromJson(json.decode(response.body.toString()));
  }

  Future<CommonModel> updateKycBackUpload(
    String id,
    String image,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var request =
        http.MultipartRequest("POST", Uri.parse(crypto_baseURL + KycbackIDUrl));
    request.headers['authorization'] =
        "Bearer " + preferences.getString("token").toString();
    request.headers['Accept'] = 'application/json';

    var pic = await http.MultipartFile.fromPath("back_upload_id", image);

    request.files.add(pic);
    request.fields['kycid'] = id;

    http.Response response =
        await http.Response.fromStream(await request.send());

    return CommonModel.fromJson(json.decode(response.body.toString()));
  }

  Future<CommonModel> emailSendOTP(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var tradeBody = {
      'type': email,
    };

    final response = await http.post(
        Uri.parse(crypto_baseURL + emailSendOTPUrl),
        body: tradeBody,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> updateEmailDetails(String email, String code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var emailData = {
      'type': email,
      "OTP": code,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + verifyOTPUrl),
        body: emailData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doLimitOrder(String pair, String side, String type,
      String quantity, String price, String quote_id, bool spotStop) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotStopData = {
      "pair": pair,
      "side": side,
      "type": type,
      "quantity": quantity,
      "price": price,
    };
    var tradeData = {
      "pair": pair,
      "side": side,
      "type": type,
      "quantity": quantity,
      "quote_id": quote_id,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + stopLimitUrl,
        ),
        body: spotStop ? spotStopData : tradeData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<UserDetailsModel> getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(crypto_baseURL + userInfoUrl),
        headers: {"authorization": "Bearer ${preferences.getString("token")}"});

    debugPrint("Here is response ${response.statusCode} ${response.body}");

    return UserDetailsModel.fromJson(json.decode(response.body));
  }

  Future<DepositDetailsModel> getDepositDetails(String coin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var tradeData = {
      "asset": coin.toUpperCase(),
    };

    print('${crypto_baseURL + depositInfoUrl}?${coin.toUpperCase()}');

    final response = await ApiService.post(
      "${crypto_baseURL + depositInfoUrl}?asset=${coin.toUpperCase()}",
      {},
      header: {
        "authorization": "Bearer ${preferences.getString("token")}",
        'Accept': "application/json"
      },
    );

    print(
        "${crypto_baseURL + depositInfoUrl} >>>>>>>>>>>>>>>>>>>>>${response}");
    return DepositDetailsModel.fromJson(response);
  }

  Future<QuoteDetailsModel> getQuoteDetails(
    String pair,
    String side,
    String quantity,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotStopData = {
      "pair": pair,
      "side": side,
      "quantity": quantity,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + getQuoteInfoUrl,
        ),
        body: spotStopData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return QuoteDetailsModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> cancelTradeOption(
    String order_id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotStopData = {
      "order_id": order_id,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + cancelTradeUrl,
        ),
        body: spotStopData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<TransHistoryListModel> getTransHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + tranHisUrl,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return TransHistoryListModel.fromJson(json.decode(response.body));
  }

  Future<BankListModel> getBankDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + bankListUrl,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return BankListModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> addbankDetails(
    String accountnumber,
    String bankname,
    String ifscnumber,
    String bankAccountType,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var InbankData = {
      "account_no": accountnumber,
      "bank_name": bankname,
      "swift_code": ifscnumber,
      "type": bankAccountType,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + addBankUrl,
        ),
        body: InbankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> removebankDetails(
    String bankid,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "bankid": bankid,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + delBankUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<WithdrawModel> coinWithdrawDetails(
      String asset, String address, String amount, String network) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "coin": asset,
      "address": address,
      "amount": amount,
      "network": network,
    };

    print(bankData);
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + coinWithUrl,
        ),
        body: bankData,
        headers: {
          "authorization":
              "Bearer " + preferences.getString("token").toString(),
          "accept": "application/json"
        });

    print(response.body);
    return WithdrawModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doCreateTicket(
    String subject,
    String message,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "subject": subject,
      "message": message,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + createTicketUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<SupportTicketListData> fetchSupportTicketList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + supportListUrl,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return SupportTicketListData.fromJson(json.decode(response.body));
  }

  Future<GetMessageData> fetchMessageList(
    String ticket_id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "ticket_id": ticket_id,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + messageListUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return GetMessageData.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doSendMessage(
    String ticket_id,
    String message,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "ticket_id": ticket_id,
      "message": message,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + sendNewMessageUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> confirmWithdrawOTP(String asset, String address,
      String amount, String OTP, String network) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "coin": asset,
      "address": address,
      "amount": amount,
      "OTP": OTP,
      "network": network,
    };

    print(bankData);
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + verifyOTP,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> resendWithdrawOTP(
    String atx_id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "atx_id": atx_id,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + resendOTP,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doChangePassword(
      String cpassword, String npassword, String confPass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var emailbodyData = {
      'current-password': cpassword,
      "new-password": npassword,
      "confirm-password": confPass,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + changePassUrl),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        },
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doDeactivateAccount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(crypto_baseURL + deactiveAccUrl),
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CountryDetailsModel> getCountry() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http
        .get(Uri.parse(crypto_baseURL + countryDetailsUrl), headers: {
      "authorization": "Bearer " + preferences.getString("token").toString()
    });

    return CountryDetailsModel.fromJson(json.decode(response.body));
  }

  Future<OpenOrdersModel> getOpenOrdersList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(crypto_baseURL + getOpenOrdersURL),
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );

    return OpenOrdersModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> cancelOrders(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var emailbodyData = {
      'id': id,
    };
    final response = await http.post(
      Uri.parse(crypto_baseURL + cancelTradeUrl),
      body: emailbodyData,
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<UploadImageModel> doUpload(
    String image,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
        "POST", Uri.parse(crypto_baseURL + profileImageUploadUrl));
    request.headers['authorization'] =
        "Bearer " + preferences.getString("token").toString();
    request.headers['Accept'] = 'application/json';

    var pic = await http.MultipartFile.fromPath("profileimg", image);

    request.files.add(pic);

    http.Response response =
        await http.Response.fromStream(await request.send());

    return UploadImageModel.fromJson(json.decode(response.body));
  }

  Future<ProfileUpdateModel> doUpdate(
    String fname,
    String lname,
    String number,
    String nation,
    String countryCode,
    String dob,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "first_name": fname,
      "last_name": lname,
      "phone_no": number,
      "nationality": nation,
      "phone_country": countryCode,
      "dob": dob,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + profileUpdateUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return ProfileUpdateModel.fromJson(json.decode(response.body));
  }

  Future<StakeListmodel> getStacklist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + stacklistUrl,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    print(response.body + "jeeva");
    return StakeListmodel.fromJson(json.decode(response.body));
  }

  Future<EarningListmodel> getEarninglist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + earninglistUrl,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return EarningListmodel.fromJson(json.decode(response.body));
  }

  Future<EarningHistoryListmodel> getEarningHistory(String type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "type": type,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + earningHisUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return EarningHistoryListmodel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doStaking(
      String depositcoin,
      String stackid,
      String no_of_coin,
      String duration_title,
      String stake_reward_type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "deposit_coin": depositcoin,
      "stackid": stackid,
      "no_of_coin": no_of_coin,
      "duration_title": duration_title,
      "stake_reward_type": stake_reward_type,
    };

    print(bankData);

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + stakeSubUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    print(response.body);
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<StackHistoryListmodel> getStackHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + stakeHisUrl,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return StackHistoryListmodel.fromJson(json.decode(response.body));
  }

  Future<ReferralHistoryListmodel> getreferralHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + refHisUrl,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return ReferralHistoryListmodel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doStakingWithdraw(String amount) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "amount": amount,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + stakeWithUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<SwapListModel> getSwapList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + swapListUrl,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return SwapListModel.fromJson(json.decode(response.body));
  }

  Future<SwapBalanceListModel> getSwapBalanceList(String key) async {

    print("here is key ${key}");

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "key": key,
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + swapBalListUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer ${preferences.getString("token")}"
        });

    print("Body ${response.statusCode} ${response.body} ");
    return SwapBalanceListModel.fromJson(json.decode(response.body));
  }

  Future<InstantSubmitModel> getSwapSubmit(String coinone, String cointwo,
      String coinoneamount, String cointwoamount) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    print('API CALLED');

    var bankData = {
      "coinone": cointwo,
      "cointwo": coinone,
      "coinoneamount": coinoneamount,
      "cointwoamount": cointwoamount,
    };
    final response = await ApiService.post(
        crypto_baseURL + swapSubmit, bankData,
        header: {"authorization": "Bearer ${preferences.getString("token")}"});

    return InstantSubmitModel.fromJson(response);
  }

  Future<SwapHistoryModel> getSwapHis() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + swapHistory,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return SwapHistoryModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> enableTwoFA(String twofa) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "twofa": twofa,
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + enableTFA,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> disableTwoFA(String twofa) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "twofa": twofa,
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + disableTFA,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> veifyEmailOTP(String OTP) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "OTP": OTP,
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + validateOTPEmail,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<AdminBankDetails> getAdminBank(String currency) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "currency": currency,
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + adminBank,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return AdminBankDetails.fromJson(json.decode(response.body));
  }

  Future<CommonModel> verifyFiatDeposit(
      String currency, String amt, String proof) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "currency": currency,
      "amount": amt,
      "proof": proof,
    };

    var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          crypto_baseURL + fiatDeposit,
        ));
    request.headers['authorization'] =
        "Bearer " + preferences.getString("token").toString();
    request.headers['Accept'] = 'application/json';

    var pic = await http.MultipartFile.fromPath("proof", proof);
    request.fields['currency'] = currency;
    request.fields['amount'] = amt;

    request.files.add(pic);

    http.Response response =
        await http.Response.fromStream(await request.send());

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<OrangePayDetails> verifyPayServices(
      String currency, String amt) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "currency": currency,
      "amount": amt,
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + payService,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    print(response.body);
    return OrangePayDetails.fromJson(json.decode(response.body));
  }

  Future<TradeHistoryModel> getTradeHis() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + tradeHistory,
        ),
        headers: {"authorization": "Bearer ${preferences.getString("token")}"});

    print(response.body);
    return TradeHistoryModel.fromJson(json.decode(response.body));
  }

  Future<BuyCryptoListModel> getBuyCryptoList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + buyCryptoList,
        ),
        headers: {"authorization": "Bearer ${preferences.getString("token")}"});

    print("New Response ${response.body}");
    return BuyCryptoListModel.fromJson(json.decode(response.body));
  }

  Future<GetBalanceModel> buyCryptoDetails(
    String Coinone,
    String Cointwo,
    String CoinoneAmt,
    String CointwoAmt,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "coinone": Cointwo,
      "cointwo": Coinone,
      "coinoneamount": CoinoneAmt,
      "cointwoamount": CointwoAmt,
      "type": "from",
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + getBalanceBuyCrypto,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return GetBalanceModel.fromJson(json.decode(response.body));
  }

  Future<BuyCryptoHistoryModel> getBuyCryptoHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + buyCryptoHistory,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    print(response.body);
    return BuyCryptoHistoryModel.fromJson(json.decode(response.body));
  }

  Future<InstantSubmitModel> getInstantSubmit(String coinone, String cointwo,
      String coinoneamount, String cointwoamount) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "coinone": coinone,
      "cointwo": cointwo,
      "coinoneamount": coinoneamount,
      "cointwoamount": cointwoamount,
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + instantSubmit,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return InstantSubmitModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> updatePayment(
    String TransacID,
    String Status,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "trans_id": TransacID,
      "status": Status,
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + updatePaymentURL,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> getDeactAccount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
          crypto_baseURL + deactivateAccURL,
        ),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    print(response.body);
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> updatePaymentDetails(
      String currency, String status) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "trans_id": currency,
      "status": status,
    };
    final response = await http.post(
        Uri.parse(
          crypto_baseURL + updatePaymentURL,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }
}
