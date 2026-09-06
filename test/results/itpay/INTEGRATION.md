# Руководство по интеграции Itpay

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 7. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://api.gw.itpay.ru`
- Переменная окружения: `ITPAY_BASE_URL`
- API-ключ: `ITPAY_API_KEY`

Адреса из OpenAPI:

- API: `https://api.gw.itpay.ru`
- API: `http://api.gw.itpay.ru`

## Авторизация

- `Merchant Authentication`: basic, header `Authorization`
- `JWT Authentication`: basic, header `Authorization`

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `admin-api_v1_accounts_message_list` | GET `/admin-api/v1/accounts/{account_id}/message/` |  | — |
| `admin-api_v1_accounts_message_create` | POST `/admin-api/v1/accounts/{account_id}/message/` |  | — |
| `admin-api_v1_accounts_message_update` | PUT `/admin-api/v1/accounts/{account_id}/message/` |  | — |
| `admin-api_v1_accounts_message_partial_update` | PATCH `/admin-api/v1/accounts/{account_id}/message/` |  | — |
| `admin-api_v1_accounts_message_delete` | DELETE `/admin-api/v1/accounts/{account_id}/message/` |  | — |
| `admin-api_v1_registration_list` | GET `/admin-api/v1/registration/` |  | — |
| `admin-api_v1_registration_create` | POST `/admin-api/v1/registration/` |  | — |
| `admin-api_v1_registration_update` | PUT `/admin-api/v1/registration/` |  | — |
| `admin-api_v1_registration_partial_update` | PATCH `/admin-api/v1/registration/` |  | — |
| `admin-api_v1_registration_delete` | DELETE `/admin-api/v1/registration/` |  | — |
| `admin-api_v1_registration_acceptance_create` | POST `/admin-api/v1/registration/{registration_request_id}/acceptance/` | Отправить заявку на проверку | — |
| `admin-api_v1_registration_acceptance_docs_list` | GET `/admin-api/v1/registration/{registration_request_id}/acceptance_docs/` | Получить список документов для заявку на регистрацию | — |
| `admin-api_v1_registration_account_create` | POST `/admin-api/v1/registration/{registration_request_id}/account/` | Добавить в заявку на регистрацию данные аккаунта | — |
| `admin-api_v1_registration_account_partial_update` | PATCH `/admin-api/v1/registration/{registration_request_id}/account/` | Добавить в заявку на регистрацию данные аккаунта | — |
| `admin-api_v1_registration_additional_data_create` | POST `/admin-api/v1/registration/{registration_request_id}/additional_data/` | Добавить в заявку на регистрацию дополнительные данные | — |
| `admin-api_v1_registration_authority_create` | POST `/admin-api/v1/registration/{registration_request_id}/authority/` | Добавить в заявку на регистрацию данные доверенности | — |
| `admin-api_v1_registration_authority_partial_update` | PATCH `/admin-api/v1/registration/{registration_request_id}/authority/` | Добавить в заявку на регистрацию данные доверенности | — |
| `admin-api_v1_registration_bank_create` | POST `/admin-api/v1/registration/{registration_request_id}/bank/` | Добавить в заявку на регистрацию банковские реквизиты | — |
| `admin-api_v1_registration_legal_entity_create` | POST `/admin-api/v1/registration/{registration_request_id}/legal_entity/` | Добавить в заявку на регистрацию юридическое лицо | — |
| `admin-api_v1_registration_legal_entity_partial_update` | PATCH `/admin-api/v1/registration/{registration_request_id}/legal_entity/` | Добавить в заявку на регистрацию юридическое лицо | — |
| `admin-api_v1_utils_file_urls_list` | GET `/admin-api/v1/utils/file_urls/` | Получить url для загрузки файла. | — |
| `Регистрация учётной системы по одноразовому коду.` | POST `/v1/accounting_system/register/` |  | — |
| `Получить список мест учетной системы.` | GET `/v1/accounting_system/sections/` |  | — |
| `Получить список уведомлений` | GET `/v1/alerts/` | Постраничный список app-уведомлений от новых к старым. Данные отдаются только если аккаунт достоверно идентифицирован (JWT) | — |
| `Количество непрочитанных уведомлений` | GET `/v1/alerts/unread/` | Вернет alerts_count. Данные отдаются только если аккаунт достоверно идентифицирован (JWT) | — |
| `Получить уведомление по ID` | GET `/v1/alerts/{alert_id}/` | Данные отдаются только если аккаунт достоверно идентифицирован (JWT) | — |
| `Отметить уведомление прочитанным` | POST `/v1/alerts/{alert_id}/read/` | Устанавливает is_read=true и readed=now(). Работает только если аккаунт достоверно идентифицирован (JWT) | — |
| `Получить события WebHook` | GET `/v1/api/events/` |  | — |
| `Получить логи попыток доставки WebHook` | GET `/v1/api/events/{event_id}/logs/` |  | — |
| `Повторить доставку события WebHook` | POST `/v1/api/events/{event_id}/repeat/` | Повторно ставит событие в очередь на доставку.<br><br>Ограничение: повтор доступен только для статусов `not_received` и `no_signed`. | — |
| `Получить список API-ключей` | GET `/v1/api/keys/` |  | — |
| `Создать API-ключ` | POST `/v1/api/keys/` |  | — |
| `Удалить API-ключ` | DELETE `/v1/api/keys/{key_id}/` |  | — |
| `Получить список запросов` | GET `/v1/api/requests/` |  | — |
| `Получить настройки WebHook` | GET `/v1/api/webhook/` |  | — |
| `Обновить настройки WebHook` | POST `/v1/api/webhook/` |  | — |
| `Удалить настройки WebHook` | DELETE `/v1/api/webhook/` |  | — |
| `Перевыпуск invite_token по email` | POST `/v1/auth/activation/renew` |  | — |
| `Получить JWT-токен c токеном Apple` | POST `/v1/auth/by_apple` |  | — |
| `Аутентификация по email` | POST `/v1/auth/by_email` |  | — |
| `Получить JWT-токен c токеном Google.` | POST `/v1/auth/by_google` |  | — |
| `Создать JWT токен на основе MAX Web-App` | POST `/v1/auth/by_max` | Аутентификация через MAX Web-App | — |
| `Получить JWT-токен c токеном-проекта ProfilesID.` | POST `/v1/auth/by_profiles` |  | — |
| `Создать JWT токен на основе Telegram Web-App` | POST `/v1/auth/by_telegram` | Аутентификация через Telegram Web-App | — |
| `Верификация Magic Link` | GET `/v1/auth/magic/{token}` |  | — |
| `Обновление access JWT` | POST `/v1/auth/refresh` |  | — |
| `Получить список кассовых ссылок` | GET `/v1/cashlinks/` |  | — |
| `Создать кассовую ссылку.` | POST `/v1/cashlinks/` |  | — |
| `Получить кассовую ссылку` | GET `/v1/cashlinks/{cashlink_id__or__external_id}/` | Идентификаторы в url: id, external_id. | — |
| `Изменить кассовую ссылку` | PATCH `/v1/cashlinks/{cashlink_id__or__external_id}/` | Идентификаторы в url: id, external_id. | — |
| `Удалить кассовую ссылку` | DELETE `/v1/cashlinks/{cashlink_id__or__external_id}/` | Идентификаторы в url: id, external_id. | — |
| `Скачать QR кассовой ссылки` | GET `/v1/cashlinks/{cashlink_id__or__external_id}/download/{lang}/` | Идентификаторы в url: id, external_id. | — |
| `Получить категории каталога` | GET `/v1/catalog/categories/` |  | — |
| `Получить каталог` | GET `/v1/catalog/items/` |  | — |
| `Создать позицию каталога` | POST `/v1/catalog/items/` |  | — |
| `Получить позицию каталога по id` | GET `/v1/catalog/items/{catalog_item_id}/` |  | — |
| `Изменить позицию магазина` | PATCH `/v1/catalog/items/{catalog_item_id}/` |  | — |
| `Удалить позицию магазина` | DELETE `/v1/catalog/items/{catalog_item_id}/` |  | — |
| `Список ошибок` | GET `/v1/code_errors/` |  | — |
| `Описание работы с API` | GET `/v1/docs/api-description` | <style><br>.endpoint {<br>    background: #f8f9fa;<br>    border: 1px solid #dee2e6;<br>    border-radius: 6px;<br>    padding: 12px 16px;<br>    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;<br>    font-size: 14px;<br>    color: #495057;<br>    margin: 16px 0;<br>}<br>.api-keys {<br>    margin: 16px 0;<br>}<br>.key-type {<br>    font-weight: 600;<br>    color: #2c5aa0;<br>}<br>/* Скрываем технические элементы для overview разделов */<br><br>/* Скрываем URL пути */<br>[data-section-id*="operation/Описание"] .operation-path,<br>[data-section-id*="operation/Проверка"] .operation-path,<br>[data-section-id*="operation/События"] .operation-path,<br>.operation-path,<br>.sc-hzUIXC {<br>    display: none !important;<br>}<br><br>/* Скрываем Responses секции */<br>[data-section-id*="operation/Описание"] h3:contains("Responses"),<br>[data-section-id*="operation/Проверка"] h3:contains("Responses"),<br>[data-section-id*="operation/События"] h3:contains("Responses"),<br>h3.sc-fIxmyt,<br>.sc-jSFjdj,<br>.responses-section {<br>    display: none !important;<br>}<br><br>/* Скрываем все что содержит "Responses" */<br>*:contains("Responses") {<br>    display: none !important;<br>}<br><br>/* Глобальное скрытие технических блоков для overview операций */<br>[data-section-id*="Описание"] .sc-fIxmyt,<br>[data-section-id*="Проверка"] .sc-fIxmyt,<br>[data-section-id*="События"] .sc-fIxmyt,<br>[data-section-id*="Описание"] button,<br>[data-section-id*="Проверка"] button,<br>[data-section-id*="События"] button {<br>    display: none !important;<br>}<br></style><br><br><div class="endpoint"><br>    <strong>Endpoint:</strong> https://api.gw.itpay.ru/v1/<br></div><br><br><div>Для аутентификации запроса используется <strong>HTTP Basic Auth</strong> — отправка логина и пароля в заголовке HTTP-запроса.</div><br><div style="margin-top: 8px;">В качестве логина используется <strong>Public ID</strong>, в качестве пароля — <strong>API Secret</strong>.</div><br><div style="margin-top: 8px;">Оба этих значения можно получить при регистрации. API Secret может быть изменен по запросу Клиента.</div><br><br><h4>Структура ответов API</h4><br><div>Все ответы API обернуты в следующую структуру:</div><br><br><div style="background: #f8f9fa; border: 1px solid #e1e5e9; border-radius: 6px; padding: 16px; margin: 12px 0;"><br>    <strong>Структура ответа:</strong><br/><br>    &#8226; <strong>error</strong>: null или описание ошибки<br/><br>    &#8226; <strong>error_code</strong>: null или код ошибки<br/><br>    &#8226; <strong>api_version</strong>: "1.1.0"<br/><br>    &#8226; <strong>data</strong>: объект с данными ответа<br></div><br><br><div class="api-keys"><br>    <h4>Типы ключей авторизации</h4><br>    <div style="padding-left: 16px;"><br>        &#8226; <span class="key-type">NoAuth</span> — методы, доступные без авторизации<br/><br>        &#8226; <span class="key-type">ShopKey</span> — ключи магазина для работы с методами API<br/><br>        &#8226; <span class="key-type">AccountKey</span> — токен авторизации под конкретным оператором магазина<br>    </div><br></div><br><br><br><script><br>// Скрываем технические элементы (URL, Responses, кнопки) для overview разделов<br>// НО НЕ скрываем GET лейблы<br>function hideOverviewTechnicalElements() {<br>    // Скрываем все технические секции в overview операциях<br>    const overviewContainers = document.querySelectorAll('[data-section-id*="operation/Описание"], [data-section-id*="operation/Проверка"], [data-section-id*="operation/События"]');<br>    overviewContainers.forEach(function(container) {<br>        // Скрываем все элементы кроме описания<br>        const elementsToHide = container.querySelectorAll(<br>            '.operation-path, .sc-hzUIXC, h3, .sc-fIxmyt, .sc-jSFjdj, button, [class*="security"], [class*="authorization"], [class*="parameters"], [class*="request"], [class*="response"]:not(.redoc-markdown)'<br>        );<br><br>        elementsToHide.forEach(function(el) {<br>            // Не скрываем наш контент<br>            if (!el.closest('.redoc-markdown') && !el.closest('.endpoint') && !el.closest('.api-keys')) {<br>                // Проверяем содержит ли элемент "Responses"<br>                if (el.textContent && el.textContent.includes('Responses')) {<br>                    el.style.display = 'none';<br>                }<br>                // Скрываем H3 заголовки которые не являются нашими<br>                else if (el.tagName === 'H3' && !el.closest('.redoc-markdown')) {<br>                    el.style.display = 'none';<br>                }<br>                // Скрываем кнопки<br>                else if (el.tagName === 'BUTTON') {<br>                    el.style.display = 'none';<br>                }<br>                // Скрываем остальные технические элементы<br>                else if (el.classList.length > 0) {<br>                    el.style.display = 'none';<br>                }<br>            }<br>        });<br>    });<br><br>    // Дополнительное скрытие по тексту - только Responses, НО НЕ GET!<br>    document.querySelectorAll('*').forEach(function(el) {<br>        if (el.textContent === 'Responses') {<br>            el.style.display = 'none';<br>            el.style.visibility = 'hidden';<br>            el.style.opacity = '0';<br>        }<br>    });<br>}<br><br>// Запускаем несколько раз для надежности<br>setTimeout(hideOverviewTechnicalElements, 300);<br>setTimeout(hideOverviewTechnicalElements, 800);<br>setTimeout(hideOverviewTechnicalElements, 1500);<br><br>// Наблюдаем за изменениями DOM<br>if (window.MutationObserver) {<br>    const observer = new MutationObserver(hideOverviewTechnicalElements);<br>    observer.observe(document.body, {childList: true, subtree: true});<br>}<br></script><br> | — |
| `Проверка подлинности` | GET `/v1/docs/authentication` | <div>Для проверки подлинности каждое сообщение от ITPay подписывается. ITPay генерирует подписи, используя код аутентификации сообщения на основе хэша (HMAC) с SHA-256.</div><br><br><h4>Пример заголовка подписи</h4><br><div style="background: #f8f9fa; border: 1px solid #e1e5e9; border-radius: 6px; padding: 12px; margin: 12px 0;"><br>    <strong>itpay-signature:</strong> t=1492774577,v1=88c4d0812782112fceb1b18b679b231d484b01b8241c397a6732f1a14742d2c0<br></div><br><br><h4>Алгоритм расшифровки подписи</h4><br><ol><br>    <li>Получить timestamp сообщения из заголовка "itpay-signature", параметр "t"</li><br>    <li>Подготовить строку signed_payload путем соединения следующих значений:</li><br>    <ul><br>        <li>timestamp сообщения, полученный в п.1</li><br>        <li>символ: "."</li><br>        <li>значение параметра "data" в json формате из полученного сообщения</li><br>    </ul><br>    <li>Получить значение hash HMAC с SHA-256 используя API Secret как ключ, а signed_payload как сообщение</li><br>    <li>Сравните полученный hash с тем, который передан в параметре "v1" заголовка "itpay-signature"</li><br></ol><br><br><style><br>/* Скрываем технические элементы для секции аутентификации */<br>[data-section-id*="operation/Проверка"] .operation-path,<br>[data-section-id*="operation/Проверка"] .sc-hzUIXC,<br>[data-section-id*="operation/Проверка"] h3:contains("Responses"),<br>[data-section-id*="operation/Проверка"] .sc-fIxmyt,<br>[data-section-id*="operation/Проверка"] .sc-jSFjdj,<br>[data-section-id*="operation/Проверка"] button {<br>    display: none !important;<br>}<br><br>/* Скрываем все что содержит "Responses" только в этой секции */<br>[data-section-id*="operation/Проверка"] *:contains("Responses") {<br>    display: none !important;<br>}<br></style><br><br><script><br>// Скрываем технические элементы для секции аутентификации<br>// НО НЕ скрываем GET лейблы<br>function hideAuthTechnicalElements() {<br>    const container = document.querySelector('[data-section-id*="operation/Проверка"]');<br>    if (container) {<br>        const elementsToHide = container.querySelectorAll('.operation-path, .sc-hzUIXC, h3, .sc-fIxmyt, .sc-jSFjdj, button, [class*="response"]:not(.redoc-markdown)');<br>        elementsToHide.forEach(function(el) {<br>            if (!el.closest('.redoc-markdown')) {<br>                if (el.textContent && el.textContent.includes('Responses')) {<br>                    el.style.display = 'none';<br>                }<br>                else if (el.tagName === 'H3' && !el.closest('.redoc-markdown')) {<br>                    el.style.display = 'none';<br>                }<br>                else if (el.tagName === 'BUTTON') {<br>                    el.style.display = 'none';<br>                }<br>                else if (el.classList.length > 0) {<br>                    el.style.display = 'none';<br>                }<br>            }<br>        });<br>    }<br><br>    // Дополнительное скрытие Responses - НО НЕ GET!<br>    document.querySelectorAll('[data-section-id*="operation/Проверка"] *').forEach(function(el) {<br>        if (el.textContent === 'Responses') {<br>            el.style.display = 'none';<br>            el.style.visibility = 'hidden';<br>            el.style.opacity = '0';<br>        }<br>    });<br>}<br><br>setTimeout(hideAuthTechnicalElements, 300);<br>setTimeout(hideAuthTechnicalElements, 800);<br>setTimeout(hideAuthTechnicalElements, 1500);<br><br>if (window.MutationObserver) {<br>    const observer = new MutationObserver(hideAuthTechnicalElements);<br>    observer.observe(document.body, {childList: true, subtree: true});<br>}<br></script><br> | — |
| `События в WebHook` | GET `/v1/docs/webhook-events` | <style><br>.key-type {<br>    font-weight: 600;<br>    color: #2c5aa0;<br>}<br></style><br><br><div><strong>WebHook событие</strong> — HTTP POST-запрос от ITPay к вашему серверу для уведомления о важных изменениях в статусе платежей и других операций.</div><br><br><div style="margin-top: 8px;">Система автоматически отправляет уведомления о ключевых событиях: успешные и неуспешные платежи, возвраты, формирование чеков и другие изменения статусов.</div><br><br><div style="margin-top: 8px;">Адрес для отправки уведомления <strong>webhook_url</strong> указывается при регистрации магазина и может быть изменен по запросу в поддержку.</div><br><br><h4>Повторные попытки доставки</h4><br><div>Если система не сможет соединиться с webhook_url или получит некорректный ответ, будет совершено <strong>10 попыток</strong> доставить сообщение с интервалом между повторами в минутах: <strong>1, 2, 5, 10, 30</strong>.</div><br><div style="margin-top: 8px;">Тайм-аут ожидания ответа — <strong>30 секунд</strong>. Менее чем в 1% случаев задержка доставки может достигать 2 минуты. В остальных случаях — меньше 1 секунды.</div><br><br><h4>Структура WebHook события</h4><br><div>Все WebHook события отправляются как POST запросы с одинаковой структурой:</div><br><br><div style="background: #f8f9fa; border: 1px solid #e1e5e9; border-radius: 6px; padding: 16px; margin: 12px 0;"><br>    <strong>Структура WebHook события:</strong><br/><br>    &#8226; <strong>id</strong>: уникальный идентификатор события<br/><br>    &#8226; <strong>object</strong>: "event"<br/><br>    &#8226; <strong>type</strong>: тип события (см. список ниже)<br/><br>    &#8226; <strong>created</strong>: временная метка создания<br/><br>    &#8226; <strong>data</strong>: объект с данными события<br></div><br><br><div style="margin-top: 12px;"><strong>Важно:</strong> В случае корректной обработки на стороне сервера Клиента в ответ должен быть отправлен Response с HTTP статусом 200 и телом ответа <strong>{"status":0}</strong></div><br><br><h4>Типы WebHook событий</h4><br><div style="padding-left: 16px;"><br>    &#8226; <span class="key-type">payment.pay</span> — отправляется после получения оплаты от пользователя<br/><br>    &#8226; <span class="key-type">payment.completed</span> — отправляется после успешного завершения всего цикла платежа<br/><br>    &#8226; <span class="key-type">payment.rejected</span> — отправляется при отклонении оплаты эквайером (окончательный статус)<br/><br>    &#8226; <span class="key-type">payment.errored</span> — отправляется при возникновении ошибки в процессе платежа<br/><br>    &#8226; <span class="key-type">payment.cancelled</span> — отправляется при отмене неоплаченного платежа<br/><br>    &#8226; <span class="key-type">payment.refund</span> — отправляется после успешного завершения возврата (data содержит модель Refund)<br/><br>    &#8226; <span class="key-type">payment.receipt</span> — отправляется после успешного формирования чека<br/><br>    &#8226; <span class="key-type">payment.feedback</span> — отправляется после добавления отзыва к платежу<br/><br>    &#8226; <span class="key-type">payment.token</span> — отправляется при активации токена сохранения карты<br></div><br><br><style><br>.key-type {<br>    font-weight: 600;<br>    color: #2c5aa0;<br>}<br><br>/* Скрываем технические элементы для секции webhook */<br>[data-section-id*="operation/События"] .operation-path,<br>[data-section-id*="operation/События"] .sc-hzUIXC,<br>[data-section-id*="operation/События"] h3:contains("Responses"),<br>[data-section-id*="operation/События"] .sc-fIxmyt,<br>[data-section-id*="operation/События"] .sc-jSFjdj,<br>[data-section-id*="operation/События"] button {<br>    display: none !important;<br>}<br><br>/* Скрываем все что содержит "Responses" только в этой секции */<br>[data-section-id*="operation/События"] *:contains("Responses") {<br>    display: none !important;<br>}<br></style><br><br><script><br>// Скрываем технические элементы для секции webhook<br>// НО НЕ скрываем GET лейблы<br>function hideWebhookTechnicalElements() {<br>    const container = document.querySelector('[data-section-id*="operation/События"]');<br>    if (container) {<br>        const elementsToHide = container.querySelectorAll('.operation-path, .sc-hzUIXC, h3, .sc-fIxmyt, .sc-jSFjdj, button, [class*="response"]:not(.redoc-markdown)');<br>        elementsToHide.forEach(function(el) {<br>            if (!el.closest('.redoc-markdown')) {<br>                if (el.textContent && el.textContent.includes('Responses')) {<br>                    el.style.display = 'none';<br>                }<br>                else if (el.tagName === 'H3' && !el.closest('.redoc-markdown')) {<br>                    el.style.display = 'none';<br>                }<br>                else if (el.tagName === 'BUTTON') {<br>                    el.style.display = 'none';<br>                }<br>                else if (el.classList.length > 0) {<br>                    el.style.display = 'none';<br>                }<br>            }<br>        });<br>    }<br><br>    // Дополнительное скрытие Responses - НО НЕ GET!<br>    document.querySelectorAll('[data-section-id*="operation/События"] *').forEach(function(el) {<br>        if (el.textContent === 'Responses') {<br>            el.style.display = 'none';<br>            el.style.visibility = 'hidden';<br>            el.style.opacity = '0';<br>        }<br>    });<br>}<br><br>setTimeout(hideWebhookTechnicalElements, 300);<br>setTimeout(hideWebhookTechnicalElements, 800);<br>setTimeout(hideWebhookTechnicalElements, 1500);<br><br>if (window.MutationObserver) {<br>    const observer = new MutationObserver(hideWebhookTechnicalElements);<br>    observer.observe(document.body, {childList: true, subtree: true});<br>}<br></script><br> | — |
| `Создать интеграцию с кассой` | POST `/v1/kassa/integration/` |  | — |
| `Заявка на неподдерживаемого провайдера кассы` | POST `/v1/kassa/integration/request/` |  | — |
| `Получить список провайдеров касс` | GET `/v1/kassa/providers/` |  | — |
| `Получить справочник параметров чека кассы` | GET `/v1/kassa/receipt/reference/` |  | — |
| `Создать новую кассу` | POST `/v1/kassa/registration/` |  | — |
| `Получить недостающие реквизиты для регистрации кассы` | GET `/v1/kassa/registration/requisites/` |  | — |
| `Получить кассу` | GET `/v1/kassa/{kassa_id}/` |  | — |
| `Обновить кассу` | PATCH `/v1/kassa/{kassa_id}/` |  | — |
| `Удалить кассу` | DELETE `/v1/kassa/{kassa_id}/` |  | — |
| `Протестировать интеграцию с кассой` | POST `/v1/kassa/{kassa_id}/test/` |  | — |
| `Создать заявку с сайта` | POST `/v1/lead/` | <br>Приём заявки с публичного сайта itpay.ru. Метод публичный: авторизация не требуется.<br><br>Обязательные поля: `name`, `email` и `consent` (должно быть `true`).<br>Необязательные: `phone`, `company`, `inn`, `page`. Неизвестные поля тела игнорируются.<br><br>Ответы:<br>- 200 — заявка принята, в `data` возвращаются `id` и `created`;<br>- 400 (`error_code=10400`) — ошибки валидации: в `error` карта «поле → список сообщений».<br>  Этим же кодом отклоняется слишком большое тело запроса и запрос без заголовка<br>  `Content-Length`;<br>- 429 (`error_code=10429`) — превышено ограничение частоты запросов.<br><br>Повторная заявка с тем же `email` в пределах окна подавления дублей возвращает 200 с<br>идентификатором ранее созданной заявки: новая заявка не создаётся.<br><br>Чтение заявок через публичный API не предусмотрено.<br> | — |
| `Получить карту лояльности.` | GET `/v1/loyalty/cards/` |  | — |
| `Добавить карту лояльности к заказу.` | POST `/v1/loyalty/cards/` |  | — |
| `Отвязать карту лояльности от заказа.` | DELETE `/v1/loyalty/cards/` |  | — |
| `Обновить комментарий карты лояльности` | PATCH `/v1/loyalty/cards/{card_id}/` |  | — |
| `Получить карту лояльности с призами.` | GET `/v1/loyalty/cards/{card_id}/prizes/` |  | — |
| `Заблокировать призы по карте лояльности.` | POST `/v1/loyalty/cards/{card_id}/prizes/block/` |  | — |
| `Снять блокировку призов по карте лояльности.` | POST `/v1/loyalty/cards/{card_id}/prizes/unblock/` |  | — |
| `Получить список заказов` | GET `/v1/orders/` |  | — |
| `Создать заказ` | POST `/v1/orders/` |  | — |
| `Получить справочник причин списания позиции` | GET `/v1/orders/removal-types/` |  | — |
| `Получить справочник типов списания при закрытии заказа` | GET `/v1/orders/writeoff-payment-types/` |  | — |
| `Получить заказ по ID` | GET `/v1/orders/{order_id}/` |  | — |
| `Обновить заказ` | PATCH `/v1/orders/{order_id}/` |  | — |
| `Удалить заказ` | DELETE `/v1/orders/{order_id}/` |  | — |
| `Закрыть заказ` | POST `/v1/orders/{order_id}/close/` |  | — |
| `Добавить позиции в заказ` | POST `/v1/orders/{order_id}/items/` |  | — |
| `Обновить позицию заказа` | PATCH `/v1/orders/{order_id}/items/{item_id}/` |  | — |
| `Удалить позицию заказа` | DELETE `/v1/orders/{order_id}/items/{item_id}/` |  | — |
| `Удалить комментарий позиции заказа` | DELETE `/v1/orders/{order_id}/items/{item_id}/comment/` |  | — |
| `Создать платеж по заказу` | POST `/v1/orders/{order_id}/payment/` | Создаёт платёж по существующему заказу.<br><br>Тело запроса поддерживает опциональное поле `cash_link_id` (UUID `CashLink.id`).<br><br>Семантика:<br>- `cash_link_id` не передан — поведение прежнее (обратная совместимость): создаётся `Payment` без привязки к `CashLink`.<br>- `cash_link_id` передан — `Payment.cash_link` привязывается к указанной кассовой ссылке; мерчант `CashLink` должен совпадать с мерчантом `Order`. `Order` при этом не модифицируется (в частности, `Order.merchant_place` не изменяется).<br><br>Counter-`Order` (заказ с проставленным `merchant`, но без `merchant_place`) поддерживается: при валидном `cash_link_id` того же мерчанта платёж создаётся штатно, `Order` не модифицируется, виртуальный `Place` не создаётся.<br><br>Тело также поддерживает опциональное поле `loyalty_card_id` (CharField, max_length=50). Это карта лояльности гостя для override на конкретный Payment.<br><br>Семантика: если поле не передано — карта наследуется из `Order.loyalty_card_id`. Если передано — записывается в `Payment.loyalty_card_id` напрямую (override), при этом `Order.loyalty_card_id` НЕ изменяется. Пустая строка отбивается валидатором (`allow_blank=False`).<br><br>Возможные коды ошибок:<br>- `400 e10400` — ошибка валидации тела запроса либо несоответствие мерчанта `CashLink` мерчанту `Order`.<br>- `403 e10403` — `Order` принадлежит другому мерчанту (определяется по API-ключу запрашивающего). Исключение — системный frontend-ключ (`itpay/itpay`): SSR-фронтенд представляет покупателя, ownership не сверяется, мерчант платежа всегда берётся из `Order`.<br>- `404 e10404` — `Order` не найден, либо `CashLink` не найдена, либо `CashLink` находится в состоянии `deleted` / `not_used`.<br>- `400 e10500` — исключение при создании платежа в транзакции. | — |
| `Создать платеж` | POST `/v1/payments` | API. Create payment by Client. | — |
| `Создать платеж по шаблону` | POST `/v1/payments/templates/{template_id}` | Создаёт платёж по шаблону и отдаёт его QR-код.<br><br>У шаблона с общим статическим кодом НСПК (`is_nspk` с заполненным `qrc_id`) платёж по запросу страницы плательщика может не создаваться: тогда приходит `400` с кодом `11228` - оплата такого шаблона идёт через страницу оплаты по шаблону (`GET /v1/templates/{template_id}/payment-info`), где плательщику показывается статический код. Шаблоны без кода НСПК и шаблоны с персональным кодом (`qrc_id` пуст) отвечают как прежде.<br><br>Прочие отказы: `400` с кодом `11226` - у шаблона не указана сумма; `400` с кодом `10400` - шаблон не найден либо платёж создать не удалось; `400` с кодом `10715` - платёж создан, но чек по нему создать не удалось; `424` с кодами `10500` и `10520` - не читается конфигурация платёжного метода или его провайдера. | — |
| `Оплата платежа по токену` | POST `/v1/payments/token/` |  | — |
| `Получить платеж по id` | GET `/v1/payments/{id}` | Получение информации о платеже по id. | — |
| `Инициализировать платеж` | PUT `/v1/payments/{id}` | Фактически результатом является оплата или получение данных для оплаты. | — |
| `Получить платёжные сервисы платежа с лентами банков` | GET `/v1/payments/{id}/services` | Платёжные сервисы, доступные на коде НСПК этого платежа, и на каждый сервис - лента банков с готовыми ссылками `desktop`/`android`/`ios`. Форма ссылок совпадает с `payment_qr_urls` ответа платежа.<br><br>Ленту стоит запрашивать лениво, при открытии списка банков: на десктопе она не нужна, там плательщик видит один QR из универсальной ссылки `desktop`, а выбор между СБП и цифровым рублём делает приложение банка.<br><br>Коды сервисов совпадают с `payment_services` ответа платежа. Пустой `payment_services` означает, что лент нет: платёж не по СБП либо код ещё не зарегистрирован в НСПК.<br><br>Для ленты цифрового рубля выбор банка на нашей стороне не регистрируется: `PUT /v1/payments/{id}` для неё вызывать не нужно и не следует - код тот же, а перерегистрация кода бессмысленна. | — |
| `Обновить отзыв платежа.` | POST `/v1/payments/{payment_id}/feedback` |  | — |
| `Создать возврат платежа` | POST `/v1/payments/{payment_id}/refund` | Совершение возврата денежных средств по id платежа | — |
| `Получить список возвратов по платежу` | GET `/v1/payments/{payment_id}/refunds` | Получение списка возвратов по конкретному платежу | — |
| `Получить проект` | GET `/v1/projects/` |  | — |
| `Получить чек id` | GET `/v1/receipts/{id}/` | Возвращает чек по идентификатору. | — |
| `Отправить чек` | POST `/v1/receipts/{id}/send/` |  | — |
| `Получить возврат по id` | GET `/v1/refunds/{id}/` | Получение возврата по id | — |
| `Получить подписки на отчеты магазина` | GET `/v1/report_subscriptions/` |  | — |
| `Создать подписку на отчеты.` | POST `/v1/report_subscriptions/` |  | — |
| `Получить подписку на отчет магазина` | GET `/v1/report_subscriptions/{report_subscription_id}/` |  | — |
| `Изменить подписку на отчеты.` | PUT `/v1/report_subscriptions/{report_subscription_id}/` |  | — |
| `Удалить подписку на отчеты.` | DELETE `/v1/report_subscriptions/{report_subscription_id}/` |  | — |
| `Получить список банков NSPK` | GET `/v1/settings/sbp/banks` | Получение списка банков NSPK | — |
| `Получить список доступных магазинов` | GET `/v1/shops/` |  | — |
| `Получить список аккаунтов` | GET `/v1/shops/accounts/` |  | — |
| `Создать аккаунт` | POST `/v1/shops/accounts/` |  | — |
| `Получить аккаунт по id` | GET `/v1/shops/accounts/{account_id}/` |  | — |
| `Обновить аккаунт` | PATCH `/v1/shops/accounts/{account_id}/` |  | — |
| `Удалить аккаунт` | DELETE `/v1/shops/accounts/{account_id}/` |  | — |
| `Получить список магазинов аккаунта` | GET `/v1/shops/accounts/{account_id}/accepted_shops/` |  | — |
| `Обновить список магазинов аккаунта` | PUT `/v1/shops/accounts/{account_id}/accepted_shops/` |  | — |
| `Получить список транзакций магазина` | GET `/v1/shops/transactions` | Получение списка транзакций текущего магазина | — |
| `Получить магазин по id` | GET `/v1/shops/{shop_id}` |  | — |
| `Обновить магазин` | PATCH `/v1/shops/{shop_id}` |  | — |
| `Получить сторис` | GET `/v1/stories/` | Возвращает список активных сторис, подходящих под условия аккаунта. Сторис с истёкшим окном hide_after_read_hours после первого просмотра исключаются. | — |
| `Отметить сторис прочитанной` | POST `/v1/stories/read/` | Идемпотентная отметка просмотра сторис текущим аккаунтом. Повторный вызов с тем же story_key возвращает успех без дубликата. | — |
| `Получить список сообщений` | GET `/v1/support/message/` | Сообщения пользовательского чата (сообщения тикетов скрываются автоматически). Передача `support_ticket_id` доступна только авторизованному аккаунту и позволяет загрузить переписку конкретного тикета. | — |
| `Создать сообщение в поддержку` | POST `/v1/support/message/` | <br>Требуется либо аккаунт из аутентификации, либо user_id из cookies.<br>Без параметра `support_ticket_id` сообщение будет помещено в чат аккаунта/пользователя.<br>Если указан `support_ticket_id`, то его можно передавать только от имени владельца аккаунта, тикет<br>должен быть в состоянии OPEN, а сообщение автоматически привяжется к переписке тикета.<br>Для прикрепления файлов передавайте имена документов в поле `attachment_doc_names` —<br>в ответе придут временные ссылки для загрузки, а при последующих запросах сообщения получат свежие ссылки на скачивание.<br> | — |
| `Количество непрочитанных сообщений` | GET `/v1/support/message/unread/` | Количество непрочитанных сообщений пользовательского чата (сообщения тикетов не учитываются). Доступно для аккаунта или user_id из cookies. | — |
| `Прочитать сообщение из поддержки` | POST `/v1/support/message/{message_id}/read/` |  | — |
| `Список обращений третьей линии` | GET `/v1/support/tickets/` |  | — |
| `Детали обращения третьей линии` | GET `/v1/support/tickets/{ticket_id}/` |  | — |
| `Получить задачу мерчанта` | GET `/v1/tasks/{task_id}/` | Возвращает подробную информацию о задаче, принадлежащей текущему мерчанту. | — |
| `Получить список шаблонов` | GET `/v1/templates/` |  | — |
| `Создать шаблон` | POST `/v1/templates/` |  | — |
| `Получить шаблон по id` | GET `/v1/templates/{template_id}/` |  | — |
| `Обновить шаблон` | PATCH `/v1/templates/{template_id}/` |  | — |
| `Удалить шаблон по id` | DELETE `/v1/templates/{template_id}/` |  | — |
| `Скачать статический QR шаблона` | GET `/v1/templates/{template_id}/download/{lang}/` |  | — |
| `Получить данные страницы оплаты по шаблону` | GET `/v1/templates/{template_id}/payment-info` | Данные трамплина - страницы плательщика для статического кода НСПК: описание и цвет шаблона, узкий блок магазина для брендинга, сумма (`null` у шаблона без суммы), идентификатор кода, универсальная ссылка НСПК и перечень платёжных сервисов.<br><br>Платёж не создаётся и не изменяется, идентификатора платежа в ответе нет: опрашивать статус нечего, результат оплаты плательщик видит в приложении банка.<br><br>Ленты банков по умолчанию не отдаются - только по явному `?with_banks=true`. На десктопе они не нужны: там плательщик сканирует один QR из `static_url`, а выбор между СБП и цифровым рублём делает приложение банка. Форма ленты совпадает с `GET /v1/payments/{id}/services`, коды сервисов - с `payment_services` ответа платежа.<br><br>Только для шаблонов с общим статическим кодом НСПК. Шаблону ITPay и шаблону с персональным кодом приходит `400` с кодом `11227`: у них своя страница оплаты с созданием платежа.<br><br>Прочие отказы: `403` (`10403`) - шаблон принадлежит другому мерчанту, `429` (`10429`) - превышено ограничение частоты, `500` (`10500`) - шаблон прочитать не удалось. | — |
| `Создать платеж-чаевые` | POST `/v1/tips/` | API. Создание standalone чаевых (без привязки к заказу).<br>Авторизация через системный Basic API Key SSR-фронтенда. | — |
| `Получить цели накопления чаевых` | GET `/v1/tips/goals/` | API. Цели накопления чаевых сотрудника: список и создание. | — |
| `Создать цель накопления чаевых` | POST `/v1/tips/goals/` | API. Цели накопления чаевых сотрудника: список и создание. | — |
| `Изменить цель накопления чаевых` | PATCH `/v1/tips/goals/{id}/` | API. Цель накопления чаевых сотрудника: изменение и удаление. | — |
| `Удалить цель накопления чаевых` | DELETE `/v1/tips/goals/{id}/` | API. Цель накопления чаевых сотрудника: изменение и удаление. | — |
| `Получить QR-код для чаевых` | GET `/v1/tips/qr/` | API. Получение QR-кода для приёма чаевых. | — |
| `Предрасчёт чаевых (quote)` | POST `/v1/tips/quote` | API. Предрасчёт чаевых для страницы оплаты (плательщик). | — |
| `Получить магазин с настройками чаевых` | GET `/v1/tips/shop/{shop_id}/` | API. Публичная витрина чаевых магазина для страницы плательщика. | — |
| `Получить историю транзакций чаевых` | GET `/v1/tips/transactions/` | API. История транзакций чаевых с фильтрами и агрегатами. | — |
| `Получить транзакцию чаевых по ID` | GET `/v1/tips/transactions/{id}/` | API. Детальная информация о транзакции чаевых по ID. | — |
| `Перевести чаевые` | POST `/v1/tips/transfers/` | API. Перевод чаевых между аккаунтами или с общего баланса на персональный. | — |
| `Вывести чаевые` | POST `/v1/tips/withdrawals/` | API. Вывод чаевых на банковский счёт сотрудника по СБП. | — |

## Обоснование выбора операций

- `create` (создание): POST `/v1/payments` — оценка 82; следующий кандидат POST `/v1/tips/withdrawals/` — оценка 82; разница 0.
- `status` (проверка статуса): GET `/v1/payments/{id}` — оценка 67; следующий кандидат PUT `/v1/payments/{id}` — оценка 28; разница 39.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `new` | `in_progress` |
| `paid` | `approved` |
| `processing` | `in_progress` |
| `completed` | `approved` |
| `cancelled` | `rejected` |
| `rejected` | `rejected` |
| `error` | `rejected` |
| `paying` | `in_progress` |
| `bill` | `in_progress` |
| `deleted` | `rejected` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `amount` | `operation.amount` |
| `client_payment_id` | **TODO:** подтвердить схему платформы |
| `method` | **TODO:** подтвердить схему платформы |
| `metadata` | **TODO:** подтвердить схему платформы |
| `description` | **TODO:** подтвердить схему платформы |
| `cash_link_id` | **TODO:** подтвердить схему платформы |
| `client_receipt.customer_email` | **TODO:** подтвердить схему платформы |
| `client_receipt.customer_phone` | **TODO:** подтвердить схему платформы |
| `client_receipt.taxation_system` | **TODO:** подтвердить схему платформы |
| `client_receipt.items` | **TODO:** подтвердить схему платформы |
| `client_crypto_addr` | **TODO:** подтвердить схему платформы |
| `catalog_items` | **TODO:** подтвердить схему платформы |
| `success_url` | **TODO:** подтвердить схему платформы |
| `success_url_description` | **TODO:** подтвердить схему платформы |
| `tips_amount` | **TODO:** подтвердить схему платформы |
| `fee_mode` | `literal:on_top` |
| `expected_total` | **TODO:** подтвердить схему платформы |
| `expected_commission` | **TODO:** подтвердить схему платформы |
| `token_id` | **TODO:** подтвердить схему платформы |
| `save` | **TODO:** подтвердить схему платформы |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
| 400 | `bad_request` | не повторять автоматически |
| 401 | `unauthorized` | исправить учётные данные и уведомить сопровождение |
| 403 | `forbidden` | не повторять автоматически |
| 404 | `bad_request` | не повторять автоматически |
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
- Неоднозначный выбор операции создания: POST /v1/payments — оценка 82; следующий кандидат POST /v1/tips/withdrawals/ — оценка 82; разница 0. Проверьте выбор вручную.
- Для POST /v1/payments не поддерживается объявленная схема авторизации; требуется явная реализация.
- Для GET /v1/payments/{id} не поддерживается объявленная схема авторизации; требуется явная реализация.
- TODO required_if client_receipt.customer_email: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO required_if client_receipt.customer_phone: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO field_map client_payment_id: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
