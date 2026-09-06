# Руководство по интеграции Yookassa

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 4. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://api.yookassa.ru/v3`
- Переменная окружения: `YOOKASSA_BASE_URL`
- API-ключ: `YOOKASSA_API_KEY`

Адреса из OpenAPI:

- API: `https://api.yookassa.ru/v3`

## Авторизация

- `BasicAuth`: http,  ``
- `OAuth2`: oauth2,  ``

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `get_/payments` | GET `/payments` | List payments | — |
| `post_/payments` | POST `/payments` | Create a payment | — |
| `get_/payments/{payment_id}` | GET `/payments/{payment_id}` | Get payment information | — |
| `post_/payments/{payment_id}/capture` | POST `/payments/{payment_id}/capture` | Capture a payment | — |
| `post_/payments/{payment_id}/cancel` | POST `/payments/{payment_id}/cancel` | Cancel a payment | — |
| `post_/payment_methods` | POST `/payment_methods` | Создание способа оплаты | — |
| `get_/payment_methods/{payment_method_id}` | GET `/payment_methods/{payment_method_id}` | Информация о способе оплаты | — |
| `post_/invoices` | POST `/invoices` | Создание счета | — |
| `get_/invoices/{invoice_id}` | GET `/invoices/{invoice_id}` | Информация о счете | — |
| `get_/refunds` | GET `/refunds` | Список возвратов | — |
| `post_/refunds` | POST `/refunds` | Создание возврата | — |
| `get_/refunds/{refund_id}` | GET `/refunds/{refund_id}` | Информация о возврате | — |
| `get_/receipts` | GET `/receipts` | Список чеков | — |
| `post_/receipts` | POST `/receipts` | Создание чека | — |
| `get_/receipts/{receipt_id}` | GET `/receipts/{receipt_id}` | Информация о чеке | — |
| `get_/deals` | GET `/deals` | Список сделок | — |
| `post_/deals` | POST `/deals` | Создание сделки | — |
| `get_/deals/{deal_id}` | GET `/deals/{deal_id}` | Информация о сделке | — |
| `get_/payouts` | GET `/payouts` | List of payouts | — |
| `post_/payouts` | POST `/payouts` | Создание выплаты | — |
| `get_/payouts/search` | GET `/payouts/search` | Search for payouts | — |
| `get_/payouts/{payout_id}` | GET `/payouts/{payout_id}` | Информация о выплате | — |
| `get_/sbp_banks` | GET `/sbp_banks` | Список участников СБП | — |
| `post_/personal_data` | POST `/personal_data` | Создание персональных данных | — |
| `get_/personal_data/{personal_data_id}` | GET `/personal_data/{personal_data_id}` | Информация о персональных данных | — |
| `get_/webhooks` | GET `/webhooks` | List created webhooks | — |
| `post_/webhooks` | POST `/webhooks` | Create a webhook | — |
| `delete_/webhooks/{webhook_id}` | DELETE `/webhooks/{webhook_id}` | Delete webhook | — |
| `get_/me` | GET `/me` | Get information about the settings of a store or gateway | — |
| `post_/pos_links` | POST `/pos_links` | Активация кассовой ссылки | — |
| `post_/pos_links/{pos_link_id}/recipient` | POST `/pos_links/{pos_link_id}/recipient` | Изменение торговой точки, привязанной к кассовой ссылке | — |
| `post_/pos_links/{pos_link_id}/deactivate` | POST `/pos_links/{pos_link_id}/deactivate` | Деактивация кассовой ссылки | — |
| `post_/pos_links/{pos_link_id}/activate` | POST `/pos_links/{pos_link_id}/activate` | Активация ранее деактивированной кассовой ссылки | — |
| `get_/pos_links/{pos_link_id}` | GET `/pos_links/{pos_link_id}` | Информация о кассовой ссылке | — |

## Обоснование выбора операций

- `create` (создание): POST `/payouts` — оценка 108; следующий кандидат POST `/payments` — оценка 90; разница 18.
- `status` (проверка статуса): GET `/payouts/{payout_id}` — оценка 67; следующий кандидат POST `/payouts` — оценка 12; разница 55.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `pending` | `in_progress` |
| `succeeded` | `approved` |
| `canceled` | `rejected` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `amount` | `operation.amount` |
| `payout_destination_data` | **TODO:** подтвердить схему платформы |
| `payout_token` | **TODO:** подтвердить схему платформы |
| `payment_method_id` | **TODO:** подтвердить схему платформы |
| `description` | **TODO:** подтвердить схему платформы |
| `deal.id` | **TODO:** подтвердить схему платформы |
| `personal_data` | **TODO:** подтвердить схему платформы |
| `metadata` | **TODO:** подтвердить схему платформы |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
| 400 | `bad_request` | не повторять автоматически |
| 401 | `unauthorized` | исправить учётные данные и уведомить сопровождение |
| 403 | `forbidden` | не повторять автоматически |
| 404 | `bad_request` | не повторять автоматически |
| 429 | `too_many_requests` | повторить с увеличивающейся задержкой |
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
- TODO required_if payout_token: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO field_map amount.value: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map amount.currency: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
