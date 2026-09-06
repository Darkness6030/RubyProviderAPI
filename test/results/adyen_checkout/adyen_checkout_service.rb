# frozen_string_literal: true
# Сгенерировано из Adyen Checkout API. Перед production-использованием проверьте маппинг полей.

require "json"
require "base64"
require "bigdecimal"
require "uri"

class Provider
  class AdyenCheckoutService < BaseService
    BASE_URL = ENV.fetch("ADYEN_CHECKOUT_BASE_URL", "https://checkout-test.adyen.com/v72")
    STATUS_MAP = {"AuthenticationFinished" => "in_progress", "AuthenticationNotRequired" => "in_progress", "Authorised" => "approved", "Cancelled" => "rejected", "ChallengeShopper" => "in_progress", "Error" => "rejected", "IdentifyShopper" => "in_progress", "PartiallyAuthorised" => "in_progress", "Pending" => "in_progress", "PresentToShopper" => "in_progress", "Received" => "in_progress", "RedirectShopper" => "in_progress", "Refused" => "rejected", "Success" => "approved"}.freeze
    ERROR_MAP = {400 => "bad_request", 401 => "unauthorized", 403 => "forbidden", 422 => "unprocessable_entity", 500 => "internal_server_error"}.freeze
    WEBHOOK_EVENTS = [].freeze

    def create_request(operation, request_method = nil)
      return failure(:internal_server_error, "provider.create_operation_missing") unless true

      path = expand_path("/payments", operation)
      response = client.public_send("post",
        "#{BASE_URL}#{path}", **request_options(operation, request_method))
      handle_create_response(response)
    end

    def fetch_status(operation)
      return failure(:internal_server_error, "provider.status_operation_missing") unless false

      path = expand_path(nil, operation)
      response = client.public_send(nil, "#{BASE_URL}#{path}", **status_request_options(operation))
      handle_status_response(response)
    end

    def process_callback(payload)
      return failure(:internal_server_error, "provider.webhook_missing") unless false
      event = payload["event"] || payload[:event]
      return failure(:unprocessable_entity, "unknown_event") if event && !WEBHOOK_EVENTS.empty? && !WEBHOOK_EVENTS.include?(event.to_s)
      apply_status(payload)
    end

    def check_conditions(operation, request_method)
      base_result = super
      return base_result if base_result.respond_to?(:failed?) && base_result.failed?
      payload = build_payload(operation, request_method)
      return failure(:unprocessable_entity, "missing_amount") if value_missing?(read_path(payload, "amount"))
      return failure(:unprocessable_entity, "missing_amount_currency") if value_missing?(read_path(payload, "amount.currency"))
      return failure(:unprocessable_entity, "missing_amount_value") if value_missing?(read_path(payload, "amount.value"))
      return failure(:unprocessable_entity, "missing_merchantAccount") if value_missing?(read_path(payload, "merchantAccount"))
      return failure(:unprocessable_entity, "missing_paymentMethod") if value_missing?(read_path(payload, "paymentMethod"))
      return failure(:unprocessable_entity, "missing_reference") if value_missing?(read_path(payload, "reference"))
      return failure(:unprocessable_entity, "missing_returnUrl") if value_missing?(read_path(payload, "returnUrl"))
      # Подтверждённых условно обязательных полей нет.
      constraint_error = constraint_violation(payload)
      return failure(:unprocessable_entity, constraint_error) if constraint_error
      success
    end

    private

    def build_payload(operation, request_method = nil)
      { "accountInfo" => { "accountAgeIndicator" => nil, "accountChangeDate" => nil, "accountChangeIndicator" => nil, "accountCreationDate" => nil, "accountType" => nil, "addCardAttemptsDay" => nil, "deliveryAddressUsageDate" => nil, "deliveryAddressUsageIndicator" => nil, "homePhone" => nil, "mobilePhone" => nil, "passwordChangeDate" => nil, "passwordChangeIndicator" => nil, "pastTransactionsDay" => nil, "pastTransactionsYear" => nil, "paymentAccountAge" => nil, "paymentAccountIndicator" => nil, "purchasesLast6Months" => nil, "suspiciousActivity" => nil, "workPhone" => nil }.compact, "additionalAmount" => { "currency" => nil, "value" => nil }.compact, "additionalData" => nil, "amount" => { "currency" => nil, "value" => nil }.compact, "applicationInfo" => { "adyenLibrary" => { "name" => nil, "version" => nil }.compact, "adyenPaymentSource" => { "name" => nil, "version" => nil }.compact, "externalPlatform" => { "integrator" => nil, "name" => nil, "version" => nil }.compact, "merchantApplication" => { "name" => nil, "version" => nil }.compact, "merchantDevice" => { "os" => nil, "osVersion" => nil, "reference" => nil }.compact, "shopperInteractionDevice" => { "locale" => nil, "os" => nil, "osVersion" => nil }.compact }.compact, "authenticationData" => { "attemptAuthentication" => nil, "authenticationOnly" => "false", "threeDSRequestData" => { "challengeWindowSize" => nil, "dataOnly" => nil, "nativeThreeDS" => nil, "threeDSVersion" => nil }.compact }.compact, "bankAccount" => { "accountType" => nil, "bankAccountNumber" => nil, "bankCity" => nil, "bankLocationId" => nil, "bankName" => nil, "bic" => nil, "countryCode" => nil, "iban" => nil, "ownerName" => nil, "taxId" => nil }.compact, "billingAddress" => { "city" => nil, "country" => nil, "houseNumberOrName" => nil, "postalCode" => nil, "stateOrProvince" => nil, "street" => nil }.compact, "browserInfo" => { "acceptHeader" => nil, "colorDepth" => nil, "javaEnabled" => nil, "javaScriptEnabled" => "true", "language" => nil, "screenHeight" => nil, "screenWidth" => nil, "timeZoneOffset" => nil, "userAgent" => nil }.compact, "captureDelayHours" => nil, "channel" => nil, "checkoutAttemptId" => nil, "company" => { "homepage" => nil, "name" => nil, "registrationNumber" => nil, "registryLocation" => nil, "taxId" => nil, "type" => nil }.compact, "countryCode" => nil, "dateOfBirth" => nil, "dccQuote" => { "account" => nil, "accountType" => nil, "baseAmount" => { "currency" => nil, "value" => nil }.compact, "basePoints" => nil, "buy" => { "currency" => nil, "value" => nil }.compact, "interbank" => { "currency" => nil, "value" => nil }.compact, "reference" => nil, "sell" => { "currency" => nil, "value" => nil }.compact, "signature" => nil, "source" => nil, "type" => nil, "validTill" => nil }.compact, "deliverAt" => nil, "deliveryAddress" => { "city" => nil, "country" => nil, "firstName" => nil, "houseNumberOrName" => nil, "lastName" => nil, "postalCode" => nil, "stateOrProvince" => nil, "street" => nil }.compact, "deliveryDate" => nil, "deviceFingerprint" => nil, "enableOneClick" => nil, "enablePayOut" => nil, "enableRecurring" => nil, "enhancedSchemeData" => { "airline" => { "agency" => { "invoiceNumber" => nil, "planName" => nil }.compact, "boardingFee" => nil, "code" => nil, "computerizedReservationSystem" => nil, "customerReferenceNumber" => nil, "designatorCode" => nil, "documentType" => nil, "flightDate" => nil, "legs" => nil, "passengerName" => nil, "passengers" => nil, "ticket" => { "issueAddress" => nil, "issueDate" => nil, "number" => nil }.compact, "travelAgency" => { "code" => nil, "name" => nil }.compact }.compact, "carRental" => { "customerServicePhoneNumber" => nil, "noShow" => nil, "pickupInfo" => { "city" => nil, "countryCode" => nil, "date" => nil, "stateOrProvince" => nil }.compact, "rateType" => nil, "rentalAgreementNumber" => nil, "rentalClassId" => nil, "rentalDays" => nil, "rentalRate" => nil, "rentalSurcharges" => { "fuel" => nil, "insurance" => nil, "oneWayDropOff" => nil }.compact, "renterName" => nil, "returnInfo" => { "city" => nil, "countryCode" => nil, "date" => nil, "locationId" => nil, "stateOrProvince" => nil }.compact, "taxExempt" => nil }.compact, "healthcare" => { "dentalValue" => nil, "otherMedicalValue" => nil, "prescriptionValue" => nil, "totalHealthcareValue" => nil, "visionPrescriptionValue" => nil }.compact, "levelTwoThree" => { "customerReferenceNumber" => nil, "destination" => { "countryCode" => nil, "postalCode" => nil, "stateOrProvince" => nil }.compact, "dutyAmount" => nil, "freightAmount" => nil, "itemDetailLines" => nil, "orderDate" => nil, "shipFromPostalCode" => nil, "totalTaxAmount" => nil }.compact, "lodging" => { "checkInDate" => nil, "checkOutDate" => nil, "customerServicePhoneNumber" => nil, "fireSafetyCompliance" => nil, "folio" => { "cashAdvances" => nil, "number" => nil }.compact, "foodBeverageCharges" => nil, "lodgingChargeType" => nil, "noShow" => nil, "prepaidExpenses" => nil, "propertyPhoneNumber" => nil, "renterName" => nil, "rooms" => nil, "totalRoomTax" => nil, "totalTax" => nil }.compact, "temporaryServices" => { "employeeName" => nil, "endDate" => nil, "hourRate" => nil, "hoursWorked" => nil, "jobDescription" => nil, "serviceRequestor" => nil, "startDate" => nil }.compact }.compact, "entityType" => nil, "fraudOffset" => nil, "fundOrigin" => { "billingAddress" => { "city" => nil, "country" => nil, "houseNumberOrName" => nil, "postalCode" => nil, "stateOrProvince" => nil, "street" => nil }.compact, "shopperEmail" => nil, "shopperName" => { "firstName" => nil, "lastName" => nil }.compact, "telephoneNumber" => nil, "walletIdentifier" => nil }.compact, "fundRecipient" => { "IBAN" => nil, "billingAddress" => { "city" => nil, "country" => nil, "houseNumberOrName" => nil, "postalCode" => nil, "stateOrProvince" => nil, "street" => nil }.compact, "paymentMethod" => { "billingSequenceNumber" => nil, "brand" => nil, "checkoutAttemptId" => nil, "cupsecureplus.smscode" => nil, "cvc" => nil, "encryptedCard" => nil, "encryptedCardNumber" => nil, "encryptedExpiryMonth" => nil, "encryptedExpiryYear" => nil, "encryptedPassword" => nil, "encryptedSecurityCode" => nil, "expiryMonth" => nil, "expiryYear" => nil, "fastlaneData" => nil, "fundingSource" => nil, "holderName" => nil, "networkPaymentReference" => nil, "number" => nil, "recurringDetailReference" => nil, "sdkData" => nil, "shopperNotificationReference" => nil, "srcCorrelationId" => nil, "srcDigitalCardId" => nil, "srcScheme" => nil, "srcTokenReference" => nil, "storedPaymentMethodId" => nil, "threeDS2SdkVersion" => nil, "type" => "scheme" }.compact, "shopperEmail" => nil, "shopperName" => { "firstName" => nil, "lastName" => nil }.compact, "shopperReference" => nil, "storedPaymentMethodId" => nil, "subMerchant" => { "city" => nil, "country" => nil, "mcc" => nil, "name" => nil, "taxId" => nil }.compact, "telephoneNumber" => nil, "walletIdentifier" => nil, "walletOwnerTaxId" => nil, "walletPurpose" => nil }.compact, "industryUsage" => nil, "installments" => { "extra" => nil, "plan" => nil, "value" => nil }.compact, "lineItems" => nil, "localizedShopperStatement" => nil, "mandate" => { "amount" => nil, "amountRule" => nil, "billingAttemptsRule" => nil, "billingDay" => nil, "count" => nil, "endsAt" => nil, "frequency" => nil, "remarks" => nil, "startsAt" => nil }.compact, "mcc" => nil, "merchantAccount" => nil, "merchantOrderReference" => nil, "merchantRiskIndicator" => { "addressMatch" => nil, "deliveryAddressIndicator" => nil, "deliveryEmail" => nil, "deliveryEmailAddress" => nil, "deliveryTimeframe" => nil, "giftCardAmount" => { "currency" => nil, "value" => nil }.compact, "giftCardCount" => nil, "giftCardCurr" => nil, "preOrderDate" => nil, "preOrderPurchase" => nil, "preOrderPurchaseInd" => nil, "reorderItems" => nil, "reorderItemsInd" => nil, "shipIndicator" => nil }.compact, "metadata" => nil, "mpiData" => { "authenticationResponse" => nil, "cavv" => nil, "cavvAlgorithm" => nil, "challengeCancel" => nil, "directoryResponse" => nil, "dsTransID" => nil, "eci" => nil, "riskScore" => nil, "threeDSVersion" => nil, "tokenAuthenticationVerificationValue" => nil, "transStatusReason" => nil, "xid" => nil }.compact, "order" => { "orderData" => nil, "pspReference" => nil }.compact, "orderReference" => nil, "origin" => nil, "paymentMethod" => nil, "paymentValidations" => { "name" => { "status" => nil }.compact }.compact, "platformChargebackLogic" => { "behavior" => nil, "costAllocationAccount" => nil, "targetAccount" => nil }.compact, "recurringExpiry" => nil, "recurringFrequency" => nil, "recurringProcessingModel" => nil, "redirectFromIssuerMethod" => nil, "redirectToIssuerMethod" => nil, "reference" => nil, "returnUrl" => nil, "riskData" => { "clientData" => nil, "customFields" => nil, "fraudOffset" => nil, "profileReference" => nil }.compact, "sessionValidity" => nil, "shopperConversionId" => nil, "shopperEmail" => nil, "shopperIP" => nil, "shopperInteraction" => nil, "shopperLocale" => nil, "shopperName" => { "firstName" => nil, "lastName" => nil }.compact, "shopperReference" => nil, "shopperStatement" => nil, "shopperTaxInfo" => { "taxCountryCode" => nil, "taxIdentificationNumber" => nil }.compact, "socialSecurityNumber" => nil, "splits" => nil, "store" => nil, "storePaymentMethod" => nil, "subMerchants" => nil, "surcharge" => { "value" => nil }.compact, "telephoneNumber" => nil, "thirdPartyTokenRedundancyInfo" => { "requestParameters" => nil, "requestTemplateCode" => nil }.compact, "threeDS2RequestData" => { "acctInfo" => { "chAccAgeInd" => nil, "chAccChange" => nil, "chAccChangeInd" => nil, "chAccPwChange" => nil, "chAccPwChangeInd" => nil, "chAccString" => nil, "nbPurchaseAccount" => nil, "paymentAccAge" => nil, "paymentAccInd" => nil, "provisionAttemptsDay" => nil, "shipAddressUsage" => nil, "shipAddressUsageInd" => nil, "shipNameIndicator" => nil, "suspiciousAccActivity" => nil, "txnActivityDay" => nil, "txnActivityYear" => nil }.compact, "acctType" => nil, "acquirerBIN" => nil, "acquirerMerchantID" => nil, "addrMatch" => nil, "authenticationOnly" => "false", "challengeIndicator" => nil, "deviceRenderOptions" => { "sdkInterface" => "both", "sdkUiType" => nil }.compact, "homePhone" => { "cc" => nil, "subscriber" => nil }.compact, "mcc" => nil, "merchantName" => nil, "messageVersion" => nil, "mobilePhone" => { "cc" => nil, "subscriber" => nil }.compact, "notificationURL" => nil, "payTokenInd" => nil, "paymentAuthenticationUseCase" => nil, "purchaseInstalData" => nil, "recurringExpiry" => nil, "recurringFrequency" => nil, "sdkAppID" => nil, "sdkEphemPubKey" => { "crv" => nil, "kty" => nil, "x" => nil, "y" => nil }.compact, "sdkMaxTimeout" => "60", "sdkReferenceNumber" => nil, "sdkTransID" => nil, "threeDSCompInd" => nil, "threeDSRequestorAuthenticationInd" => nil, "threeDSRequestorAuthenticationInfo" => { "threeDSReqAuthData" => nil, "threeDSReqAuthMethod" => nil, "threeDSReqAuthTimestamp" => nil }.compact, "threeDSRequestorChallengeInd" => nil, "threeDSRequestorID" => nil, "threeDSRequestorName" => nil, "threeDSRequestorPriorAuthenticationInfo" => { "threeDSReqPriorAuthData" => nil, "threeDSReqPriorAuthMethod" => nil, "threeDSReqPriorAuthTimestamp" => nil, "threeDSReqPriorRef" => nil }.compact, "threeDSRequestorURL" => nil, "transType" => nil, "transactionType" => nil, "whiteListStatus" => nil, "workPhone" => { "cc" => nil, "subscriber" => nil }.compact }.compact, "threeDSAuthenticationOnly" => "false", "trustedShopper" => nil }.compact
    end

    def constraint_violation(payload)
      value = read_path(payload, "accountInfo.accountAgeIndicator"); return "account_info_account_age_indicator_not_allowed" if !value_missing?(value) && !["notApplicable", "thisTransaction", "lessThan30Days", "from30To60Days", "moreThan60Days"].include?(value)
      value = read_path(payload, "accountInfo.accountChangeIndicator"); return "account_info_account_change_indicator_not_allowed" if !value_missing?(value) && !["thisTransaction", "lessThan30Days", "from30To60Days", "moreThan60Days"].include?(value)
      value = read_path(payload, "accountInfo.accountType"); return "account_info_account_type_not_allowed" if !value_missing?(value) && !["notApplicable", "credit", "debit"].include?(value)
      value = read_path(payload, "accountInfo.deliveryAddressUsageIndicator"); return "account_info_delivery_address_usage_indicator_not_allowed" if !value_missing?(value) && !["thisTransaction", "lessThan30Days", "from30To60Days", "moreThan60Days"].include?(value)
      value = read_path(payload, "accountInfo.passwordChangeIndicator"); return "account_info_password_change_indicator_not_allowed" if !value_missing?(value) && !["notApplicable", "thisTransaction", "lessThan30Days", "from30To60Days", "moreThan60Days"].include?(value)
      value = read_path(payload, "accountInfo.paymentAccountIndicator"); return "account_info_payment_account_indicator_not_allowed" if !value_missing?(value) && !["notApplicable", "thisTransaction", "lessThan30Days", "from30To60Days", "moreThan60Days"].include?(value)
      value = read_path(payload, "additionalAmount.currency"); return "additional_amount_currency_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "additionalAmount.currency"); return "additional_amount_currency_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "amount.currency"); return "amount_currency_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "amount.currency"); return "amount_currency_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "authenticationData.attemptAuthentication"); return "authentication_data_attempt_authentication_not_allowed" if !value_missing?(value) && !["always", "never"].include?(value)
      value = read_path(payload, "authenticationData.threeDSRequestData.challengeWindowSize"); return "authentication_data_three_dsrequest_data_challenge_window_size_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04", "05"].include?(value)
      value = read_path(payload, "authenticationData.threeDSRequestData.dataOnly"); return "authentication_data_three_dsrequest_data_data_only_not_allowed" if !value_missing?(value) && !["false", "true"].include?(value)
      value = read_path(payload, "authenticationData.threeDSRequestData.nativeThreeDS"); return "authentication_data_three_dsrequest_data_native_three_ds_not_allowed" if !value_missing?(value) && !["preferred", "disabled"].include?(value)
      value = read_path(payload, "authenticationData.threeDSRequestData.threeDSVersion"); return "authentication_data_three_dsrequest_data_three_dsversion_not_allowed" if !value_missing?(value) && !["2.1.0", "2.2.0"].include?(value)
      value = read_path(payload, "bankAccount.accountType"); return "bank_account_account_type_not_allowed" if !value_missing?(value) && !["balance", "checking", "deposit", "general", "other", "payment", "savings"].include?(value)
      value = read_path(payload, "billingAddress.city"); return "billing_address_city_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "billingAddress.houseNumberOrName"); return "billing_address_house_number_or_name_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "billingAddress.postalCode"); return "billing_address_postal_code_too_long" if !value_missing?(value) && value.to_s.length > 10
      value = read_path(payload, "billingAddress.stateOrProvince"); return "billing_address_state_or_province_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "billingAddress.street"); return "billing_address_street_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "channel"); return "channel_not_allowed" if !value_missing?(value) && !["iOS", "Android", "Web"].include?(value)
      value = read_path(payload, "checkoutAttemptId"); return "checkout_attempt_id_too_long" if !value_missing?(value) && value.to_s.length > 256
      value = read_path(payload, "countryCode"); return "country_code_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "dccQuote.baseAmount.currency"); return "dcc_quote_base_amount_currency_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "dccQuote.baseAmount.currency"); return "dcc_quote_base_amount_currency_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "dccQuote.buy.currency"); return "dcc_quote_buy_currency_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "dccQuote.buy.currency"); return "dcc_quote_buy_currency_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "dccQuote.interbank.currency"); return "dcc_quote_interbank_currency_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "dccQuote.interbank.currency"); return "dcc_quote_interbank_currency_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "dccQuote.sell.currency"); return "dcc_quote_sell_currency_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "dccQuote.sell.currency"); return "dcc_quote_sell_currency_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "deliveryAddress.city"); return "delivery_address_city_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "deliveryAddress.houseNumberOrName"); return "delivery_address_house_number_or_name_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "deliveryAddress.postalCode"); return "delivery_address_postal_code_too_long" if !value_missing?(value) && value.to_s.length > 10
      value = read_path(payload, "deliveryAddress.stateOrProvince"); return "delivery_address_state_or_province_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "deliveryAddress.street"); return "delivery_address_street_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "deviceFingerprint"); return "device_fingerprint_too_long" if !value_missing?(value) && value.to_s.length > 5000
      value = read_path(payload, "enhancedSchemeData.carRental.rateType"); return "enhanced_scheme_data_car_rental_rate_type_not_allowed" if !value_missing?(value) && !["daily", "weekly"].include?(value)
      value = read_path(payload, "enhancedSchemeData.lodging.lodgingChargeType"); return "enhanced_scheme_data_lodging_lodging_charge_type_not_allowed" if !value_missing?(value) && !["advanceDeposit", "noShow", "stay"].include?(value)
      value = read_path(payload, "entityType"); return "entity_type_not_allowed" if !value_missing?(value) && !["NaturalPerson", "CompanyName"].include?(value)
      value = read_path(payload, "fundOrigin.billingAddress.city"); return "fund_origin_billing_address_city_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "fundOrigin.billingAddress.houseNumberOrName"); return "fund_origin_billing_address_house_number_or_name_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "fundOrigin.billingAddress.street"); return "fund_origin_billing_address_street_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "fundOrigin.shopperName.firstName"); return "fund_origin_shopper_name_first_name_too_long" if !value_missing?(value) && value.to_s.length > 80
      value = read_path(payload, "fundOrigin.shopperName.lastName"); return "fund_origin_shopper_name_last_name_too_long" if !value_missing?(value) && value.to_s.length > 80
      value = read_path(payload, "fundRecipient.billingAddress.city"); return "fund_recipient_billing_address_city_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "fundRecipient.billingAddress.houseNumberOrName"); return "fund_recipient_billing_address_house_number_or_name_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "fundRecipient.billingAddress.street"); return "fund_recipient_billing_address_street_too_long" if !value_missing?(value) && value.to_s.length > 3000
      value = read_path(payload, "fundRecipient.paymentMethod.encryptedCard"); return "fund_recipient_payment_method_encrypted_card_too_long" if !value_missing?(value) && value.to_s.length > 40000
      value = read_path(payload, "fundRecipient.paymentMethod.encryptedCardNumber"); return "fund_recipient_payment_method_encrypted_card_number_too_long" if !value_missing?(value) && value.to_s.length > 15000
      value = read_path(payload, "fundRecipient.paymentMethod.encryptedExpiryMonth"); return "fund_recipient_payment_method_encrypted_expiry_month_too_long" if !value_missing?(value) && value.to_s.length > 15000
      value = read_path(payload, "fundRecipient.paymentMethod.encryptedExpiryYear"); return "fund_recipient_payment_method_encrypted_expiry_year_too_long" if !value_missing?(value) && value.to_s.length > 15000
      value = read_path(payload, "fundRecipient.paymentMethod.encryptedPassword"); return "fund_recipient_payment_method_encrypted_password_too_long" if !value_missing?(value) && value.to_s.length > 15000
      value = read_path(payload, "fundRecipient.paymentMethod.encryptedSecurityCode"); return "fund_recipient_payment_method_encrypted_security_code_too_long" if !value_missing?(value) && value.to_s.length > 15000
      value = read_path(payload, "fundRecipient.paymentMethod.fundingSource"); return "fund_recipient_payment_method_funding_source_not_allowed" if !value_missing?(value) && !["credit", "debit", "prepaid"].include?(value)
      value = read_path(payload, "fundRecipient.paymentMethod.holderName"); return "fund_recipient_payment_method_holder_name_too_long" if !value_missing?(value) && value.to_s.length > 15000
      value = read_path(payload, "fundRecipient.paymentMethod.sdkData"); return "fund_recipient_payment_method_sdk_data_too_long" if !value_missing?(value) && value.to_s.length > 50000
      value = read_path(payload, "fundRecipient.paymentMethod.storedPaymentMethodId"); return "fund_recipient_payment_method_stored_payment_method_id_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "fundRecipient.paymentMethod.threeDS2SdkVersion"); return "fund_recipient_payment_method_three_ds2_sdk_version_too_long" if !value_missing?(value) && value.to_s.length > 12
      value = read_path(payload, "fundRecipient.paymentMethod.type"); return "fund_recipient_payment_method_type_not_allowed" if !value_missing?(value) && !["bcmc", "scheme", "networkToken", "giftcard", "card", "clicktopay"].include?(value)
      value = read_path(payload, "fundRecipient.shopperName.firstName"); return "fund_recipient_shopper_name_first_name_too_long" if !value_missing?(value) && value.to_s.length > 80
      value = read_path(payload, "fundRecipient.shopperName.lastName"); return "fund_recipient_shopper_name_last_name_too_long" if !value_missing?(value) && value.to_s.length > 80
      value = read_path(payload, "fundRecipient.shopperReference"); return "fund_recipient_shopper_reference_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "fundRecipient.shopperReference"); return "fund_recipient_shopper_reference_too_long" if !value_missing?(value) && value.to_s.length > 256
      value = read_path(payload, "fundRecipient.storedPaymentMethodId"); return "fund_recipient_stored_payment_method_id_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "fundRecipient.walletPurpose"); return "fund_recipient_wallet_purpose_not_allowed" if !value_missing?(value) && !["identifiedBoleto", "transferDifferentWallet", "transferOwnWallet", "transferSameWallet", "unidentifiedBoleto"].include?(value)
      value = read_path(payload, "industryUsage"); return "industry_usage_not_allowed" if !value_missing?(value) && !["delayedCharge", "installment", "noShow"].include?(value)
      value = read_path(payload, "installments.plan"); return "installments_plan_not_allowed" if !value_missing?(value) && !["bonus", "buynow_paylater", "interes_refund_prctg", "interest_bonus", "nointeres_refund_prctg", "nointerest_bonus", "refund_prctg", "regular", "revolving", "with_interest"].include?(value)
      value = read_path(payload, "mandate.amountRule"); return "mandate_amount_rule_not_allowed" if !value_missing?(value) && !["max", "exact"].include?(value)
      value = read_path(payload, "mandate.billingAttemptsRule"); return "mandate_billing_attempts_rule_not_allowed" if !value_missing?(value) && !["on", "before", "after"].include?(value)
      value = read_path(payload, "mandate.frequency"); return "mandate_frequency_not_allowed" if !value_missing?(value) && !["adhoc", "daily", "weekly", "biWeekly", "monthly", "quarterly", "halfYearly", "yearly"].include?(value)
      value = read_path(payload, "merchantOrderReference"); return "merchant_order_reference_too_long" if !value_missing?(value) && value.to_s.length > 1000
      value = read_path(payload, "merchantRiskIndicator.deliveryAddressIndicator"); return "merchant_risk_indicator_delivery_address_indicator_not_allowed" if !value_missing?(value) && !["shipToBillingAddress", "shipToVerifiedAddress", "shipToNewAddress", "shipToStore", "digitalGoods", "goodsNotShipped", "other"].include?(value)
      value = read_path(payload, "merchantRiskIndicator.deliveryEmailAddress"); return "merchant_risk_indicator_delivery_email_address_too_long" if !value_missing?(value) && value.to_s.length > 254
      value = read_path(payload, "merchantRiskIndicator.deliveryTimeframe"); return "merchant_risk_indicator_delivery_timeframe_not_allowed" if !value_missing?(value) && !["electronicDelivery", "sameDayShipping", "overnightShipping", "twoOrMoreDaysShipping"].include?(value)
      value = read_path(payload, "merchantRiskIndicator.giftCardAmount.currency"); return "merchant_risk_indicator_gift_card_amount_currency_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "merchantRiskIndicator.giftCardAmount.currency"); return "merchant_risk_indicator_gift_card_amount_currency_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "mpiData.authenticationResponse"); return "mpi_data_authentication_response_not_allowed" if !value_missing?(value) && !["Y", "N", "U", "A"].include?(value)
      value = read_path(payload, "mpiData.challengeCancel"); return "mpi_data_challenge_cancel_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04", "05", "06", "07"].include?(value)
      value = read_path(payload, "mpiData.directoryResponse"); return "mpi_data_directory_response_not_allowed" if !value_missing?(value) && !["A", "C", "D", "I", "N", "R", "U", "Y"].include?(value)
      value = read_path(payload, "order.orderData"); return "order_order_data_too_long" if !value_missing?(value) && value.to_s.length > 5000
      value = read_path(payload, "origin"); return "origin_too_long" if !value_missing?(value) && value.to_s.length > 80
      value = read_path(payload, "platformChargebackLogic.behavior"); return "platform_chargeback_logic_behavior_not_allowed" if !value_missing?(value) && !["deductFromOneBalanceAccount", "deductAccordingToSplitRatio", "deductFromLiableAccount"].include?(value)
      value = read_path(payload, "recurringProcessingModel"); return "recurring_processing_model_not_allowed" if !value_missing?(value) && !["CardOnFile", "Subscription", "UnscheduledCardOnFile"].include?(value)
      value = read_path(payload, "reference"); return "reference_too_long" if !value_missing?(value) && value.to_s.length > 80
      value = read_path(payload, "returnUrl"); return "return_url_too_long" if !value_missing?(value) && value.to_s.length > 1024
      value = read_path(payload, "riskData.clientData"); return "risk_data_client_data_too_long" if !value_missing?(value) && value.to_s.length > 5000
      value = read_path(payload, "shopperConversionId"); return "shopper_conversion_id_too_long" if !value_missing?(value) && value.to_s.length > 256
      value = read_path(payload, "shopperEmail"); return "shopper_email_too_long" if !value_missing?(value) && value.to_s.length > 256
      value = read_path(payload, "shopperIP"); return "shopper_ip_too_long" if !value_missing?(value) && value.to_s.length > 50
      value = read_path(payload, "shopperInteraction"); return "shopper_interaction_not_allowed" if !value_missing?(value) && !["Ecommerce", "ContAuth", "Moto", "POS"].include?(value)
      value = read_path(payload, "shopperName.firstName"); return "shopper_name_first_name_too_long" if !value_missing?(value) && value.to_s.length > 80
      value = read_path(payload, "shopperName.lastName"); return "shopper_name_last_name_too_long" if !value_missing?(value) && value.to_s.length > 80
      value = read_path(payload, "shopperReference"); return "shopper_reference_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "shopperReference"); return "shopper_reference_too_long" if !value_missing?(value) && value.to_s.length > 256
      value = read_path(payload, "shopperStatement"); return "shopper_statement_too_long" if !value_missing?(value) && value.to_s.length > 10000
      value = read_path(payload, "shopperTaxInfo.taxCountryCode"); return "shopper_tax_info_tax_country_code_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "shopperTaxInfo.taxIdentificationNumber"); return "shopper_tax_info_tax_identification_number_too_long" if !value_missing?(value) && value.to_s.length > 20
      value = read_path(payload, "socialSecurityNumber"); return "social_security_number_too_long" if !value_missing?(value) && value.to_s.length > 50
      value = read_path(payload, "store"); return "store_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "store"); return "store_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "telephoneNumber"); return "telephone_number_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "threeDS2RequestData.acctInfo.chAccAgeInd"); return "three_ds2_request_data_acct_info_ch_acc_age_ind_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04", "05"].include?(value)
      value = read_path(payload, "threeDS2RequestData.acctInfo.chAccAgeInd"); return "three_ds2_request_data_acct_info_ch_acc_age_ind_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.chAccAgeInd"); return "three_ds2_request_data_acct_info_ch_acc_age_ind_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.chAccChangeInd"); return "three_ds2_request_data_acct_info_ch_acc_change_ind_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04"].include?(value)
      value = read_path(payload, "threeDS2RequestData.acctInfo.chAccChangeInd"); return "three_ds2_request_data_acct_info_ch_acc_change_ind_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.chAccChangeInd"); return "three_ds2_request_data_acct_info_ch_acc_change_ind_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.chAccPwChangeInd"); return "three_ds2_request_data_acct_info_ch_acc_pw_change_ind_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04", "05"].include?(value)
      value = read_path(payload, "threeDS2RequestData.acctInfo.chAccPwChangeInd"); return "three_ds2_request_data_acct_info_ch_acc_pw_change_ind_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.chAccPwChangeInd"); return "three_ds2_request_data_acct_info_ch_acc_pw_change_ind_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.paymentAccInd"); return "three_ds2_request_data_acct_info_payment_acc_ind_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04", "05"].include?(value)
      value = read_path(payload, "threeDS2RequestData.acctInfo.paymentAccInd"); return "three_ds2_request_data_acct_info_payment_acc_ind_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.paymentAccInd"); return "three_ds2_request_data_acct_info_payment_acc_ind_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.shipAddressUsageInd"); return "three_ds2_request_data_acct_info_ship_address_usage_ind_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04"].include?(value)
      value = read_path(payload, "threeDS2RequestData.acctInfo.shipAddressUsageInd"); return "three_ds2_request_data_acct_info_ship_address_usage_ind_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.shipAddressUsageInd"); return "three_ds2_request_data_acct_info_ship_address_usage_ind_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.shipNameIndicator"); return "three_ds2_request_data_acct_info_ship_name_indicator_not_allowed" if !value_missing?(value) && !["01", "02"].include?(value)
      value = read_path(payload, "threeDS2RequestData.acctInfo.shipNameIndicator"); return "three_ds2_request_data_acct_info_ship_name_indicator_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.shipNameIndicator"); return "three_ds2_request_data_acct_info_ship_name_indicator_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.suspiciousAccActivity"); return "three_ds2_request_data_acct_info_suspicious_acc_activity_not_allowed" if !value_missing?(value) && !["01", "02"].include?(value)
      value = read_path(payload, "threeDS2RequestData.acctInfo.suspiciousAccActivity"); return "three_ds2_request_data_acct_info_suspicious_acc_activity_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.suspiciousAccActivity"); return "three_ds2_request_data_acct_info_suspicious_acc_activity_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.acctInfo.txnActivityDay"); return "three_ds2_request_data_acct_info_txn_activity_day_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "threeDS2RequestData.acctInfo.txnActivityYear"); return "three_ds2_request_data_acct_info_txn_activity_year_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "threeDS2RequestData.acctType"); return "three_ds2_request_data_acct_type_not_allowed" if !value_missing?(value) && !["01", "02", "03"].include?(value)
      value = read_path(payload, "threeDS2RequestData.acctType"); return "three_ds2_request_data_acct_type_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.acctType"); return "three_ds2_request_data_acct_type_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.addrMatch"); return "three_ds2_request_data_addr_match_not_allowed" if !value_missing?(value) && !["Y", "N"].include?(value)
      value = read_path(payload, "threeDS2RequestData.addrMatch"); return "three_ds2_request_data_addr_match_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "threeDS2RequestData.addrMatch"); return "three_ds2_request_data_addr_match_too_long" if !value_missing?(value) && value.to_s.length > 1
      value = read_path(payload, "threeDS2RequestData.challengeIndicator"); return "three_ds2_request_data_challenge_indicator_not_allowed" if !value_missing?(value) && !["noPreference", "requestNoChallenge", "requestChallenge", "requestChallengeAsMandate"].include?(value)
      value = read_path(payload, "threeDS2RequestData.deviceRenderOptions.sdkInterface"); return "three_ds2_request_data_device_render_options_sdk_interface_not_allowed" if !value_missing?(value) && !["native", "html", "both"].include?(value)
      value = read_path(payload, "threeDS2RequestData.homePhone.cc"); return "three_ds2_request_data_home_phone_cc_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "threeDS2RequestData.homePhone.cc"); return "three_ds2_request_data_home_phone_cc_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "threeDS2RequestData.homePhone.subscriber"); return "three_ds2_request_data_home_phone_subscriber_too_long" if !value_missing?(value) && value.to_s.length > 15
      value = read_path(payload, "threeDS2RequestData.mobilePhone.cc"); return "three_ds2_request_data_mobile_phone_cc_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "threeDS2RequestData.mobilePhone.cc"); return "three_ds2_request_data_mobile_phone_cc_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "threeDS2RequestData.mobilePhone.subscriber"); return "three_ds2_request_data_mobile_phone_subscriber_too_long" if !value_missing?(value) && value.to_s.length > 15
      value = read_path(payload, "threeDS2RequestData.purchaseInstalData"); return "three_ds2_request_data_purchase_instal_data_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "threeDS2RequestData.purchaseInstalData"); return "three_ds2_request_data_purchase_instal_data_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "threeDS2RequestData.recurringFrequency"); return "three_ds2_request_data_recurring_frequency_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorAuthenticationInfo.threeDSReqAuthMethod"); return "three_ds2_request_data_three_dsrequestor_authentication_info_three_dsreq_auth_method_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04", "05", "06"].include?(value)
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorAuthenticationInfo.threeDSReqAuthMethod"); return "three_ds2_request_data_three_dsrequestor_authentication_info_three_dsreq_auth_method_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorAuthenticationInfo.threeDSReqAuthMethod"); return "three_ds2_request_data_three_dsrequestor_authentication_info_three_dsreq_auth_method_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorAuthenticationInfo.threeDSReqAuthTimestamp"); return "three_ds2_request_data_three_dsrequestor_authentication_info_three_dsreq_auth_timestamp_too_short" if !value_missing?(value) && value.to_s.length < 12
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorAuthenticationInfo.threeDSReqAuthTimestamp"); return "three_ds2_request_data_three_dsrequestor_authentication_info_three_dsreq_auth_timestamp_too_long" if !value_missing?(value) && value.to_s.length > 12
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorChallengeInd"); return "three_ds2_request_data_three_dsrequestor_challenge_ind_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04", "05", "06"].include?(value)
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorAuthMethod"); return "three_ds2_request_data_three_dsrequestor_prior_authentication_info_three_dsreq_prior_auth_method_not_allowed" if !value_missing?(value) && !["01", "02", "03", "04"].include?(value)
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorAuthMethod"); return "three_ds2_request_data_three_dsrequestor_prior_authentication_info_three_dsreq_prior_auth_method_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorAuthMethod"); return "three_ds2_request_data_three_dsrequestor_prior_authentication_info_three_dsreq_prior_auth_method_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorAuthTimestamp"); return "three_ds2_request_data_three_dsrequestor_prior_authentication_info_three_dsreq_prior_auth_timestamp_too_short" if !value_missing?(value) && value.to_s.length < 12
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorAuthTimestamp"); return "three_ds2_request_data_three_dsrequestor_prior_authentication_info_three_dsreq_prior_auth_timestamp_too_long" if !value_missing?(value) && value.to_s.length > 12
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorRef"); return "three_ds2_request_data_three_dsrequestor_prior_authentication_info_three_dsreq_prior_ref_too_short" if !value_missing?(value) && value.to_s.length < 36
      value = read_path(payload, "threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorRef"); return "three_ds2_request_data_three_dsrequestor_prior_authentication_info_three_dsreq_prior_ref_too_long" if !value_missing?(value) && value.to_s.length > 36
      value = read_path(payload, "threeDS2RequestData.transType"); return "three_ds2_request_data_trans_type_not_allowed" if !value_missing?(value) && !["01", "03", "10", "11", "28"].include?(value)
      value = read_path(payload, "threeDS2RequestData.transType"); return "three_ds2_request_data_trans_type_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "threeDS2RequestData.transType"); return "three_ds2_request_data_trans_type_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "threeDS2RequestData.transactionType"); return "three_ds2_request_data_transaction_type_not_allowed" if !value_missing?(value) && !["goodsOrServicePurchase", "checkAcceptance", "accountFunding", "quasiCashTransaction", "prepaidActivationAndLoad"].include?(value)
      value = read_path(payload, "threeDS2RequestData.workPhone.cc"); return "three_ds2_request_data_work_phone_cc_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "threeDS2RequestData.workPhone.cc"); return "three_ds2_request_data_work_phone_cc_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "threeDS2RequestData.workPhone.subscriber"); return "three_ds2_request_data_work_phone_subscriber_too_long" if !value_missing?(value) && value.to_s.length > 15
      nil
    end

    def create_headers(operation)
      headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
      credentials = [ENV.fetch("ADYEN_CHECKOUT_USERNAME"), ENV.fetch("ADYEN_CHECKOUT_PASSWORD")].join(":")
      headers["Authorization"] = "Basic #{Base64.strict_encode64(credentials)}"
      headers["Idempotency-Key"] = operation.id.to_s if operation.respond_to?(:id)
      headers
    end

    def status_headers(operation)
      headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
      # Авторизация в спецификации не объявлена.
      # Для операции не объявлен заголовок идемпотентности.
      headers
    end

    def request_options(operation, request_method)
      payload = build_payload(operation, request_method)
      options = { headers: create_headers(operation) }
      options[:json] = payload
      options
    end

    def status_request_options(operation)
      options = { headers: status_headers(operation) }
      # У GET-операции проверки статуса нет тела запроса.
      options
    end

    def handle_create_response(response)
      code = response.respond_to?(:status) ? response.status.to_i : response.code.to_i
      body = response_body(response)
      return provider_failure(code, body) if code >= 400
      id = provider_id(body)
      return failure(:unprocessable_entity, "provider.operation_id_missing") if value_missing?(id)
      success(result: { id: id })
    rescue JSON::ParserError
      failure(:internal_server_error, "provider.invalid_json_response")
    end

    def handle_status_response(response)
      code = response.respond_to?(:status) ? response.status.to_i : response.code.to_i
      body = response_body(response)
      return provider_failure(code, body) if code >= 400
      apply_status(body)
    rescue JSON::ParserError
      failure(:internal_server_error, "provider.invalid_json_response")
    end

    def response_body(response)
      body = response.respond_to?(:body) ? response.body : {}
      body.is_a?(String) ? JSON.parse(body) : body
    end

    def provider_failure(code, body)
      failure(ERROR_MAP.fetch(code, "internal_server_error").to_sym, provider_error_key(body, code))
    end

    def provider_error_key(payload, http_code)
      error = payload.is_a?(Hash) ? (payload["error"] || payload[:error]) : nil
      provider_code = error.is_a?(Hash) ? (error["code"] || error[:code]) : nil
      provider_code ? "provider.#{provider_code}" : "provider.http_#{http_code}"
    end

    def apply_status(payload)
      status = provider_status(payload)
      mapped = STATUS_MAP.fetch(status.to_s, "unknown")
      return failure(:unprocessable_entity, "provider.unknown_status") if mapped == "unknown"

      id = provider_id(payload)
      return failure(:unprocessable_entity, "provider.operation_id_missing") if value_missing?(id)
      return approve_operation(id) if mapped == "approved"
      return reject_operation(id, provider_error_code(payload) || status.to_s) if mapped == "rejected"
      success
    end

    def provider_error_code(payload)
      return unless payload.is_a?(Hash)
      error = payload["error"] || payload[:error]
      error["code"] || error[:code] if error.is_a?(Hash)
    end

    def provider_status(payload)
      status_keys = %w[payment_state payout_status transaction_status order_status status state result_code]
      resource_payloads(payload).each do |candidate|
        status_keys.each do |wanted|
          pair = candidate.find { |key, _| normalized_key(key) == wanted }
          return pair.last if pair
        end
      end
      nil
    end

    def provider_id(payload)
      id_keys = %w[payment_id payout_id order_id batch_id id psp_reference]
      resource_payloads(payload).each do |candidate|
        id_keys.each do |wanted|
          pair = candidate.find { |key, _| normalized_key(key) == wanted }
          return pair.last if pair
        end
      end
      nil
    end

    def resource_payloads(payload)
      return [] unless payload.is_a?(Hash)
      wrappers = %w[payment payout order batch transaction data result]
      nested = payload.filter_map do |key, value|
        value if wrappers.include?(normalized_key(key)) && value.is_a?(Hash)
      end
      [payload, *nested]
    end

    def normalized_key(key)
      key.to_s.gsub(/([a-z0-9])([A-Z])/, "\\1_\\2").downcase.tr(" -", "__")
    end

    def read_operation(operation, key)
      return operation.public_send(key) if operation.respond_to?(key)
      if operation.respond_to?(:to_h)
        values = operation.to_h
        return values[key.to_sym] if values.key?(key.to_sym)
        return values[key] if values.key?(key)
      end
      nil
    end

    def read_path(operation, path)
      path.split(".").reduce(operation) do |value, key|
        break nil if value.nil?
        if value.respond_to?(key)
          value.public_send(key)
        elsif value.respond_to?(:key?) && value.respond_to?(:[])
          value.key?(key) ? value[key] : value[key.to_sym]
        elsif value.respond_to?(:[])
          value[key]
        end
      end
    end

    def value_missing?(value)
      value.nil? || (value.respond_to?(:empty?) && value.empty?)
    end

    def numeric_constraint_value(value)
      BigDecimal(value.to_s)
    rescue ArgumentError, TypeError
      nil
    end

    def constraint_pattern_match?(value, pattern)
      Regexp.new(pattern).match?(value.to_s)
    rescue RegexpError
      false
    end

    def expand_path(template, operation)
      template.gsub(/{([^}]+)}/) do
        name = Regexp.last_match(1)
        value = if normalized_key(name).match?(/\A(?:id|payment_(?:id|uuid)|payout_(?:id|uuid)|order_(?:id|uuid)|batch_(?:id|uuid)|transaction_(?:id|uuid))\z/)
                  read_operation(operation, "provider_operation_key")
                end
        value ||= read_operation(operation, name)
        raise ArgumentError, "Не заполнен path-параметр #{name}" if value_missing?(value)
        URI.encode_www_form_component(value.to_s).gsub("+", "%20")
      end
    end

    def payout_type(operation, request_method)
      method = request_method.to_s
      return "sbp" if method == "sbp"
      return "card" if %w[card p2p].include?(method)

      requisite = read_operation(operation, "payout_requisite")
      return "sbp" if read_path(requisite, "sbp")
      return "card" unless value_missing?(read_path(requisite, "card_number"))
      nil
    end
  end
end
