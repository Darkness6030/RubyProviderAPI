# frozen_string_literal: true
# Сгенерировано из Orders. Перед production-использованием проверьте маппинг полей.

require "json"
require "base64"
require "bigdecimal"
require "uri"

class Provider
  class PaypalOrdersService < BaseService
    BASE_URL = ENV.fetch("PAYPAL_ORDERS_BASE_URL", "https://api-m.paypal.com")
    STATUS_MAP = {"CREATED" => "in_progress", "SAVED" => "in_progress", "APPROVED" => "approved", "VOIDED" => "rejected", "COMPLETED" => "approved", "PAYER_ACTION_REQUIRED" => "in_progress"}.freeze
    ERROR_MAP = {400 => "bad_request", 401 => "unauthorized", 403 => "forbidden", 404 => "bad_request", 409 => "unprocessable_entity", 422 => "unprocessable_entity", 500 => "internal_server_error"}.freeze
    WEBHOOK_EVENTS = [].freeze

    def create_request(operation, request_method = nil)
      return failure(:internal_server_error, "provider.create_operation_missing") unless true

      path = expand_path("/v2/checkout/orders", operation)
      response = client.public_send("post",
        "#{BASE_URL}#{path}", **request_options(operation, request_method))
      handle_create_response(response)
    end

    def fetch_status(operation)
      return failure(:internal_server_error, "provider.status_operation_missing") unless true

      path = expand_path("/v2/checkout/orders/{id}", operation)
      response = client.public_send("get", "#{BASE_URL}#{path}", **status_request_options(operation))
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
      return failure(:unprocessable_entity, "missing_intent") if value_missing?(read_path(payload, "intent"))
      return failure(:unprocessable_entity, "missing_purchase_units") if value_missing?(read_path(payload, "purchase_units"))
      # Подтверждённых условно обязательных полей нет.
      constraint_error = constraint_violation(payload)
      return failure(:unprocessable_entity, constraint_error) if constraint_error
      success
    end

    private

    def build_payload(operation, request_method = nil)
      { "intent" => nil, "payer" => nil, "purchase_units" => nil, "payment_source" => { "card" => nil, "token" => { "id" => nil, "type" => "BILLING_AGREEMENT" }.compact, "paypal" => nil, "bancontact" => nil, "blik" => nil, "eps" => nil, "giropay" => nil, "ideal" => nil, "mybank" => nil, "p24" => nil, "sofort" => nil, "trustly" => nil, "apple_pay" => nil, "google_pay" => nil, "venmo" => nil, "crypto" => nil }.compact, "application_context" => nil }.compact
    end

    def constraint_violation(payload)
      value = read_path(payload, "intent"); return "intent_not_allowed" if !value_missing?(value) && !["CAPTURE", "AUTHORIZE"].include?(value)
      value = read_path(payload, "payer.name.prefix"); return "payer_name_prefix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.name.prefix"); return "payer_name_prefix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.name.prefix"); return "payer_name_prefix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payer.name.given_name"); return "payer_name_given_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.name.given_name"); return "payer_name_given_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.name.given_name"); return "payer_name_given_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payer.name.surname"); return "payer_name_surname_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.name.surname"); return "payer_name_surname_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.name.surname"); return "payer_name_surname_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payer.name.middle_name"); return "payer_name_middle_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.name.middle_name"); return "payer_name_middle_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.name.middle_name"); return "payer_name_middle_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payer.name.suffix"); return "payer_name_suffix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.name.suffix"); return "payer_name_suffix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.name.suffix"); return "payer_name_suffix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payer.name.full_name"); return "payer_name_full_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.name.full_name"); return "payer_name_full_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.name.full_name"); return "payer_name_full_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payer.phone.phone_type"); return "payer_phone_phone_type_not_allowed" if !value_missing?(value) && !["FAX", "HOME", "MOBILE", "OTHER", "PAGER"].include?(value)
      value = read_path(payload, "payer.phone.phone_number.national_number"); return "payer_phone_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payer.phone.phone_number.national_number"); return "payer_phone_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payer.phone.phone_number.national_number"); return "payer_phone_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payer.tax_info.tax_id"); return "payer_tax_info_tax_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*([a-zA-Z0-9]).*$")
      value = read_path(payload, "payer.tax_info.tax_id"); return "payer_tax_info_tax_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payer.tax_info.tax_id"); return "payer_tax_info_tax_id_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payer.tax_info.tax_id_type"); return "payer_tax_info_tax_id_type_not_allowed" if !value_missing?(value) && !["BR_CPF", "BR_CNPJ"].include?(value)
      value = read_path(payload, "payer.address.address_line_1"); return "payer_address_address_line_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.address_line_1"); return "payer_address_address_line_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.address_line_1"); return "payer_address_address_line_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payer.address.address_line_2"); return "payer_address_address_line_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.address_line_2"); return "payer_address_address_line_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.address_line_2"); return "payer_address_address_line_2_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payer.address.address_line_3"); return "payer_address_address_line_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.address_line_3"); return "payer_address_address_line_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.address_line_3"); return "payer_address_address_line_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payer.address.admin_area_4"); return "payer_address_admin_area_4_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.admin_area_4"); return "payer_address_admin_area_4_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.admin_area_4"); return "payer_address_admin_area_4_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payer.address.admin_area_3"); return "payer_address_admin_area_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.admin_area_3"); return "payer_address_admin_area_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.admin_area_3"); return "payer_address_admin_area_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payer.address.admin_area_2"); return "payer_address_admin_area_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.admin_area_2"); return "payer_address_admin_area_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.admin_area_2"); return "payer_address_admin_area_2_too_long" if !value_missing?(value) && value.to_s.length > 120
      value = read_path(payload, "payer.address.admin_area_1"); return "payer_address_admin_area_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.admin_area_1"); return "payer_address_admin_area_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.admin_area_1"); return "payer_address_admin_area_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payer.address.postal_code"); return "payer_address_postal_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.postal_code"); return "payer_address_postal_code_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.postal_code"); return "payer_address_postal_code_too_long" if !value_missing?(value) && value.to_s.length > 60
      value = read_path(payload, "payer.address.country_code"); return "payer_address_country_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^([A-Z]{2}|C2)$")
      value = read_path(payload, "payer.address.country_code"); return "payer_address_country_code_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payer.address.country_code"); return "payer_address_country_code_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "payer.address.address_details.street_number"); return "payer_address_address_details_street_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.address_details.street_number"); return "payer_address_address_details_street_number_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.address_details.street_number"); return "payer_address_address_details_street_number_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payer.address.address_details.street_name"); return "payer_address_address_details_street_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.address_details.street_name"); return "payer_address_address_details_street_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.address_details.street_name"); return "payer_address_address_details_street_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payer.address.address_details.street_type"); return "payer_address_address_details_street_type_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.address_details.street_type"); return "payer_address_address_details_street_type_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.address_details.street_type"); return "payer_address_address_details_street_type_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payer.address.address_details.delivery_service"); return "payer_address_address_details_delivery_service_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.address_details.delivery_service"); return "payer_address_address_details_delivery_service_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.address_details.delivery_service"); return "payer_address_address_details_delivery_service_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payer.address.address_details.building_name"); return "payer_address_address_details_building_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.address_details.building_name"); return "payer_address_address_details_building_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.address_details.building_name"); return "payer_address_address_details_building_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payer.address.address_details.sub_building"); return "payer_address_address_details_sub_building_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payer.address.address_details.sub_building"); return "payer_address_address_details_sub_building_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payer.address.address_details.sub_building"); return "payer_address_address_details_sub_building_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.name"); return "payment_source_card_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.{1,300}$")
      value = read_path(payload, "payment_source.card.name"); return "payment_source_card_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.card.name"); return "payment_source_card_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.card.number"); return "payment_source_card_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{13,19}$")
      value = read_path(payload, "payment_source.card.number"); return "payment_source_card_number_too_short" if !value_missing?(value) && value.to_s.length < 13
      value = read_path(payload, "payment_source.card.number"); return "payment_source_card_number_too_long" if !value_missing?(value) && value.to_s.length > 19
      value = read_path(payload, "payment_source.card.security_code"); return "payment_source_card_security_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{3,4}$")
      value = read_path(payload, "payment_source.card.security_code"); return "payment_source_card_security_code_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "payment_source.card.security_code"); return "payment_source_card_security_code_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "payment_source.card.last_digits"); return "payment_source_card_last_digits_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{2,4}$")
      value = read_path(payload, "payment_source.card.last_digits"); return "payment_source_card_last_digits_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.card.last_digits"); return "payment_source_card_last_digits_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "payment_source.card.billing_address.address_line_1"); return "payment_source_card_billing_address_address_line_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.address_line_1"); return "payment_source_card_billing_address_address_line_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.address_line_1"); return "payment_source_card_billing_address_address_line_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.card.billing_address.address_line_2"); return "payment_source_card_billing_address_address_line_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.address_line_2"); return "payment_source_card_billing_address_address_line_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.address_line_2"); return "payment_source_card_billing_address_address_line_2_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.card.billing_address.address_line_3"); return "payment_source_card_billing_address_address_line_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.address_line_3"); return "payment_source_card_billing_address_address_line_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.address_line_3"); return "payment_source_card_billing_address_address_line_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.billing_address.admin_area_4"); return "payment_source_card_billing_address_admin_area_4_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.admin_area_4"); return "payment_source_card_billing_address_admin_area_4_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.admin_area_4"); return "payment_source_card_billing_address_admin_area_4_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.billing_address.admin_area_3"); return "payment_source_card_billing_address_admin_area_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.admin_area_3"); return "payment_source_card_billing_address_admin_area_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.admin_area_3"); return "payment_source_card_billing_address_admin_area_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.billing_address.admin_area_2"); return "payment_source_card_billing_address_admin_area_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.admin_area_2"); return "payment_source_card_billing_address_admin_area_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.admin_area_2"); return "payment_source_card_billing_address_admin_area_2_too_long" if !value_missing?(value) && value.to_s.length > 120
      value = read_path(payload, "payment_source.card.billing_address.admin_area_1"); return "payment_source_card_billing_address_admin_area_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.admin_area_1"); return "payment_source_card_billing_address_admin_area_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.admin_area_1"); return "payment_source_card_billing_address_admin_area_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.card.billing_address.postal_code"); return "payment_source_card_billing_address_postal_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.postal_code"); return "payment_source_card_billing_address_postal_code_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.postal_code"); return "payment_source_card_billing_address_postal_code_too_long" if !value_missing?(value) && value.to_s.length > 60
      value = read_path(payload, "payment_source.card.billing_address.country_code"); return "payment_source_card_billing_address_country_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^([A-Z]{2}|C2)$")
      value = read_path(payload, "payment_source.card.billing_address.country_code"); return "payment_source_card_billing_address_country_code_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.card.billing_address.country_code"); return "payment_source_card_billing_address_country_code_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "payment_source.card.billing_address.address_details.street_number"); return "payment_source_card_billing_address_address_details_street_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.address_details.street_number"); return "payment_source_card_billing_address_address_details_street_number_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.address_details.street_number"); return "payment_source_card_billing_address_address_details_street_number_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.billing_address.address_details.street_name"); return "payment_source_card_billing_address_address_details_street_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.address_details.street_name"); return "payment_source_card_billing_address_address_details_street_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.address_details.street_name"); return "payment_source_card_billing_address_address_details_street_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.billing_address.address_details.street_type"); return "payment_source_card_billing_address_address_details_street_type_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.address_details.street_type"); return "payment_source_card_billing_address_address_details_street_type_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.address_details.street_type"); return "payment_source_card_billing_address_address_details_street_type_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.billing_address.address_details.delivery_service"); return "payment_source_card_billing_address_address_details_delivery_service_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.address_details.delivery_service"); return "payment_source_card_billing_address_address_details_delivery_service_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.address_details.delivery_service"); return "payment_source_card_billing_address_address_details_delivery_service_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.billing_address.address_details.building_name"); return "payment_source_card_billing_address_address_details_building_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.address_details.building_name"); return "payment_source_card_billing_address_address_details_building_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.address_details.building_name"); return "payment_source_card_billing_address_address_details_building_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.billing_address.address_details.sub_building"); return "payment_source_card_billing_address_address_details_sub_building_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.billing_address.address_details.sub_building"); return "payment_source_card_billing_address_address_details_sub_building_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.billing_address.address_details.sub_building"); return "payment_source_card_billing_address_address_details_sub_building_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.card.attributes.customer.id"); return "payment_source_card_attributes_customer_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9a-zA-Z_-]+$")
      value = read_path(payload, "payment_source.card.attributes.customer.id"); return "payment_source_card_attributes_customer_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.card.attributes.customer.id"); return "payment_source_card_attributes_customer_id_too_long" if !value_missing?(value) && value.to_s.length > 22
      value = read_path(payload, "payment_source.card.attributes.customer.phone.phone_type"); return "payment_source_card_attributes_customer_phone_phone_type_not_allowed" if !value_missing?(value) && !["FAX", "HOME", "MOBILE", "OTHER", "PAGER"].include?(value)
      value = read_path(payload, "payment_source.card.attributes.customer.phone.phone_number.national_number"); return "payment_source_card_attributes_customer_phone_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payment_source.card.attributes.customer.phone.phone_number.national_number"); return "payment_source_card_attributes_customer_phone_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.card.attributes.customer.phone.phone_number.national_number"); return "payment_source_card_attributes_customer_phone_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.card.attributes.customer.name.prefix"); return "payment_source_card_attributes_customer_name_prefix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.attributes.customer.name.prefix"); return "payment_source_card_attributes_customer_name_prefix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.attributes.customer.name.prefix"); return "payment_source_card_attributes_customer_name_prefix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.card.attributes.customer.name.given_name"); return "payment_source_card_attributes_customer_name_given_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.attributes.customer.name.given_name"); return "payment_source_card_attributes_customer_name_given_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.attributes.customer.name.given_name"); return "payment_source_card_attributes_customer_name_given_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.card.attributes.customer.name.surname"); return "payment_source_card_attributes_customer_name_surname_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.attributes.customer.name.surname"); return "payment_source_card_attributes_customer_name_surname_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.attributes.customer.name.surname"); return "payment_source_card_attributes_customer_name_surname_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.card.attributes.customer.name.middle_name"); return "payment_source_card_attributes_customer_name_middle_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.attributes.customer.name.middle_name"); return "payment_source_card_attributes_customer_name_middle_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.attributes.customer.name.middle_name"); return "payment_source_card_attributes_customer_name_middle_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.card.attributes.customer.name.suffix"); return "payment_source_card_attributes_customer_name_suffix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.attributes.customer.name.suffix"); return "payment_source_card_attributes_customer_name_suffix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.attributes.customer.name.suffix"); return "payment_source_card_attributes_customer_name_suffix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.card.attributes.customer.name.full_name"); return "payment_source_card_attributes_customer_name_full_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.card.attributes.customer.name.full_name"); return "payment_source_card_attributes_customer_name_full_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.card.attributes.customer.name.full_name"); return "payment_source_card_attributes_customer_name_full_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.card.attributes.customer.merchant_customer_id"); return "payment_source_card_attributes_customer_merchant_customer_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9a-zA-Z-_.^*$@#]+$")
      value = read_path(payload, "payment_source.card.attributes.customer.merchant_customer_id"); return "payment_source_card_attributes_customer_merchant_customer_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.card.attributes.customer.merchant_customer_id"); return "payment_source_card_attributes_customer_merchant_customer_id_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "payment_source.card.attributes.vault.store_in_vault"); return "payment_source_card_attributes_vault_store_in_vault_not_allowed" if !value_missing?(value) && !["ON_SUCCESS"].include?(value)
      value = read_path(payload, "payment_source.card.attributes.verification.method"); return "payment_source_card_attributes_verification_method_not_allowed" if !value_missing?(value) && !["SCA_ALWAYS", "SCA_WHEN_REQUIRED", "3D_SECURE", "AVS_CVV"].include?(value)
      value = read_path(payload, "payment_source.card.stored_credential.payment_initiator"); return "payment_source_card_stored_credential_payment_initiator_not_allowed" if !value_missing?(value) && !["CUSTOMER", "MERCHANT"].include?(value)
      value = read_path(payload, "payment_source.card.stored_credential.payment_type"); return "payment_source_card_stored_credential_payment_type_not_allowed" if !value_missing?(value) && !["ONE_TIME", "RECURRING", "UNSCHEDULED"].include?(value)
      value = read_path(payload, "payment_source.card.stored_credential.usage"); return "payment_source_card_stored_credential_usage_not_allowed" if !value_missing?(value) && !["FIRST", "SUBSEQUENT", "DERIVED"].include?(value)
      value = read_path(payload, "payment_source.card.stored_credential.previous_network_transaction_reference.id"); return "payment_source_card_stored_credential_previous_network_transaction_reference_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[a-zA-Z0-9-_@.:&+=*^'~#!$%()]+$")
      value = read_path(payload, "payment_source.card.stored_credential.previous_network_transaction_reference.id"); return "payment_source_card_stored_credential_previous_network_transaction_reference_id_too_short" if !value_missing?(value) && value.to_s.length < 9
      value = read_path(payload, "payment_source.card.stored_credential.previous_network_transaction_reference.id"); return "payment_source_card_stored_credential_previous_network_transaction_reference_id_too_long" if !value_missing?(value) && value.to_s.length > 36
      value = read_path(payload, "payment_source.card.stored_credential.previous_network_transaction_reference.date"); return "payment_source_card_stored_credential_previous_network_transaction_reference_date_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]+$")
      value = read_path(payload, "payment_source.card.stored_credential.previous_network_transaction_reference.date"); return "payment_source_card_stored_credential_previous_network_transaction_reference_date_too_short" if !value_missing?(value) && value.to_s.length < 4
      value = read_path(payload, "payment_source.card.stored_credential.previous_network_transaction_reference.date"); return "payment_source_card_stored_credential_previous_network_transaction_reference_date_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "payment_source.card.stored_credential.previous_network_transaction_reference.acquirer_reference_number"); return "payment_source_card_stored_credential_previous_network_transaction_reference_acquirer_reference_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[a-zA-Z0-9]+$")
      value = read_path(payload, "payment_source.card.stored_credential.previous_network_transaction_reference.acquirer_reference_number"); return "payment_source_card_stored_credential_previous_network_transaction_reference_acquirer_reference_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.card.stored_credential.previous_network_transaction_reference.acquirer_reference_number"); return "payment_source_card_stored_credential_previous_network_transaction_reference_acquirer_reference_number_too_long" if !value_missing?(value) && value.to_s.length > 36
      value = read_path(payload, "payment_source.card.network_token.number"); return "payment_source_card_network_token_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{13,19}$")
      value = read_path(payload, "payment_source.card.network_token.number"); return "payment_source_card_network_token_number_too_short" if !value_missing?(value) && value.to_s.length < 13
      value = read_path(payload, "payment_source.card.network_token.number"); return "payment_source_card_network_token_number_too_long" if !value_missing?(value) && value.to_s.length > 19
      value = read_path(payload, "payment_source.card.network_token.cryptogram"); return "payment_source_card_network_token_cryptogram_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.card.network_token.cryptogram"); return "payment_source_card_network_token_cryptogram_too_short" if !value_missing?(value) && value.to_s.length < 28
      value = read_path(payload, "payment_source.card.network_token.cryptogram"); return "payment_source_card_network_token_cryptogram_too_long" if !value_missing?(value) && value.to_s.length > 32
      value = read_path(payload, "payment_source.card.network_token.eci_flag"); return "payment_source_card_network_token_eci_flag_not_allowed" if !value_missing?(value) && !["MASTERCARD_NON_3D_SECURE_TRANSACTION", "MASTERCARD_ATTEMPTED_AUTHENTICATION_TRANSACTION", "MASTERCARD_FULLY_AUTHENTICATED_TRANSACTION", "FULLY_AUTHENTICATED_TRANSACTION", "ATTEMPTED_AUTHENTICATION_TRANSACTION", "NON_3D_SECURE_TRANSACTION"].include?(value)
      value = read_path(payload, "payment_source.card.network_token.token_requestor_id"); return "payment_source_card_network_token_token_requestor_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9A-Z_]+$")
      value = read_path(payload, "payment_source.card.network_token.token_requestor_id"); return "payment_source_card_network_token_token_requestor_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.card.network_token.token_requestor_id"); return "payment_source_card_network_token_token_requestor_id_too_long" if !value_missing?(value) && value.to_s.length > 11
      value = read_path(payload, "payment_source.token.id"); return "payment_source_token_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9a-zA-Z_-]+$")
      value = read_path(payload, "payment_source.token.id"); return "payment_source_token_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.token.id"); return "payment_source_token_id_too_long" if !value_missing?(value) && value.to_s.length > 255
      value = read_path(payload, "payment_source.token.type"); return "payment_source_token_type_not_allowed" if !value_missing?(value) && !["BILLING_AGREEMENT"].include?(value)
      value = read_path(payload, "payment_source.paypal.name.prefix"); return "payment_source_paypal_name_prefix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.name.prefix"); return "payment_source_paypal_name_prefix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.name.prefix"); return "payment_source_paypal_name_prefix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.name.given_name"); return "payment_source_paypal_name_given_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.name.given_name"); return "payment_source_paypal_name_given_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.name.given_name"); return "payment_source_paypal_name_given_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.name.surname"); return "payment_source_paypal_name_surname_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.name.surname"); return "payment_source_paypal_name_surname_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.name.surname"); return "payment_source_paypal_name_surname_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.name.middle_name"); return "payment_source_paypal_name_middle_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.name.middle_name"); return "payment_source_paypal_name_middle_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.name.middle_name"); return "payment_source_paypal_name_middle_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.name.suffix"); return "payment_source_paypal_name_suffix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.name.suffix"); return "payment_source_paypal_name_suffix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.name.suffix"); return "payment_source_paypal_name_suffix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.name.full_name"); return "payment_source_paypal_name_full_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.name.full_name"); return "payment_source_paypal_name_full_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.name.full_name"); return "payment_source_paypal_name_full_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.paypal.phone.phone_type"); return "payment_source_paypal_phone_phone_type_not_allowed" if !value_missing?(value) && !["FAX", "HOME", "MOBILE", "OTHER", "PAGER"].include?(value)
      value = read_path(payload, "payment_source.paypal.phone.phone_number.national_number"); return "payment_source_paypal_phone_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payment_source.paypal.phone.phone_number.national_number"); return "payment_source_paypal_phone_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.phone.phone_number.national_number"); return "payment_source_paypal_phone_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.paypal.tax_info.tax_id"); return "payment_source_paypal_tax_info_tax_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*([a-zA-Z0-9]).*$")
      value = read_path(payload, "payment_source.paypal.tax_info.tax_id"); return "payment_source_paypal_tax_info_tax_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.tax_info.tax_id"); return "payment_source_paypal_tax_info_tax_id_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.paypal.tax_info.tax_id_type"); return "payment_source_paypal_tax_info_tax_id_type_not_allowed" if !value_missing?(value) && !["BR_CPF", "BR_CNPJ"].include?(value)
      value = read_path(payload, "payment_source.paypal.address.address_line_1"); return "payment_source_paypal_address_address_line_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.address_line_1"); return "payment_source_paypal_address_address_line_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.address_line_1"); return "payment_source_paypal_address_address_line_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.paypal.address.address_line_2"); return "payment_source_paypal_address_address_line_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.address_line_2"); return "payment_source_paypal_address_address_line_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.address_line_2"); return "payment_source_paypal_address_address_line_2_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.paypal.address.address_line_3"); return "payment_source_paypal_address_address_line_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.address_line_3"); return "payment_source_paypal_address_address_line_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.address_line_3"); return "payment_source_paypal_address_address_line_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.address.admin_area_4"); return "payment_source_paypal_address_admin_area_4_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.admin_area_4"); return "payment_source_paypal_address_admin_area_4_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.admin_area_4"); return "payment_source_paypal_address_admin_area_4_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.address.admin_area_3"); return "payment_source_paypal_address_admin_area_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.admin_area_3"); return "payment_source_paypal_address_admin_area_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.admin_area_3"); return "payment_source_paypal_address_admin_area_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.address.admin_area_2"); return "payment_source_paypal_address_admin_area_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.admin_area_2"); return "payment_source_paypal_address_admin_area_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.admin_area_2"); return "payment_source_paypal_address_admin_area_2_too_long" if !value_missing?(value) && value.to_s.length > 120
      value = read_path(payload, "payment_source.paypal.address.admin_area_1"); return "payment_source_paypal_address_admin_area_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.admin_area_1"); return "payment_source_paypal_address_admin_area_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.admin_area_1"); return "payment_source_paypal_address_admin_area_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.paypal.address.postal_code"); return "payment_source_paypal_address_postal_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.postal_code"); return "payment_source_paypal_address_postal_code_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.postal_code"); return "payment_source_paypal_address_postal_code_too_long" if !value_missing?(value) && value.to_s.length > 60
      value = read_path(payload, "payment_source.paypal.address.country_code"); return "payment_source_paypal_address_country_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^([A-Z]{2}|C2)$")
      value = read_path(payload, "payment_source.paypal.address.country_code"); return "payment_source_paypal_address_country_code_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.paypal.address.country_code"); return "payment_source_paypal_address_country_code_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "payment_source.paypal.address.address_details.street_number"); return "payment_source_paypal_address_address_details_street_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.address_details.street_number"); return "payment_source_paypal_address_address_details_street_number_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.address_details.street_number"); return "payment_source_paypal_address_address_details_street_number_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.address.address_details.street_name"); return "payment_source_paypal_address_address_details_street_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.address_details.street_name"); return "payment_source_paypal_address_address_details_street_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.address_details.street_name"); return "payment_source_paypal_address_address_details_street_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.address.address_details.street_type"); return "payment_source_paypal_address_address_details_street_type_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.address_details.street_type"); return "payment_source_paypal_address_address_details_street_type_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.address_details.street_type"); return "payment_source_paypal_address_address_details_street_type_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.address.address_details.delivery_service"); return "payment_source_paypal_address_address_details_delivery_service_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.address_details.delivery_service"); return "payment_source_paypal_address_address_details_delivery_service_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.address_details.delivery_service"); return "payment_source_paypal_address_address_details_delivery_service_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.address.address_details.building_name"); return "payment_source_paypal_address_address_details_building_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.address_details.building_name"); return "payment_source_paypal_address_address_details_building_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.address_details.building_name"); return "payment_source_paypal_address_address_details_building_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.address.address_details.sub_building"); return "payment_source_paypal_address_address_details_sub_building_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.address.address_details.sub_building"); return "payment_source_paypal_address_address_details_sub_building_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.address.address_details.sub_building"); return "payment_source_paypal_address_address_details_sub_building_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.customer.id"); return "payment_source_paypal_attributes_customer_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9a-zA-Z_-]+$")
      value = read_path(payload, "payment_source.paypal.attributes.customer.id"); return "payment_source_paypal_attributes_customer_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.attributes.customer.id"); return "payment_source_paypal_attributes_customer_id_too_long" if !value_missing?(value) && value.to_s.length > 22
      value = read_path(payload, "payment_source.paypal.attributes.customer.phone.phone_type"); return "payment_source_paypal_attributes_customer_phone_phone_type_not_allowed" if !value_missing?(value) && !["FAX", "HOME", "MOBILE", "OTHER", "PAGER"].include?(value)
      value = read_path(payload, "payment_source.paypal.attributes.customer.phone.phone_number.national_number"); return "payment_source_paypal_attributes_customer_phone_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payment_source.paypal.attributes.customer.phone.phone_number.national_number"); return "payment_source_paypal_attributes_customer_phone_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.attributes.customer.phone.phone_number.national_number"); return "payment_source_paypal_attributes_customer_phone_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.prefix"); return "payment_source_paypal_attributes_customer_name_prefix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.prefix"); return "payment_source_paypal_attributes_customer_name_prefix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.prefix"); return "payment_source_paypal_attributes_customer_name_prefix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.given_name"); return "payment_source_paypal_attributes_customer_name_given_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.given_name"); return "payment_source_paypal_attributes_customer_name_given_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.given_name"); return "payment_source_paypal_attributes_customer_name_given_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.surname"); return "payment_source_paypal_attributes_customer_name_surname_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.surname"); return "payment_source_paypal_attributes_customer_name_surname_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.surname"); return "payment_source_paypal_attributes_customer_name_surname_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.middle_name"); return "payment_source_paypal_attributes_customer_name_middle_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.middle_name"); return "payment_source_paypal_attributes_customer_name_middle_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.middle_name"); return "payment_source_paypal_attributes_customer_name_middle_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.suffix"); return "payment_source_paypal_attributes_customer_name_suffix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.suffix"); return "payment_source_paypal_attributes_customer_name_suffix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.suffix"); return "payment_source_paypal_attributes_customer_name_suffix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.full_name"); return "payment_source_paypal_attributes_customer_name_full_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.full_name"); return "payment_source_paypal_attributes_customer_name_full_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.customer.name.full_name"); return "payment_source_paypal_attributes_customer_name_full_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.paypal.attributes.customer.merchant_customer_id"); return "payment_source_paypal_attributes_customer_merchant_customer_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9a-zA-Z-_.^*$@#]+$")
      value = read_path(payload, "payment_source.paypal.attributes.customer.merchant_customer_id"); return "payment_source_paypal_attributes_customer_merchant_customer_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.attributes.customer.merchant_customer_id"); return "payment_source_paypal_attributes_customer_merchant_customer_id_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "payment_source.paypal.attributes.vault.store_in_vault"); return "payment_source_paypal_attributes_vault_store_in_vault_not_allowed" if !value_missing?(value) && !["ON_SUCCESS"].include?(value)
      value = read_path(payload, "payment_source.paypal.attributes.vault.description"); return "payment_source_paypal_attributes_vault_description_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.description"); return "payment_source_paypal_attributes_vault_description_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.attributes.vault.description"); return "payment_source_paypal_attributes_vault_description_too_long" if !value_missing?(value) && value.to_s.length > 128
      value = read_path(payload, "payment_source.paypal.attributes.vault.usage_pattern"); return "payment_source_paypal_attributes_vault_usage_pattern_not_allowed" if !value_missing?(value) && !["IMMEDIATE", "DEFERRED", "RECURRING_PREPAID", "RECURRING_POSTPAID", "THRESHOLD_PREPAID", "THRESHOLD_POSTPAID", "SUBSCRIPTION_PREPAID", "SUBSCRIPTION_POSTPAID", "UNSCHEDULED_PREPAID", "UNSCHEDULED_POSTPAID", "INSTALLMENT_PREPAID", "INSTALLMENT_POSTPAID"].include?(value)
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.prefix"); return "payment_source_paypal_attributes_vault_shipping_name_prefix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.prefix"); return "payment_source_paypal_attributes_vault_shipping_name_prefix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.prefix"); return "payment_source_paypal_attributes_vault_shipping_name_prefix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.given_name"); return "payment_source_paypal_attributes_vault_shipping_name_given_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.given_name"); return "payment_source_paypal_attributes_vault_shipping_name_given_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.given_name"); return "payment_source_paypal_attributes_vault_shipping_name_given_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.surname"); return "payment_source_paypal_attributes_vault_shipping_name_surname_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.surname"); return "payment_source_paypal_attributes_vault_shipping_name_surname_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.surname"); return "payment_source_paypal_attributes_vault_shipping_name_surname_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.middle_name"); return "payment_source_paypal_attributes_vault_shipping_name_middle_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.middle_name"); return "payment_source_paypal_attributes_vault_shipping_name_middle_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.middle_name"); return "payment_source_paypal_attributes_vault_shipping_name_middle_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.suffix"); return "payment_source_paypal_attributes_vault_shipping_name_suffix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.suffix"); return "payment_source_paypal_attributes_vault_shipping_name_suffix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.suffix"); return "payment_source_paypal_attributes_vault_shipping_name_suffix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.full_name"); return "payment_source_paypal_attributes_vault_shipping_name_full_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.full_name"); return "payment_source_paypal_attributes_vault_shipping_name_full_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.name.full_name"); return "payment_source_paypal_attributes_vault_shipping_name_full_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.phone_number.country_code"); return "payment_source_paypal_attributes_vault_shipping_phone_number_country_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,3}?$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.phone_number.country_code"); return "payment_source_paypal_attributes_vault_shipping_phone_number_country_code_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.phone_number.country_code"); return "payment_source_paypal_attributes_vault_shipping_phone_number_country_code_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.phone_number.national_number"); return "payment_source_paypal_attributes_vault_shipping_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.phone_number.national_number"); return "payment_source_paypal_attributes_vault_shipping_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.phone_number.national_number"); return "payment_source_paypal_attributes_vault_shipping_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.phone_number.extension_number"); return "payment_source_paypal_attributes_vault_shipping_phone_number_extension_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,15}?$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.phone_number.extension_number"); return "payment_source_paypal_attributes_vault_shipping_phone_number_extension_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.phone_number.extension_number"); return "payment_source_paypal_attributes_vault_shipping_phone_number_extension_number_too_long" if !value_missing?(value) && value.to_s.length > 15
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.type"); return "payment_source_paypal_attributes_vault_shipping_type_not_allowed" if !value_missing?(value) && !["SHIPPING", "PICKUP_IN_PERSON", "PICKUP_IN_STORE", "PICKUP_FROM_PERSON"].include?(value)
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_line_1"); return "payment_source_paypal_attributes_vault_shipping_address_address_line_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_line_1"); return "payment_source_paypal_attributes_vault_shipping_address_address_line_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_line_1"); return "payment_source_paypal_attributes_vault_shipping_address_address_line_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_line_2"); return "payment_source_paypal_attributes_vault_shipping_address_address_line_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_line_2"); return "payment_source_paypal_attributes_vault_shipping_address_address_line_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_line_2"); return "payment_source_paypal_attributes_vault_shipping_address_address_line_2_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_line_3"); return "payment_source_paypal_attributes_vault_shipping_address_address_line_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_line_3"); return "payment_source_paypal_attributes_vault_shipping_address_address_line_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_line_3"); return "payment_source_paypal_attributes_vault_shipping_address_address_line_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_4"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_4_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_4"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_4_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_4"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_4_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_3"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_3"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_3"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_2"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_2"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_2"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_2_too_long" if !value_missing?(value) && value.to_s.length > 120
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_1"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_1"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.admin_area_1"); return "payment_source_paypal_attributes_vault_shipping_address_admin_area_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.postal_code"); return "payment_source_paypal_attributes_vault_shipping_address_postal_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.postal_code"); return "payment_source_paypal_attributes_vault_shipping_address_postal_code_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.postal_code"); return "payment_source_paypal_attributes_vault_shipping_address_postal_code_too_long" if !value_missing?(value) && value.to_s.length > 60
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.country_code"); return "payment_source_paypal_attributes_vault_shipping_address_country_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^([A-Z]{2}|C2)$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.country_code"); return "payment_source_paypal_attributes_vault_shipping_address_country_code_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.country_code"); return "payment_source_paypal_attributes_vault_shipping_address_country_code_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.street_number"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_street_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.street_number"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_street_number_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.street_number"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_street_number_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.street_name"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_street_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.street_name"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_street_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.street_name"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_street_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.street_type"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_street_type_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.street_type"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_street_type_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.street_type"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_street_type_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.delivery_service"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_delivery_service_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.delivery_service"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_delivery_service_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.delivery_service"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_delivery_service_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.building_name"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_building_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.building_name"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_building_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.building_name"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_building_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.sub_building"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_sub_building_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.sub_building"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_sub_building_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.paypal.attributes.vault.shipping.address.address_details.sub_building"); return "payment_source_paypal_attributes_vault_shipping_address_address_details_sub_building_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.paypal.attributes.vault.usage_type"); return "payment_source_paypal_attributes_vault_usage_type_not_allowed" if !value_missing?(value) && !["MERCHANT", "PLATFORM"].include?(value)
      value = read_path(payload, "payment_source.paypal.attributes.vault.customer_type"); return "payment_source_paypal_attributes_vault_customer_type_not_allowed" if !value_missing?(value) && !["CONSUMER", "BUSINESS"].include?(value)
      value = read_path(payload, "payment_source.paypal.experience_context.brand_name"); return "payment_source_paypal_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.paypal.experience_context.brand_name"); return "payment_source_paypal_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.experience_context.brand_name"); return "payment_source_paypal_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.paypal.experience_context.shipping_preference"); return "payment_source_paypal_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.paypal.experience_context.contact_preference"); return "payment_source_paypal_experience_context_contact_preference_not_allowed" if !value_missing?(value) && !["NO_CONTACT_INFO", "UPDATE_CONTACT_INFO", "RETAIN_CONTACT_INFO"].include?(value)
      value = read_path(payload, "payment_source.paypal.experience_context.app_switch_context.native_app.os_type"); return "payment_source_paypal_experience_context_app_switch_context_native_app_os_type_not_allowed" if !value_missing?(value) && !["ANDROID", "IOS", "OTHER"].include?(value)
      value = read_path(payload, "payment_source.paypal.experience_context.app_switch_context.native_app.os_version"); return "payment_source_paypal_experience_context_app_switch_context_native_app_os_version_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.paypal.experience_context.app_switch_context.native_app.os_version"); return "payment_source_paypal_experience_context_app_switch_context_native_app_os_version_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.experience_context.app_switch_context.native_app.os_version"); return "payment_source_paypal_experience_context_app_switch_context_native_app_os_version_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "payment_source.paypal.experience_context.app_switch_context.mobile_web.return_flow"); return "payment_source_paypal_experience_context_app_switch_context_mobile_web_return_flow_not_allowed" if !value_missing?(value) && !["AUTO", "MANUAL"].include?(value)
      value = read_path(payload, "payment_source.paypal.experience_context.app_switch_context.mobile_web.buyer_user_agent"); return "payment_source_paypal_experience_context_app_switch_context_mobile_web_buyer_user_agent_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.paypal.experience_context.app_switch_context.mobile_web.buyer_user_agent"); return "payment_source_paypal_experience_context_app_switch_context_mobile_web_buyer_user_agent_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.paypal.experience_context.app_switch_context.mobile_web.buyer_user_agent"); return "payment_source_paypal_experience_context_app_switch_context_mobile_web_buyer_user_agent_too_long" if !value_missing?(value) && value.to_s.length > 512
      value = read_path(payload, "payment_source.paypal.experience_context.landing_page"); return "payment_source_paypal_experience_context_landing_page_not_allowed" if !value_missing?(value) && !["LOGIN", "GUEST_CHECKOUT", "NO_PREFERENCE", "BILLING"].include?(value)
      value = read_path(payload, "payment_source.paypal.experience_context.user_action"); return "payment_source_paypal_experience_context_user_action_not_allowed" if !value_missing?(value) && !["CONTINUE", "PAY_NOW"].include?(value)
      value = read_path(payload, "payment_source.paypal.experience_context.payment_method_preference"); return "payment_source_paypal_experience_context_payment_method_preference_not_allowed" if !value_missing?(value) && !["UNRESTRICTED", "IMMEDIATE_PAYMENT_REQUIRED"].include?(value)
      value = read_path(payload, "payment_source.paypal.experience_context.order_update_callback_config.callback_url"); return "payment_source_paypal_experience_context_order_update_callback_config_callback_url_too_short" if !value_missing?(value) && value.to_s.length < 10
      value = read_path(payload, "payment_source.paypal.experience_context.order_update_callback_config.callback_url"); return "payment_source_paypal_experience_context_order_update_callback_config_callback_url_too_long" if !value_missing?(value) && value.to_s.length > 2040
      value = read_path(payload, "payment_source.paypal.billing_agreement_id"); return "payment_source_paypal_billing_agreement_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[a-zA-Z0-9-]+$")
      value = read_path(payload, "payment_source.paypal.billing_agreement_id"); return "payment_source_paypal_billing_agreement_id_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.paypal.billing_agreement_id"); return "payment_source_paypal_billing_agreement_id_too_long" if !value_missing?(value) && value.to_s.length > 128
      value = read_path(payload, "payment_source.paypal.stored_credential.payment_initiator"); return "payment_source_paypal_stored_credential_payment_initiator_not_allowed" if !value_missing?(value) && !["CUSTOMER", "MERCHANT"].include?(value)
      value = read_path(payload, "payment_source.paypal.stored_credential.usage_pattern"); return "payment_source_paypal_stored_credential_usage_pattern_not_allowed" if !value_missing?(value) && !["IMMEDIATE", "DEFERRED", "RECURRING_PREPAID", "RECURRING_POSTPAID", "THRESHOLD_PREPAID", "THRESHOLD_POSTPAID", "SUBSCRIPTION_PREPAID", "SUBSCRIPTION_POSTPAID", "UNSCHEDULED_PREPAID", "UNSCHEDULED_POSTPAID", "INSTALLMENT_PREPAID", "INSTALLMENT_POSTPAID"].include?(value)
      value = read_path(payload, "payment_source.paypal.stored_credential.usage"); return "payment_source_paypal_stored_credential_usage_not_allowed" if !value_missing?(value) && !["FIRST", "SUBSEQUENT", "DERIVED"].include?(value)
      value = read_path(payload, "payment_source.bancontact.experience_context.brand_name"); return "payment_source_bancontact_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.bancontact.experience_context.brand_name"); return "payment_source_bancontact_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.bancontact.experience_context.brand_name"); return "payment_source_bancontact_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.bancontact.experience_context.shipping_preference"); return "payment_source_bancontact_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.blik.experience_context.brand_name"); return "payment_source_blik_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.blik.experience_context.brand_name"); return "payment_source_blik_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.blik.experience_context.brand_name"); return "payment_source_blik_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.blik.experience_context.shipping_preference"); return "payment_source_blik_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.blik.experience_context.consumer_user_agent"); return "payment_source_blik_experience_context_consumer_user_agent_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.blik.experience_context.consumer_user_agent"); return "payment_source_blik_experience_context_consumer_user_agent_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.blik.experience_context.consumer_user_agent"); return "payment_source_blik_experience_context_consumer_user_agent_too_long" if !value_missing?(value) && value.to_s.length > 256
      value = read_path(payload, "payment_source.blik.level_0.auth_code"); return "payment_source_blik_level_0_auth_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{6}$")
      value = read_path(payload, "payment_source.blik.level_0.auth_code"); return "payment_source_blik_level_0_auth_code_too_short" if !value_missing?(value) && value.to_s.length < 6
      value = read_path(payload, "payment_source.blik.level_0.auth_code"); return "payment_source_blik_level_0_auth_code_too_long" if !value_missing?(value) && value.to_s.length > 6
      value = read_path(payload, "payment_source.blik.one_click.auth_code"); return "payment_source_blik_one_click_auth_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{6}$")
      value = read_path(payload, "payment_source.blik.one_click.auth_code"); return "payment_source_blik_one_click_auth_code_too_short" if !value_missing?(value) && value.to_s.length < 6
      value = read_path(payload, "payment_source.blik.one_click.auth_code"); return "payment_source_blik_one_click_auth_code_too_long" if !value_missing?(value) && value.to_s.length > 6
      value = read_path(payload, "payment_source.blik.one_click.consumer_reference"); return "payment_source_blik_one_click_consumer_reference_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[ -~]{3,64}$")
      value = read_path(payload, "payment_source.blik.one_click.consumer_reference"); return "payment_source_blik_one_click_consumer_reference_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "payment_source.blik.one_click.consumer_reference"); return "payment_source_blik_one_click_consumer_reference_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "payment_source.blik.one_click.alias_label"); return "payment_source_blik_one_click_alias_label_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[ -~]{8,35}$")
      value = read_path(payload, "payment_source.blik.one_click.alias_label"); return "payment_source_blik_one_click_alias_label_too_short" if !value_missing?(value) && value.to_s.length < 8
      value = read_path(payload, "payment_source.blik.one_click.alias_label"); return "payment_source_blik_one_click_alias_label_too_long" if !value_missing?(value) && value.to_s.length > 35
      value = read_path(payload, "payment_source.blik.one_click.alias_key"); return "payment_source_blik_one_click_alias_key_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]+$")
      value = read_path(payload, "payment_source.blik.one_click.alias_key"); return "payment_source_blik_one_click_alias_key_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.blik.one_click.alias_key"); return "payment_source_blik_one_click_alias_key_too_long" if !value_missing?(value) && value.to_s.length > 19
      value = read_path(payload, "payment_source.eps.experience_context.brand_name"); return "payment_source_eps_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.eps.experience_context.brand_name"); return "payment_source_eps_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.eps.experience_context.brand_name"); return "payment_source_eps_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.eps.experience_context.shipping_preference"); return "payment_source_eps_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.giropay.experience_context.brand_name"); return "payment_source_giropay_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.giropay.experience_context.brand_name"); return "payment_source_giropay_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.giropay.experience_context.brand_name"); return "payment_source_giropay_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.giropay.experience_context.shipping_preference"); return "payment_source_giropay_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.ideal.experience_context.brand_name"); return "payment_source_ideal_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.ideal.experience_context.brand_name"); return "payment_source_ideal_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.ideal.experience_context.brand_name"); return "payment_source_ideal_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.ideal.experience_context.shipping_preference"); return "payment_source_ideal_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.mybank.experience_context.brand_name"); return "payment_source_mybank_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.mybank.experience_context.brand_name"); return "payment_source_mybank_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.mybank.experience_context.brand_name"); return "payment_source_mybank_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.mybank.experience_context.shipping_preference"); return "payment_source_mybank_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.p24.experience_context.brand_name"); return "payment_source_p24_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.p24.experience_context.brand_name"); return "payment_source_p24_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.p24.experience_context.brand_name"); return "payment_source_p24_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.p24.experience_context.shipping_preference"); return "payment_source_p24_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.sofort.experience_context.brand_name"); return "payment_source_sofort_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.sofort.experience_context.brand_name"); return "payment_source_sofort_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.sofort.experience_context.brand_name"); return "payment_source_sofort_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.sofort.experience_context.shipping_preference"); return "payment_source_sofort_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.trustly.experience_context.brand_name"); return "payment_source_trustly_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.trustly.experience_context.brand_name"); return "payment_source_trustly_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.trustly.experience_context.brand_name"); return "payment_source_trustly_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.trustly.experience_context.shipping_preference"); return "payment_source_trustly_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.apple_pay.id"); return "payment_source_apple_pay_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.apple_pay.id"); return "payment_source_apple_pay_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.id"); return "payment_source_apple_pay_id_too_long" if !value_missing?(value) && value.to_s.length > 250
      value = read_path(payload, "payment_source.apple_pay.phone_number.national_number"); return "payment_source_apple_pay_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payment_source.apple_pay.phone_number.national_number"); return "payment_source_apple_pay_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.phone_number.national_number"); return "payment_source_apple_pay_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.transaction_amount.currency_code"); return "payment_source_apple_pay_decrypted_token_transaction_amount_currency_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.transaction_amount.currency_code"); return "payment_source_apple_pay_decrypted_token_transaction_amount_currency_code_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.transaction_amount.currency_code"); return "payment_source_apple_pay_decrypted_token_transaction_amount_currency_code_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.transaction_amount.value"); return "payment_source_apple_pay_decrypted_token_transaction_amount_value_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^((-?[0-9]+)|(-?([0-9]+)?[.][0-9]+))$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.transaction_amount.value"); return "payment_source_apple_pay_decrypted_token_transaction_amount_value_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.transaction_amount.value"); return "payment_source_apple_pay_decrypted_token_transaction_amount_value_too_long" if !value_missing?(value) && value.to_s.length > 32
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.{1,300}$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.number"); return "payment_source_apple_pay_decrypted_token_tokenized_card_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{13,19}$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.number"); return "payment_source_apple_pay_decrypted_token_tokenized_card_number_too_short" if !value_missing?(value) && value.to_s.length < 13
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.number"); return "payment_source_apple_pay_decrypted_token_tokenized_card_number_too_long" if !value_missing?(value) && value.to_s.length > 19
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.security_code"); return "payment_source_apple_pay_decrypted_token_tokenized_card_security_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{3,4}$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.security_code"); return "payment_source_apple_pay_decrypted_token_tokenized_card_security_code_too_short" if !value_missing?(value) && value.to_s.length < 3
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.security_code"); return "payment_source_apple_pay_decrypted_token_tokenized_card_security_code_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.last_digits"); return "payment_source_apple_pay_decrypted_token_tokenized_card_last_digits_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{2,4}$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.last_digits"); return "payment_source_apple_pay_decrypted_token_tokenized_card_last_digits_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.last_digits"); return "payment_source_apple_pay_decrypted_token_tokenized_card_last_digits_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_1"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_line_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_1"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_line_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_1"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_line_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_2"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_line_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_2"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_line_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_2"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_line_2_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_3"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_line_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_3"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_line_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_3"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_line_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_4"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_4_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_4"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_4_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_4"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_4_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_3"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_3"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_3"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_2"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_2"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_2"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_2_too_long" if !value_missing?(value) && value.to_s.length > 120
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_1"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_1"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_1"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_admin_area_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.postal_code"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_postal_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.postal_code"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_postal_code_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.postal_code"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_postal_code_too_long" if !value_missing?(value) && value.to_s.length > 60
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.country_code"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_country_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^([A-Z]{2}|C2)$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.country_code"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_country_code_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.country_code"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_country_code_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_number"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_street_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_number"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_street_number_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_number"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_street_number_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_street_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_street_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_street_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_type"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_street_type_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_type"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_street_type_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_type"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_street_type_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.delivery_service"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_delivery_service_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.delivery_service"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_delivery_service_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.delivery_service"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_delivery_service_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.building_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_building_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.building_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_building_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.building_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_building_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.sub_building"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_sub_building_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.sub_building"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_sub_building_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.sub_building"); return "payment_source_apple_pay_decrypted_token_tokenized_card_billing_address_address_details_sub_building_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.id"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9a-zA-Z_-]+$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.id"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.id"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_id_too_long" if !value_missing?(value) && value.to_s.length > 22
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.phone.phone_type"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_phone_phone_type_not_allowed" if !value_missing?(value) && !["FAX", "HOME", "MOBILE", "OTHER", "PAGER"].include?(value)
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.phone.phone_number.national_number"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_phone_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.phone.phone_number.national_number"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_phone_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.phone.phone_number.national_number"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_phone_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.prefix"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_prefix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.prefix"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_prefix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.prefix"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_prefix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.given_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_given_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.given_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_given_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.given_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_given_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.surname"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_surname_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.surname"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_surname_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.surname"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_surname_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.middle_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_middle_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.middle_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_middle_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.middle_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_middle_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.suffix"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_suffix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.suffix"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_suffix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.suffix"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_suffix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.full_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_full_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.full_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_full_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.full_name"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_name_full_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.merchant_customer_id"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_merchant_customer_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9a-zA-Z-_.^*$@#]+$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.merchant_customer_id"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_merchant_customer_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.merchant_customer_id"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_customer_merchant_customer_id_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.vault.store_in_vault"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_vault_store_in_vault_not_allowed" if !value_missing?(value) && !["ON_SUCCESS"].include?(value)
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.tokenized_card.attributes.verification.method"); return "payment_source_apple_pay_decrypted_token_tokenized_card_attributes_verification_method_not_allowed" if !value_missing?(value) && !["SCA_ALWAYS", "SCA_WHEN_REQUIRED", "3D_SECURE", "AVS_CVV"].include?(value)
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.device_manufacturer_id"); return "payment_source_apple_pay_decrypted_token_device_manufacturer_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.device_manufacturer_id"); return "payment_source_apple_pay_decrypted_token_device_manufacturer_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.device_manufacturer_id"); return "payment_source_apple_pay_decrypted_token_device_manufacturer_id_too_long" if !value_missing?(value) && value.to_s.length > 2000
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data_type"); return "payment_source_apple_pay_decrypted_token_payment_data_type_not_allowed" if !value_missing?(value) && !["3DSECURE", "EMV"].include?(value)
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.cryptogram"); return "payment_source_apple_pay_decrypted_token_payment_data_cryptogram_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.cryptogram"); return "payment_source_apple_pay_decrypted_token_payment_data_cryptogram_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.cryptogram"); return "payment_source_apple_pay_decrypted_token_payment_data_cryptogram_too_long" if !value_missing?(value) && value.to_s.length > 2000
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.eci_indicator"); return "payment_source_apple_pay_decrypted_token_payment_data_eci_indicator_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.eci_indicator"); return "payment_source_apple_pay_decrypted_token_payment_data_eci_indicator_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.eci_indicator"); return "payment_source_apple_pay_decrypted_token_payment_data_eci_indicator_too_long" if !value_missing?(value) && value.to_s.length > 256
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.emv_data"); return "payment_source_apple_pay_decrypted_token_payment_data_emv_data_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.emv_data"); return "payment_source_apple_pay_decrypted_token_payment_data_emv_data_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.emv_data"); return "payment_source_apple_pay_decrypted_token_payment_data_emv_data_too_long" if !value_missing?(value) && value.to_s.length > 2000
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.pin"); return "payment_source_apple_pay_decrypted_token_payment_data_pin_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.pin"); return "payment_source_apple_pay_decrypted_token_payment_data_pin_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.decrypted_token.payment_data.pin"); return "payment_source_apple_pay_decrypted_token_payment_data_pin_too_long" if !value_missing?(value) && value.to_s.length > 2000
      value = read_path(payload, "payment_source.apple_pay.stored_credential.payment_initiator"); return "payment_source_apple_pay_stored_credential_payment_initiator_not_allowed" if !value_missing?(value) && !["CUSTOMER", "MERCHANT"].include?(value)
      value = read_path(payload, "payment_source.apple_pay.stored_credential.payment_type"); return "payment_source_apple_pay_stored_credential_payment_type_not_allowed" if !value_missing?(value) && !["ONE_TIME", "RECURRING", "UNSCHEDULED"].include?(value)
      value = read_path(payload, "payment_source.apple_pay.stored_credential.usage"); return "payment_source_apple_pay_stored_credential_usage_not_allowed" if !value_missing?(value) && !["FIRST", "SUBSEQUENT", "DERIVED"].include?(value)
      value = read_path(payload, "payment_source.apple_pay.stored_credential.previous_network_transaction_reference.id"); return "payment_source_apple_pay_stored_credential_previous_network_transaction_reference_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[a-zA-Z0-9-_@.:&+=*^'~#!$%()]+$")
      value = read_path(payload, "payment_source.apple_pay.stored_credential.previous_network_transaction_reference.id"); return "payment_source_apple_pay_stored_credential_previous_network_transaction_reference_id_too_short" if !value_missing?(value) && value.to_s.length < 9
      value = read_path(payload, "payment_source.apple_pay.stored_credential.previous_network_transaction_reference.id"); return "payment_source_apple_pay_stored_credential_previous_network_transaction_reference_id_too_long" if !value_missing?(value) && value.to_s.length > 36
      value = read_path(payload, "payment_source.apple_pay.stored_credential.previous_network_transaction_reference.date"); return "payment_source_apple_pay_stored_credential_previous_network_transaction_reference_date_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]+$")
      value = read_path(payload, "payment_source.apple_pay.stored_credential.previous_network_transaction_reference.date"); return "payment_source_apple_pay_stored_credential_previous_network_transaction_reference_date_too_short" if !value_missing?(value) && value.to_s.length < 4
      value = read_path(payload, "payment_source.apple_pay.stored_credential.previous_network_transaction_reference.date"); return "payment_source_apple_pay_stored_credential_previous_network_transaction_reference_date_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "payment_source.apple_pay.stored_credential.previous_network_transaction_reference.acquirer_reference_number"); return "payment_source_apple_pay_stored_credential_previous_network_transaction_reference_acquirer_reference_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[a-zA-Z0-9]+$")
      value = read_path(payload, "payment_source.apple_pay.stored_credential.previous_network_transaction_reference.acquirer_reference_number"); return "payment_source_apple_pay_stored_credential_previous_network_transaction_reference_acquirer_reference_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.stored_credential.previous_network_transaction_reference.acquirer_reference_number"); return "payment_source_apple_pay_stored_credential_previous_network_transaction_reference_acquirer_reference_number_too_long" if !value_missing?(value) && value.to_s.length > 36
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.id"); return "payment_source_apple_pay_attributes_customer_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9a-zA-Z_-]+$")
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.id"); return "payment_source_apple_pay_attributes_customer_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.id"); return "payment_source_apple_pay_attributes_customer_id_too_long" if !value_missing?(value) && value.to_s.length > 22
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.phone.phone_type"); return "payment_source_apple_pay_attributes_customer_phone_phone_type_not_allowed" if !value_missing?(value) && !["FAX", "HOME", "MOBILE", "OTHER", "PAGER"].include?(value)
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.phone.phone_number.national_number"); return "payment_source_apple_pay_attributes_customer_phone_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.phone.phone_number.national_number"); return "payment_source_apple_pay_attributes_customer_phone_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.phone.phone_number.national_number"); return "payment_source_apple_pay_attributes_customer_phone_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.prefix"); return "payment_source_apple_pay_attributes_customer_name_prefix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.prefix"); return "payment_source_apple_pay_attributes_customer_name_prefix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.prefix"); return "payment_source_apple_pay_attributes_customer_name_prefix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.given_name"); return "payment_source_apple_pay_attributes_customer_name_given_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.given_name"); return "payment_source_apple_pay_attributes_customer_name_given_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.given_name"); return "payment_source_apple_pay_attributes_customer_name_given_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.surname"); return "payment_source_apple_pay_attributes_customer_name_surname_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.surname"); return "payment_source_apple_pay_attributes_customer_name_surname_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.surname"); return "payment_source_apple_pay_attributes_customer_name_surname_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.middle_name"); return "payment_source_apple_pay_attributes_customer_name_middle_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.middle_name"); return "payment_source_apple_pay_attributes_customer_name_middle_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.middle_name"); return "payment_source_apple_pay_attributes_customer_name_middle_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.suffix"); return "payment_source_apple_pay_attributes_customer_name_suffix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.suffix"); return "payment_source_apple_pay_attributes_customer_name_suffix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.suffix"); return "payment_source_apple_pay_attributes_customer_name_suffix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.full_name"); return "payment_source_apple_pay_attributes_customer_name_full_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.full_name"); return "payment_source_apple_pay_attributes_customer_name_full_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.apple_pay.attributes.customer.name.full_name"); return "payment_source_apple_pay_attributes_customer_name_full_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.apple_pay.attributes.vault.store_in_vault"); return "payment_source_apple_pay_attributes_vault_store_in_vault_not_allowed" if !value_missing?(value) && !["ON_SUCCESS"].include?(value)
      value = read_path(payload, "payment_source.google_pay.phone_number.country_code"); return "payment_source_google_pay_phone_number_country_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,3}?$")
      value = read_path(payload, "payment_source.google_pay.phone_number.country_code"); return "payment_source_google_pay_phone_number_country_code_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.google_pay.phone_number.country_code"); return "payment_source_google_pay_phone_number_country_code_too_long" if !value_missing?(value) && value.to_s.length > 3
      value = read_path(payload, "payment_source.google_pay.phone_number.national_number"); return "payment_source_google_pay_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payment_source.google_pay.phone_number.national_number"); return "payment_source_google_pay_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.google_pay.phone_number.national_number"); return "payment_source_google_pay_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.google_pay.card.name"); return "payment_source_google_pay_card_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.{1,300}$")
      value = read_path(payload, "payment_source.google_pay.card.name"); return "payment_source_google_pay_card_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.google_pay.card.name"); return "payment_source_google_pay_card_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.google_pay.card.number"); return "payment_source_google_pay_card_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{13,19}$")
      value = read_path(payload, "payment_source.google_pay.card.number"); return "payment_source_google_pay_card_number_too_short" if !value_missing?(value) && value.to_s.length < 13
      value = read_path(payload, "payment_source.google_pay.card.number"); return "payment_source_google_pay_card_number_too_long" if !value_missing?(value) && value.to_s.length > 19
      value = read_path(payload, "payment_source.google_pay.card.last_digits"); return "payment_source_google_pay_card_last_digits_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{2,4}$")
      value = read_path(payload, "payment_source.google_pay.card.last_digits"); return "payment_source_google_pay_card_last_digits_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.google_pay.card.last_digits"); return "payment_source_google_pay_card_last_digits_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_line_1"); return "payment_source_google_pay_card_billing_address_address_line_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_line_1"); return "payment_source_google_pay_card_billing_address_address_line_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_line_1"); return "payment_source_google_pay_card_billing_address_address_line_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_line_2"); return "payment_source_google_pay_card_billing_address_address_line_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_line_2"); return "payment_source_google_pay_card_billing_address_address_line_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_line_2"); return "payment_source_google_pay_card_billing_address_address_line_2_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_line_3"); return "payment_source_google_pay_card_billing_address_address_line_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_line_3"); return "payment_source_google_pay_card_billing_address_address_line_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_line_3"); return "payment_source_google_pay_card_billing_address_address_line_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_4"); return "payment_source_google_pay_card_billing_address_admin_area_4_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_4"); return "payment_source_google_pay_card_billing_address_admin_area_4_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_4"); return "payment_source_google_pay_card_billing_address_admin_area_4_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_3"); return "payment_source_google_pay_card_billing_address_admin_area_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_3"); return "payment_source_google_pay_card_billing_address_admin_area_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_3"); return "payment_source_google_pay_card_billing_address_admin_area_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_2"); return "payment_source_google_pay_card_billing_address_admin_area_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_2"); return "payment_source_google_pay_card_billing_address_admin_area_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_2"); return "payment_source_google_pay_card_billing_address_admin_area_2_too_long" if !value_missing?(value) && value.to_s.length > 120
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_1"); return "payment_source_google_pay_card_billing_address_admin_area_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_1"); return "payment_source_google_pay_card_billing_address_admin_area_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.admin_area_1"); return "payment_source_google_pay_card_billing_address_admin_area_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.google_pay.card.billing_address.postal_code"); return "payment_source_google_pay_card_billing_address_postal_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.postal_code"); return "payment_source_google_pay_card_billing_address_postal_code_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.postal_code"); return "payment_source_google_pay_card_billing_address_postal_code_too_long" if !value_missing?(value) && value.to_s.length > 60
      value = read_path(payload, "payment_source.google_pay.card.billing_address.country_code"); return "payment_source_google_pay_card_billing_address_country_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^([A-Z]{2}|C2)$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.country_code"); return "payment_source_google_pay_card_billing_address_country_code_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.google_pay.card.billing_address.country_code"); return "payment_source_google_pay_card_billing_address_country_code_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.street_number"); return "payment_source_google_pay_card_billing_address_address_details_street_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.street_number"); return "payment_source_google_pay_card_billing_address_address_details_street_number_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.street_number"); return "payment_source_google_pay_card_billing_address_address_details_street_number_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.street_name"); return "payment_source_google_pay_card_billing_address_address_details_street_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.street_name"); return "payment_source_google_pay_card_billing_address_address_details_street_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.street_name"); return "payment_source_google_pay_card_billing_address_address_details_street_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.street_type"); return "payment_source_google_pay_card_billing_address_address_details_street_type_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.street_type"); return "payment_source_google_pay_card_billing_address_address_details_street_type_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.street_type"); return "payment_source_google_pay_card_billing_address_address_details_street_type_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.delivery_service"); return "payment_source_google_pay_card_billing_address_address_details_delivery_service_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.delivery_service"); return "payment_source_google_pay_card_billing_address_address_details_delivery_service_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.delivery_service"); return "payment_source_google_pay_card_billing_address_address_details_delivery_service_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.building_name"); return "payment_source_google_pay_card_billing_address_address_details_building_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.building_name"); return "payment_source_google_pay_card_billing_address_address_details_building_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.building_name"); return "payment_source_google_pay_card_billing_address_address_details_building_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.sub_building"); return "payment_source_google_pay_card_billing_address_address_details_sub_building_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.sub_building"); return "payment_source_google_pay_card_billing_address_address_details_sub_building_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.card.billing_address.address_details.sub_building"); return "payment_source_google_pay_card_billing_address_address_details_sub_building_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.message_id"); return "payment_source_google_pay_decrypted_token_message_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.message_id"); return "payment_source_google_pay_decrypted_token_message_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.google_pay.decrypted_token.message_id"); return "payment_source_google_pay_decrypted_token_message_id_too_long" if !value_missing?(value) && value.to_s.length > 250
      value = read_path(payload, "payment_source.google_pay.decrypted_token.message_expiration"); return "payment_source_google_pay_decrypted_token_message_expiration_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^\\d{13}$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.message_expiration"); return "payment_source_google_pay_decrypted_token_message_expiration_too_short" if !value_missing?(value) && value.to_s.length < 13
      value = read_path(payload, "payment_source.google_pay.decrypted_token.message_expiration"); return "payment_source_google_pay_decrypted_token_message_expiration_too_long" if !value_missing?(value) && value.to_s.length > 13
      value = read_path(payload, "payment_source.google_pay.decrypted_token.payment_method"); return "payment_source_google_pay_decrypted_token_payment_method_not_allowed" if !value_missing?(value) && !["CARD"].include?(value)
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.name"); return "payment_source_google_pay_decrypted_token_card_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.{1,300}$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.name"); return "payment_source_google_pay_decrypted_token_card_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.name"); return "payment_source_google_pay_decrypted_token_card_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.number"); return "payment_source_google_pay_decrypted_token_card_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{13,19}$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.number"); return "payment_source_google_pay_decrypted_token_card_number_too_short" if !value_missing?(value) && value.to_s.length < 13
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.number"); return "payment_source_google_pay_decrypted_token_card_number_too_long" if !value_missing?(value) && value.to_s.length > 19
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.last_digits"); return "payment_source_google_pay_decrypted_token_card_last_digits_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{2,4}$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.last_digits"); return "payment_source_google_pay_decrypted_token_card_last_digits_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.last_digits"); return "payment_source_google_pay_decrypted_token_card_last_digits_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_line_1"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_line_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_line_1"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_line_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_line_1"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_line_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_line_2"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_line_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_line_2"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_line_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_line_2"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_line_2_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_line_3"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_line_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_line_3"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_line_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_line_3"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_line_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_4"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_4_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_4"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_4_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_4"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_4_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_3"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_3_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_3"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_3_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_3"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_3_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_2"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_2_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_2"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_2_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_2"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_2_too_long" if !value_missing?(value) && value.to_s.length > 120
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_1"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_1_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_1"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_1_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.admin_area_1"); return "payment_source_google_pay_decrypted_token_card_billing_address_admin_area_1_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.postal_code"); return "payment_source_google_pay_decrypted_token_card_billing_address_postal_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.postal_code"); return "payment_source_google_pay_decrypted_token_card_billing_address_postal_code_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.postal_code"); return "payment_source_google_pay_decrypted_token_card_billing_address_postal_code_too_long" if !value_missing?(value) && value.to_s.length > 60
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.country_code"); return "payment_source_google_pay_decrypted_token_card_billing_address_country_code_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^([A-Z]{2}|C2)$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.country_code"); return "payment_source_google_pay_decrypted_token_card_billing_address_country_code_too_short" if !value_missing?(value) && value.to_s.length < 2
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.country_code"); return "payment_source_google_pay_decrypted_token_card_billing_address_country_code_too_long" if !value_missing?(value) && value.to_s.length > 2
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_number"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_street_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_number"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_street_number_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_number"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_street_number_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_name"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_street_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_name"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_street_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_name"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_street_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_type"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_street_type_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_type"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_street_type_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_type"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_street_type_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.delivery_service"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_delivery_service_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.delivery_service"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_delivery_service_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.delivery_service"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_delivery_service_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.building_name"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_building_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.building_name"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_building_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.building_name"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_building_name_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.sub_building"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_sub_building_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.sub_building"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_sub_building_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.google_pay.decrypted_token.card.billing_address.address_details.sub_building"); return "payment_source_google_pay_decrypted_token_card_billing_address_address_details_sub_building_too_long" if !value_missing?(value) && value.to_s.length > 100
      value = read_path(payload, "payment_source.google_pay.decrypted_token.authentication_method"); return "payment_source_google_pay_decrypted_token_authentication_method_not_allowed" if !value_missing?(value) && !["PAN_ONLY", "CRYPTOGRAM_3DS"].include?(value)
      value = read_path(payload, "payment_source.google_pay.decrypted_token.cryptogram"); return "payment_source_google_pay_decrypted_token_cryptogram_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.cryptogram"); return "payment_source_google_pay_decrypted_token_cryptogram_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.google_pay.decrypted_token.cryptogram"); return "payment_source_google_pay_decrypted_token_cryptogram_too_long" if !value_missing?(value) && value.to_s.length > 2000
      value = read_path(payload, "payment_source.google_pay.decrypted_token.eci_indicator"); return "payment_source_google_pay_decrypted_token_eci_indicator_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.google_pay.decrypted_token.eci_indicator"); return "payment_source_google_pay_decrypted_token_eci_indicator_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.google_pay.decrypted_token.eci_indicator"); return "payment_source_google_pay_decrypted_token_eci_indicator_too_long" if !value_missing?(value) && value.to_s.length > 256
      value = read_path(payload, "payment_source.venmo.experience_context.brand_name"); return "payment_source_venmo_experience_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^.*$")
      value = read_path(payload, "payment_source.venmo.experience_context.brand_name"); return "payment_source_venmo_experience_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.venmo.experience_context.brand_name"); return "payment_source_venmo_experience_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "payment_source.venmo.experience_context.shipping_preference"); return "payment_source_venmo_experience_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "payment_source.venmo.experience_context.order_update_callback_config.callback_url"); return "payment_source_venmo_experience_context_order_update_callback_config_callback_url_too_short" if !value_missing?(value) && value.to_s.length < 10
      value = read_path(payload, "payment_source.venmo.experience_context.order_update_callback_config.callback_url"); return "payment_source_venmo_experience_context_order_update_callback_config_callback_url_too_long" if !value_missing?(value) && value.to_s.length > 2040
      value = read_path(payload, "payment_source.venmo.experience_context.user_action"); return "payment_source_venmo_experience_context_user_action_not_allowed" if !value_missing?(value) && !["CONTINUE", "PAY_NOW"].include?(value)
      value = read_path(payload, "payment_source.venmo.attributes.customer.id"); return "payment_source_venmo_attributes_customer_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9a-zA-Z_-]+$")
      value = read_path(payload, "payment_source.venmo.attributes.customer.id"); return "payment_source_venmo_attributes_customer_id_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.venmo.attributes.customer.id"); return "payment_source_venmo_attributes_customer_id_too_long" if !value_missing?(value) && value.to_s.length > 22
      value = read_path(payload, "payment_source.venmo.attributes.customer.phone.phone_type"); return "payment_source_venmo_attributes_customer_phone_phone_type_not_allowed" if !value_missing?(value) && !["FAX", "HOME", "MOBILE", "OTHER", "PAGER"].include?(value)
      value = read_path(payload, "payment_source.venmo.attributes.customer.phone.phone_number.national_number"); return "payment_source_venmo_attributes_customer_phone_phone_number_national_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]{1,14}?$")
      value = read_path(payload, "payment_source.venmo.attributes.customer.phone.phone_number.national_number"); return "payment_source_venmo_attributes_customer_phone_phone_number_national_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.venmo.attributes.customer.phone.phone_number.national_number"); return "payment_source_venmo_attributes_customer_phone_phone_number_national_number_too_long" if !value_missing?(value) && value.to_s.length > 14
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.prefix"); return "payment_source_venmo_attributes_customer_name_prefix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.prefix"); return "payment_source_venmo_attributes_customer_name_prefix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.prefix"); return "payment_source_venmo_attributes_customer_name_prefix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.given_name"); return "payment_source_venmo_attributes_customer_name_given_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.given_name"); return "payment_source_venmo_attributes_customer_name_given_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.given_name"); return "payment_source_venmo_attributes_customer_name_given_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.surname"); return "payment_source_venmo_attributes_customer_name_surname_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.surname"); return "payment_source_venmo_attributes_customer_name_surname_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.surname"); return "payment_source_venmo_attributes_customer_name_surname_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.middle_name"); return "payment_source_venmo_attributes_customer_name_middle_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.middle_name"); return "payment_source_venmo_attributes_customer_name_middle_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.middle_name"); return "payment_source_venmo_attributes_customer_name_middle_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.suffix"); return "payment_source_venmo_attributes_customer_name_suffix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.suffix"); return "payment_source_venmo_attributes_customer_name_suffix_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.suffix"); return "payment_source_venmo_attributes_customer_name_suffix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.full_name"); return "payment_source_venmo_attributes_customer_name_full_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.full_name"); return "payment_source_venmo_attributes_customer_name_full_name_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "payment_source.venmo.attributes.customer.name.full_name"); return "payment_source_venmo_attributes_customer_name_full_name_too_long" if !value_missing?(value) && value.to_s.length > 300
      value = read_path(payload, "payment_source.venmo.attributes.vault.store_in_vault"); return "payment_source_venmo_attributes_vault_store_in_vault_not_allowed" if !value_missing?(value) && !["ON_SUCCESS"].include?(value)
      value = read_path(payload, "payment_source.venmo.attributes.vault.description"); return "payment_source_venmo_attributes_vault_description_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[a-zA-Z0-9_'\\-., :;\\!?\"]*$")
      value = read_path(payload, "payment_source.venmo.attributes.vault.description"); return "payment_source_venmo_attributes_vault_description_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.venmo.attributes.vault.description"); return "payment_source_venmo_attributes_vault_description_too_long" if !value_missing?(value) && value.to_s.length > 128
      value = read_path(payload, "payment_source.venmo.attributes.vault.usage_pattern"); return "payment_source_venmo_attributes_vault_usage_pattern_not_allowed" if !value_missing?(value) && !["IMMEDIATE", "DEFERRED", "RECURRING_PREPAID", "RECURRING_POSTPAID", "THRESHOLD_PREPAID", "THRESHOLD_POSTPAID"].include?(value)
      value = read_path(payload, "payment_source.venmo.attributes.vault.usage_type"); return "payment_source_venmo_attributes_vault_usage_type_not_allowed" if !value_missing?(value) && !["MERCHANT", "PLATFORM"].include?(value)
      value = read_path(payload, "payment_source.venmo.attributes.vault.customer_type"); return "payment_source_venmo_attributes_vault_customer_type_not_allowed" if !value_missing?(value) && !["CONSUMER", "BUSINESS"].include?(value)
      value = read_path(payload, "payment_source.crypto.name.prefix"); return "payment_source_crypto_name_prefix_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.crypto.name.prefix"); return "payment_source_crypto_name_prefix_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.crypto.name.prefix"); return "payment_source_crypto_name_prefix_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.crypto.name.given_name"); return "payment_source_crypto_name_given_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.crypto.name.given_name"); return "payment_source_crypto_name_given_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.crypto.name.given_name"); return "payment_source_crypto_name_given_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.crypto.name.surname"); return "payment_source_crypto_name_surname_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.crypto.name.surname"); return "payment_source_crypto_name_surname_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.crypto.name.surname"); return "payment_source_crypto_name_surname_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "payment_source.crypto.name.middle_name"); return "payment_source_crypto_name_middle_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "payment_source.crypto.name.middle_name"); return "payment_source_crypto_name_middle_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "payment_source.crypto.name.middle_name"); return "payment_source_crypto_name_middle_name_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "application_context.brand_name"); return "application_context_brand_name_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[\\S\\s]*$")
      value = read_path(payload, "application_context.brand_name"); return "application_context_brand_name_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "application_context.brand_name"); return "application_context_brand_name_too_long" if !value_missing?(value) && value.to_s.length > 127
      value = read_path(payload, "application_context.landing_page"); return "application_context_landing_page_not_allowed" if !value_missing?(value) && !["LOGIN", "BILLING", "NO_PREFERENCE"].include?(value)
      value = read_path(payload, "application_context.shipping_preference"); return "application_context_shipping_preference_not_allowed" if !value_missing?(value) && !["GET_FROM_FILE", "NO_SHIPPING", "SET_PROVIDED_ADDRESS"].include?(value)
      value = read_path(payload, "application_context.user_action"); return "application_context_user_action_not_allowed" if !value_missing?(value) && !["CONTINUE", "PAY_NOW"].include?(value)
      value = read_path(payload, "application_context.payment_method.payee_preferred"); return "application_context_payment_method_payee_preferred_not_allowed" if !value_missing?(value) && !["UNRESTRICTED", "IMMEDIATE_PAYMENT_REQUIRED"].include?(value)
      value = read_path(payload, "application_context.payment_method.standard_entry_class_code"); return "application_context_payment_method_standard_entry_class_code_not_allowed" if !value_missing?(value) && !["TEL", "WEB", "CCD", "PPD"].include?(value)
      value = read_path(payload, "application_context.return_url"); return "application_context_return_url_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "application_context.return_url"); return "application_context_return_url_too_long" if !value_missing?(value) && value.to_s.length > 2147483647
      value = read_path(payload, "application_context.cancel_url"); return "application_context_cancel_url_too_short" if !value_missing?(value) && value.to_s.length < 0
      value = read_path(payload, "application_context.cancel_url"); return "application_context_cancel_url_too_long" if !value_missing?(value) && value.to_s.length > 2147483647
      value = read_path(payload, "application_context.stored_payment_source.payment_initiator"); return "application_context_stored_payment_source_payment_initiator_not_allowed" if !value_missing?(value) && !["CUSTOMER", "MERCHANT"].include?(value)
      value = read_path(payload, "application_context.stored_payment_source.payment_type"); return "application_context_stored_payment_source_payment_type_not_allowed" if !value_missing?(value) && !["ONE_TIME", "RECURRING", "UNSCHEDULED"].include?(value)
      value = read_path(payload, "application_context.stored_payment_source.usage"); return "application_context_stored_payment_source_usage_not_allowed" if !value_missing?(value) && !["FIRST", "SUBSEQUENT", "DERIVED"].include?(value)
      value = read_path(payload, "application_context.stored_payment_source.previous_network_transaction_reference.id"); return "application_context_stored_payment_source_previous_network_transaction_reference_id_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[a-zA-Z0-9-_@.:&+=*^'~#!$%()]+$")
      value = read_path(payload, "application_context.stored_payment_source.previous_network_transaction_reference.id"); return "application_context_stored_payment_source_previous_network_transaction_reference_id_too_short" if !value_missing?(value) && value.to_s.length < 9
      value = read_path(payload, "application_context.stored_payment_source.previous_network_transaction_reference.id"); return "application_context_stored_payment_source_previous_network_transaction_reference_id_too_long" if !value_missing?(value) && value.to_s.length > 36
      value = read_path(payload, "application_context.stored_payment_source.previous_network_transaction_reference.date"); return "application_context_stored_payment_source_previous_network_transaction_reference_date_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[0-9]+$")
      value = read_path(payload, "application_context.stored_payment_source.previous_network_transaction_reference.date"); return "application_context_stored_payment_source_previous_network_transaction_reference_date_too_short" if !value_missing?(value) && value.to_s.length < 4
      value = read_path(payload, "application_context.stored_payment_source.previous_network_transaction_reference.date"); return "application_context_stored_payment_source_previous_network_transaction_reference_date_too_long" if !value_missing?(value) && value.to_s.length > 4
      value = read_path(payload, "application_context.stored_payment_source.previous_network_transaction_reference.acquirer_reference_number"); return "application_context_stored_payment_source_previous_network_transaction_reference_acquirer_reference_number_invalid_format" if !value_missing?(value) && !constraint_pattern_match?(value, "^[a-zA-Z0-9]+$")
      value = read_path(payload, "application_context.stored_payment_source.previous_network_transaction_reference.acquirer_reference_number"); return "application_context_stored_payment_source_previous_network_transaction_reference_acquirer_reference_number_too_short" if !value_missing?(value) && value.to_s.length < 1
      value = read_path(payload, "application_context.stored_payment_source.previous_network_transaction_reference.acquirer_reference_number"); return "application_context_stored_payment_source_previous_network_transaction_reference_acquirer_reference_number_too_long" if !value_missing?(value) && value.to_s.length > 36
      nil
    end

    def create_headers(operation)
      headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
      # TODO: реализуйте авторизацию типа oauth2.
      # Для операции не объявлен заголовок идемпотентности.
      headers
    end

    def status_headers(operation)
      headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
      # TODO: реализуйте авторизацию типа oauth2.
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
