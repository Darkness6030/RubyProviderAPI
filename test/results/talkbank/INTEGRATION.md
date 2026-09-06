# Руководство по интеграции Talkbank

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 4. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://baas.staging.talkbank.dev/api/v1`
- Переменная окружения: `TALKBANK_BASE_URL`
- API-ключ: `TALKBANK_API_KEY`

Адреса из OpenAPI:

- API: `https://baas.staging.talkbank.dev/api/v1`

## Авторизация

Авторизация в спецификации не объявлена.

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `client_store` | POST `/clients` | Добавление клиента и запуск идентификации | — |
| `client_show` | GET `/clients/{client_id}` | Получение статуса клиента | — |
| `client_edit` | PUT `/clients/{client_id}` | Редактирование данных клиента | — |
| `card_activate_virtual` | POST `/clients/{client_id}/virtual-cards` | Выпуск виртуальной карты | — |
| `card_activate` | POST `/clients/{client_id}/cards/{barcode}/activate` | Активация карты | — |
| `card_reactivate_virtual` | POST `/clients/{client_id}/virtual-cards/{barcode}/reactivate` | Реактивация виртуальной карты | — |
| `card_activation` | GET `/clients/{client_id}/cards/{barcode}/activation` | Получение статуса активации карты | — |
| `card_details` | GET `/clients/{client_id}/cards/{barcode}` | Получение реквизитов карты | — |
| `card_details_full` | GET `/clients/{client_id}/cards/{barcode}/full` | Получение полного номера карты | — |
| `card_barcode` | POST `/cards/barcode` | Получение баркода по номеру карты | — |
| `card_delivery_store` | POST `/clients/{client_id}/card-deliveries` | Заказ и доставка карты по указанному адресу | — |
| `card_delivery_show` | GET `/clients/{client_id}/card-deliveries/{delivery_id}` | Получение статуса доставки | — |
| `btc` | POST `/clients/{client_id}/btc` | Перевод юридического лица физическому лицу | — |
| `account_balance` | GET `/balance` | Получение баланса | — |
| `payment_status` | GET `/payment/{order_slug}` | Получение статуса платежа | — |
| `payment_authorization` | POST `/authorize/card/{client_id}` | Авторизация карты без формы | — |
| `payment_authorization_with_form` | POST `/authorize/card/{client_id}/with/form` | Авторизация карты с формой | — |
| `payment_from_unregistered_card` | POST `/charge/{client_id}/unregistered/card` | Списание с незарегистрированной карты на счет партнера | — |
| `payment_from_unregistered_card_with_form` | POST `/charge/{client_id}/unregistered/card/with/form` | Списание с незарегистрированной карты на счет партнера с формой | — |
| `hold` | POST `/hold` | Холдирование без формы | — |
| `hold_with_form` | POST `/hold/{client_id}/with/form` | Холдирование с формой | — |
| `hold_confirm` | POST `/hold/confirm/{order_slug}` | Подтверждение списания | — |
| `hold_reverse` | POST `/hold/reverse/{order_slug}` | Отмена списания | — |
| `payment_from_registered_card` | POST `/payment/from/{client_id}/registered/card` | Списание с авторизованной карты без 3dsecure | — |
| `card_withdrawal` | POST `/clients/{client_id}/cards/{barcode}/withdrawal` | Списание средств с карты TalkBank на счет партнера | — |
| `card_token` | POST `/clients/{client_id}/cards/token` | Получение токена карты | — |
| `payment_to_unregistered_card` | POST `/refill/unregistered/card` | Списание со счета партнера на незарегистрированную карту | — |
| `payment_to_unregistered_card_with_form` | POST `/refill/{client_id}/unregistered/card/with/form` | Списание со счета партнера на незарегистрированную карту с формой | — |
| `payment_to_registered_card` | POST `/payment/to/{client_id}/registered/card` | Списание со счета партнера на зарегистрированную карту | — |
| `card_refill` | POST `/clients/{client_id}/cards/{barcode}/refill` | Списание со счета партнера на карту TalkBank | — |
| `payment_to_account` | POST `/account/transfer` | Выплата по реквизитам | — |
| `payment_to_account_status` | GET `/account/transfer/{order_slug}` | Получение статуса перевода по реквизитам | — |
| `payment_to_account_with_tax_data` | POST `/account/transfer/tax` | Оплата налоговых платежей | — |
| `payment_to_account_payment_order` | GET `/account/transfer/{order_slug}/payment-order` | Получение платежного поручения | — |
| `document_uploader` | POST `/document-uploader` | Получение pdf файла для KYC | — |
| `payment_refund` | POST `/refund` | Оформление возврата операции | — |
| `payment_reverse` | POST `/reverse` | Отмена операции | — |
| `account_operations` | GET `/operations` | Список операций по счету партнера | — |
| `account_operation` | GET `/operations/{type}/{id}` | Операция по счету партнера | — |
| `account_cards_transactions` | GET `/cards-transactions` | Получение транзакций по всем картам партнера | — |
| `payment_receipt` | GET `/payment/{order_slug}/receipt` | Получение платежной квитанции | — |
| `sbp_check_availability` | POST `/sbp/check` | Проверка возможности совершения платежа по номеру телефона | — |
| `sbp_check_availability_status` | GET `/sbp/check/{request_id}` | Получить статус проверки возможности совершения платежа по номеру телефона | — |
| `sbp_payment` | POST `/sbp/payment` | Платеж по номеру телефона | — |
| `client_sbp_check_availability` | POST `/clients/{client_id}/check-sbp` | Проверка возможности совершения платежа клиенту | — |
| `client_sbp_payment` | POST `/clients/{client_id}/payment-sbp` | Платеж клиенту | — |
| `payment_qr` | POST `/clients/{client_id}/payment-qr` | Генерация платежной ссылки | — |
| `card_balance` | GET `/clients/{client_id}/cards/{barcode}/balance` | Получение баланса на карте | — |
| `card_limits` | GET `/clients/{client_id}/cards/{barcode}/limits` | Получение лимитов по карте | — |
| `card_change_limit` | POST `/clients/{client_id}/cards/{barcode}/limits` | Изменение лимитов по карте | — |
| `card_lock_status` | GET `/clients/{client_id}/cards/{barcode}/lock` | Получение статуса блокировки карты | — |
| `card_lock` | POST `/clients/{client_id}/cards/{barcode}/lock` | Блокировка карты | — |
| `card_unlock` | DELETE `/clients/{client_id}/cards/{barcode}/lock` | Снятие блокировки с карты | — |
| `card_cvv` | GET `/clients/{client_id}/cards/{barcode}/security-code` | Восстановление CVV | — |
| `card_transactions` | GET `/clients/{client_id}/cards/{barcode}/set/pin` | Получение транзакций по карте | — |
| `payment_from_card_to_card` | POST `/payment/{client_id}/from/card/to/card` | Создание ссылки на перевод card2card | — |
| `card_to_card_status` | GET `/clients/{client_id}/card2card/{payment_id}` | Получение статуса перевода card2card | — |
| `card_list` | GET `/clients/{client_id}/cards` | Получение списка карт клиента | — |
| `path_account_cards_transactions.yaml` | GET `/transactions` | История операций по счету партнера | — |
| `selfemployments_inn` | GET `/selfemployments/inn` | Определение ИНН по паспортным данным | — |
| `selfemployments_status` | GET `/selfemployments/{client_id}` | Получение статуса самозанятого | — |
| `selfemployments_bind` | POST `/selfemployments/{client_id}/bind` | Привязка самозанятого к TalkBank | — |
| `selfemployments_add_receipt_async` | POST `/selfemployments/{client_id}/receipt-async` | Регистрация дохода самозанятого (асинхронный метод) | — |
| `selfemployments_cancel_receipt` | DELETE `/selfemployments/{client_id}/receipt` | Отмена чека | — |
| `selfemployments_receipts` | GET `/selfemployments/{client_id}/receipts` | Получение списка зарегистрированных чеков | — |
| `selfemployments_income` | GET `/selfemployments/{client_id}/income` | Получение информации по доходу самозанятого за период | — |
| `selfemployments_payments` | GET `/selfemployments/{client_id}/payments` | Получение списка налоговых начислений, долгов и пени самозанятого | — |
| `selfemployments_payment_documents` | GET `/selfemployments/{client_id}/payment-documents` | Получение реквизитов и квитанций для оплаты начислений | — |
| `selfemployments_permissions_change_get` | GET `/selfemployments/{client_id}/permissions_change/get` | Получение списка запросов на привязку самозанятого | — |
| `selfemployments_permission_change_decision` | POST `/selfemployments/{client_id}/permissions_change/decision` | Подтверждение/отклонение запроса на привязку cамозанятого к платформе | — |
| `selfemployments_permissions` | GET `/selfemployments/{client_id}/permissions` | Получение списка разрешений | — |
| `selfemployments_income_reference` | GET `/selfemployments/{client_id}/income_reference` | Получение справки о доходах самозанятого | — |
| `selfemployments_registration_reference` | GET `/selfemployments/{client_id}/registration_reference` | Получение справки о постановке на учет (снятии с учета) физического лица в качестве самозанятого | — |
| `selfemployments_account_status` | GET `/selfemployments/{client_id}/account_status` | Получение сводной информацию по лицевому счету | — |
| `selfemployments_status_date` | GET `/selfemployments/{client_id}/status/{yyyy-mm-dd}` | Получение статуса самозанятого на дату | — |
| `beneficiary_list` | GET `/beneficiaries` | Список бенефициаров | — |
| `beneficiary_add` | POST `/beneficiaries` | Создание бенефициара | — |
| `beneficiary_show` | GET `/beneficiaries/{beneficiary_id}` | Получение данных о бенефициаре | — |
| `beneficiary_edit` | PUT `/beneficiaries/{beneficiary_id}` | Редактирование бенефициара | — |
| `beneficiary_commission_list` | GET `/beneficiaries/{beneficiary_id}/commissions` | Список комиссий бенефициара | — |
| `beneficiary_commission_add` | POST `/beneficiaries/{beneficiary_id}/commissions` | Создание комиссии бенефициара | — |
| `beneficiary_commission_edit` | POST `/beneficiaries/{beneficiary_id}/commissions/{commission_id}` | Редактирование комиссии бенефициара | — |
| `beneficiary_commission_delete` | DELETE `/beneficiaries/{beneficiary_id}/commissions/{commission_id}` | Удаление комиссии бенефициара | — |
| `beneficiary_add_balance_correction` | PUT `/beneficiaries/{beneficiary_id}/add-balance-correction` | Корректировка баланса бенефициара | — |
| `event_subscription_list` | GET `/event-subscriptions` | Получение списка подписок | — |
| `event_subscription_store` | POST `/event-subscriptions` | Оформление подписки | — |
| `event_subscription_remove` | DELETE `/event-subscriptions/{subscription_id}` | Удаление подписки на событие | — |
| `inter_card` | POST `/payment/inter/card` | Перевод с российской на иностранную карту | — |
| `inter_cash` | POST `/payment/inter/cash` | Перевод с российской карты с выдачей наличных средств за рубежом | — |
| `payment_countries` | GET `/payment/countries` | Получение списка стран для получения средств | — |

