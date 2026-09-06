# Руководство по интеграции Tbank

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 9. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://securepay.tinkoff.ru`
- Переменная окружения: `TBANK_BASE_URL`
- API-ключ: `TBANK_API_KEY`

Адреса из OpenAPI:

- production: `https://securepay.tinkoff.ru`
- test: `https://rest-api-test.tinkoff.ru`

## Авторизация

Авторизация в спецификации не объявлена.

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `Init` | POST `/v2/Init` | Инициировать платеж | — |
| `Check3dsVersion` | POST `/v2/Check3dsVersion` | Проверить версию 3DS | — |
| `ThreeDSMethod` | POST `/v2/ThreeDSMethod` | Пройти этап 3DS Method | — |
| `FinishAuthorize` | POST `/v2/FinishAuthorize` | Подтвердить платеж | — |
| `Confirm` | POST `/v2/Confirm` | Подтвердить списание | — |
| `Cancel` | POST `/v2/Cancel` | Отменить платеж | — |
| `Charge` | POST `/v2/Charge` | Провести платеж по сохраненным реквизитам | — |
| `GetState` | POST `/v2/GetState` | Получить статус платежа | — |
| `AddCustomer` | POST `/v2/AddCustomer` | Зарегистрировать покупателя | — |
| `GetCustomer` | POST `/v2/GetCustomer` | Получить данные покупателя | — |
| `RemoveCustomer` | POST `/v2/RemoveCustomer` | Удалить данные покупателя | — |
| `AddCard` | POST `/v2/AddCard` | Инициировать привязку карты к покупателю | — |
| `AttachCard` | POST `/v2/AttachCard` | Привязать карту | — |
| `AcsUrl` | POST `/v2/AcsUrl` | Отправить запрос в банк-эмитент для прохождения 3DS | — |
| `Submit3DSAuthorization` | POST `/v2/Submit3DSAuthorization` | Подтвердить прохождение 3DS v1.0 | — |
| `Submit3DSAuthorizationV2` | POST `/v2/Submit3DSAuthorizationV2` | Подтвердить прохождение 3DS v2.1 | — |
| `GetAddCardState` | POST `/v2/GetAddCardState` | Получить статус привязки карты | — |
| `GetCardList` | POST `/v2/GetCardList` | Получить список карт покупателя | — |
| `RemoveCard` | POST `/v2/RemoveCard` | Удалить привязанную карту покупателя | — |
| `GetQr` | POST `/v2/GetQr` | Сформировать QR | — |
| `Status` | GET `/v2/TinkoffPay/terminals/{TerminalKey}/status` | Определить возможность проведения платежа | — |
| `Link` | GET `/v2/TinkoffPay/transactions/{paymentId}/versions/{version}/link` | Получить ссылку | — |
| `Sberpay-link-get` | POST `/v2/SberPay/link/get` | Создать заказ | — |
| `SberPaylink` | GET `/v2/SberPay/transactions/{paymentId}/link` | Получить ссылку | — |
| `GetDeepLink` | POST `/v2/MirPay/GetDeepLink` | Получить DeepLink | — |
| `AlfaPayLink` | POST `/v2/AlfaPay/link/get` | Получить ссылку | — |
| `QrMembersList` | POST `/v2/QrMembersList` | Получить список банков-пользователей QR для возврата | — |
| `AddAccountQr` | POST `/v2/AddAccountQr` | Привязать счет к магазину | — |
| `GetAddAccountQrState` | POST `/v2/GetAddAccountQrState` | Получить статус привязки счета к магазину | — |
| `GetAccountQrList` | POST `/v2/GetAccountQrList` | Получить список счетов, привязанных к магазину | — |
| `ChargeQr` | POST `/v2/ChargeQr` | Автоплатеж по QR СБП | — |
| `SbpPayTest` | POST `/v2/SbpPayTest` | Создать тестовую платежную сессию | — |
| `GetQrState` | POST `/v2/GetQrState` | Получить статус возврата | — |
| `GetQrBankList` | POST `/v2/GetQrBankList` | Получить список банков-участников СБП для платежа | — |
| `CheckOrder` | POST `/v2/CheckOrder` | Получить статус заказа | — |
| `SendClosingReceipt` | POST `/cashbox/SendClosingReceipt` | Отправить закрывающий чек в кассу | — |
| `GetConfirmOperation` | POST `/v2/getConfirmOperation` | Получить справку по операции | — |

## Обоснование выбора операций

- `create` (создание): POST `/v2/Init` — оценка 82; следующий кандидат POST `/v2/SbpPayTest` — оценка 39; разница 43.
- `status` (проверка статуса): POST `/v2/GetState` — оценка 65; следующий кандидат POST `/v2/GetAddAccountQrState` — оценка 57; разница 8.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `NEW` | `in_progress` |
| `AUTHORIZED` | `approved` |
| `CONFIRMED` | `approved` |
| `REVERSED` | `rejected` |
| `REFUNDED` | `rejected` |
| `PARTIAL_REFUNDED` | `rejected` |
| `REJECTED` | `rejected` |
| `DEADLINE_EXPIRED` | `rejected` |
| `3DS_CHECKING` | `in_progress` |
| `3DS_CHECKED` | `in_progress` |
| `FORM_SHOWED` | `in_progress` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `TerminalKey` | **TODO:** подтвердить схему платформы |
| `Amount` | **TODO:** подтвердить схему платформы |
| `OrderId` | **TODO:** подтвердить схему платформы |
| `Token` | **TODO:** подтвердить схему платформы |
| `Description` | **TODO:** подтвердить схему платформы |
| `CustomerKey` | **TODO:** подтвердить схему платформы |
| `Recurrent` | `literal:Y` |
| `PayType` | **TODO:** подтвердить схему платформы |
| `Language` | `literal:ru` |
| `NotificationURL` | **TODO:** подтвердить схему платформы |
| `SuccessURL` | **TODO:** подтвердить схему платформы |
| `FailURL` | **TODO:** подтвердить схему платформы |
| `RedirectDueDate` | **TODO:** подтвердить схему платформы |
| `DATA` | **TODO:** подтвердить схему платформы |
| `Receipt` | **TODO:** подтвердить схему платформы |
| `Shops` | **TODO:** подтвердить схему платформы |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
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
- Авторизация через Token/signature в теле запроса требует явной настройки для провайдера.
- TODO amount_unit: единица суммы указана только в description; подтвердите её в overrides.
- TODO required_if CustomerKey: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO required_if Receipt: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO field_map TerminalKey: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map Token: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map Amount: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map OrderId: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
