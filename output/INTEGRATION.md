# Руководство по интеграции Novapay

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** критичных предупреждений нет; перед рабочим подключением артефакты всё равно требуют контрактного ревью.

## Подключение

- Базовый URL по умолчанию: `https://api.sandbox.novapay.example/v1`
- Переменная окружения: `NOVAPAY_BASE_URL`
- API-ключ: `NOVAPAY_API_KEY`

Адреса из OpenAPI:

- Sandbox: `https://api.sandbox.novapay.example/v1`
- Production: `https://api.novapay.example/v1`

## Авторизация

- `ApiKeyAuth`: apiKey, header `X-API-Key`

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `createPayout` | POST `/payouts` | Создать выплату | да |
| `getPayoutStatus` | GET `/payouts/{payout_id}` | Получить статус выплаты | — |
| `cancelPayout` | POST `/payouts/{payout_id}/cancel` | Отменить выплату | — |
| `payoutWebhook` | POST `/webhooks/payout` | Webhook уведомление о смене статуса | — |
| `getBalance` | GET `/balance` | Баланс провайдера | — |

## Обоснование выбора операций

- `create` (создание): POST `/payouts` — оценка 108; следующий кандидат GET `/payouts/{payout_id}` — оценка 11; разница 97.
- `status` (проверка статуса): GET `/payouts/{payout_id}` — оценка 150; следующий кандидат POST `/payouts` — оценка 12; разница 138.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `pending` | `in_progress` |
| `processing` | `in_progress` |
| `completed` | `approved` |
| `failed` | `rejected` |
| `cancelled` | `rejected` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `amount` | `operation.amount` |
| `currency` | `literal:RUB` |
| `external_id` | `operation.id` |
| `recipient.type` | `payout_type` |
| `recipient.phone` | `payout_requisite.sbp.phone` |
| `recipient.bank_code` | `payout_requisite.sbp.bank_code` |
| `recipient.bank_name` | `payout_requisite.sbp.bank_name` |
| `recipient.card_number` | `payout_requisite.card_number` |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
| 400 | `bad_request` | не повторять автоматически |
| 401 | `unauthorized` | исправить учётные данные и уведомить сопровождение |
| 402 | `unprocessable_entity` | повторить позже |
| 404 | `bad_request` | не повторять автоматически |
| 409 | `unprocessable_entity` | не повторять автоматически |
| 422 | `unprocessable_entity` | не повторять автоматически |
| 429 | `too_many_requests` | повторить с увеличивающейся задержкой |
| 500 | `internal_server_error` | повторить с увеличивающейся задержкой |

## Конфигурация ProviderGateway

```json
{
  "external_method": "sbp_payout",
  "gateway": "RUB_SBP_WITHDRAW"
}
```

## Подпись webhook

X-NovaPay-Signature / HMAC-SHA256 / hex / проверка платформой до разбора JSON

`process_callback` получает уже разобранный JSON в `payload`, без исходного тела и заголовков. Поэтому криптографическую проверку подписи нельзя корректно выполнить внутри сгенерированного сервиса: её следует делать на уровне платформы до разбора JSON. Сервис не имитирует проверку по повторно сериализованному объекту.

## Подтверждённые overrides

- Единица суммы: `minor`, множитель `100`.
- `recipient.phone` обязательно, когда `recipient.type = sbp`.
- `recipient.bank_code` обязательно, когда `recipient.type = sbp`.
- `recipient.card_number` обязательно, когда `recipient.type = card`.
- Подпись: `HMAC-SHA256`, кодирование `hex`, заголовок `X-NovaPay-Signature`; проверка выполняется платформой до разбора JSON.

## Предупреждения генератора

Нет.
