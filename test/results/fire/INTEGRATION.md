# Руководство по интеграции Fire

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 2. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://api.fire.com/business`
- Переменная окружения: `FIRE_BASE_URL`
- API-ключ: `FIRE_API_KEY`

Адреса из OpenAPI:

- Production Server: `https://api.fire.com/business`

## Авторизация

- `bearerAuth`: http,  ``

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `authenticate` | POST `/v1/apps/accesstokens` | Authenticate with the API. | — |
| `getAccounts` | GET `/v1/accounts` | List accounts | — |
| `addAccount` | POST `/v1/accounts` | Create a new Fire Account. | — |
| `getAccountsV2` | GET `/v2/accounts` | List accounts (V2) | — |
| `getAccountByIdV2` | GET `/v2/accounts/{ican}` | Get details of an account (V2) | — |
| `updateAccountConfig` | PUT `/v2/accounts/{ican}` | Update account configuration | — |
| `requestInternationalDetails` | PUT `/v2/accounts/{ican}/internationaldetails` | Request international account details | — |
| `getActivities` | GET `/v2/activities` | Get activity | — |
| `getAccountById` | GET `/v1/accounts/{ican}` | Get details of an account | — |
| `getTransactionsByAccountIdv3` | GET `/v3/accounts/{ican}/transactions` | List transactions for an account | — |
| `getListofCards` | GET `/v1/cards` | List debit cards | — |
| `createNewCard` | POST `/v1/cards` | Create a new Fire debit card | — |
| `getListofCardTransactions` | GET `/v1/me/cards/{cardId}/transactions` | Get a list of debit card transactions | — |
| `blockCard` | POST `/v1/me/cards/{cardId}/block` | Block a Fire debit card | — |
| `unblockCard` | POST `/v1/me/cards/{cardId}/unblock` | Unblock a Fire debit card | — |
| `newPaymentRequest` | POST `/v1/paymentrequests` | Create a payment request | — |
| `getPaymentRequestDetails` | GET `/v1/paymentrequests/{paymentRequestCode}` | Get payment request details | — |
| `getPaymentRequestPaymentsv2` | GET `/v2/paymentrequests/{paymentRequestCode}/payments` | Get list of all payment attempts related to a payment request | — |
| `getPaymentRequestReportV2` | GET `/v2/paymentrequests/{paymentRequestCode}/reports` | Get a report from a payment request | — |
| `getPaymentRequestsSentV2` | GET `/v2/paymentrequests/sent` | Get a list of payment request transactions | — |
| `getPublicPaymentRequest` | GET `/v2/paymentrequests/{paymentRequestCode}/public` | List details of a public payment request | — |
| `getFXRates` | GET `/v2/fx/rate` | Get FX rates | — |
| `getLimits` | GET `/v2/limits` | List all limits | — |
| `sendTestWebhook` | GET `/v2/webhooks/{webhookId}/events/{event}/test` | Send test webhooks | — |
| `getWebhookEvents` | GET `/v2/webhooks` | List all webhooks | — |
| `getNewPayeeBatch` | GET `/v2/batches/{batchUuid}/newpayees` | List new payees in a batch | — |
| `getPaymentDetailsv2` | GET `/v2/payments/{paymentUuid}` | Get payment details | — |
| `getListOfAspsps` | GET `/v1/aspsps` | Get list of ASPSPs / Banks | — |
| `getUsers` | GET `/v1/users` | List all users | — |
| `getUser` | GET `/v1/users/{userId}` | Get the details of a user | — |
| `getApiApplications` | GET `/v1/apps` | List all API applications | — |
| `createApiApplication` | POST `/v1/apps` | Create an API Application | — |
| `getPermissions` | GET `/v1/apps/{applicationId}/permissions` | List all permissions for an API application | — |
| `getAllPermissions` | GET `/v1/apps/permissions` | List all permissions for API applications | — |
| `getPayees` | GET `/v1/payees` | List payees | — |
| `getPayeeDetails` | GET `/v1/payees/{payeeId}` | Get details of a payee | — |
| `getPayeeTransactions` | GET `/v1/payees/{payeeId}/transactions` | List transaction for a payee account | — |
| `getDirectDebitsForMandateUuid` | GET `/v1/directdebits` | List all direct debits | — |
| `getDirectDebitByUuid` | GET `/v1/directdebits/{directDebitUuid}` | Get the details of a direct debit | — |
| `rejectDirectDebit` | POST `/v1/directdebits/{directDebitUuid}/reject` | Reject a direct debit | — |
| `getDirectDebitMandates` | GET `/v1/mandates` | List all direct debit mandates | — |
| `getMandate` | GET `/v1/mandates/{mandateUuid}` | Get the details of a direct debit mandate | — |
| `updateMandateAlias` | PUT `/v1/mandates/{mandateUuid}` | Update direct debit mandate alias | — |
| `cancelMandateByUuid` | POST `/v1/mandates/{mandateUuid}/cancel` | Cancel a direct debit mandate | — |
| `activateMandate` | POST `/v1/mandates/{mandateUuid}/activate` | Activate a direct debit mandate | — |
| `getBatches` | GET `/v1/batches` | List all batches | — |
| `createBatchPayment` | POST `/v1/batches` | Create a new batch | — |
| `getItemsBatchInternalTrasnfer` | GET `/v1/batches/{batchUuid}/internaltransfers` | List items for an internal transfer batch | — |
| `addInternalTransferBatchPayment` | POST `/v1/batches/{batchUuid}/internaltransfers` | Add an internal transfer to a Batch | — |
| `getItemsBatchBankTransfer` | GET `/v1/batches/{batchUuid}/banktransfers` | List items for a bank transfer batch | — |
| `addBankTransferBatchPayment` | POST `/v1/batches/{batchUuid}/banktransfers` | Add a bank transfer to a batch. | — |
| `getItemsBatchInternationalTransfer` | GET `/v2/batches/{batchUuid}/internationaltransfers` | List items for an international transfer batch | — |
| `addInternationalTransferBatchPayment` | POST `/v2/batches/{batchUuid}/internationaltransfers` | Add an international transfer to a Batch | — |
| `deleteInternalTransferBatchPayment` | DELETE `/v1/batches/{batchUuid}/internaltransfers/{itemUuid}` | Remove an internal transfer from a batch | — |
| `deleteBankTransferBatchPayment` | DELETE `/v1/batches/{batchUuid}/banktransfers/{itemUuid}` | Remove a bank transfer from a batch. | — |
| `deleteInternationalTransferBatchPayment` | DELETE `/v2/batches/{batchUuid}/internationaltransfers/{itemUuid}` | Remove an international transfer from a batch | — |
| `getDetailsSingleBatch` | GET `/v1/batches/{batchUuid}` | Get the details of a batch | — |
| `submitBatch` | PUT `/v1/batches/{batchUuid}` | Submit a batch | — |
| `cancelBatchPayment` | DELETE `/v1/batches/{batchUuid}` | Cancel a batch | — |
| `getListofApproversForBatch` | GET `/v1/batches/{batchUuid}/approvals` | List approvals for a batch. | — |
| `getUserAddress` | GET `/v2/users/{userId}/address` | Get the address of a user | — |
| `getServiceFees` | GET `/v2/services` | Get service Fees and info | — |
| `updatePaymentRequest` | PUT `/v2/paymentrequests/{paymentRequestCode}/status` | Update the status of a payment request | — |
| `post_webhook` | POST `webhook` | Event Webhook | — |

