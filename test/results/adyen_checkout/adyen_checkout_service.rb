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
      return failure(:unprocessable_entity, "amount_too_low") if read_operation(operation, "amount").to_i < 0
      # Подтверждённых условно обязательных полей нет.
      success
    end

    private

    def build_payload(operation, request_method = nil)
      { "accountInfo" => { "accountAgeIndicator" => nil, "accountChangeDate" => nil, "accountChangeIndicator" => nil, "accountCreationDate" => nil, "accountType" => nil, "addCardAttemptsDay" => nil, "deliveryAddressUsageDate" => nil, "deliveryAddressUsageIndicator" => nil, "homePhone" => nil, "mobilePhone" => nil, "passwordChangeDate" => nil, "passwordChangeIndicator" => nil, "pastTransactionsDay" => nil, "pastTransactionsYear" => nil, "paymentAccountAge" => nil, "paymentAccountIndicator" => nil, "purchasesLast6Months" => nil, "suspiciousActivity" => nil, "workPhone" => nil }.compact, "additionalAmount" => { "currency" => nil, "value" => nil }.compact, "additionalData" => nil, "amount" => { "currency" => nil, "value" => nil }.compact, "applicationInfo" => { "adyenLibrary" => { "name" => nil, "version" => nil }.compact, "adyenPaymentSource" => { "name" => nil, "version" => nil }.compact, "externalPlatform" => { "integrator" => nil, "name" => nil, "version" => nil }.compact, "merchantApplication" => { "name" => nil, "version" => nil }.compact, "merchantDevice" => { "os" => nil, "osVersion" => nil, "reference" => nil }.compact, "shopperInteractionDevice" => { "locale" => nil, "os" => nil, "osVersion" => nil }.compact }.compact, "authenticationData" => { "attemptAuthentication" => nil, "authenticationOnly" => "false", "threeDSRequestData" => { "challengeWindowSize" => nil, "dataOnly" => nil, "nativeThreeDS" => nil, "threeDSVersion" => nil }.compact }.compact, "bankAccount" => { "accountType" => nil, "bankAccountNumber" => nil, "bankCity" => nil, "bankLocationId" => nil, "bankName" => nil, "bic" => nil, "countryCode" => nil, "iban" => nil, "ownerName" => nil, "taxId" => nil }.compact, "billingAddress" => { "city" => nil, "country" => nil, "houseNumberOrName" => nil, "postalCode" => nil, "stateOrProvince" => nil, "street" => nil }.compact, "browserInfo" => { "acceptHeader" => nil, "colorDepth" => nil, "javaEnabled" => nil, "javaScriptEnabled" => "true", "language" => nil, "screenHeight" => nil, "screenWidth" => nil, "timeZoneOffset" => nil, "userAgent" => nil }.compact, "captureDelayHours" => nil, "channel" => nil, "checkoutAttemptId" => nil, "company" => { "homepage" => nil, "name" => nil, "registrationNumber" => nil, "registryLocation" => nil, "taxId" => nil, "type" => nil }.compact, "countryCode" => nil, "dateOfBirth" => nil, "dccQuote" => { "account" => nil, "accountType" => nil, "baseAmount" => { "currency" => nil, "value" => nil }.compact, "basePoints" => nil, "buy" => { "currency" => nil, "value" => nil }.compact, "interbank" => { "currency" => nil, "value" => nil }.compact, "reference" => nil, "sell" => { "currency" => nil, "value" => nil }.compact, "signature" => nil, "source" => nil, "type" => nil, "validTill" => nil }.compact, "deliverAt" => nil, "deliveryAddress" => { "city" => nil, "country" => nil, "firstName" => nil, "houseNumberOrName" => nil, "lastName" => nil, "postalCode" => nil, "stateOrProvince" => nil, "street" => nil }.compact, "deliveryDate" => nil, "deviceFingerprint" => nil, "enableOneClick" => nil, "enablePayOut" => nil, "enableRecurring" => nil, "enhancedSchemeData" => { "airline" => { "agency" => { "invoiceNumber" => nil, "planName" => nil }.compact, "boardingFee" => nil, "code" => nil, "computerizedReservationSystem" => nil, "customerReferenceNumber" => nil, "designatorCode" => nil, "documentType" => nil, "flightDate" => nil, "legs" => nil, "passengerName" => nil, "passengers" => nil, "ticket" => { "issueAddress" => nil, "issueDate" => nil, "number" => nil }.compact, "travelAgency" => { "code" => nil, "name" => nil }.compact }.compact, "carRental" => { "customerServicePhoneNumber" => nil, "noShow" => nil, "pickupInfo" => { "city" => nil, "countryCode" => nil, "date" => nil, "stateOrProvince" => nil }.compact, "rateType" => nil, "rentalAgreementNumber" => nil, "rentalClassId" => nil, "rentalDays" => nil, "rentalRate" => nil, "rentalSurcharges" => { "fuel" => nil, "insurance" => nil, "oneWayDropOff" => nil }.compact, "renterName" => nil, "returnInfo" => { "city" => nil, "countryCode" => nil, "date" => nil, "locationId" => nil, "stateOrProvince" => nil }.compact, "taxExempt" => nil }.compact, "healthcare" => { "dentalValue" => nil, "otherMedicalValue" => nil, "prescriptionValue" => nil, "totalHealthcareValue" => nil, "visionPrescriptionValue" => nil }.compact, "levelTwoThree" => { "customerReferenceNumber" => nil, "destination" => { "countryCode" => nil, "postalCode" => nil, "stateOrProvince" => nil }.compact, "dutyAmount" => nil, "freightAmount" => nil, "itemDetailLines" => nil, "orderDate" => nil, "shipFromPostalCode" => nil, "totalTaxAmount" => nil }.compact, "lodging" => { "checkInDate" => nil, "checkOutDate" => nil, "customerServicePhoneNumber" => nil, "fireSafetyCompliance" => nil, "folio" => { "cashAdvances" => nil, "number" => nil }.compact, "foodBeverageCharges" => nil, "lodgingChargeType" => nil, "noShow" => nil, "prepaidExpenses" => nil, "propertyPhoneNumber" => nil, "renterName" => nil, "rooms" => nil, "totalRoomTax" => nil, "totalTax" => nil }.compact, "temporaryServices" => { "employeeName" => nil, "endDate" => nil, "hourRate" => nil, "hoursWorked" => nil, "jobDescription" => nil, "serviceRequestor" => nil, "startDate" => nil }.compact }.compact, "entityType" => nil, "fraudOffset" => nil, "fundOrigin" => { "billingAddress" => { "city" => nil, "country" => nil, "houseNumberOrName" => nil, "postalCode" => nil, "stateOrProvince" => nil, "street" => nil }.compact, "shopperEmail" => nil, "shopperName" => { "firstName" => nil, "lastName" => nil }.compact, "telephoneNumber" => nil, "walletIdentifier" => nil }.compact, "fundRecipient" => { "IBAN" => nil, "billingAddress" => { "city" => nil, "country" => nil, "houseNumberOrName" => nil, "postalCode" => nil, "stateOrProvince" => nil, "street" => nil }.compact, "paymentMethod" => { "billingSequenceNumber" => nil, "brand" => nil, "checkoutAttemptId" => nil, "cupsecureplus.smscode" => nil, "cvc" => nil, "encryptedCard" => nil, "encryptedCardNumber" => nil, "encryptedExpiryMonth" => nil, "encryptedExpiryYear" => nil, "encryptedPassword" => nil, "encryptedSecurityCode" => nil, "expiryMonth" => nil, "expiryYear" => nil, "fastlaneData" => nil, "fundingSource" => nil, "holderName" => nil, "networkPaymentReference" => nil, "number" => nil, "recurringDetailReference" => nil, "sdkData" => nil, "shopperNotificationReference" => nil, "srcCorrelationId" => nil, "srcDigitalCardId" => nil, "srcScheme" => nil, "srcTokenReference" => nil, "storedPaymentMethodId" => nil, "threeDS2SdkVersion" => nil, "type" => "scheme" }.compact, "shopperEmail" => nil, "shopperName" => { "firstName" => nil, "lastName" => nil }.compact, "shopperReference" => nil, "storedPaymentMethodId" => nil, "subMerchant" => { "city" => nil, "country" => nil, "mcc" => nil, "name" => nil, "taxId" => nil }.compact, "telephoneNumber" => nil, "walletIdentifier" => nil, "walletOwnerTaxId" => nil, "walletPurpose" => nil }.compact, "industryUsage" => nil, "installments" => { "extra" => nil, "plan" => nil, "value" => nil }.compact, "lineItems" => nil, "localizedShopperStatement" => nil, "mandate" => { "amount" => nil, "amountRule" => nil, "billingAttemptsRule" => nil, "billingDay" => nil, "count" => nil, "endsAt" => nil, "frequency" => nil, "remarks" => nil, "startsAt" => nil }.compact, "mcc" => nil, "merchantAccount" => nil, "merchantOrderReference" => nil, "merchantRiskIndicator" => { "addressMatch" => nil, "deliveryAddressIndicator" => nil, "deliveryEmail" => nil, "deliveryEmailAddress" => nil, "deliveryTimeframe" => nil, "giftCardAmount" => { "currency" => nil, "value" => nil }.compact, "giftCardCount" => nil, "giftCardCurr" => nil, "preOrderDate" => nil, "preOrderPurchase" => nil, "preOrderPurchaseInd" => nil, "reorderItems" => nil, "reorderItemsInd" => nil, "shipIndicator" => nil }.compact, "metadata" => nil, "mpiData" => { "authenticationResponse" => nil, "cavv" => nil, "cavvAlgorithm" => nil, "challengeCancel" => nil, "directoryResponse" => nil, "dsTransID" => nil, "eci" => nil, "riskScore" => nil, "threeDSVersion" => nil, "tokenAuthenticationVerificationValue" => nil, "transStatusReason" => nil, "xid" => nil }.compact, "order" => { "orderData" => nil, "pspReference" => nil }.compact, "orderReference" => nil, "origin" => nil, "paymentMethod" => nil, "paymentValidations" => { "name" => { "status" => nil }.compact }.compact, "platformChargebackLogic" => { "behavior" => nil, "costAllocationAccount" => nil, "targetAccount" => nil }.compact, "recurringExpiry" => nil, "recurringFrequency" => nil, "recurringProcessingModel" => nil, "redirectFromIssuerMethod" => nil, "redirectToIssuerMethod" => nil, "reference" => nil, "returnUrl" => nil, "riskData" => { "clientData" => nil, "customFields" => nil, "fraudOffset" => nil, "profileReference" => nil }.compact, "sessionValidity" => nil, "shopperConversionId" => nil, "shopperEmail" => nil, "shopperIP" => nil, "shopperInteraction" => nil, "shopperLocale" => nil, "shopperName" => { "firstName" => nil, "lastName" => nil }.compact, "shopperReference" => nil, "shopperStatement" => nil, "shopperTaxInfo" => { "taxCountryCode" => nil, "taxIdentificationNumber" => nil }.compact, "socialSecurityNumber" => nil, "splits" => nil, "store" => nil, "storePaymentMethod" => nil, "subMerchants" => nil, "surcharge" => { "value" => nil }.compact, "telephoneNumber" => nil, "thirdPartyTokenRedundancyInfo" => { "requestParameters" => nil, "requestTemplateCode" => nil }.compact, "threeDS2RequestData" => { "acctInfo" => { "chAccAgeInd" => nil, "chAccChange" => nil, "chAccChangeInd" => nil, "chAccPwChange" => nil, "chAccPwChangeInd" => nil, "chAccString" => nil, "nbPurchaseAccount" => nil, "paymentAccAge" => nil, "paymentAccInd" => nil, "provisionAttemptsDay" => nil, "shipAddressUsage" => nil, "shipAddressUsageInd" => nil, "shipNameIndicator" => nil, "suspiciousAccActivity" => nil, "txnActivityDay" => nil, "txnActivityYear" => nil }.compact, "acctType" => nil, "acquirerBIN" => nil, "acquirerMerchantID" => nil, "addrMatch" => nil, "authenticationOnly" => "false", "challengeIndicator" => nil, "deviceRenderOptions" => { "sdkInterface" => "both", "sdkUiType" => nil }.compact, "homePhone" => { "cc" => nil, "subscriber" => nil }.compact, "mcc" => nil, "merchantName" => nil, "messageVersion" => nil, "mobilePhone" => { "cc" => nil, "subscriber" => nil }.compact, "notificationURL" => nil, "payTokenInd" => nil, "paymentAuthenticationUseCase" => nil, "purchaseInstalData" => nil, "recurringExpiry" => nil, "recurringFrequency" => nil, "sdkAppID" => nil, "sdkEphemPubKey" => { "crv" => nil, "kty" => nil, "x" => nil, "y" => nil }.compact, "sdkMaxTimeout" => "60", "sdkReferenceNumber" => nil, "sdkTransID" => nil, "threeDSCompInd" => nil, "threeDSRequestorAuthenticationInd" => nil, "threeDSRequestorAuthenticationInfo" => { "threeDSReqAuthData" => nil, "threeDSReqAuthMethod" => nil, "threeDSReqAuthTimestamp" => nil }.compact, "threeDSRequestorChallengeInd" => nil, "threeDSRequestorID" => nil, "threeDSRequestorName" => nil, "threeDSRequestorPriorAuthenticationInfo" => { "threeDSReqPriorAuthData" => nil, "threeDSReqPriorAuthMethod" => nil, "threeDSReqPriorAuthTimestamp" => nil, "threeDSReqPriorRef" => nil }.compact, "threeDSRequestorURL" => nil, "transType" => nil, "transactionType" => nil, "whiteListStatus" => nil, "workPhone" => { "cc" => nil, "subscriber" => nil }.compact }.compact, "threeDSAuthenticationOnly" => "false", "trustedShopper" => nil }.compact
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
