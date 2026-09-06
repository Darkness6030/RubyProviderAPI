# Руководство по интеграции AdyenCheckout

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 15. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://checkout-test.adyen.com/v72`
- Переменная окружения: `ADYEN_CHECKOUT_BASE_URL`
- API-ключ: `ADYEN_CHECKOUT_API_KEY`

Адреса из OpenAPI:

- API: `https://checkout-test.adyen.com/v72`

## Авторизация

- `ApiKeyAuth`: apiKey, header `X-API-Key`
- `BasicAuth`: http,  ``

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `post-applePay-sessions` | POST `/applePay/sessions` | Get an Apple Pay session | да |
| `post-cancels` | POST `/cancels` | Cancel an authorised payment | да |
| `post-cardDetails` | POST `/cardDetails` | Get the brands and other details of a card | да |
| `post-donationCampaigns` | POST `/donationCampaigns` | Get a list of donation campaigns. | да |
| `post-donations` | POST `/donations` | Make a donation | да |
| `post-forward` | POST `/forward` | Forward stored payment details | да |
| `post-orders` | POST `/orders` | Create an order | да |
| `post-orders-cancel` | POST `/orders/cancel` | Cancel an order | да |
| `post-originKeys` | POST `/originKeys` | Create originKey values for domains | да |
| `post-paymentLinks` | POST `/paymentLinks` | Create a payment link | да |
| `get-paymentLinks-linkId` | GET `/paymentLinks/{linkId}` | Get a payment link | — |
| `patch-paymentLinks-linkId` | PATCH `/paymentLinks/{linkId}` | Update the status of a payment link | — |
| `post-paymentMethods` | POST `/paymentMethods` | Get a list of available payment methods | да |
| `post-paymentMethods-balance` | POST `/paymentMethods/balance` | Get the balance of a gift card | да |
| `post-payments` | POST `/payments` | Start a transaction | да |
| `post-payments-details` | POST `/payments/details` | Submit details for a payment | да |
| `post-payments-paymentPspReference-amountUpdates` | POST `/payments/{paymentPspReference}/amountUpdates` | Update an authorised amount | да |
| `post-payments-paymentPspReference-cancels` | POST `/payments/{paymentPspReference}/cancels` | Cancel an authorised payment | да |
| `post-payments-paymentPspReference-captures` | POST `/payments/{paymentPspReference}/captures` | Capture an authorised payment | да |
| `post-payments-paymentPspReference-refunds` | POST `/payments/{paymentPspReference}/refunds` | Refund a captured payment | да |
| `post-payments-paymentPspReference-reversals` | POST `/payments/{paymentPspReference}/reversals` | Refund or cancel a payment | да |
| `post-paypal-updateOrder` | POST `/paypal/updateOrder` | Updates the order for PayPal Express Checkout | да |
| `post-sessions` | POST `/sessions` | Create a payment session | да |
| `get-sessions-sessionId` | GET `/sessions/{sessionId}` | Get the result of a payment session | — |
| `patch-sessions-sessionId` | PATCH `/sessions/{sessionId}` | Update a payment session | — |
| `get-storedPaymentMethods` | GET `/storedPaymentMethods` | Get tokens for stored payment details | — |
| `post-storedPaymentMethods` | POST `/storedPaymentMethods` | Create a token to store payment details | да |
| `delete-storedPaymentMethods-storedPaymentMethodId` | DELETE `/storedPaymentMethods/{storedPaymentMethodId}` | Delete a token for stored payment details | — |
| `post-validateShopperId` | POST `/validateShopperId` | Validates shopper Id | — |

## Обоснование выбора операций

