# Руководство по интеграции Sberbank

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 9. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://ecomtest.sberbank.ru`
- Переменная окружения: `SBERBANK_BASE_URL`
- API-ключ: `SBERBANK_API_KEY`

Адреса из OpenAPI:

- Тестовая среда: `https://ecomtest.sberbank.ru`

## Авторизация

Авторизация в спецификации не объявлена.

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `register` | POST `/ecomm/gw/partner/api/v1/register.do` | Регистрация заказа [register] | — |
| `registerPreAuth` | POST `/ecomm/gw/partner/api/v1/registerPreAuth.do` | Регистрация заказа для двухстадийного сценария [registerPreAuth] | — |
| `deposit` | POST `/ecomm/gw/partner/api/v1/deposit.do` | Завершение двухстадийного сценария [deposit] | — |
| `reverse` | POST `/ecomm/gw/partner/api/v1/reverse.do` | Отмена заказа [reverse] | — |
| `refund` | POST `/ecomm/gw/partner/api/v1/refund.do` | Возврат средств Плательщика [refund] | — |
| `getOrderStatusExtended` | POST `/ecomm/gw/partner/api/v1/getOrderStatusExtended.do` | Получение информации о заказе [getOrderStatusExtended] | — |
| `decline` | POST `/ecomm/gw/partner/api/v1/decline.do` | Отмена заказа до начала платежа [decline] | — |
| `paymentOrder` | POST `/ecomm/gw/partner/api/v1/paymentOrder.do` | Проведение оплаты по карте [paymentOrder] | — |
| `paymentOrderBySubscription` | POST `/ecomm/gw/partner/api/v1/paymentOrderBySubscription` | Проведение оплаты по подписке СБП [paymentOrderBySubscription] | — |
| `paymentOrderBinding` | POST `/ecomm/gw/partner/api/v1/paymentOrderBinding.do` | Проведение оплаты по связке [paymentOrderBinding] | — |
| `unBindCard` | POST `/ecomm/gw/partner/api/v1/unbindCard.do` | Деактивация связки Плательщика [unbindCard] | — |
| `getBindings` | POST `/ecomm/gw/partner/api/v1/getBindings.do` | Получение связок по идентификатору Плательщика [getBindings] | — |
| `getBindingsByCardOrId` | POST `/ecomm/gw/partner/api/v1/getBindingsByCardOrId.do` | Получение связок по номеру карты или идентификатору связки Плательщика [getBindingsByCardOrId] | — |
| `bindCard` | POST `/ecomm/gw/partner/api/v1/bindCard.do` | Активация связки Плательщика [bindCard] | — |
| `recurrentPayment` | POST `/ecomm/gw/partner/api/v1/recurrentPayment.do` | Проведение периодического платежа [recurrentPayment] | — |
| `paymentDirect` | POST `/ecomm/gw/partner/api/v1/mir/paymentDirect.do` | Проведение платежа с использованием прямого взаимодействия Партнера с MirPay [paymentDirect] | — |
| `finish3dsMethod` | POST `/ecomm/gw/partner/api/v1/finish3dsMethod.do` | Завершение 3DS Method [finish3dsMethod] | — |
| `finish3dsPayment` | POST `/ecomm/gw/partner/api/v1/finish3dsPayment.do` | Завершение аутентификации 3-D Secure [finish3dsPayment] | — |
| `callback` | POST `/callbackUrl` | Уведомление о проведении платежа [callback] | — |
| `bindingCallback` | POST `/bindingCallbackUrl` | Уведомление о событии со связкой [bindingCallback] | — |
| `setPermanentPassword` | POST `/ecomm/gw/partner/api/accounts/v1/set-permanent-password` | Установка постоянного пароля [setPermanentPassword] | — |
| `generateApiKey` | POST `/ecomm/gw/partner/api/accounts/v1/apikey/generate` | Генерация ключа Партнера для работы с сервисами платежного шлюза через SDK [generateApiKey]. | — |
| `getReceiptStatus` | POST `/ecomm/gw/partner/api/ofd/v1/getReceiptStatus` | Получение информации о результате обработки чека [getReceiptStatus] | — |
| `retryReceipt` | POST `/ecomm/gw/partner/api/ofd/v1/retryReceipt` | Переотправка чека без изменения Корзины [retryReceipt] | — |
| `doReceipt` | POST `/ecomm/gw/partner/api/ofd/v1/doReceipt` | Создание чека [doReceipt] | — |
| `doCorrection` | POST `/ecomm/gw/partner/api/ofd/v1/doCorrection` | Чеки коррекции [doCorrection] | — |
| `getLoyaltyBalance` | POST `/ecomm/gw/partner/api/v1/getFiscalStatus` | Мониторинг состояния ККТ АТОЛ Онлайн [getFiscalStatus] | — |
| `getLoyaltyBalance` | POST `/ecomm/gw/partner/api/v1/getLoyaltyBalance` | Получение баланса бонусов СберСпасибо [getLoyaltyBalance] | — |
| `autoCompletion` | POST `/ecomm/gw/partner/api/v1/autoCompletion` | Завершение двухстадийного сценария [autoCompletion] | — |
| `autoRefund` | POST `/ecomm/gw/partner/api/v1/autoRefund` | Возврат средств Плательщика [autoRefund] | — |
| `externalReceipt` | POST `/ecomm/gw/partner/api/v1/externalReceipt` | Передача данных чека [externalReceipt] | — |
| `registerP2P` | POST `/ecomm/gw/partner/api/p2p/v1/register` | Сервис регистрации заказа на перевод [registerP2P] | — |
| `performP2P` | POST `/ecomm/gw/partner/api/p2p/v1/perform` | Сервис проведения перевода [performP2P] | — |

