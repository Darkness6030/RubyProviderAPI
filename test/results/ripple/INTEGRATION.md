# Руководство по интеграции Ripple

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 4. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://api.test.ripple.com`
- Переменная окружения: `RIPPLE_BASE_URL`
- API-ключ: `RIPPLE_API_KEY`

Адреса из OpenAPI:

- UAT environment with simulated currency: `https://api.test.ripple.com`
- Production environment: `https://api.ripple.com`

## Авторизация

- `Bearer`: http,  ``
- `BasicAuth`: http,  ``

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `authenticate` | POST `/v2/oauth/token` | Request an access token | — |
| `testAuthToken` | GET `/v2/oauth/token/test` | Test access token | — |
| `searchPaymentsV2` | POST `/v3/payments/filter` | Search payments | — |
| `createPaymentV2` | POST `/v3/payments` | Create payment | — |
| `getPaymentByIdV2` | GET `/v3/payments/{paymentId}` | Get a payment by ID | — |
| `getPaymentStateTransitionsByIdV2` | GET `/v3/payments/{paymentId}/states` | Get state transitions by payment ID | — |
| `updatePaymentLabelsV2` | PATCH `/v3/payments/{paymentId}/labels` | Update payment labels | — |
| `getIdentities` | GET `/v3/identities` | Get a list of identities | — |
| `createIdentity` | POST `/v3/identities` | Create an identity | — |
| `getIdentityById` | GET `/v3/identities/{identity-id}` | Get an identity by ID | — |
| `putIdentity` | PUT `/v3/identities/{identity-id}` | Update an identity | — |
| `deactivateIdentityV3` | DELETE `/v3/identities/{identity-id}` | Deactivate an identity | — |
| `getIdentityByInternalId` | GET `/v3/identities/by-internal-id/{internal-id}` | Get an identity by Internal ID | — |
| `getFinancialInstruments` | GET `/v3/identities/{identity-id}/financial-instruments` | Get a list of financial instruments of the identity | — |
| `createFinancialInstrument` | POST `/v3/identities/{identity-id}/financial-instruments` | Add a financial instrument | — |
| `getFinancialInstrumentById` | GET `/v3/identities/{identity-id}/financial-instruments/{financial-instrument-id}` | Get a financial instrument by ID | — |
| `putFinancialInstrument` | PUT `/v3/identities/{identity-id}/financial-instruments/{financial-instrument-id}` | Update a financial instrument | — |
| `deactivateFinancialInstrumentV3` | DELETE `/v3/identities/{identity-id}/financial-instruments/{financial-instrument-id}` | Deactivate a Financial Instrument | — |
| `createQuoteCollection` | POST `/v2/quotes/quote-collection` | Create quote collection | — |
| `getQuoteCollection` | GET `/v2/quotes/quote-collection/{quote-collection-id}` | Get quote collection | — |
| `getQuote` | GET `/v2/quotes/{quote-id}` | Get quote | — |
| `getBalances` | GET `/v2/balances` | Get available balances | — |
| `getStatementsTransactionsForCustomer` | GET `/v2/ledger-transactions` | Get ledger transactions | — |

## Обоснование выбора операций

- `create` (создание): POST `/v3/payments` — оценка 74; следующий кандидат POST `/v3/identities/{identity-id}/financial-instruments` — оценка 35; разница 39.
- `status` (проверка статуса): GET `/v3/payments/{paymentId}` — оценка 85; следующий кандидат GET `/v3/payments/{paymentId}/states` — оценка 73; разница 12.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `INITIATED` | `in_progress` |
| `QUOTED` | `in_progress` |
| `VALIDATING` | `in_progress` |
| `TRANSFERRING` | `in_progress` |
| `COMPLETED` | `approved` |
| `FAILED` | `rejected` |
| `RETURNED` | `rejected` |
| `DECLINED` | `rejected` |
| `AWAITING_FUNDING` | `in_progress` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `quoteId` | **TODO:** подтвердить схему платформы |
| `originatorIdentityId` | **TODO:** подтвердить схему платформы |
| `beneficiaryIdentityId` | **TODO:** подтвердить схему платформы |
| `internalId` | **TODO:** подтвердить схему платформы |
| `purposeCode` | **TODO:** подтвердить схему платформы |
| `sourceOfCash` | **TODO:** подтвердить схему платформы |
| `paymentLabels` | **TODO:** подтвердить схему платформы |
| `beneficiaryFinancialInstrumentId` | **TODO:** подтвердить схему платформы |
| `receiverRelationship` | **TODO:** подтвердить схему платформы |
| `paymentMemo` | **TODO:** подтвердить схему платформы |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
| 400 | `bad_request` | не повторять автоматически |
| 401 | `unauthorized` | исправить учётные данные и уведомить сопровождение |
| 402 | `unprocessable_entity` | повторить позже |
| 403 | `forbidden` | не повторять автоматически |
| 404 | `bad_request` | не повторять автоматически |
| 405 | `internal_server_error` | не повторять автоматически |
| 409 | `unprocessable_entity` | не повторять автоматически |
| 415 | `internal_server_error` | не повторять автоматически |
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
- TODO field_map quoteId: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map beneficiaryIdentityId: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map beneficiaryFinancialInstrumentId: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
