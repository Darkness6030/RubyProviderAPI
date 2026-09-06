# Provider API v1.0

Детерминированный генератор интеграций с платёжными провайдерами. Принимает OpenAPI 3.x или Swagger 2.0 в YAML/JSON и создаёт Ruby-сервис, руководство по подключению и тестовые фикстуры.

## Чем отличается решение

- Для каждой роли сохраняются выбранный метод, ближайший кандидат, оценки и разница между ними — выбор можно перепроверить.
- Спорный выбор можно явно подтвердить в `overrides` по `operation_id` либо по паре HTTP-метод + путь.
- Выплатные методы имеют явный приоритет; платежи используются только как запасной сценарий для спецификаций без выплат.
- Неподтверждённые единицы суммы, поля и статусы не превращаются в правдоподобный код: генератор оставляет адресный `TODO`, а `--strict` останавливает сборку.
- Ограничения `minimum`, `maximum`, `pattern`, `enum`, `minLength` и `maxLength` проверяются до HTTP-вызова.
- `--verify` проверяет синтаксис, контракт, сценарий без сети и побайтовую повторяемость результата.
- Обязательные артефакты дополнены маппингом полей, всеми адресами API, реакциями на ошибки, итогом готовности и отрицательными сценариями.
- То же ядро проверяется на 12 сохранённых API и 1430 операциях; в анализаторе нет веток по имени провайдера.

## Как устроено

```text
OpenAPI / Swagger
        ↓
SpecLoader — читает и приводит форматы к одной структуре
        ↓
Analyzer — сравнивает кандидатов и отмечает спорные решения
        ↓
Generator — выпускает сервис, руководство и фикстуры
```

## Быстрый запуск

Требуется Docker с поддержкой Compose.

```bash
docker compose build
docker compose run --rm generator
```

Результат появится в каталоге `output/`:

- `novapay_service.rb` — сервис по контракту `Provider::BaseService`;
- `INTEGRATION.md` — настройка, авторизация, методы, статусы, ошибки и предупреждения;
- `fixtures.json` — примеры запросов, ответов и входящих уведомлений.

Для собственной спецификации:

```bash
docker compose run --rm generator \
  --spec examples/novapay/openapi.yaml \
  --provider novapay \
  --overrides examples/novapay/overrides.yaml \
  --output output
```

Для генерации с полной самопроверкой:

```bash
docker compose run --rm generator \
  --spec examples/novapay/openapi.yaml \
  --provider novapay \
  --overrides examples/novapay/overrides.yaml \
  --output output \
  --verify
```

`--verbose` выводит все найденные операции. `--strict` завершает процесс с кодом `3`, если остались решения, требующие подтверждения. `--verify` возвращает код `4`, если пакет не прошёл проверку.

Явное подтверждение ролей в `overrides`:

```yaml
operations:
  create:
    operation_id: createPayout
  status:
    method: get
    path: /payouts/{payout_id}
  webhook:
    operation_id: payoutWebhook
```

## Проверка

Полный набор автоматических тестов:

```bash
docker compose run --rm --entrypoint ruby \
  generator -I/workspace/lib /workspace/test/all_tests.rb --verbose
```

Проверка одного ядра на 12 сохранённых API:

```bash
docker compose run --rm --entrypoint ruby \
  generator /workspace/bin/run_real_corpus /workspace/test/results
```

Текущий результат: 21 тест, 281 проверка, 12 из 12 сценариев корпуса без ошибок.

## Материалы

- [Пример OpenAPI и подтверждённые настройки NovaPay](examples/novapay/)
- [Финальная презентация](presentation/index.html)

## Граница решения

Генератор выпускает проверяемую заготовку интеграции. Подтверждённый контракт уже учитывает `operation.id`, `operation.amount`, JSONB-хеш `operation.payout_requisite`, `provider_operation_key`, возврат `success(result: { id: ... })` и смену статуса через `approve_operation` / `reject_operation`. Перед рабочим подключением остаётся сверить интерфейс HTTP-клиента и точные сигнатуры хелперов с реальным `Provider::BaseService`. Неподтверждённая бизнес-семантика не применяется молча: она становится предупреждением и фиксируется в универсальном файле уточнений.

Проект не использует нейросети и проприетарные библиотеки. Ядро, CLI и тесты написаны на Ruby и работают на стандартной библиотеке.