## Обоснование выбора операций

- `create` (создание): POST `/ecomm/gw/partner/api/p2p/v1/register` — оценка 60; следующий кандидат POST `/ecomm/gw/partner/api/v1/register.do` — оценка 52; разница 8.
- `status` (проверка статуса): POST `/ecomm/gw/partner/api/v1/getOrderStatusExtended.do` — оценка 12; следующий кандидат POST `/ecomm/gw/partner/api/p2p/v1/perform` — оценка 0; разница 12.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `1` | `unknown` |
| `0` | `unknown` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `userName` | **TODO:** подтвердить схему платформы |
| `password` | **TODO:** подтвердить схему платформы |
| `orderNumber` | **TODO:** подтвердить схему платформы |
| `amount` | `operation.amount` |
| `currency` | `literal:643` |
| `returnUrl` | **TODO:** подтвердить схему платформы |
| `features` | **TODO:** подтвердить схему платформы |
| `failUrl` | **TODO:** подтвердить схему платформы |
| `description` | **TODO:** подтвердить схему платформы |
| `language` | `literal:ru` |
| `merchantLogin` | **TODO:** подтвердить схему платформы |
| `jsonParams.keyValue.name1` | **TODO:** подтвердить схему платформы |
| `jsonParams.keyValue.name2` | **TODO:** подтвердить схему платформы |
| `sessionTimeoutSecs` | `literal:1200` |
| `expirationDate` | **TODO:** подтвердить схему платформы |
| `phone` | **TODO:** подтвердить схему платформы |
| `email` | **TODO:** подтвердить схему платформы |
| `dynamicCallbackUrl` | **TODO:** подтвердить схему платформы |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
| 400 | `bad_request` | не повторять автоматически |
| 404 | `bad_request` | не повторять автоматически |
| 405 | `internal_server_error` | не повторять автоматически |
| 429 | `too_many_requests` | повторить с увеличивающейся задержкой |
| 451 | `internal_server_error` | не повторять автоматически |
| 500 | `internal_server_error` | повторить с увеличивающейся задержкой |

## Конфигурация ProviderGateway

Не задана. Укажите `provider_gateway.external_method` и `provider_gateway.gateway` в overrides после подтверждения бизнес-маршрута.

## Подпись webhook

В спецификации не обнаружена.

`process_callback` получает уже разобранный JSON в `payload`, без исходного тела и заголовков. Поэтому криптографическую проверку подписи нельзя корректно выполнить внутри сгенерированного сервиса: её следует делать на уровне платформы до разбора JSON. Сервис не имитирует проверку по повторно сериализованному объекту.

## Подтверждённые overrides

Не переданы. Элементы из свободного текста остаются TODO в предупреждениях.

## Предупреждения генератора

- Не удалось определить операцию проверки статуса.
- TODO required_if orderNumber: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO field_map userName: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map password: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map orderNumber: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map returnUrl: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map features: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map email: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- Не сопоставлены статусы: 1, 0. Добавьте подтверждённые соответствия в status_map overrides.
