# Руководство по интеграции PaypalOrders

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 5. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://api-m.paypal.com`
- Переменная окружения: `PAYPAL_ORDERS_BASE_URL`
- API-ключ: `PAYPAL_ORDERS_API_KEY`

Адреса из OpenAPI:

- Server for https scheme.: `https://api-m.paypal.com`

## Авторизация

- `Oauth2`: oauth2,  ``

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `orders.create` | POST `/v2/checkout/orders` | Create order | — |
| `orders.get` | GET `/v2/checkout/orders/{id}` | Show order details | — |
| `orders.patch` | PATCH `/v2/checkout/orders/{id}` | Update order | — |
| `orders.confirm` | POST `/v2/checkout/orders/{id}/confirm-payment-source` | Confirm the Order | — |
| `orders.authorize` | POST `/v2/checkout/orders/{id}/authorize` | Authorize payment for order | — |
| `orders.capture` | POST `/v2/checkout/orders/{id}/capture` | Capture payment for order | — |
| `orders.track.create` | POST `/v2/checkout/orders/{id}/track` | Add tracking information for an Order. | — |
| `orders.trackers.patch` | PATCH `/v2/checkout/orders/{id}/trackers/{tracker_id}` | Update or cancel tracking information for an order | — |
| `server.callback` | POST `/v2/checkout/orders/order-update-callback` | Receive updated order information via callback URL | — |

## Обоснование выбора операций

