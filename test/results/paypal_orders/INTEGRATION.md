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
| `payer` | **TODO:** подтвердить схему платформы |
| `purchase_units` | **TODO:** подтвердить схему платформы |
| `payment_source.card` | **TODO:** подтвердить схему платформы |
| `payment_source.token.id` | **TODO:** подтвердить схему платформы |
| `payment_source.token.type` | `literal:BILLING_AGREEMENT` |
| `payment_source.paypal` | **TODO:** подтвердить схему платформы |
| `payment_source.bancontact` | **TODO:** подтвердить схему платформы |
| `payment_source.blik` | **TODO:** подтвердить схему платформы |
| `payment_source.eps` | **TODO:** подтвердить схему платформы |
| `payment_source.giropay` | **TODO:** подтвердить схему платформы |
| `payment_source.ideal` | **TODO:** подтвердить схему платформы |
| `payment_source.mybank` | **TODO:** подтвердить схему платформы |
| `payment_source.p24` | **TODO:** подтвердить схему платформы |
| `payment_source.sofort` | **TODO:** подтвердить схему платформы |
| `payment_source.trustly` | **TODO:** подтвердить схему платформы |
| `payment_source.apple_pay` | **TODO:** подтвердить схему платформы |
| `payment_source.google_pay` | **TODO:** подтвердить схему платформы |
| `payment_source.venmo` | **TODO:** подтвердить схему платформы |
| `payment_source.crypto` | **TODO:** подтвердить схему платформы |
| `application_context` | **TODO:** подтвердить схему платформы |

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