## Обоснование выбора операций

- `create` (создание): POST `/v1/batches` — оценка 57; следующий кандидат POST `/v1/paymentrequests` — оценка 51; разница 6.
- `status` (проверка статуса): GET `/v1/batches/{batchUuid}` — оценка 57; следующий кандидат GET `/v2/payments/{paymentUuid}` — оценка 50; разница 7.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `PENDING_APPROVAL` | `in_progress` |
| `REJECTED` | `rejected` |
| `COMPLETE` | `approved` |
| `OPEN` | `in_progress` |
| `CANCELLED` | `rejected` |
| `PENDING_PARENT_BATCH_APPROVAL` | `in_progress` |
| `READY_FOR_PROCESSING` | `in_progress` |
| `PROCESSING` | `in_progress` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `type` | **TODO:** подтвердить схему платформы |
| `currency` | **TODO:** подтвердить схему платформы |
| `batchName` | **TODO:** подтвердить схему платформы |
| `jobNumber` | **TODO:** подтвердить схему платформы |
| `callbackUrl` | **TODO:** подтвердить схему платформы |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
| 400 | `bad_request` | не повторять автоматически |
| 401 | `unauthorized` | исправить учётные данные и уведомить сопровождение |
| 403 | `forbidden` | не повторять автоматически |

## Конфигурация ProviderGateway

Не задана. Укажите `provider_gateway.external_method` и `provider_gateway.gateway` в overrides после подтверждения бизнес-маршрута.

## Подпись webhook

В спецификации не обнаружена.

`process_callback` получает уже разобранный JSON в `payload`, без исходного тела и заголовков. Поэтому криптографическую проверку подписи нельзя корректно выполнить внутри сгенерированного сервиса: её следует делать на уровне платформы до разбора JSON. Сервис не имитирует проверку по повторно сериализованному объекту.

## Подтверждённые overrides

Не переданы. Элементы из свободного текста остаются TODO в предупреждениях.

## Предупреждения генератора

- Неоднозначный выбор операции создания: POST /v1/batches — оценка 57; следующий кандидат POST /v1/paymentrequests — оценка 51; разница 6. Проверьте выбор вручную.
- Неоднозначный выбор операции проверки статуса: GET /v1/batches/{batchUuid} — оценка 57; следующий кандидат GET /v2/payments/{paymentUuid} — оценка 50; разница 7. Проверьте выбор вручную.