- `create` (создание): POST `/v2/checkout/orders` — оценка 36; следующий кандидат POST `/v2/checkout/orders/order-update-callback` — оценка 26; разница 10.
- `status` (проверка статуса): GET `/v2/checkout/orders/{id}` — оценка 57; следующий кандидат POST `/v2/checkout/orders/{id}/authorize` — оценка 18; разница 39.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `CREATED` | `in_progress` |
| `SAVED` | `in_progress` |
| `APPROVED` | `approved` |
| `VOIDED` | `rejected` |
| `COMPLETED` | `approved` |
| `PAYER_ACTION_REQUIRED` | `in_progress` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `intent` | **TODO:** подтвердить схему платформы |
| `payer.email_address` | **TODO:** подтвердить схему платформы |
| `payer.payer_id` | **TODO:** подтвердить схему платформы |
| `payer.name.prefix` | **TODO:** подтвердить схему платформы |
| `payer.name.given_name` | **TODO:** подтвердить схему платформы |
| `payer.name.surname` | **TODO:** подтвердить схему платформы |
| `payer.name.middle_name` | **TODO:** подтвердить схему платформы |
| `payer.name.suffix` | **TODO:** подтвердить схему платформы |
| `payer.name.full_name` | **TODO:** подтвердить схему платформы |
| `payer.phone.phone_type` | **TODO:** подтвердить схему платформы |
| `payer.phone.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payer.birth_date` | **TODO:** подтвердить схему платформы |
| `payer.tax_info.tax_id` | **TODO:** подтвердить схему платформы |
| `payer.tax_info.tax_id_type` | **TODO:** подтвердить схему платформы |
| `payer.address.address_line_1` | **TODO:** подтвердить схему платформы |
| `payer.address.address_line_2` | **TODO:** подтвердить схему платформы |
| `payer.address.address_line_3` | **TODO:** подтвердить схему платформы |
| `payer.address.admin_area_4` | **TODO:** подтвердить схему платформы |
| `payer.address.admin_area_3` | **TODO:** подтвердить схему платформы |
| `payer.address.admin_area_2` | **TODO:** подтвердить схему платформы |
| `payer.address.admin_area_1` | **TODO:** подтвердить схему платформы |
| `payer.address.postal_code` | **TODO:** подтвердить схему платформы |
| `payer.address.country_code` | **TODO:** подтвердить схему платформы |
| `payer.address.address_details.street_number` | **TODO:** подтвердить схему платформы |
| `payer.address.address_details.street_name` | **TODO:** подтвердить схему платформы |
| `payer.address.address_details.street_type` | **TODO:** подтвердить схему платформы |
| `payer.address.address_details.delivery_service` | **TODO:** подтвердить схему платформы |
| `payer.address.address_details.building_name` | **TODO:** подтвердить схему платформы |
| `payer.address.address_details.sub_building` | **TODO:** подтвердить схему платформы |
| `purchase_units` | **TODO:** подтвердить схему платформы |
| `payment_source.card.id` | **TODO:** подтвердить схему платформы |
| `payment_source.card.name` | **TODO:** подтвердить схему платформы |
| `payment_source.card.number` | **TODO:** подтвердить схему платформы |
| `payment_source.card.expiry` | **TODO:** подтвердить схему платформы |
| `payment_source.card.security_code` | **TODO:** подтвердить схему платформы |
| `payment_source.card.last_digits` | **TODO:** подтвердить схему платформы |
| `payment_source.card.card_type` | **TODO:** подтвердить схему платформы |
| `payment_source.card.type` | **TODO:** подтвердить схему платформы |
| `payment_source.card.brand` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.address_line_1` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.address_line_2` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.address_line_3` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.admin_area_4` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.admin_area_3` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.admin_area_2` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.admin_area_1` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.postal_code` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.address_details.street_number` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.address_details.street_name` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.address_details.street_type` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.address_details.delivery_service` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.address_details.building_name` | **TODO:** подтвердить схему платформы |
| `payment_source.card.billing_address.address_details.sub_building` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.id` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.phone.phone_type` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.phone.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.name.prefix` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.name.given_name` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.name.surname` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.name.middle_name` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.name.suffix` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.name.full_name` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.customer.merchant_customer_id` | **TODO:** подтвердить схему платформы |
| `payment_source.card.attributes.vault.store_in_vault` | `literal:ON_SUCCESS` |
| `payment_source.card.attributes.verification.method` | `literal:SCA_WHEN_REQUIRED` |
| `payment_source.card.vault_id` | **TODO:** подтвердить схему платформы |
| `payment_source.card.single_use_token` | **TODO:** подтвердить схему платформы |
| `payment_source.card.stored_credential.payment_initiator` | **TODO:** подтвердить схему платформы |
| `payment_source.card.stored_credential.payment_type` | **TODO:** подтвердить схему платформы |
| `payment_source.card.stored_credential.usage` | `literal:DERIVED` |
| `payment_source.card.stored_credential.previous_network_transaction_reference.id` | **TODO:** подтвердить схему платформы |
| `payment_source.card.stored_credential.previous_network_transaction_reference.date` | **TODO:** подтвердить схему платформы |
| `payment_source.card.stored_credential.previous_network_transaction_reference.network` | **TODO:** подтвердить схему платформы |
| `payment_source.card.stored_credential.previous_network_transaction_reference.acquirer_reference_number` | **TODO:** подтвердить схему платформы |
| `payment_source.card.network_token.number` | **TODO:** подтвердить схему платформы |
| `payment_source.card.network_token.expiry` | **TODO:** подтвердить схему платформы |
| `payment_source.card.network_token.cryptogram` | **TODO:** подтвердить схему платформы |
| `payment_source.card.network_token.eci_flag` | **TODO:** подтвердить схему платформы |
| `payment_source.card.network_token.token_requestor_id` | **TODO:** подтвердить схему платформы |
| `payment_source.card.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.card.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.token.id` | **TODO:** подтвердить схему платформы |
| `payment_source.token.type` | `literal:BILLING_AGREEMENT` |
| `payment_source.paypal.vault_id` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.name.prefix` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.name.given_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.name.surname` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.name.middle_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.name.suffix` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.name.full_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.phone.phone_type` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.phone.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.birth_date` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.tax_info.tax_id` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.tax_info.tax_id_type` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.address_line_1` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.address_line_2` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.address_line_3` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.admin_area_4` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.admin_area_3` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.admin_area_2` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.admin_area_1` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.postal_code` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.address_details.street_number` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.address_details.street_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.address_details.street_type` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.address_details.delivery_service` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.address_details.building_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.address.address_details.sub_building` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.id` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.phone.phone_type` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.phone.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.name.prefix` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.name.given_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.name.surname` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.name.middle_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.name.suffix` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.name.full_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.customer.merchant_customer_id` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.store_in_vault` | `literal:ON_SUCCESS` |
| `payment_source.paypal.attributes.vault.description` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.usage_pattern` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.name.prefix` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.name.given_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.name.surname` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.name.middle_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.name.suffix` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.name.full_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.phone_number.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.phone_number.extension_number` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.type` | `literal:SHIPPING` |
| `payment_source.paypal.attributes.vault.shipping.options` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.address_line_1` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.address_line_2` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.address_line_3` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.admin_area_4` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.admin_area_3` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.admin_area_2` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.admin_area_1` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.postal_code` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.street_number` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.street_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.street_type` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.delivery_service` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.building_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.sub_building` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.usage_type` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.attributes.vault.customer_type` | `literal:CONSUMER` |
| `payment_source.paypal.attributes.vault.permit_multiple_payment_tokens` | `literal:false` |
| `payment_source.paypal.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.paypal.experience_context.contact_preference` | `literal:NO_CONTACT_INFO` |
| `payment_source.paypal.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.experience_context.app_switch_context.native_app.os_type` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.experience_context.app_switch_context.native_app.os_version` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.experience_context.app_switch_context.mobile_web.return_flow` | `literal:AUTO` |
| `payment_source.paypal.experience_context.app_switch_context.mobile_web.buyer_user_agent` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.experience_context.landing_page` | `literal:NO_PREFERENCE` |
| `payment_source.paypal.experience_context.user_action` | `literal:CONTINUE` |
| `payment_source.paypal.experience_context.payment_method_preference` | `literal:UNRESTRICTED` |
| `payment_source.paypal.experience_context.order_update_callback_config.callback_events` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.experience_context.order_update_callback_config.callback_url` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.billing_agreement_id` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.stored_credential.payment_initiator` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.stored_credential.charge_pattern` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.stored_credential.usage_pattern` | **TODO:** подтвердить схему платформы |
| `payment_source.paypal.stored_credential.usage` | `literal:DERIVED` |
| `payment_source.bancontact.name` | **TODO:** подтвердить схему платформы |
| `payment_source.bancontact.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.bancontact.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.bancontact.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.bancontact.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.bancontact.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.bancontact.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.name` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.email` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.blik.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.experience_context.consumer_ip` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.experience_context.consumer_user_agent` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.level_0.auth_code` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.one_click.auth_code` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.one_click.consumer_reference` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.one_click.alias_label` | **TODO:** подтвердить схему платформы |
| `payment_source.blik.one_click.alias_key` | **TODO:** подтвердить схему платформы |
| `payment_source.eps.name` | **TODO:** подтвердить схему платформы |
| `payment_source.eps.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.eps.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.eps.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.eps.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.eps.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.eps.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.giropay.name` | **TODO:** подтвердить схему платформы |
| `payment_source.giropay.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.giropay.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.giropay.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.giropay.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.giropay.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.giropay.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.ideal.name` | **TODO:** подтвердить схему платформы |
| `payment_source.ideal.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.ideal.bic` | **TODO:** подтвердить схему платформы |
| `payment_source.ideal.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.ideal.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.ideal.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.ideal.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.ideal.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.mybank.name` | **TODO:** подтвердить схему платформы |
| `payment_source.mybank.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.mybank.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.mybank.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.mybank.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.mybank.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.mybank.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.p24.name` | **TODO:** подтвердить схему платформы |
| `payment_source.p24.email` | **TODO:** подтвердить схему платформы |
| `payment_source.p24.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.p24.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.p24.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.p24.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.p24.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.p24.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.sofort.name` | **TODO:** подтвердить схему платформы |
| `payment_source.sofort.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.sofort.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.sofort.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.sofort.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.sofort.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.sofort.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.trustly.name` | **TODO:** подтвердить схему платформы |
| `payment_source.trustly.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.trustly.email` | **TODO:** подтвердить схему платформы |
| `payment_source.trustly.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.trustly.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.trustly.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.trustly.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.trustly.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.id` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.transaction_amount.currency_code` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.transaction_amount.value` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.id` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.number` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.expiry` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.security_code` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.last_digits` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.card_type` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.type` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.brand` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_1` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_2` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_3` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_4` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_3` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_2` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_1` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.postal_code` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_number` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_type` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.delivery_service` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.building_name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.sub_building` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.id` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.phone.phone_type` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.phone.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.prefix` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.given_name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.surname` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.middle_name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.suffix` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.full_name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.merchant_customer_id` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.vault.store_in_vault` | `literal:ON_SUCCESS` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.verification.method` | `literal:SCA_WHEN_REQUIRED` |
| `payment_source.apple_pay.decrypted_token.device_manufacturer_id` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.payment_data_type` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.payment_data.cryptogram` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.payment_data.eci_indicator` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.payment_data.emv_data` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.decrypted_token.payment_data.pin` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.stored_credential.payment_initiator` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.stored_credential.payment_type` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.stored_credential.usage` | `literal:DERIVED` |
| `payment_source.apple_pay.stored_credential.previous_network_transaction_reference.id` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.stored_credential.previous_network_transaction_reference.date` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.stored_credential.previous_network_transaction_reference.network` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.stored_credential.previous_network_transaction_reference.acquirer_reference_number` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.vault_id` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.id` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.phone.phone_type` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.phone.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.name.prefix` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.name.given_name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.name.surname` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.name.middle_name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.name.suffix` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.customer.name.full_name` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.attributes.vault.store_in_vault` | `literal:ON_SUCCESS` |
| `payment_source.apple_pay.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.name` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.phone_number.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.name` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.number` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.expiry` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.last_digits` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.type` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.brand` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.address_line_1` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.address_line_2` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.address_line_3` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.admin_area_4` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.admin_area_3` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.admin_area_2` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.admin_area_1` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.postal_code` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.address_details.street_number` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.address_details.street_name` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.address_details.street_type` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.address_details.delivery_service` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.address_details.building_name` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.card.billing_address.address_details.sub_building` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.message_id` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.message_expiration` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.payment_method` | `literal:CARD` |
| `payment_source.google_pay.decrypted_token.card.name` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.number` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.expiry` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.last_digits` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.type` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.brand` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_line_1` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_line_2` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_line_3` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.admin_area_4` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.admin_area_3` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.admin_area_2` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.admin_area_1` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.postal_code` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_number` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_name` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_type` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.delivery_service` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.building_name` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.sub_building` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.authentication_method` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.cryptogram` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.decrypted_token.eci_indicator` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.assurance_details.account_verified` | `literal:false` |
| `payment_source.google_pay.assurance_details.card_holder_authenticated` | `literal:false` |
| `payment_source.google_pay.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.vault_id` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.experience_context.brand_name` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.experience_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `payment_source.venmo.experience_context.order_update_callback_config.callback_events` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.experience_context.order_update_callback_config.callback_url` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.experience_context.user_action` | `literal:CONTINUE` |
| `payment_source.venmo.attributes.customer.id` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.customer.email_address` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.customer.phone.phone_type` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.customer.phone.phone_number.national_number` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.customer.name.prefix` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.customer.name.given_name` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.customer.name.surname` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.customer.name.middle_name` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.customer.name.suffix` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.customer.name.full_name` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.vault.store_in_vault` | `literal:ON_SUCCESS` |
| `payment_source.venmo.attributes.vault.description` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.vault.usage_pattern` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.vault.usage_type` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo.attributes.vault.customer_type` | `literal:CONSUMER` |
| `payment_source.venmo.attributes.vault.permit_multiple_payment_tokens` | `literal:false` |
| `payment_source.crypto.country_code` | **TODO:** подтвердить схему платформы |
| `payment_source.crypto.name.prefix` | **TODO:** подтвердить схему платформы |
| `payment_source.crypto.name.given_name` | **TODO:** подтвердить схему платформы |
| `payment_source.crypto.name.surname` | **TODO:** подтвердить схему платформы |
| `payment_source.crypto.name.middle_name` | **TODO:** подтвердить схему платформы |
| `payment_source.crypto.experience_context.locale` | **TODO:** подтвердить схему платформы |
| `payment_source.crypto.experience_context.return_url` | **TODO:** подтвердить схему платформы |
| `payment_source.crypto.experience_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `application_context.brand_name` | **TODO:** подтвердить схему платформы |
| `application_context.locale` | **TODO:** подтвердить схему платформы |
| `application_context.landing_page` | `literal:NO_PREFERENCE` |
| `application_context.shipping_preference` | `literal:GET_FROM_FILE` |
| `application_context.user_action` | `literal:CONTINUE` |
| `application_context.payment_method.payee_preferred` | `literal:UNRESTRICTED` |
| `application_context.payment_method.standard_entry_class_code` | `literal:WEB` |
| `application_context.return_url` | **TODO:** подтвердить схему платформы |
| `application_context.cancel_url` | **TODO:** подтвердить схему платформы |
| `application_context.stored_payment_source.payment_initiator` | **TODO:** подтвердить схему платформы |
| `application_context.stored_payment_source.payment_type` | **TODO:** подтвердить схему платформы |
| `application_context.stored_payment_source.usage` | `literal:DERIVED` |
| `application_context.stored_payment_source.previous_network_transaction_reference.id` | **TODO:** подтвердить схему платформы |
| `application_context.stored_payment_source.previous_network_transaction_reference.date` | **TODO:** подтвердить схему платформы |
| `application_context.stored_payment_source.previous_network_transaction_reference.network` | **TODO:** подтвердить схему платформы |
| `application_context.stored_payment_source.previous_network_transaction_reference.acquirer_reference_number` | **TODO:** подтвердить схему платформы |

## Локальная проверка данных

Ограничения из OpenAPI проверяются в `check_conditions` до обращения к провайдеру. При ошибке сервис возвращает `failure(:unprocessable_entity, ...)`.

| Поле | Проверяемые ограничения |
|---|---|
| `intent` | enum: `CAPTURE, AUTHORIZE` |
| `payer.name.prefix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payer.name.given_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payer.name.surname` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payer.name.middle_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payer.name.suffix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payer.name.full_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payer.phone.phone_type` | enum: `FAX, HOME, MOBILE, OTHER, PAGER` |
| `payer.phone.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payer.tax_info.tax_id` | pattern: `^.*([a-zA-Z0-9]).*$`; minLength: `1`; maxLength: `14` |
| `payer.tax_info.tax_id_type` | enum: `BR_CPF, BR_CNPJ` |
| `payer.address.address_line_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payer.address.address_line_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payer.address.address_line_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payer.address.admin_area_4` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payer.address.admin_area_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payer.address.admin_area_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `120` |
| `payer.address.admin_area_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payer.address.postal_code` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `60` |
| `payer.address.country_code` | pattern: `^([A-Z]{2}\|C2)$`; minLength: `2`; maxLength: `2` |
| `payer.address.address_details.street_number` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payer.address.address_details.street_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payer.address.address_details.street_type` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payer.address.address_details.delivery_service` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payer.address.address_details.building_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payer.address.address_details.sub_building` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.name` | pattern: `^.{1,300}$`; minLength: `1`; maxLength: `300` |
| `payment_source.card.number` | pattern: `^[0-9]{13,19}$`; minLength: `13`; maxLength: `19` |
| `payment_source.card.security_code` | pattern: `^[0-9]{3,4}$`; minLength: `3`; maxLength: `4` |
| `payment_source.card.last_digits` | pattern: `^[0-9]{2,4}$`; minLength: `2`; maxLength: `4` |
| `payment_source.card.billing_address.address_line_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.card.billing_address.address_line_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.card.billing_address.address_line_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.billing_address.admin_area_4` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.billing_address.admin_area_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.billing_address.admin_area_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `120` |
| `payment_source.card.billing_address.admin_area_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.card.billing_address.postal_code` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `60` |
| `payment_source.card.billing_address.country_code` | pattern: `^([A-Z]{2}\|C2)$`; minLength: `2`; maxLength: `2` |
| `payment_source.card.billing_address.address_details.street_number` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.billing_address.address_details.street_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.billing_address.address_details.street_type` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.billing_address.address_details.delivery_service` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.billing_address.address_details.building_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.billing_address.address_details.sub_building` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.card.attributes.customer.id` | pattern: `^[0-9a-zA-Z_-]+$`; minLength: `1`; maxLength: `22` |
| `payment_source.card.attributes.customer.phone.phone_type` | enum: `FAX, HOME, MOBILE, OTHER, PAGER` |
| `payment_source.card.attributes.customer.phone.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payment_source.card.attributes.customer.name.prefix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.card.attributes.customer.name.given_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.card.attributes.customer.name.surname` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.card.attributes.customer.name.middle_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.card.attributes.customer.name.suffix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.card.attributes.customer.name.full_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.card.attributes.customer.merchant_customer_id` | pattern: `^[0-9a-zA-Z-_.^*$@#]+$`; minLength: `1`; maxLength: `64` |
| `payment_source.card.attributes.vault.store_in_vault` | enum: `ON_SUCCESS` |
| `payment_source.card.attributes.verification.method` | enum: `SCA_ALWAYS, SCA_WHEN_REQUIRED, 3D_SECURE, AVS_CVV` |
| `payment_source.card.stored_credential.payment_initiator` | enum: `CUSTOMER, MERCHANT` |
| `payment_source.card.stored_credential.payment_type` | enum: `ONE_TIME, RECURRING, UNSCHEDULED` |
| `payment_source.card.stored_credential.usage` | enum: `FIRST, SUBSEQUENT, DERIVED` |
| `payment_source.card.stored_credential.previous_network_transaction_reference.id` | pattern: `^[a-zA-Z0-9-_@.:&+=*^'~#!$%()]+$`; minLength: `9`; maxLength: `36` |
| `payment_source.card.stored_credential.previous_network_transaction_reference.date` | pattern: `^[0-9]+$`; minLength: `4`; maxLength: `4` |
| `payment_source.card.stored_credential.previous_network_transaction_reference.acquirer_reference_number` | pattern: `^[a-zA-Z0-9]+$`; minLength: `1`; maxLength: `36` |
| `payment_source.card.network_token.number` | pattern: `^[0-9]{13,19}$`; minLength: `13`; maxLength: `19` |
| `payment_source.card.network_token.cryptogram` | pattern: `^.*$`; minLength: `28`; maxLength: `32` |
| `payment_source.card.network_token.eci_flag` | enum: `MASTERCARD_NON_3D_SECURE_TRANSACTION, MASTERCARD_ATTEMPTED_AUTHENTICATION_TRANSACTION, MASTERCARD_FULLY_AUTHENTICATED_TRANSACTION, FULLY_AUTHENTICATED_TRANSACTION, ATTEMPTED_AUTHENTICATION_TRANSACTION, NON_3D_SECURE_TRANSACTION` |
| `payment_source.card.network_token.token_requestor_id` | pattern: `^[0-9A-Z_]+$`; minLength: `1`; maxLength: `11` |
| `payment_source.token.id` | pattern: `^[0-9a-zA-Z_-]+$`; minLength: `1`; maxLength: `255` |
| `payment_source.token.type` | enum: `BILLING_AGREEMENT` |
| `payment_source.paypal.name.prefix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.name.given_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.name.surname` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.name.middle_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.name.suffix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.name.full_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.paypal.phone.phone_type` | enum: `FAX, HOME, MOBILE, OTHER, PAGER` |
| `payment_source.paypal.phone.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payment_source.paypal.tax_info.tax_id` | pattern: `^.*([a-zA-Z0-9]).*$`; minLength: `1`; maxLength: `14` |
| `payment_source.paypal.tax_info.tax_id_type` | enum: `BR_CPF, BR_CNPJ` |
| `payment_source.paypal.address.address_line_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.paypal.address.address_line_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.paypal.address.address_line_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.address.admin_area_4` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.address.admin_area_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.address.admin_area_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `120` |
| `payment_source.paypal.address.admin_area_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.paypal.address.postal_code` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `60` |
| `payment_source.paypal.address.country_code` | pattern: `^([A-Z]{2}\|C2)$`; minLength: `2`; maxLength: `2` |
| `payment_source.paypal.address.address_details.street_number` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.address.address_details.street_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.address.address_details.street_type` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.address.address_details.delivery_service` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.address.address_details.building_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.address.address_details.sub_building` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.customer.id` | pattern: `^[0-9a-zA-Z_-]+$`; minLength: `1`; maxLength: `22` |
| `payment_source.paypal.attributes.customer.phone.phone_type` | enum: `FAX, HOME, MOBILE, OTHER, PAGER` |
| `payment_source.paypal.attributes.customer.phone.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payment_source.paypal.attributes.customer.name.prefix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.customer.name.given_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.customer.name.surname` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.customer.name.middle_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.customer.name.suffix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.customer.name.full_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.paypal.attributes.customer.merchant_customer_id` | pattern: `^[0-9a-zA-Z-_.^*$@#]+$`; minLength: `1`; maxLength: `64` |
| `payment_source.paypal.attributes.vault.store_in_vault` | enum: `ON_SUCCESS` |
| `payment_source.paypal.attributes.vault.description` | pattern: `^[\S\s]*$`; minLength: `1`; maxLength: `128` |
| `payment_source.paypal.attributes.vault.usage_pattern` | enum: `IMMEDIATE, DEFERRED, RECURRING_PREPAID, RECURRING_POSTPAID, THRESHOLD_PREPAID, THRESHOLD_POSTPAID, SUBSCRIPTION_PREPAID, SUBSCRIPTION_POSTPAID, UNSCHEDULED_PREPAID, UNSCHEDULED_POSTPAID, INSTALLMENT_PREPAID, INSTALLMENT_POSTPAID` |
| `payment_source.paypal.attributes.vault.shipping.name.prefix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.vault.shipping.name.given_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.vault.shipping.name.surname` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.vault.shipping.name.middle_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.vault.shipping.name.suffix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.paypal.attributes.vault.shipping.name.full_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.paypal.attributes.vault.shipping.phone_number.country_code` | pattern: `^[0-9]{1,3}?$`; minLength: `1`; maxLength: `3` |
| `payment_source.paypal.attributes.vault.shipping.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payment_source.paypal.attributes.vault.shipping.phone_number.extension_number` | pattern: `^[0-9]{1,15}?$`; minLength: `1`; maxLength: `15` |
| `payment_source.paypal.attributes.vault.shipping.type` | enum: `SHIPPING, PICKUP_IN_PERSON, PICKUP_IN_STORE, PICKUP_FROM_PERSON` |
| `payment_source.paypal.attributes.vault.shipping.address.address_line_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.paypal.attributes.vault.shipping.address.address_line_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.paypal.attributes.vault.shipping.address.address_line_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.vault.shipping.address.admin_area_4` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.vault.shipping.address.admin_area_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.vault.shipping.address.admin_area_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `120` |
| `payment_source.paypal.attributes.vault.shipping.address.admin_area_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.paypal.attributes.vault.shipping.address.postal_code` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `60` |
| `payment_source.paypal.attributes.vault.shipping.address.country_code` | pattern: `^([A-Z]{2}\|C2)$`; minLength: `2`; maxLength: `2` |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.street_number` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.street_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.street_type` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.delivery_service` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.building_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.vault.shipping.address.address_details.sub_building` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.paypal.attributes.vault.usage_type` | enum: `MERCHANT, PLATFORM` |
| `payment_source.paypal.attributes.vault.customer_type` | enum: `CONSUMER, BUSINESS` |
| `payment_source.paypal.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.paypal.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.paypal.experience_context.contact_preference` | enum: `NO_CONTACT_INFO, UPDATE_CONTACT_INFO, RETAIN_CONTACT_INFO` |
| `payment_source.paypal.experience_context.app_switch_context.native_app.os_type` | enum: `ANDROID, IOS, OTHER` |
| `payment_source.paypal.experience_context.app_switch_context.native_app.os_version` | pattern: `^.*$`; minLength: `1`; maxLength: `64` |
| `payment_source.paypal.experience_context.app_switch_context.mobile_web.return_flow` | enum: `AUTO, MANUAL` |
| `payment_source.paypal.experience_context.app_switch_context.mobile_web.buyer_user_agent` | pattern: `^.*$`; minLength: `1`; maxLength: `512` |
| `payment_source.paypal.experience_context.landing_page` | enum: `LOGIN, GUEST_CHECKOUT, NO_PREFERENCE, BILLING` |
| `payment_source.paypal.experience_context.user_action` | enum: `CONTINUE, PAY_NOW` |
| `payment_source.paypal.experience_context.payment_method_preference` | enum: `UNRESTRICTED, IMMEDIATE_PAYMENT_REQUIRED` |
| `payment_source.paypal.experience_context.order_update_callback_config.callback_url` | minLength: `10`; maxLength: `2040` |
| `payment_source.paypal.billing_agreement_id` | pattern: `^[a-zA-Z0-9-]+$`; minLength: `2`; maxLength: `128` |
| `payment_source.paypal.stored_credential.payment_initiator` | enum: `CUSTOMER, MERCHANT` |
| `payment_source.paypal.stored_credential.usage_pattern` | enum: `IMMEDIATE, DEFERRED, RECURRING_PREPAID, RECURRING_POSTPAID, THRESHOLD_PREPAID, THRESHOLD_POSTPAID, SUBSCRIPTION_PREPAID, SUBSCRIPTION_POSTPAID, UNSCHEDULED_PREPAID, UNSCHEDULED_POSTPAID, INSTALLMENT_PREPAID, INSTALLMENT_POSTPAID` |
| `payment_source.paypal.stored_credential.usage` | enum: `FIRST, SUBSEQUENT, DERIVED` |
| `payment_source.bancontact.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.bancontact.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.blik.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.blik.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.blik.experience_context.consumer_user_agent` | pattern: `^.*$`; minLength: `1`; maxLength: `256` |
| `payment_source.blik.level_0.auth_code` | pattern: `^[0-9]{6}$`; minLength: `6`; maxLength: `6` |
| `payment_source.blik.one_click.auth_code` | pattern: `^[0-9]{6}$`; minLength: `6`; maxLength: `6` |
| `payment_source.blik.one_click.consumer_reference` | pattern: `^[ -~]{3,64}$`; minLength: `3`; maxLength: `64` |
| `payment_source.blik.one_click.alias_label` | pattern: `^[ -~]{8,35}$`; minLength: `8`; maxLength: `35` |
| `payment_source.blik.one_click.alias_key` | pattern: `^[0-9]+$`; minLength: `1`; maxLength: `19` |
| `payment_source.eps.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.eps.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.giropay.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.giropay.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.ideal.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.ideal.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.mybank.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.mybank.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.p24.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.p24.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.sofort.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.sofort.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.trustly.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.trustly.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.apple_pay.id` | pattern: `^.*$`; minLength: `1`; maxLength: `250` |
| `payment_source.apple_pay.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payment_source.apple_pay.decrypted_token.transaction_amount.currency_code` | pattern: `^[\S\s]*$`; minLength: `3`; maxLength: `3` |
| `payment_source.apple_pay.decrypted_token.transaction_amount.value` | pattern: `^((-?[0-9]+)\|(-?([0-9]+)?[.][0-9]+))$`; minLength: `0`; maxLength: `32` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.name` | pattern: `^.{1,300}$`; minLength: `1`; maxLength: `300` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.number` | pattern: `^[0-9]{13,19}$`; minLength: `13`; maxLength: `19` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.security_code` | pattern: `^[0-9]{3,4}$`; minLength: `3`; maxLength: `4` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.last_digits` | pattern: `^[0-9]{2,4}$`; minLength: `2`; maxLength: `4` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_line_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_4` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `120` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.admin_area_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.postal_code` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `60` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.country_code` | pattern: `^([A-Z]{2}\|C2)$`; minLength: `2`; maxLength: `2` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_number` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.street_type` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.delivery_service` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.building_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.billing_address.address_details.sub_building` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.id` | pattern: `^[0-9a-zA-Z_-]+$`; minLength: `1`; maxLength: `22` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.phone.phone_type` | enum: `FAX, HOME, MOBILE, OTHER, PAGER` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.phone.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.prefix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.given_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.surname` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.middle_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.suffix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.name.full_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.customer.merchant_customer_id` | pattern: `^[0-9a-zA-Z-_.^*$@#]+$`; minLength: `1`; maxLength: `64` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.vault.store_in_vault` | enum: `ON_SUCCESS` |
| `payment_source.apple_pay.decrypted_token.tokenized_card.attributes.verification.method` | enum: `SCA_ALWAYS, SCA_WHEN_REQUIRED, 3D_SECURE, AVS_CVV` |
| `payment_source.apple_pay.decrypted_token.device_manufacturer_id` | pattern: `^.*$`; minLength: `1`; maxLength: `2000` |
| `payment_source.apple_pay.decrypted_token.payment_data_type` | enum: `3DSECURE, EMV` |
| `payment_source.apple_pay.decrypted_token.payment_data.cryptogram` | pattern: `^.*$`; minLength: `1`; maxLength: `2000` |
| `payment_source.apple_pay.decrypted_token.payment_data.eci_indicator` | pattern: `^.*$`; minLength: `1`; maxLength: `256` |
| `payment_source.apple_pay.decrypted_token.payment_data.emv_data` | pattern: `^.*$`; minLength: `1`; maxLength: `2000` |
| `payment_source.apple_pay.decrypted_token.payment_data.pin` | pattern: `^.*$`; minLength: `1`; maxLength: `2000` |
| `payment_source.apple_pay.stored_credential.payment_initiator` | enum: `CUSTOMER, MERCHANT` |
| `payment_source.apple_pay.stored_credential.payment_type` | enum: `ONE_TIME, RECURRING, UNSCHEDULED` |
| `payment_source.apple_pay.stored_credential.usage` | enum: `FIRST, SUBSEQUENT, DERIVED` |
| `payment_source.apple_pay.stored_credential.previous_network_transaction_reference.id` | pattern: `^[a-zA-Z0-9-_@.:&+=*^'~#!$%()]+$`; minLength: `9`; maxLength: `36` |
| `payment_source.apple_pay.stored_credential.previous_network_transaction_reference.date` | pattern: `^[0-9]+$`; minLength: `4`; maxLength: `4` |
| `payment_source.apple_pay.stored_credential.previous_network_transaction_reference.acquirer_reference_number` | pattern: `^[a-zA-Z0-9]+$`; minLength: `1`; maxLength: `36` |
| `payment_source.apple_pay.attributes.customer.id` | pattern: `^[0-9a-zA-Z_-]+$`; minLength: `1`; maxLength: `22` |
| `payment_source.apple_pay.attributes.customer.phone.phone_type` | enum: `FAX, HOME, MOBILE, OTHER, PAGER` |
| `payment_source.apple_pay.attributes.customer.phone.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payment_source.apple_pay.attributes.customer.name.prefix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.attributes.customer.name.given_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.attributes.customer.name.surname` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.attributes.customer.name.middle_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.attributes.customer.name.suffix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.apple_pay.attributes.customer.name.full_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.apple_pay.attributes.vault.store_in_vault` | enum: `ON_SUCCESS` |
| `payment_source.google_pay.phone_number.country_code` | pattern: `^[0-9]{1,3}?$`; minLength: `1`; maxLength: `3` |
| `payment_source.google_pay.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payment_source.google_pay.card.name` | pattern: `^.{1,300}$`; minLength: `1`; maxLength: `300` |
| `payment_source.google_pay.card.number` | pattern: `^[0-9]{13,19}$`; minLength: `13`; maxLength: `19` |
| `payment_source.google_pay.card.last_digits` | pattern: `^[0-9]{2,4}$`; minLength: `2`; maxLength: `4` |
| `payment_source.google_pay.card.billing_address.address_line_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.google_pay.card.billing_address.address_line_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.google_pay.card.billing_address.address_line_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.card.billing_address.admin_area_4` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.card.billing_address.admin_area_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.card.billing_address.admin_area_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `120` |
| `payment_source.google_pay.card.billing_address.admin_area_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.google_pay.card.billing_address.postal_code` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `60` |
| `payment_source.google_pay.card.billing_address.country_code` | pattern: `^([A-Z]{2}\|C2)$`; minLength: `2`; maxLength: `2` |
| `payment_source.google_pay.card.billing_address.address_details.street_number` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.card.billing_address.address_details.street_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.card.billing_address.address_details.street_type` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.card.billing_address.address_details.delivery_service` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.card.billing_address.address_details.building_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.card.billing_address.address_details.sub_building` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.message_id` | pattern: `^.*$`; minLength: `1`; maxLength: `250` |
| `payment_source.google_pay.decrypted_token.message_expiration` | pattern: `^\d{13}$`; minLength: `13`; maxLength: `13` |
| `payment_source.google_pay.decrypted_token.payment_method` | enum: `CARD` |
| `payment_source.google_pay.decrypted_token.card.name` | pattern: `^.{1,300}$`; minLength: `1`; maxLength: `300` |
| `payment_source.google_pay.decrypted_token.card.number` | pattern: `^[0-9]{13,19}$`; minLength: `13`; maxLength: `19` |
| `payment_source.google_pay.decrypted_token.card.last_digits` | pattern: `^[0-9]{2,4}$`; minLength: `2`; maxLength: `4` |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_line_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_line_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_line_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.card.billing_address.admin_area_4` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.card.billing_address.admin_area_3` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.card.billing_address.admin_area_2` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `120` |
| `payment_source.google_pay.decrypted_token.card.billing_address.admin_area_1` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.google_pay.decrypted_token.card.billing_address.postal_code` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `60` |
| `payment_source.google_pay.decrypted_token.card.billing_address.country_code` | pattern: `^([A-Z]{2}\|C2)$`; minLength: `2`; maxLength: `2` |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_number` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.street_type` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.delivery_service` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.building_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.card.billing_address.address_details.sub_building` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `100` |
| `payment_source.google_pay.decrypted_token.authentication_method` | enum: `PAN_ONLY, CRYPTOGRAM_3DS` |
| `payment_source.google_pay.decrypted_token.cryptogram` | pattern: `^[\S\s]*$`; minLength: `1`; maxLength: `2000` |
| `payment_source.google_pay.decrypted_token.eci_indicator` | pattern: `^.*$`; minLength: `1`; maxLength: `256` |
| `payment_source.venmo.experience_context.brand_name` | pattern: `^.*$`; minLength: `1`; maxLength: `127` |
| `payment_source.venmo.experience_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `payment_source.venmo.experience_context.order_update_callback_config.callback_url` | minLength: `10`; maxLength: `2040` |
| `payment_source.venmo.experience_context.user_action` | enum: `CONTINUE, PAY_NOW` |
| `payment_source.venmo.attributes.customer.id` | pattern: `^[0-9a-zA-Z_-]+$`; minLength: `1`; maxLength: `22` |
| `payment_source.venmo.attributes.customer.phone.phone_type` | enum: `FAX, HOME, MOBILE, OTHER, PAGER` |
| `payment_source.venmo.attributes.customer.phone.phone_number.national_number` | pattern: `^[0-9]{1,14}?$`; minLength: `1`; maxLength: `14` |
| `payment_source.venmo.attributes.customer.name.prefix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.venmo.attributes.customer.name.given_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.venmo.attributes.customer.name.surname` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.venmo.attributes.customer.name.middle_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.venmo.attributes.customer.name.suffix` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `140` |
| `payment_source.venmo.attributes.customer.name.full_name` | pattern: `^[\S\s]*$`; minLength: `0`; maxLength: `300` |
| `payment_source.venmo.attributes.vault.store_in_vault` | enum: `ON_SUCCESS` |
| `payment_source.venmo.attributes.vault.description` | pattern: `^[a-zA-Z0-9_'\-., :;\!?"]*$`; minLength: `1`; maxLength: `128` |
| `payment_source.venmo.attributes.vault.usage_pattern` | enum: `IMMEDIATE, DEFERRED, RECURRING_PREPAID, RECURRING_POSTPAID, THRESHOLD_PREPAID, THRESHOLD_POSTPAID` |
| `payment_source.venmo.attributes.vault.usage_type` | enum: `MERCHANT, PLATFORM` |
| `payment_source.venmo.attributes.vault.customer_type` | enum: `CONSUMER, BUSINESS` |
| `payment_source.crypto.name.prefix` | pattern: `^[\S\s]*$`; minLength: `1`; maxLength: `140` |
| `payment_source.crypto.name.given_name` | pattern: `^[\S\s]*$`; minLength: `1`; maxLength: `140` |
| `payment_source.crypto.name.surname` | pattern: `^[\S\s]*$`; minLength: `1`; maxLength: `140` |
| `payment_source.crypto.name.middle_name` | pattern: `^[\S\s]*$`; minLength: `1`; maxLength: `140` |
| `application_context.brand_name` | pattern: `^[\S\s]*$`; minLength: `1`; maxLength: `127` |
| `application_context.landing_page` | enum: `LOGIN, BILLING, NO_PREFERENCE` |
| `application_context.shipping_preference` | enum: `GET_FROM_FILE, NO_SHIPPING, SET_PROVIDED_ADDRESS` |
| `application_context.user_action` | enum: `CONTINUE, PAY_NOW` |
| `application_context.payment_method.payee_preferred` | enum: `UNRESTRICTED, IMMEDIATE_PAYMENT_REQUIRED` |
| `application_context.payment_method.standard_entry_class_code` | enum: `TEL, WEB, CCD, PPD` |
| `application_context.return_url` | minLength: `0`; maxLength: `2147483647` |
| `application_context.cancel_url` | minLength: `0`; maxLength: `2147483647` |
| `application_context.stored_payment_source.payment_initiator` | enum: `CUSTOMER, MERCHANT` |
| `application_context.stored_payment_source.payment_type` | enum: `ONE_TIME, RECURRING, UNSCHEDULED` |
| `application_context.stored_payment_source.usage` | enum: `FIRST, SUBSEQUENT, DERIVED` |
| `application_context.stored_payment_source.previous_network_transaction_reference.id` | pattern: `^[a-zA-Z0-9-_@.:&+=*^'~#!$%()]+$`; minLength: `9`; maxLength: `36` |
| `application_context.stored_payment_source.previous_network_transaction_reference.date` | pattern: `^[0-9]+$`; minLength: `4`; maxLength: `4` |
| `application_context.stored_payment_source.previous_network_transaction_reference.acquirer_reference_number` | pattern: `^[a-zA-Z0-9]+$`; minLength: `1`; maxLength: `36` |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
| 400 | `bad_request` | не повторять автоматически |
| 401 | `unauthorized` | исправить учётные данные и уведомить сопровождение |
| 403 | `forbidden` | не повторять автоматически |
| 404 | `bad_request` | не повторять автоматически |
| 409 | `unprocessable_entity` | не повторять автоматически |
| 422 | `unprocessable_entity` | не повторять автоматически |
| 500 | `internal_server_error` | повторить с увеличивающейся задержкой |

## Конфигурация ProviderGateway

Не задана. Укажите `provider_gateway.external_method` и `provider_gateway.gateway` в overrides после подтверждения бизнес-маршрута.

## Подпись webhook

В спецификации не обнаружена.

`process_callback` получает уже разобранный JSON в `payload`, без исходного тела и заголовков. Поэтому криптографическую проверку подписи нельзя корректно выполнить внутри сгенерированного сервиса: её следует делать на уровне платформы до разбора JSON. Сервис не имитирует проверку по повторно сериализованному объекту.

## Подтверждённые overrides

Не переданы. Элементы из свободного текста остаются TODO в предупреждениях.

## Предупреждения генератора

- Не удалось определить входящий webhook.
- Для POST /v2/checkout/orders не поддерживается объявленная схема авторизации; требуется явная реализация.
- Для GET /v2/checkout/orders/{id} не поддерживается объявленная схема авторизации; требуется явная реализация.
- TODO field_map intent: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map purchase_units: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