## Обоснование выбора операций

- `create` (создание): POST `/account/transfer` — оценка 85; следующий кандидат POST `/clients/{client_id}/cards/{barcode}/withdrawal` — оценка 82; разница 3.
- `status` (проверка статуса): GET `/account/transfer/{order_slug}` — оценка 102; следующий кандидат GET `/payment/{order_slug}` — оценка 77; разница 25.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `new` | `in_progress` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `amount` | `operation.amount` |
| `account` | **TODO:** подтвердить схему платформы |
| `bik` | **TODO:** подтвердить схему платформы |
| `name` | **TODO:** подтвердить схему платформы |
| `inn` | **TODO:** подтвердить схему платформы |
| `description` | **TODO:** подтвердить схему платформы |
| `order_slug` | **TODO:** подтвердить схему платформы |
| `receipt_ids` | **TODO:** подтвердить схему платформы |
| `beneficiary_id` | **TODO:** подтвердить схему платформы |
| `income_code` | **TODO:** подтвердить схему платформы |
| `currency_control_file_id` | **TODO:** подтвердить схему платформы |

## Локальная проверка данных

Ограничения из OpenAPI проверяются в `check_conditions` до обращения к провайдеру. При ошибке сервис возвращает `failure(:unprocessable_entity, ...)`.

| Поле | Проверяемые ограничения |
|---|---|
| — | В OpenAPI не объявлены |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
| 400 | `bad_request` | не повторять автоматически |
| 403 | `forbidden` | не повторять автоматически |
| 404 | `bad_request` | не повторять автоматически |
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
- Неоднозначный выбор операции создания: POST /account/transfer — оценка 85; следующий кандидат POST /clients/{client_id}/cards/{barcode}/withdrawal — оценка 82; разница 3. Проверьте выбор вручную.
- TODO amount_unit: единица суммы указана только в description; подтвердите её в overrides.
- TODO field_map amount account bik name: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