- `create` (создание): POST `/payments` — оценка 67; следующий кандидат POST `/sessions` — оценка 60; разница 7.
- `status` (проверка статуса): GET `/sessions/{sessionId}` — оценка 22; следующий кандидат POST `/payments/{paymentPspReference}/amountUpdates` — оценка 18; разница 4.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `AuthenticationFinished` | `in_progress` |
| `AuthenticationNotRequired` | `in_progress` |
| `Authorised` | `approved` |
| `Cancelled` | `rejected` |
| `ChallengeShopper` | `in_progress` |
| `Error` | `rejected` |
| `IdentifyShopper` | `in_progress` |
| `PartiallyAuthorised` | `in_progress` |
| `Pending` | `in_progress` |
| `PresentToShopper` | `in_progress` |
| `Received` | `in_progress` |
| `RedirectShopper` | `in_progress` |
| `Refused` | `rejected` |
| `Success` | `approved` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `accountInfo.accountAgeIndicator` | **TODO:** подтвердить схему платформы |
| `accountInfo.accountChangeDate` | **TODO:** подтвердить схему платформы |
| `accountInfo.accountChangeIndicator` | **TODO:** подтвердить схему платформы |
| `accountInfo.accountCreationDate` | **TODO:** подтвердить схему платформы |
| `accountInfo.accountType` | **TODO:** подтвердить схему платформы |
| `accountInfo.addCardAttemptsDay` | **TODO:** подтвердить схему платформы |
| `accountInfo.deliveryAddressUsageDate` | **TODO:** подтвердить схему платформы |
| `accountInfo.deliveryAddressUsageIndicator` | **TODO:** подтвердить схему платформы |
| `accountInfo.homePhone` | **TODO:** подтвердить схему платформы |
| `accountInfo.mobilePhone` | **TODO:** подтвердить схему платформы |
| `accountInfo.passwordChangeDate` | **TODO:** подтвердить схему платформы |
| `accountInfo.passwordChangeIndicator` | **TODO:** подтвердить схему платформы |
| `accountInfo.pastTransactionsDay` | **TODO:** подтвердить схему платформы |
| `accountInfo.pastTransactionsYear` | **TODO:** подтвердить схему платформы |
| `accountInfo.paymentAccountAge` | **TODO:** подтвердить схему платформы |
| `accountInfo.paymentAccountIndicator` | **TODO:** подтвердить схему платформы |
| `accountInfo.purchasesLast6Months` | **TODO:** подтвердить схему платформы |
| `accountInfo.suspiciousActivity` | **TODO:** подтвердить схему платформы |
| `accountInfo.workPhone` | **TODO:** подтвердить схему платформы |
| `additionalAmount.currency` | **TODO:** подтвердить схему платформы |
| `additionalAmount.value` | **TODO:** подтвердить схему платформы |
| `additionalData` | **TODO:** подтвердить схему платформы |
| `amount.currency` | **TODO:** подтвердить схему платформы |
| `amount.value` | **TODO:** подтвердить схему платформы |
| `applicationInfo.adyenLibrary.name` | **TODO:** подтвердить схему платформы |
| `applicationInfo.adyenLibrary.version` | **TODO:** подтвердить схему платформы |
| `applicationInfo.adyenPaymentSource.name` | **TODO:** подтвердить схему платформы |
| `applicationInfo.adyenPaymentSource.version` | **TODO:** подтвердить схему платформы |
| `applicationInfo.externalPlatform.integrator` | **TODO:** подтвердить схему платформы |
| `applicationInfo.externalPlatform.name` | **TODO:** подтвердить схему платформы |
| `applicationInfo.externalPlatform.version` | **TODO:** подтвердить схему платформы |
| `applicationInfo.merchantApplication.name` | **TODO:** подтвердить схему платформы |
| `applicationInfo.merchantApplication.version` | **TODO:** подтвердить схему платформы |
| `applicationInfo.merchantDevice.os` | **TODO:** подтвердить схему платформы |
| `applicationInfo.merchantDevice.osVersion` | **TODO:** подтвердить схему платформы |
| `applicationInfo.merchantDevice.reference` | **TODO:** подтвердить схему платформы |
| `applicationInfo.shopperInteractionDevice.locale` | **TODO:** подтвердить схему платформы |
| `applicationInfo.shopperInteractionDevice.os` | **TODO:** подтвердить схему платформы |
| `applicationInfo.shopperInteractionDevice.osVersion` | **TODO:** подтвердить схему платформы |
| `authenticationData.attemptAuthentication` | **TODO:** подтвердить схему платформы |
| `authenticationData.authenticationOnly` | `literal:false` |
| `authenticationData.threeDSRequestData.challengeWindowSize` | **TODO:** подтвердить схему платформы |
| `authenticationData.threeDSRequestData.dataOnly` | **TODO:** подтвердить схему платформы |
| `authenticationData.threeDSRequestData.nativeThreeDS` | **TODO:** подтвердить схему платформы |
| `authenticationData.threeDSRequestData.threeDSVersion` | **TODO:** подтвердить схему платформы |
| `bankAccount.accountType` | **TODO:** подтвердить схему платформы |
| `bankAccount.bankAccountNumber` | **TODO:** подтвердить схему платформы |
| `bankAccount.bankCity` | **TODO:** подтвердить схему платформы |
| `bankAccount.bankLocationId` | **TODO:** подтвердить схему платформы |
| `bankAccount.bankName` | **TODO:** подтвердить схему платформы |
| `bankAccount.bic` | **TODO:** подтвердить схему платформы |
| `bankAccount.countryCode` | **TODO:** подтвердить схему платформы |
| `bankAccount.iban` | **TODO:** подтвердить схему платформы |
| `bankAccount.ownerName` | **TODO:** подтвердить схему платформы |
| `bankAccount.taxId` | **TODO:** подтвердить схему платформы |
| `billingAddress.city` | **TODO:** подтвердить схему платформы |
| `billingAddress.country` | **TODO:** подтвердить схему платформы |
| `billingAddress.houseNumberOrName` | **TODO:** подтвердить схему платформы |
| `billingAddress.postalCode` | **TODO:** подтвердить схему платформы |
| `billingAddress.stateOrProvince` | **TODO:** подтвердить схему платформы |
| `billingAddress.street` | **TODO:** подтвердить схему платформы |
| `browserInfo.acceptHeader` | **TODO:** подтвердить схему платформы |
| `browserInfo.colorDepth` | **TODO:** подтвердить схему платформы |
| `browserInfo.javaEnabled` | **TODO:** подтвердить схему платформы |
| `browserInfo.javaScriptEnabled` | `literal:true` |
| `browserInfo.language` | **TODO:** подтвердить схему платформы |
| `browserInfo.screenHeight` | **TODO:** подтвердить схему платформы |
| `browserInfo.screenWidth` | **TODO:** подтвердить схему платформы |
| `browserInfo.timeZoneOffset` | **TODO:** подтвердить схему платформы |
| `browserInfo.userAgent` | **TODO:** подтвердить схему платформы |
| `captureDelayHours` | **TODO:** подтвердить схему платформы |
| `channel` | **TODO:** подтвердить схему платформы |
| `checkoutAttemptId` | **TODO:** подтвердить схему платформы |
| `company.homepage` | **TODO:** подтвердить схему платформы |
| `company.name` | **TODO:** подтвердить схему платформы |
| `company.registrationNumber` | **TODO:** подтвердить схему платформы |
| `company.registryLocation` | **TODO:** подтвердить схему платформы |
| `company.taxId` | **TODO:** подтвердить схему платформы |
| `company.type` | **TODO:** подтвердить схему платформы |
| `countryCode` | **TODO:** подтвердить схему платформы |
| `dateOfBirth` | **TODO:** подтвердить схему платформы |
| `dccQuote.account` | **TODO:** подтвердить схему платформы |
| `dccQuote.accountType` | **TODO:** подтвердить схему платформы |
| `dccQuote.baseAmount.currency` | **TODO:** подтвердить схему платформы |
| `dccQuote.baseAmount.value` | **TODO:** подтвердить схему платформы |
| `dccQuote.basePoints` | **TODO:** подтвердить схему платформы |
| `dccQuote.buy.currency` | **TODO:** подтвердить схему платформы |
| `dccQuote.buy.value` | **TODO:** подтвердить схему платформы |
| `dccQuote.interbank.currency` | **TODO:** подтвердить схему платформы |
| `dccQuote.interbank.value` | **TODO:** подтвердить схему платформы |
| `dccQuote.reference` | **TODO:** подтвердить схему платформы |
| `dccQuote.sell.currency` | **TODO:** подтвердить схему платформы |
| `dccQuote.sell.value` | **TODO:** подтвердить схему платформы |
| `dccQuote.signature` | **TODO:** подтвердить схему платформы |
| `dccQuote.source` | **TODO:** подтвердить схему платформы |
| `dccQuote.type` | **TODO:** подтвердить схему платформы |
| `dccQuote.validTill` | **TODO:** подтвердить схему платформы |
| `deliverAt` | **TODO:** подтвердить схему платформы |
| `deliveryAddress.city` | **TODO:** подтвердить схему платформы |
| `deliveryAddress.country` | **TODO:** подтвердить схему платформы |
| `deliveryAddress.firstName` | **TODO:** подтвердить схему платформы |
| `deliveryAddress.houseNumberOrName` | **TODO:** подтвердить схему платформы |
| `deliveryAddress.lastName` | **TODO:** подтвердить схему платформы |
| `deliveryAddress.postalCode` | **TODO:** подтвердить схему платформы |
| `deliveryAddress.stateOrProvince` | **TODO:** подтвердить схему платформы |
| `deliveryAddress.street` | **TODO:** подтвердить схему платформы |
| `deliveryDate` | **TODO:** подтвердить схему платформы |
| `deviceFingerprint` | **TODO:** подтвердить схему платформы |
| `enableOneClick` | **TODO:** подтвердить схему платформы |
| `enablePayOut` | **TODO:** подтвердить схему платформы |
| `enableRecurring` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.agency.invoiceNumber` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.agency.planName` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.boardingFee` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.code` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.computerizedReservationSystem` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.customerReferenceNumber` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.designatorCode` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.documentType` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.flightDate` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.legs` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.passengerName` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.passengers` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.ticket.issueAddress` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.ticket.issueDate` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.ticket.number` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.travelAgency.code` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.airline.travelAgency.name` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.customerServicePhoneNumber` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.noShow` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.pickupInfo.city` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.pickupInfo.countryCode` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.pickupInfo.date` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.pickupInfo.stateOrProvince` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.rateType` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.rentalAgreementNumber` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.rentalClassId` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.rentalDays` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.rentalRate` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.rentalSurcharges.fuel` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.rentalSurcharges.insurance` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.rentalSurcharges.oneWayDropOff` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.renterName` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.returnInfo.city` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.returnInfo.countryCode` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.returnInfo.date` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.returnInfo.locationId` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.returnInfo.stateOrProvince` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.carRental.taxExempt` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.healthcare.dentalValue` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.healthcare.otherMedicalValue` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.healthcare.prescriptionValue` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.healthcare.totalHealthcareValue` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.healthcare.visionPrescriptionValue` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.customerReferenceNumber` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.destination.countryCode` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.destination.postalCode` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.destination.stateOrProvince` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.dutyAmount` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.freightAmount` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.itemDetailLines` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.orderDate` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.shipFromPostalCode` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.levelTwoThree.totalTaxAmount` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.checkInDate` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.checkOutDate` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.customerServicePhoneNumber` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.fireSafetyCompliance` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.folio.cashAdvances` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.folio.number` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.foodBeverageCharges` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.lodgingChargeType` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.noShow` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.prepaidExpenses` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.propertyPhoneNumber` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.renterName` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.rooms` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.totalRoomTax` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.lodging.totalTax` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.temporaryServices.employeeName` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.temporaryServices.endDate` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.temporaryServices.hourRate` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.temporaryServices.hoursWorked` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.temporaryServices.jobDescription` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.temporaryServices.serviceRequestor` | **TODO:** подтвердить схему платформы |
| `enhancedSchemeData.temporaryServices.startDate` | **TODO:** подтвердить схему платформы |
| `entityType` | **TODO:** подтвердить схему платформы |
| `fraudOffset` | **TODO:** подтвердить схему платформы |
| `fundOrigin.billingAddress.city` | **TODO:** подтвердить схему платформы |
| `fundOrigin.billingAddress.country` | **TODO:** подтвердить схему платформы |
| `fundOrigin.billingAddress.houseNumberOrName` | **TODO:** подтвердить схему платформы |
| `fundOrigin.billingAddress.postalCode` | **TODO:** подтвердить схему платформы |
| `fundOrigin.billingAddress.stateOrProvince` | **TODO:** подтвердить схему платформы |
| `fundOrigin.billingAddress.street` | **TODO:** подтвердить схему платформы |
| `fundOrigin.shopperEmail` | **TODO:** подтвердить схему платформы |
| `fundOrigin.shopperName.firstName` | **TODO:** подтвердить схему платформы |
| `fundOrigin.shopperName.lastName` | **TODO:** подтвердить схему платформы |
| `fundOrigin.telephoneNumber` | **TODO:** подтвердить схему платформы |
| `fundOrigin.walletIdentifier` | **TODO:** подтвердить схему платформы |
| `fundRecipient.IBAN` | **TODO:** подтвердить схему платформы |
| `fundRecipient.billingAddress.city` | **TODO:** подтвердить схему платформы |
| `fundRecipient.billingAddress.country` | **TODO:** подтвердить схему платформы |
| `fundRecipient.billingAddress.houseNumberOrName` | **TODO:** подтвердить схему платформы |
| `fundRecipient.billingAddress.postalCode` | **TODO:** подтвердить схему платформы |
| `fundRecipient.billingAddress.stateOrProvince` | **TODO:** подтвердить схему платформы |
| `fundRecipient.billingAddress.street` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.billingSequenceNumber` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.brand` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.checkoutAttemptId` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.cupsecureplus.smscode` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.cvc` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.encryptedCard` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.encryptedCardNumber` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.encryptedExpiryMonth` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.encryptedExpiryYear` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.encryptedPassword` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.encryptedSecurityCode` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.expiryMonth` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.expiryYear` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.fastlaneData` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.fundingSource` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.holderName` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.networkPaymentReference` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.number` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.recurringDetailReference` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.sdkData` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.shopperNotificationReference` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.srcCorrelationId` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.srcDigitalCardId` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.srcScheme` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.srcTokenReference` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.storedPaymentMethodId` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.threeDS2SdkVersion` | **TODO:** подтвердить схему платформы |
| `fundRecipient.paymentMethod.type` | `literal:scheme` |
| `fundRecipient.shopperEmail` | **TODO:** подтвердить схему платформы |
| `fundRecipient.shopperName.firstName` | **TODO:** подтвердить схему платформы |
| `fundRecipient.shopperName.lastName` | **TODO:** подтвердить схему платформы |
| `fundRecipient.shopperReference` | **TODO:** подтвердить схему платформы |
| `fundRecipient.storedPaymentMethodId` | **TODO:** подтвердить схему платформы |
| `fundRecipient.subMerchant.city` | **TODO:** подтвердить схему платформы |
| `fundRecipient.subMerchant.country` | **TODO:** подтвердить схему платформы |
| `fundRecipient.subMerchant.mcc` | **TODO:** подтвердить схему платформы |
| `fundRecipient.subMerchant.name` | **TODO:** подтвердить схему платформы |
| `fundRecipient.subMerchant.taxId` | **TODO:** подтвердить схему платформы |
| `fundRecipient.telephoneNumber` | **TODO:** подтвердить схему платформы |
| `fundRecipient.walletIdentifier` | **TODO:** подтвердить схему платформы |
| `fundRecipient.walletOwnerTaxId` | **TODO:** подтвердить схему платформы |
| `fundRecipient.walletPurpose` | **TODO:** подтвердить схему платформы |
| `industryUsage` | **TODO:** подтвердить схему платформы |
| `installments.extra` | **TODO:** подтвердить схему платформы |
| `installments.plan` | **TODO:** подтвердить схему платформы |
| `installments.value` | **TODO:** подтвердить схему платформы |
| `lineItems` | **TODO:** подтвердить схему платформы |
| `localizedShopperStatement` | **TODO:** подтвердить схему платформы |
| `mandate.amount` | **TODO:** подтвердить схему платформы |
| `mandate.amountRule` | **TODO:** подтвердить схему платформы |
| `mandate.billingAttemptsRule` | **TODO:** подтвердить схему платформы |
| `mandate.billingDay` | **TODO:** подтвердить схему платформы |
| `mandate.count` | **TODO:** подтвердить схему платформы |
| `mandate.endsAt` | **TODO:** подтвердить схему платформы |
| `mandate.frequency` | **TODO:** подтвердить схему платформы |
| `mandate.remarks` | **TODO:** подтвердить схему платформы |
| `mandate.startsAt` | **TODO:** подтвердить схему платформы |
| `mcc` | **TODO:** подтвердить схему платформы |
| `merchantAccount` | **TODO:** подтвердить схему платформы |
| `merchantOrderReference` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.addressMatch` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.deliveryAddressIndicator` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.deliveryEmail` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.deliveryEmailAddress` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.deliveryTimeframe` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.giftCardAmount.currency` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.giftCardAmount.value` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.giftCardCount` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.giftCardCurr` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.preOrderDate` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.preOrderPurchase` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.preOrderPurchaseInd` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.reorderItems` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.reorderItemsInd` | **TODO:** подтвердить схему платформы |
| `merchantRiskIndicator.shipIndicator` | **TODO:** подтвердить схему платформы |
| `metadata` | **TODO:** подтвердить схему платформы |
| `mpiData.authenticationResponse` | **TODO:** подтвердить схему платформы |
| `mpiData.cavv` | **TODO:** подтвердить схему платформы |
| `mpiData.cavvAlgorithm` | **TODO:** подтвердить схему платформы |
| `mpiData.challengeCancel` | **TODO:** подтвердить схему платформы |
| `mpiData.directoryResponse` | **TODO:** подтвердить схему платформы |
| `mpiData.dsTransID` | **TODO:** подтвердить схему платформы |
| `mpiData.eci` | **TODO:** подтвердить схему платформы |
| `mpiData.riskScore` | **TODO:** подтвердить схему платформы |
| `mpiData.threeDSVersion` | **TODO:** подтвердить схему платформы |
| `mpiData.tokenAuthenticationVerificationValue` | **TODO:** подтвердить схему платформы |
| `mpiData.transStatusReason` | **TODO:** подтвердить схему платформы |
| `mpiData.xid` | **TODO:** подтвердить схему платформы |
| `order.orderData` | **TODO:** подтвердить схему платформы |
| `order.pspReference` | **TODO:** подтвердить схему платформы |
| `orderReference` | **TODO:** подтвердить схему платформы |
| `origin` | **TODO:** подтвердить схему платформы |
| `paymentMethod` | **TODO:** подтвердить схему платформы |
| `paymentValidations.name.status` | **TODO:** подтвердить схему платформы |
| `platformChargebackLogic.behavior` | **TODO:** подтвердить схему платформы |
| `platformChargebackLogic.costAllocationAccount` | **TODO:** подтвердить схему платформы |
| `platformChargebackLogic.targetAccount` | **TODO:** подтвердить схему платформы |
| `recurringExpiry` | **TODO:** подтвердить схему платформы |
| `recurringFrequency` | **TODO:** подтвердить схему платформы |
| `recurringProcessingModel` | **TODO:** подтвердить схему платформы |
| `redirectFromIssuerMethod` | **TODO:** подтвердить схему платформы |
| `redirectToIssuerMethod` | **TODO:** подтвердить схему платформы |
| `reference` | **TODO:** подтвердить схему платформы |
| `returnUrl` | **TODO:** подтвердить схему платформы |
| `riskData.clientData` | **TODO:** подтвердить схему платформы |
| `riskData.customFields` | **TODO:** подтвердить схему платформы |
| `riskData.fraudOffset` | **TODO:** подтвердить схему платформы |
| `riskData.profileReference` | **TODO:** подтвердить схему платформы |
| `sessionValidity` | **TODO:** подтвердить схему платформы |
| `shopperConversionId` | **TODO:** подтвердить схему платформы |
| `shopperEmail` | **TODO:** подтвердить схему платформы |
| `shopperIP` | **TODO:** подтвердить схему платформы |
| `shopperInteraction` | **TODO:** подтвердить схему платформы |
| `shopperLocale` | **TODO:** подтвердить схему платформы |
| `shopperName.firstName` | **TODO:** подтвердить схему платформы |
| `shopperName.lastName` | **TODO:** подтвердить схему платформы |
| `shopperReference` | **TODO:** подтвердить схему платформы |
| `shopperStatement` | **TODO:** подтвердить схему платформы |
| `shopperTaxInfo.taxCountryCode` | **TODO:** подтвердить схему платформы |
| `shopperTaxInfo.taxIdentificationNumber` | **TODO:** подтвердить схему платформы |
| `socialSecurityNumber` | **TODO:** подтвердить схему платформы |
| `splits` | **TODO:** подтвердить схему платформы |
| `store` | **TODO:** подтвердить схему платформы |
| `storePaymentMethod` | **TODO:** подтвердить схему платформы |
| `subMerchants` | **TODO:** подтвердить схему платформы |
| `surcharge.value` | **TODO:** подтвердить схему платформы |
| `telephoneNumber` | **TODO:** подтвердить схему платформы |
| `thirdPartyTokenRedundancyInfo.requestParameters` | **TODO:** подтвердить схему платформы |
| `thirdPartyTokenRedundancyInfo.requestTemplateCode` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.chAccAgeInd` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.chAccChange` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.chAccChangeInd` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.chAccPwChange` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.chAccPwChangeInd` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.chAccString` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.nbPurchaseAccount` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.paymentAccAge` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.paymentAccInd` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.provisionAttemptsDay` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.shipAddressUsage` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.shipAddressUsageInd` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.shipNameIndicator` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.suspiciousAccActivity` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.txnActivityDay` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctInfo.txnActivityYear` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acctType` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acquirerBIN` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.acquirerMerchantID` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.addrMatch` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.authenticationOnly` | `literal:false` |
| `threeDS2RequestData.challengeIndicator` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.deviceRenderOptions.sdkInterface` | `literal:both` |
| `threeDS2RequestData.deviceRenderOptions.sdkUiType` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.homePhone.cc` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.homePhone.subscriber` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.mcc` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.merchantName` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.messageVersion` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.mobilePhone.cc` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.mobilePhone.subscriber` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.notificationURL` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.payTokenInd` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.paymentAuthenticationUseCase` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.purchaseInstalData` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.recurringExpiry` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.recurringFrequency` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.sdkAppID` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.sdkEphemPubKey.crv` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.sdkEphemPubKey.kty` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.sdkEphemPubKey.x` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.sdkEphemPubKey.y` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.sdkMaxTimeout` | `literal:60` |
| `threeDS2RequestData.sdkReferenceNumber` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.sdkTransID` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSCompInd` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorAuthenticationInd` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorAuthenticationInfo.threeDSReqAuthData` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorAuthenticationInfo.threeDSReqAuthMethod` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorAuthenticationInfo.threeDSReqAuthTimestamp` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorChallengeInd` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorID` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorName` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorAuthData` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorAuthMethod` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorAuthTimestamp` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorPriorAuthenticationInfo.threeDSReqPriorRef` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.threeDSRequestorURL` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.transType` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.transactionType` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.whiteListStatus` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.workPhone.cc` | **TODO:** подтвердить схему платформы |
| `threeDS2RequestData.workPhone.subscriber` | **TODO:** подтвердить схему платформы |
| `threeDSAuthenticationOnly` | `literal:false` |
| `trustedShopper` | **TODO:** подтвердить схему платформы |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|
| 400 | `bad_request` | не повторять автоматически |
| 401 | `unauthorized` | исправить учётные данные и уведомить сопровождение |
| 403 | `forbidden` | не повторять автоматически |
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

- Не удалось определить операцию проверки статуса.
- Не удалось определить входящий webhook.
- Неоднозначный выбор операции создания: POST /payments — оценка 67; следующий кандидат POST /sessions — оценка 60; разница 7. Проверьте выбор вручную.
- TODO amount_unit: единица суммы указана только в description; подтвердите её в overrides.
- TODO required_if authenticationData.threeDSRequestData.dataOnly: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO required_if fundRecipient.subMerchant: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO required_if recurringProcessingModel: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO required_if threeDS2RequestData.threeDSRequestorID: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO required_if threeDS2RequestData.threeDSRequestorName: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO field_map amount.currency: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map amount.value: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map merchantAccount: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map paymentMethod: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map reference: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map returnUrl: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
