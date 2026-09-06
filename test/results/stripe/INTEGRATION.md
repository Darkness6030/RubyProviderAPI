# Руководство по интеграции Stripe

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 2. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://api.stripe.com/`
- Переменная окружения: `STRIPE_BASE_URL`
- API-ключ: `STRIPE_API_KEY`

Адреса из OpenAPI:

- API: `https://api.stripe.com/`

## Авторизация

- `basicAuth`: http,  ``
- `bearerAuth`: http,  ``

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `GetAccount` | GET `/v1/account` | Retrieve account | — |
| `PostAccountLinks` | POST `/v1/account_links` | Create an account link | — |
| `PostAccountSessions` | POST `/v1/account_sessions` | Create an Account Session | — |
| `GetAccounts` | GET `/v1/accounts` | List all connected accounts | — |
| `PostAccounts` | POST `/v1/accounts` | Create an account | — |
| `GetAccountsAccount` | GET `/v1/accounts/{account}` | Retrieve account | — |
| `PostAccountsAccount` | POST `/v1/accounts/{account}` | Update an account | — |
| `DeleteAccountsAccount` | DELETE `/v1/accounts/{account}` | Delete an account | — |
| `PostAccountsAccountBankAccounts` | POST `/v1/accounts/{account}/bank_accounts` | Create an external account | — |
| `GetAccountsAccountBankAccountsId` | GET `/v1/accounts/{account}/bank_accounts/{id}` | Retrieve an external account | — |
| `PostAccountsAccountBankAccountsId` | POST `/v1/accounts/{account}/bank_accounts/{id}` | Update a bank account | — |
| `DeleteAccountsAccountBankAccountsId` | DELETE `/v1/accounts/{account}/bank_accounts/{id}` | Delete an external account | — |
| `GetAccountsAccountCapabilities` | GET `/v1/accounts/{account}/capabilities` | List all account capabilities | — |
| `GetAccountsAccountCapabilitiesCapability` | GET `/v1/accounts/{account}/capabilities/{capability}` | Retrieve an Account Capability | — |
| `PostAccountsAccountCapabilitiesCapability` | POST `/v1/accounts/{account}/capabilities/{capability}` | Update an Account Capability | — |
| `GetAccountsAccountExternalAccounts` | GET `/v1/accounts/{account}/external_accounts` | List all external accounts | — |
| `PostAccountsAccountExternalAccounts` | POST `/v1/accounts/{account}/external_accounts` | Create an external account | — |
| `GetAccountsAccountExternalAccountsId` | GET `/v1/accounts/{account}/external_accounts/{id}` | Retrieve an external account | — |
| `PostAccountsAccountExternalAccountsId` | POST `/v1/accounts/{account}/external_accounts/{id}` | Update a bank account | — |
| `DeleteAccountsAccountExternalAccountsId` | DELETE `/v1/accounts/{account}/external_accounts/{id}` | Delete an external account | — |
| `PostAccountsAccountLoginLinks` | POST `/v1/accounts/{account}/login_links` | Create a login link | — |
| `GetAccountsAccountPeople` | GET `/v1/accounts/{account}/people` | List all persons | — |
| `PostAccountsAccountPeople` | POST `/v1/accounts/{account}/people` | Create a person | — |
| `GetAccountsAccountPeoplePerson` | GET `/v1/accounts/{account}/people/{person}` | Retrieve a person | — |
| `PostAccountsAccountPeoplePerson` | POST `/v1/accounts/{account}/people/{person}` | Update a person | — |
| `DeleteAccountsAccountPeoplePerson` | DELETE `/v1/accounts/{account}/people/{person}` | Delete a person | — |
| `GetAccountsAccountPersons` | GET `/v1/accounts/{account}/persons` | List all persons | — |
| `PostAccountsAccountPersons` | POST `/v1/accounts/{account}/persons` | Create a person | — |
| `GetAccountsAccountPersonsPerson` | GET `/v1/accounts/{account}/persons/{person}` | Retrieve a person | — |
| `PostAccountsAccountPersonsPerson` | POST `/v1/accounts/{account}/persons/{person}` | Update a person | — |
| `DeleteAccountsAccountPersonsPerson` | DELETE `/v1/accounts/{account}/persons/{person}` | Delete a person | — |
| `PostAccountsAccountReject` | POST `/v1/accounts/{account}/reject` | Reject an account | — |
| `PostAccountsAccountUnreject` | POST `/v1/accounts/{account}/unreject` | Unreject an account | — |
| `GetApplePayDomains` | GET `/v1/apple_pay/domains` | <p>List apple pay domains.</p> | — |
| `PostApplePayDomains` | POST `/v1/apple_pay/domains` | <p>Create an apple pay domain.</p> | — |
| `GetApplePayDomainsDomain` | GET `/v1/apple_pay/domains/{domain}` | <p>Retrieve an apple pay domain.</p> | — |
| `DeleteApplePayDomainsDomain` | DELETE `/v1/apple_pay/domains/{domain}` | <p>Delete an apple pay domain.</p> | — |
| `GetApplicationFees` | GET `/v1/application_fees` | List all application fees | — |
| `GetApplicationFeesFeeRefundsId` | GET `/v1/application_fees/{fee}/refunds/{id}` | Retrieve an application fee refund | — |
| `PostApplicationFeesFeeRefundsId` | POST `/v1/application_fees/{fee}/refunds/{id}` | Update an application fee refund | — |
| `GetApplicationFeesId` | GET `/v1/application_fees/{id}` | Retrieve an application fee | — |
| `PostApplicationFeesIdRefund` | POST `/v1/application_fees/{id}/refund` |  | — |
| `GetApplicationFeesIdRefunds` | GET `/v1/application_fees/{id}/refunds` | List all application fee refunds | — |
| `PostApplicationFeesIdRefunds` | POST `/v1/application_fees/{id}/refunds` | Create an application fee refund | — |
| `GetAppsSecrets` | GET `/v1/apps/secrets` | List secrets | — |
| `PostAppsSecrets` | POST `/v1/apps/secrets` | Set a Secret | — |
| `PostAppsSecretsDelete` | POST `/v1/apps/secrets/delete` | Delete a Secret | — |
| `GetAppsSecretsFind` | GET `/v1/apps/secrets/find` | Find a Secret | — |
| `GetBalance` | GET `/v1/balance` | Retrieve balance | — |
| `GetBalanceHistory` | GET `/v1/balance/history` | List all balance transactions | — |
| `GetBalanceHistoryId` | GET `/v1/balance/history/{id}` | Retrieve a balance transaction | — |
| `GetBalanceSettings` | GET `/v1/balance_settings` | Retrieve balance settings | — |
| `PostBalanceSettings` | POST `/v1/balance_settings` | Update balance settings | — |
| `GetBalanceTransactions` | GET `/v1/balance_transactions` | List all balance transactions | — |
| `GetBalanceTransactionsId` | GET `/v1/balance_transactions/{id}` | Retrieve a balance transaction | — |
| `GetBillingAlerts` | GET `/v1/billing/alerts` | List billing alerts | — |
| `PostBillingAlerts` | POST `/v1/billing/alerts` | Create a billing alert | — |
| `GetBillingAlertsId` | GET `/v1/billing/alerts/{id}` | Retrieve a billing alert | — |
| `PostBillingAlertsIdActivate` | POST `/v1/billing/alerts/{id}/activate` | Activate a billing alert | — |
| `PostBillingAlertsIdArchive` | POST `/v1/billing/alerts/{id}/archive` | Archive a billing alert | — |
| `PostBillingAlertsIdDeactivate` | POST `/v1/billing/alerts/{id}/deactivate` | Deactivate a billing alert | — |
| `GetBillingCreditBalanceSummary` | GET `/v1/billing/credit_balance_summary` | Retrieve the credit balance summary for a customer | — |
| `GetBillingCreditBalanceTransactions` | GET `/v1/billing/credit_balance_transactions` | List credit balance transactions | — |
| `GetBillingCreditBalanceTransactionsId` | GET `/v1/billing/credit_balance_transactions/{id}` | Retrieve a credit balance transaction | — |
| `GetBillingCreditGrants` | GET `/v1/billing/credit_grants` | List credit grants | — |
| `PostBillingCreditGrants` | POST `/v1/billing/credit_grants` | Create a credit grant | — |
| `GetBillingCreditGrantsId` | GET `/v1/billing/credit_grants/{id}` | Retrieve a credit grant | — |
| `PostBillingCreditGrantsId` | POST `/v1/billing/credit_grants/{id}` | Update a credit grant | — |
| `PostBillingCreditGrantsIdExpire` | POST `/v1/billing/credit_grants/{id}/expire` | Expire a credit grant | — |
| `PostBillingCreditGrantsIdVoid` | POST `/v1/billing/credit_grants/{id}/void` | Void a credit grant | — |
| `PostBillingMeterEventAdjustments` | POST `/v1/billing/meter_event_adjustments` | Create a billing meter event adjustment | — |
| `PostBillingMeterEvents` | POST `/v1/billing/meter_events` | Create a billing meter event | — |
| `GetBillingMeters` | GET `/v1/billing/meters` | List billing meters | — |
| `PostBillingMeters` | POST `/v1/billing/meters` | Create a billing meter | — |
| `GetBillingMetersId` | GET `/v1/billing/meters/{id}` | Retrieve a billing meter | — |
| `PostBillingMetersId` | POST `/v1/billing/meters/{id}` | Update a billing meter | — |
| `PostBillingMetersIdDeactivate` | POST `/v1/billing/meters/{id}/deactivate` | Deactivate a billing meter | — |
| `GetBillingMetersIdEventSummaries` | GET `/v1/billing/meters/{id}/event_summaries` | List billing meter event summaries | — |
| `PostBillingMetersIdReactivate` | POST `/v1/billing/meters/{id}/reactivate` | Reactivate a billing meter | — |
| `GetBillingPortalConfigurations` | GET `/v1/billing_portal/configurations` | List portal configurations | — |
| `PostBillingPortalConfigurations` | POST `/v1/billing_portal/configurations` | Create a portal configuration | — |
| `GetBillingPortalConfigurationsConfiguration` | GET `/v1/billing_portal/configurations/{configuration}` | Retrieve a portal configuration | — |
| `PostBillingPortalConfigurationsConfiguration` | POST `/v1/billing_portal/configurations/{configuration}` | Update a portal configuration | — |
| `PostBillingPortalSessions` | POST `/v1/billing_portal/sessions` | Create a portal session | — |
| `GetCharges` | GET `/v1/charges` | List all charges | — |
| `PostCharges` | POST `/v1/charges` | Create a charge | — |
| `GetChargesSearch` | GET `/v1/charges/search` | Search charges | — |
| `GetChargesCharge` | GET `/v1/charges/{charge}` | Retrieve a charge | — |
| `PostChargesCharge` | POST `/v1/charges/{charge}` | Update a charge | — |
| `PostChargesChargeCapture` | POST `/v1/charges/{charge}/capture` | Capture a charge | — |
| `GetChargesChargeDispute` | GET `/v1/charges/{charge}/dispute` | <p>Retrieve a dispute for a specified charge.</p> | — |
| `PostChargesChargeDispute` | POST `/v1/charges/{charge}/dispute` |  | — |
| `PostChargesChargeDisputeClose` | POST `/v1/charges/{charge}/dispute/close` |  | — |
| `PostChargesChargeRefund` | POST `/v1/charges/{charge}/refund` | Create a refund | — |
| `GetChargesChargeRefunds` | GET `/v1/charges/{charge}/refunds` | List all refunds | — |
| `PostChargesChargeRefunds` | POST `/v1/charges/{charge}/refunds` | Create a refund | — |
| `GetChargesChargeRefundsRefund` | GET `/v1/charges/{charge}/refunds/{refund}` | <p>Retrieves the details of an existing refund.</p> | — |
| `PostChargesChargeRefundsRefund` | POST `/v1/charges/{charge}/refunds/{refund}` | <p>Update a specified refund.</p> | — |
| `GetCheckoutSessions` | GET `/v1/checkout/sessions` | List all Checkout Sessions | — |
| `PostCheckoutSessions` | POST `/v1/checkout/sessions` | Create a Checkout Session | — |
| `GetCheckoutSessionsSession` | GET `/v1/checkout/sessions/{session}` | Retrieve a Checkout Session | — |
| `PostCheckoutSessionsSession` | POST `/v1/checkout/sessions/{session}` | Update a Checkout Session | — |
| `PostCheckoutSessionsSessionExpire` | POST `/v1/checkout/sessions/{session}/expire` | Expire a Checkout Session | — |
| `GetCheckoutSessionsSessionLineItems` | GET `/v1/checkout/sessions/{session}/line_items` | Retrieve a Checkout Session's line items | — |
| `GetClimateOrders` | GET `/v1/climate/orders` | List orders | — |
| `PostClimateOrders` | POST `/v1/climate/orders` | Create an order | — |
| `GetClimateOrdersOrder` | GET `/v1/climate/orders/{order}` | Retrieve an order | — |
| `PostClimateOrdersOrder` | POST `/v1/climate/orders/{order}` | Update an order | — |
| `PostClimateOrdersOrderCancel` | POST `/v1/climate/orders/{order}/cancel` | Cancel an order | — |
| `GetClimateProducts` | GET `/v1/climate/products` | List products | — |
| `GetClimateProductsProduct` | GET `/v1/climate/products/{product}` | Retrieve a product | — |
| `GetClimateSuppliers` | GET `/v1/climate/suppliers` | List suppliers | — |
| `GetClimateSuppliersSupplier` | GET `/v1/climate/suppliers/{supplier}` | Retrieve a supplier | — |
| `GetConfirmationTokensConfirmationToken` | GET `/v1/confirmation_tokens/{confirmation_token}` | Retrieve a ConfirmationToken | — |
| `GetCountrySpecs` | GET `/v1/country_specs` | List Country Specs | — |
| `GetCountrySpecsCountry` | GET `/v1/country_specs/{country}` | Retrieve a Country Spec | — |
| `GetCoupons` | GET `/v1/coupons` | List all coupons | — |
| `PostCoupons` | POST `/v1/coupons` | Create a coupon | — |
| `GetCouponsCoupon` | GET `/v1/coupons/{coupon}` | Retrieve a coupon | — |
| `PostCouponsCoupon` | POST `/v1/coupons/{coupon}` | Update a coupon | — |
| `DeleteCouponsCoupon` | DELETE `/v1/coupons/{coupon}` | Delete a coupon | — |
| `GetCreditNotes` | GET `/v1/credit_notes` | List all credit notes | — |
| `PostCreditNotes` | POST `/v1/credit_notes` | Create a credit note | — |
| `GetCreditNotesPreview` | GET `/v1/credit_notes/preview` | Preview a credit note | — |
| `GetCreditNotesPreviewLines` | GET `/v1/credit_notes/preview/lines` | Retrieve a credit note preview's line items | — |
| `GetCreditNotesCreditNoteLines` | GET `/v1/credit_notes/{credit_note}/lines` | Retrieve a credit note's line items | — |
| `GetCreditNotesId` | GET `/v1/credit_notes/{id}` | Retrieve a credit note | — |
| `PostCreditNotesId` | POST `/v1/credit_notes/{id}` | Update a credit note | — |
| `PostCreditNotesIdVoid` | POST `/v1/credit_notes/{id}/void` | Void a credit note | — |
| `PostCustomerSessions` | POST `/v1/customer_sessions` | Create a Customer Session | — |
| `GetCustomers` | GET `/v1/customers` | List all customers | — |
| `PostCustomers` | POST `/v1/customers` | Create a customer | — |
| `GetCustomersSearch` | GET `/v1/customers/search` | Search customers | — |
| `GetCustomersCustomer` | GET `/v1/customers/{customer}` | Retrieve a customer | — |
| `PostCustomersCustomer` | POST `/v1/customers/{customer}` | Update a customer | — |
| `DeleteCustomersCustomer` | DELETE `/v1/customers/{customer}` | Delete a customer | — |
| `GetCustomersCustomerBalanceTransactions` | GET `/v1/customers/{customer}/balance_transactions` | List customer balance transactions | — |
| `PostCustomersCustomerBalanceTransactions` | POST `/v1/customers/{customer}/balance_transactions` | Create a customer balance transaction | — |
| `GetCustomersCustomerBalanceTransactionsTransaction` | GET `/v1/customers/{customer}/balance_transactions/{transaction}` | Retrieve a customer balance transaction | — |
| `PostCustomersCustomerBalanceTransactionsTransaction` | POST `/v1/customers/{customer}/balance_transactions/{transaction}` | Update a customer credit balance transaction | — |
| `GetCustomersCustomerBankAccounts` | GET `/v1/customers/{customer}/bank_accounts` | List all bank accounts | — |
| `PostCustomersCustomerBankAccounts` | POST `/v1/customers/{customer}/bank_accounts` | Create a card | — |
| `GetCustomersCustomerBankAccountsId` | GET `/v1/customers/{customer}/bank_accounts/{id}` | Retrieve a bank account | — |
| `PostCustomersCustomerBankAccountsId` | POST `/v1/customers/{customer}/bank_accounts/{id}` | Update a card | — |
| `DeleteCustomersCustomerBankAccountsId` | DELETE `/v1/customers/{customer}/bank_accounts/{id}` | Delete a customer source | — |
| `PostCustomersCustomerBankAccountsIdVerify` | POST `/v1/customers/{customer}/bank_accounts/{id}/verify` | Verify a bank account | — |
| `GetCustomersCustomerCards` | GET `/v1/customers/{customer}/cards` | List all cards | — |
| `PostCustomersCustomerCards` | POST `/v1/customers/{customer}/cards` | Create a card | — |
| `GetCustomersCustomerCardsId` | GET `/v1/customers/{customer}/cards/{id}` | Retrieve a card | — |
| `PostCustomersCustomerCardsId` | POST `/v1/customers/{customer}/cards/{id}` | Update a card | — |
| `DeleteCustomersCustomerCardsId` | DELETE `/v1/customers/{customer}/cards/{id}` | Delete a customer source | — |
| `GetCustomersCustomerCashBalance` | GET `/v1/customers/{customer}/cash_balance` | Retrieve a cash balance | — |
| `PostCustomersCustomerCashBalance` | POST `/v1/customers/{customer}/cash_balance` | Update a cash balance's settings | — |
| `GetCustomersCustomerCashBalanceTransactions` | GET `/v1/customers/{customer}/cash_balance_transactions` | List cash balance transactions | — |
| `GetCustomersCustomerCashBalanceTransactionsTransaction` | GET `/v1/customers/{customer}/cash_balance_transactions/{transaction}` | Retrieve a cash balance transaction | — |
| `GetCustomersCustomerDiscount` | GET `/v1/customers/{customer}/discount` |  | — |
| `DeleteCustomersCustomerDiscount` | DELETE `/v1/customers/{customer}/discount` | Delete a customer discount | — |
| `PostCustomersCustomerFundingInstructions` | POST `/v1/customers/{customer}/funding_instructions` | Create or retrieve funding instructions for a customer cash balance | — |
| `GetCustomersCustomerPaymentMethods` | GET `/v1/customers/{customer}/payment_methods` | List a Customer's PaymentMethods | — |
| `GetCustomersCustomerPaymentMethodsPaymentMethod` | GET `/v1/customers/{customer}/payment_methods/{payment_method}` | Retrieve a Customer's PaymentMethod | — |
| `GetCustomersCustomerSources` | GET `/v1/customers/{customer}/sources` | <p>List sources for a specified customer.</p> | — |
| `PostCustomersCustomerSources` | POST `/v1/customers/{customer}/sources` | Create a card | — |
| `GetCustomersCustomerSourcesId` | GET `/v1/customers/{customer}/sources/{id}` | <p>Retrieve a specified source for a given customer.</p> | — |
| `PostCustomersCustomerSourcesId` | POST `/v1/customers/{customer}/sources/{id}` | Update a card | — |
| `DeleteCustomersCustomerSourcesId` | DELETE `/v1/customers/{customer}/sources/{id}` | Delete a customer source | — |
| `PostCustomersCustomerSourcesIdVerify` | POST `/v1/customers/{customer}/sources/{id}/verify` | Verify a bank account | — |
| `GetCustomersCustomerSubscriptions` | GET `/v1/customers/{customer}/subscriptions` | List active subscriptions | — |
| `PostCustomersCustomerSubscriptions` | POST `/v1/customers/{customer}/subscriptions` | Create a subscription | — |
| `GetCustomersCustomerSubscriptionsSubscriptionExposedId` | GET `/v1/customers/{customer}/subscriptions/{subscription_exposed_id}` | Retrieve a subscription | — |
| `PostCustomersCustomerSubscriptionsSubscriptionExposedId` | POST `/v1/customers/{customer}/subscriptions/{subscription_exposed_id}` | Update a subscription on a customer | — |
| `DeleteCustomersCustomerSubscriptionsSubscriptionExposedId` | DELETE `/v1/customers/{customer}/subscriptions/{subscription_exposed_id}` | Cancel a subscription | — |
| `GetCustomersCustomerSubscriptionsSubscriptionExposedIdDiscount` | GET `/v1/customers/{customer}/subscriptions/{subscription_exposed_id}/discount` |  | — |
| `DeleteCustomersCustomerSubscriptionsSubscriptionExposedIdDiscount` | DELETE `/v1/customers/{customer}/subscriptions/{subscription_exposed_id}/discount` | Delete a customer discount | — |
| `GetCustomersCustomerTaxIds` | GET `/v1/customers/{customer}/tax_ids` | List all Customer tax IDs | — |
| `PostCustomersCustomerTaxIds` | POST `/v1/customers/{customer}/tax_ids` | Create a Customer tax ID | — |
| `GetCustomersCustomerTaxIdsId` | GET `/v1/customers/{customer}/tax_ids/{id}` | Retrieve a Customer tax ID | — |
| `DeleteCustomersCustomerTaxIdsId` | DELETE `/v1/customers/{customer}/tax_ids/{id}` | Delete a Customer tax ID | — |
| `GetDisputes` | GET `/v1/disputes` | List all disputes | — |
| `GetDisputesDispute` | GET `/v1/disputes/{dispute}` | Retrieve a dispute | — |
| `PostDisputesDispute` | POST `/v1/disputes/{dispute}` | Update a dispute | — |
| `PostDisputesDisputeClose` | POST `/v1/disputes/{dispute}/close` | Close a dispute | — |
| `GetEntitlementsActiveEntitlements` | GET `/v1/entitlements/active_entitlements` | List all active entitlements | — |
| `GetEntitlementsActiveEntitlementsId` | GET `/v1/entitlements/active_entitlements/{id}` | Retrieve an active entitlement | — |
| `GetEntitlementsFeatures` | GET `/v1/entitlements/features` | List all features | — |
| `PostEntitlementsFeatures` | POST `/v1/entitlements/features` | Create a feature | — |
| `GetEntitlementsFeaturesId` | GET `/v1/entitlements/features/{id}` | Retrieve a feature | — |
| `PostEntitlementsFeaturesId` | POST `/v1/entitlements/features/{id}` | Updates a feature | — |
| `PostEphemeralKeys` | POST `/v1/ephemeral_keys` | Create an ephemeral key | — |
| `DeleteEphemeralKeysKey` | DELETE `/v1/ephemeral_keys/{key}` | Immediately invalidate an ephemeral key | — |
| `GetEvents` | GET `/v1/events` | List all events | — |
| `GetEventsId` | GET `/v1/events/{id}` | Retrieve an event | — |
| `GetExchangeRates` | GET `/v1/exchange_rates` | List all exchange rates | — |
| `GetExchangeRatesRateId` | GET `/v1/exchange_rates/{rate_id}` | Retrieve an exchange rate | — |
| `PostExternalAccountsId` | POST `/v1/external_accounts/{id}` | Update a bank account | — |
| `GetFileLinks` | GET `/v1/file_links` | List all file links | — |
| `PostFileLinks` | POST `/v1/file_links` | Create a file link | — |
| `GetFileLinksLink` | GET `/v1/file_links/{link}` | Retrieve a file link | — |
| `PostFileLinksLink` | POST `/v1/file_links/{link}` | Update a file link | — |
| `GetFiles` | GET `/v1/files` | List all files | — |
| `PostFiles` | POST `/v1/files` | Create a file | — |
| `GetFilesFile` | GET `/v1/files/{file}` | Retrieve a file | — |
| `GetFinancialConnectionsAccounts` | GET `/v1/financial_connections/accounts` | List Accounts | — |
| `GetFinancialConnectionsAccountsAccount` | GET `/v1/financial_connections/accounts/{account}` | Retrieve an Account | — |
| `PostFinancialConnectionsAccountsAccountDisconnect` | POST `/v1/financial_connections/accounts/{account}/disconnect` | Disconnect an Account | — |
| `GetFinancialConnectionsAccountsAccountOwners` | GET `/v1/financial_connections/accounts/{account}/owners` | List Account Owners | — |
| `PostFinancialConnectionsAccountsAccountRefresh` | POST `/v1/financial_connections/accounts/{account}/refresh` | Refresh Account data | — |
| `PostFinancialConnectionsAccountsAccountSubscribe` | POST `/v1/financial_connections/accounts/{account}/subscribe` | Subscribe to data refreshes for an Account | — |
| `PostFinancialConnectionsAccountsAccountUnsubscribe` | POST `/v1/financial_connections/accounts/{account}/unsubscribe` | Unsubscribe from data refreshes for an Account | — |
| `PostFinancialConnectionsSessions` | POST `/v1/financial_connections/sessions` | Create a Session | — |
| `GetFinancialConnectionsSessionsSession` | GET `/v1/financial_connections/sessions/{session}` | Retrieve a Session | — |
| `GetFinancialConnectionsTransactions` | GET `/v1/financial_connections/transactions` | List Transactions | — |
| `GetFinancialConnectionsTransactionsTransaction` | GET `/v1/financial_connections/transactions/{transaction}` | Retrieve a Transaction | — |
| `GetForwardingRequests` | GET `/v1/forwarding/requests` | List all ForwardingRequests | — |
| `PostForwardingRequests` | POST `/v1/forwarding/requests` | Create a ForwardingRequest | — |
| `GetForwardingRequestsId` | GET `/v1/forwarding/requests/{id}` | Retrieve a ForwardingRequest | — |
| `GetIdentityVerificationReports` | GET `/v1/identity/verification_reports` | List VerificationReports | — |
| `GetIdentityVerificationReportsReport` | GET `/v1/identity/verification_reports/{report}` | Retrieve a VerificationReport | — |
| `GetIdentityVerificationSessions` | GET `/v1/identity/verification_sessions` | List VerificationSessions | — |
| `PostIdentityVerificationSessions` | POST `/v1/identity/verification_sessions` | Create a VerificationSession | — |
| `GetIdentityVerificationSessionsSession` | GET `/v1/identity/verification_sessions/{session}` | Retrieve a VerificationSession | — |
| `PostIdentityVerificationSessionsSession` | POST `/v1/identity/verification_sessions/{session}` | Update a VerificationSession | — |
| `PostIdentityVerificationSessionsSessionCancel` | POST `/v1/identity/verification_sessions/{session}/cancel` | Cancel a VerificationSession | — |
| `PostIdentityVerificationSessionsSessionRedact` | POST `/v1/identity/verification_sessions/{session}/redact` | Redact a VerificationSession | — |
| `GetInvoicePayments` | GET `/v1/invoice_payments` | List all payments for an invoice | — |
| `GetInvoicePaymentsInvoicePayment` | GET `/v1/invoice_payments/{invoice_payment}` | Retrieve an InvoicePayment | — |
| `GetInvoiceRenderingTemplates` | GET `/v1/invoice_rendering_templates` | List all invoice rendering templates | — |
| `GetInvoiceRenderingTemplatesTemplate` | GET `/v1/invoice_rendering_templates/{template}` | Retrieve an invoice rendering template | — |
| `PostInvoiceRenderingTemplatesTemplateArchive` | POST `/v1/invoice_rendering_templates/{template}/archive` | Archive an invoice rendering template | — |
| `PostInvoiceRenderingTemplatesTemplateUnarchive` | POST `/v1/invoice_rendering_templates/{template}/unarchive` | Unarchive an invoice rendering template | — |
| `GetInvoiceitems` | GET `/v1/invoiceitems` | List all invoice items | — |
| `PostInvoiceitems` | POST `/v1/invoiceitems` | Create an invoice item | — |
| `GetInvoiceitemsInvoiceitem` | GET `/v1/invoiceitems/{invoiceitem}` | Retrieve an invoice item | — |
| `PostInvoiceitemsInvoiceitem` | POST `/v1/invoiceitems/{invoiceitem}` | Update an invoice item | — |
| `DeleteInvoiceitemsInvoiceitem` | DELETE `/v1/invoiceitems/{invoiceitem}` | Delete an invoice item | — |
| `GetInvoices` | GET `/v1/invoices` | List all invoices | — |
| `PostInvoices` | POST `/v1/invoices` | Create an invoice | — |
| `PostInvoicesCreatePreview` | POST `/v1/invoices/create_preview` | Create a preview invoice | — |
| `GetInvoicesSearch` | GET `/v1/invoices/search` | Search invoices | — |
| `GetInvoicesInvoice` | GET `/v1/invoices/{invoice}` | Retrieve an invoice | — |
| `PostInvoicesInvoice` | POST `/v1/invoices/{invoice}` | Update an invoice | — |
| `DeleteInvoicesInvoice` | DELETE `/v1/invoices/{invoice}` | Delete a draft invoice | — |
| `PostInvoicesInvoiceAddLines` | POST `/v1/invoices/{invoice}/add_lines` | Bulk add invoice line items | — |
| `PostInvoicesInvoiceAttachPayment` | POST `/v1/invoices/{invoice}/attach_payment` | Attach a payment to an Invoice | — |
| `PostInvoicesInvoiceFinalize` | POST `/v1/invoices/{invoice}/finalize` | Finalize an invoice | — |
| `GetInvoicesInvoiceLines` | GET `/v1/invoices/{invoice}/lines` | Retrieve an invoice's line items | — |
| `PostInvoicesInvoiceLinesLineItemId` | POST `/v1/invoices/{invoice}/lines/{line_item_id}` | Update an invoice's line item | — |
| `PostInvoicesInvoiceMarkUncollectible` | POST `/v1/invoices/{invoice}/mark_uncollectible` | Mark an invoice as uncollectible | — |
| `PostInvoicesInvoicePay` | POST `/v1/invoices/{invoice}/pay` | Pay an invoice | — |
| `PostInvoicesInvoiceRemoveLines` | POST `/v1/invoices/{invoice}/remove_lines` | Bulk remove invoice line items | — |
| `PostInvoicesInvoiceSend` | POST `/v1/invoices/{invoice}/send` | Send an invoice for manual payment | — |
| `PostInvoicesInvoiceUpdateLines` | POST `/v1/invoices/{invoice}/update_lines` | Bulk update invoice line items | — |
| `PostInvoicesInvoiceVoid` | POST `/v1/invoices/{invoice}/void` | Void an invoice | — |
| `GetIssuingAuthorizations` | GET `/v1/issuing/authorizations` | List all authorizations | — |
| `GetIssuingAuthorizationsAuthorization` | GET `/v1/issuing/authorizations/{authorization}` | Retrieve an authorization | — |
| `PostIssuingAuthorizationsAuthorization` | POST `/v1/issuing/authorizations/{authorization}` | Update an authorization | — |
| `PostIssuingAuthorizationsAuthorizationApprove` | POST `/v1/issuing/authorizations/{authorization}/approve` | Approve an authorization | — |
| `PostIssuingAuthorizationsAuthorizationDecline` | POST `/v1/issuing/authorizations/{authorization}/decline` | Decline an authorization | — |
| `GetIssuingCardholders` | GET `/v1/issuing/cardholders` | List all cardholders | — |
| `PostIssuingCardholders` | POST `/v1/issuing/cardholders` | Create a cardholder | — |
| `GetIssuingCardholdersCardholder` | GET `/v1/issuing/cardholders/{cardholder}` | Retrieve a cardholder | — |
| `PostIssuingCardholdersCardholder` | POST `/v1/issuing/cardholders/{cardholder}` | Update a cardholder | — |
| `GetIssuingCards` | GET `/v1/issuing/cards` | List all cards | — |
| `PostIssuingCards` | POST `/v1/issuing/cards` | Create a card | — |
| `GetIssuingCardsCard` | GET `/v1/issuing/cards/{card}` | Retrieve a card | — |
| `PostIssuingCardsCard` | POST `/v1/issuing/cards/{card}` | Update a card | — |
| `GetIssuingDisputes` | GET `/v1/issuing/disputes` | List all disputes | — |
| `PostIssuingDisputes` | POST `/v1/issuing/disputes` | Create a dispute | — |
| `GetIssuingDisputesDispute` | GET `/v1/issuing/disputes/{dispute}` | Retrieve a dispute | — |
| `PostIssuingDisputesDispute` | POST `/v1/issuing/disputes/{dispute}` | Update a dispute | — |
| `PostIssuingDisputesDisputeSubmit` | POST `/v1/issuing/disputes/{dispute}/submit` | Submit a dispute | — |
| `GetIssuingPersonalizationDesigns` | GET `/v1/issuing/personalization_designs` | List all personalization designs | — |
| `PostIssuingPersonalizationDesigns` | POST `/v1/issuing/personalization_designs` | Create a personalization design | — |
| `GetIssuingPersonalizationDesignsPersonalizationDesign` | GET `/v1/issuing/personalization_designs/{personalization_design}` | Retrieve a personalization design | — |
| `PostIssuingPersonalizationDesignsPersonalizationDesign` | POST `/v1/issuing/personalization_designs/{personalization_design}` | Update a personalization design | — |
| `GetIssuingPhysicalBundles` | GET `/v1/issuing/physical_bundles` | List all physical bundles | — |
| `GetIssuingPhysicalBundlesPhysicalBundle` | GET `/v1/issuing/physical_bundles/{physical_bundle}` | Retrieve a physical bundle | — |
| `GetIssuingSettlementsSettlement` | GET `/v1/issuing/settlements/{settlement}` | Retrieve a settlement | — |
| `PostIssuingSettlementsSettlement` | POST `/v1/issuing/settlements/{settlement}` | Update a settlement | — |
| `GetIssuingTokens` | GET `/v1/issuing/tokens` | List all issuing tokens for card | — |
| `GetIssuingTokensToken` | GET `/v1/issuing/tokens/{token}` | Retrieve an issuing token | — |
| `PostIssuingTokensToken` | POST `/v1/issuing/tokens/{token}` | Update a token status | — |
| `GetIssuingTransactions` | GET `/v1/issuing/transactions` | List all transactions | — |
| `GetIssuingTransactionsTransaction` | GET `/v1/issuing/transactions/{transaction}` | Retrieve a transaction | — |
| `PostIssuingTransactionsTransaction` | POST `/v1/issuing/transactions/{transaction}` | Update a transaction | — |
| `PostLinkAccountSessions` | POST `/v1/link_account_sessions` | Create a Session | — |
| `GetLinkAccountSessionsSession` | GET `/v1/link_account_sessions/{session}` | Retrieve a Session | — |
| `GetLinkedAccounts` | GET `/v1/linked_accounts` | List Accounts | — |
| `GetLinkedAccountsAccount` | GET `/v1/linked_accounts/{account}` | Retrieve an Account | — |
| `PostLinkedAccountsAccountDisconnect` | POST `/v1/linked_accounts/{account}/disconnect` | Disconnect an Account | — |
| `GetLinkedAccountsAccountOwners` | GET `/v1/linked_accounts/{account}/owners` | List Account Owners | — |
| `PostLinkedAccountsAccountRefresh` | POST `/v1/linked_accounts/{account}/refresh` | Refresh Account data | — |
| `GetMandatesMandate` | GET `/v1/mandates/{mandate}` | Retrieve a Mandate | — |
| `GetPaymentAttemptRecords` | GET `/v1/payment_attempt_records` | List Payment Attempt Records | — |
| `GetPaymentAttemptRecordsId` | GET `/v1/payment_attempt_records/{id}` | Retrieve a Payment Attempt Record | — |
| `GetPaymentIntents` | GET `/v1/payment_intents` | List all PaymentIntents | — |
| `PostPaymentIntents` | POST `/v1/payment_intents` | Create a PaymentIntent | — |
| `GetPaymentIntentsSearch` | GET `/v1/payment_intents/search` | Search PaymentIntents | — |
| `GetPaymentIntentsIntent` | GET `/v1/payment_intents/{intent}` | Retrieve a PaymentIntent | — |
| `PostPaymentIntentsIntent` | POST `/v1/payment_intents/{intent}` | Update a PaymentIntent | — |
| `GetPaymentIntentsIntentAmountDetailsLineItems` | GET `/v1/payment_intents/{intent}/amount_details_line_items` | List all PaymentIntent LineItems | — |
| `PostPaymentIntentsIntentApplyCustomerBalance` | POST `/v1/payment_intents/{intent}/apply_customer_balance` | Reconcile a customer_balance PaymentIntent | — |
| `PostPaymentIntentsIntentCancel` | POST `/v1/payment_intents/{intent}/cancel` | Cancel a PaymentIntent | — |
| `PostPaymentIntentsIntentCapture` | POST `/v1/payment_intents/{intent}/capture` | Capture a PaymentIntent | — |
| `PostPaymentIntentsIntentConfirm` | POST `/v1/payment_intents/{intent}/confirm` | Confirm a PaymentIntent | — |
| `PostPaymentIntentsIntentIncrementAuthorization` | POST `/v1/payment_intents/{intent}/increment_authorization` | Increment an authorization | — |
| `PostPaymentIntentsIntentVerifyMicrodeposits` | POST `/v1/payment_intents/{intent}/verify_microdeposits` | Verify microdeposits on a PaymentIntent | — |
| `GetPaymentLinks` | GET `/v1/payment_links` | List all payment links | — |
| `PostPaymentLinks` | POST `/v1/payment_links` | Create a payment link | — |
| `GetPaymentLinksPaymentLink` | GET `/v1/payment_links/{payment_link}` | Retrieve payment link | — |
| `PostPaymentLinksPaymentLink` | POST `/v1/payment_links/{payment_link}` | Update a payment link | — |
| `GetPaymentLinksPaymentLinkLineItems` | GET `/v1/payment_links/{payment_link}/line_items` | Retrieve a payment link's line items | — |
| `GetPaymentMethodConfigurations` | GET `/v1/payment_method_configurations` | List payment method configurations | — |
| `PostPaymentMethodConfigurations` | POST `/v1/payment_method_configurations` | Create a payment method configuration | — |
| `GetPaymentMethodConfigurationsConfiguration` | GET `/v1/payment_method_configurations/{configuration}` | Retrieve payment method configuration | — |
| `PostPaymentMethodConfigurationsConfiguration` | POST `/v1/payment_method_configurations/{configuration}` | Update payment method configuration | — |
| `GetPaymentMethodDomains` | GET `/v1/payment_method_domains` | List payment method domains | — |
| `PostPaymentMethodDomains` | POST `/v1/payment_method_domains` | Create a payment method domain | — |
| `GetPaymentMethodDomainsPaymentMethodDomain` | GET `/v1/payment_method_domains/{payment_method_domain}` | Retrieve a payment method domain | — |
| `PostPaymentMethodDomainsPaymentMethodDomain` | POST `/v1/payment_method_domains/{payment_method_domain}` | Update a payment method domain | — |
| `PostPaymentMethodDomainsPaymentMethodDomainValidate` | POST `/v1/payment_method_domains/{payment_method_domain}/validate` | Validate an existing payment method domain | — |
| `GetPaymentMethods` | GET `/v1/payment_methods` | List PaymentMethods | — |
| `PostPaymentMethods` | POST `/v1/payment_methods` | Create a PaymentMethod | — |
| `GetPaymentMethodsPaymentMethod` | GET `/v1/payment_methods/{payment_method}` | Retrieve a PaymentMethod | — |
| `PostPaymentMethodsPaymentMethod` | POST `/v1/payment_methods/{payment_method}` | Update a PaymentMethod | — |
| `PostPaymentMethodsPaymentMethodAttach` | POST `/v1/payment_methods/{payment_method}/attach` | Attach a PaymentMethod to a Customer | — |
| `PostPaymentMethodsPaymentMethodDetach` | POST `/v1/payment_methods/{payment_method}/detach` | Detach a PaymentMethod from a Customer | — |
| `GetPaymentRecords` | GET `/v1/payment_records` | List Payment Records | — |
| `PostPaymentRecordsReportPayment` | POST `/v1/payment_records/report_payment` | Report a payment | — |
| `GetPaymentRecordsId` | GET `/v1/payment_records/{id}` | Retrieve a Payment Record | — |
| `PostPaymentRecordsIdReportPaymentAttempt` | POST `/v1/payment_records/{id}/report_payment_attempt` | Report a payment attempt | — |
| `PostPaymentRecordsIdReportPaymentAttemptCanceled` | POST `/v1/payment_records/{id}/report_payment_attempt_canceled` | Report payment attempt canceled | — |
| `PostPaymentRecordsIdReportPaymentAttemptFailed` | POST `/v1/payment_records/{id}/report_payment_attempt_failed` | Report payment attempt failed | — |
| `PostPaymentRecordsIdReportPaymentAttemptGuaranteed` | POST `/v1/payment_records/{id}/report_payment_attempt_guaranteed` | Report payment attempt guaranteed | — |
| `PostPaymentRecordsIdReportPaymentAttemptInformational` | POST `/v1/payment_records/{id}/report_payment_attempt_informational` | Report payment attempt informational | — |
| `PostPaymentRecordsIdReportRefund` | POST `/v1/payment_records/{id}/report_refund` | Report a refund | — |
| `GetPayouts` | GET `/v1/payouts` | List all payouts | — |
| `PostPayouts` | POST `/v1/payouts` | Create a payout | — |
| `GetPayoutsPayout` | GET `/v1/payouts/{payout}` | Retrieve a payout | — |
| `PostPayoutsPayout` | POST `/v1/payouts/{payout}` | Update a payout | — |
| `PostPayoutsPayoutCancel` | POST `/v1/payouts/{payout}/cancel` | Cancel a payout | — |
| `PostPayoutsPayoutReverse` | POST `/v1/payouts/{payout}/reverse` | Reverse a payout | — |
| `GetPlans` | GET `/v1/plans` | List all plans | — |
| `PostPlans` | POST `/v1/plans` | Create a plan | — |
| `GetPlansPlan` | GET `/v1/plans/{plan}` | Retrieve a plan | — |
| `PostPlansPlan` | POST `/v1/plans/{plan}` | Update a plan | — |
| `DeletePlansPlan` | DELETE `/v1/plans/{plan}` | Delete a plan | — |
| `GetPrices` | GET `/v1/prices` | List all prices | — |
| `PostPrices` | POST `/v1/prices` | Create a price | — |
| `GetPricesSearch` | GET `/v1/prices/search` | Search prices | — |
| `GetPricesPrice` | GET `/v1/prices/{price}` | Retrieve a price | — |
| `PostPricesPrice` | POST `/v1/prices/{price}` | Update a price | — |
| `GetProducts` | GET `/v1/products` | List all products | — |
| `PostProducts` | POST `/v1/products` | Create a product | — |
| `GetProductsSearch` | GET `/v1/products/search` | Search products | — |
| `GetProductsId` | GET `/v1/products/{id}` | Retrieve a product | — |
| `PostProductsId` | POST `/v1/products/{id}` | Update a product | — |
| `DeleteProductsId` | DELETE `/v1/products/{id}` | Delete a product | — |
| `GetProductsProductFeatures` | GET `/v1/products/{product}/features` | List all features attached to a product | — |
| `PostProductsProductFeatures` | POST `/v1/products/{product}/features` | Attach a feature to a product | — |
| `GetProductsProductFeaturesId` | GET `/v1/products/{product}/features/{id}` | Retrieve a product_feature | — |
| `DeleteProductsProductFeaturesId` | DELETE `/v1/products/{product}/features/{id}` | Remove a feature from a product | — |
| `GetPromotionCodes` | GET `/v1/promotion_codes` | List all promotion codes | — |
| `PostPromotionCodes` | POST `/v1/promotion_codes` | Create a promotion code | — |
| `GetPromotionCodesPromotionCode` | GET `/v1/promotion_codes/{promotion_code}` | Retrieve a promotion code | — |
| `PostPromotionCodesPromotionCode` | POST `/v1/promotion_codes/{promotion_code}` | Update a promotion code | — |
| `GetQuotes` | GET `/v1/quotes` | List all quotes | — |
| `PostQuotes` | POST `/v1/quotes` | Create a quote | — |
| `GetQuotesQuote` | GET `/v1/quotes/{quote}` | Retrieve a quote | — |
| `PostQuotesQuote` | POST `/v1/quotes/{quote}` | Update a quote | — |
| `PostQuotesQuoteAccept` | POST `/v1/quotes/{quote}/accept` | Accept a quote | — |
| `PostQuotesQuoteCancel` | POST `/v1/quotes/{quote}/cancel` | Cancel a quote | — |
| `GetQuotesQuoteComputedUpfrontLineItems` | GET `/v1/quotes/{quote}/computed_upfront_line_items` | Retrieve a quote's upfront line items | — |
| `PostQuotesQuoteFinalize` | POST `/v1/quotes/{quote}/finalize` | Finalize a quote | — |
| `GetQuotesQuoteLineItems` | GET `/v1/quotes/{quote}/line_items` | Retrieve a quote's line items | — |
| `GetQuotesQuotePdf` | GET `/v1/quotes/{quote}/pdf` | Download quote PDF | — |
| `GetRadarEarlyFraudWarnings` | GET `/v1/radar/early_fraud_warnings` | List all early fraud warnings | — |
| `GetRadarEarlyFraudWarningsEarlyFraudWarning` | GET `/v1/radar/early_fraud_warnings/{early_fraud_warning}` | Retrieve an early fraud warning | — |
| `PostRadarPaymentEvaluations` | POST `/v1/radar/payment_evaluations` | Create a Payment Evaluation | — |
| `GetRadarValueListItems` | GET `/v1/radar/value_list_items` | List all value list items | — |
| `PostRadarValueListItems` | POST `/v1/radar/value_list_items` | Create a value list item | — |
| `GetRadarValueListItemsItem` | GET `/v1/radar/value_list_items/{item}` | Retrieve a value list item | — |
| `DeleteRadarValueListItemsItem` | DELETE `/v1/radar/value_list_items/{item}` | Delete a value list item | — |
| `GetRadarValueLists` | GET `/v1/radar/value_lists` | List all value lists | — |
| `PostRadarValueLists` | POST `/v1/radar/value_lists` | Create a value list | — |
| `GetRadarValueListsValueList` | GET `/v1/radar/value_lists/{value_list}` | Retrieve a value list | — |
| `PostRadarValueListsValueList` | POST `/v1/radar/value_lists/{value_list}` | Update a value list | — |
| `DeleteRadarValueListsValueList` | DELETE `/v1/radar/value_lists/{value_list}` | Delete a value list | — |
| `GetRefunds` | GET `/v1/refunds` | List all refunds | — |
| `PostRefunds` | POST `/v1/refunds` | Create a refund | — |
| `GetRefundsRefund` | GET `/v1/refunds/{refund}` | Retrieve a refund | — |
| `PostRefundsRefund` | POST `/v1/refunds/{refund}` | Update a refund | — |
| `PostRefundsRefundCancel` | POST `/v1/refunds/{refund}/cancel` | Cancel a refund | — |
| `GetReportingReportRuns` | GET `/v1/reporting/report_runs` | List all Report Runs | — |
| `PostReportingReportRuns` | POST `/v1/reporting/report_runs` | Create a Report Run | — |
| `GetReportingReportRunsReportRun` | GET `/v1/reporting/report_runs/{report_run}` | Retrieve a Report Run | — |
| `GetReportingReportTypes` | GET `/v1/reporting/report_types` | List all Report Types | — |
| `GetReportingReportTypesReportType` | GET `/v1/reporting/report_types/{report_type}` | Retrieve a Report Type | — |
| `GetReviews` | GET `/v1/reviews` | List all open reviews | — |
| `GetReviewsReview` | GET `/v1/reviews/{review}` | Retrieve a review | — |
| `PostReviewsReviewApprove` | POST `/v1/reviews/{review}/approve` | Approve a review | — |
| `GetSetupAttempts` | GET `/v1/setup_attempts` | List all SetupAttempts | — |
| `GetSetupIntents` | GET `/v1/setup_intents` | List all SetupIntents | — |
| `PostSetupIntents` | POST `/v1/setup_intents` | Create a SetupIntent | — |
| `GetSetupIntentsIntent` | GET `/v1/setup_intents/{intent}` | Retrieve a SetupIntent | — |
| `PostSetupIntentsIntent` | POST `/v1/setup_intents/{intent}` | Update a SetupIntent | — |
| `PostSetupIntentsIntentCancel` | POST `/v1/setup_intents/{intent}/cancel` | Cancel a SetupIntent | — |
| `PostSetupIntentsIntentConfirm` | POST `/v1/setup_intents/{intent}/confirm` | Confirm a SetupIntent | — |
| `PostSetupIntentsIntentVerifyMicrodeposits` | POST `/v1/setup_intents/{intent}/verify_microdeposits` | Verify microdeposits on a SetupIntent | — |
| `GetShippingRates` | GET `/v1/shipping_rates` | List all shipping rates | — |
| `PostShippingRates` | POST `/v1/shipping_rates` | Create a shipping rate | — |
| `GetShippingRatesShippingRateToken` | GET `/v1/shipping_rates/{shipping_rate_token}` | Retrieve a shipping rate | — |
| `PostShippingRatesShippingRateToken` | POST `/v1/shipping_rates/{shipping_rate_token}` | Update a shipping rate | — |
| `PostSigmaSavedQueriesId` | POST `/v1/sigma/saved_queries/{id}` | Update an existing Sigma Query | — |
| `GetSigmaScheduledQueryRuns` | GET `/v1/sigma/scheduled_query_runs` | List all scheduled query runs | — |
| `GetSigmaScheduledQueryRunsScheduledQueryRun` | GET `/v1/sigma/scheduled_query_runs/{scheduled_query_run}` | Retrieve a scheduled query run | — |
| `PostSources` | POST `/v1/sources` | Create a source | — |
| `GetSourcesSource` | GET `/v1/sources/{source}` | Retrieve a source | — |
| `PostSourcesSource` | POST `/v1/sources/{source}` | Update a source | — |
| `GetSourcesSourceMandateNotificationsMandateNotification` | GET `/v1/sources/{source}/mandate_notifications/{mandate_notification}` | Retrieve a Source MandateNotification | — |
| `GetSourcesSourceSourceTransactions` | GET `/v1/sources/{source}/source_transactions` | <p>List source transactions for a given source.</p> | — |
| `GetSourcesSourceSourceTransactionsSourceTransaction` | GET `/v1/sources/{source}/source_transactions/{source_transaction}` | Retrieve a source transaction | — |
| `PostSourcesSourceVerify` | POST `/v1/sources/{source}/verify` | <p>Verify a given source.</p> | — |
| `GetSubscriptionItems` | GET `/v1/subscription_items` | List all subscription items | — |
| `PostSubscriptionItems` | POST `/v1/subscription_items` | Create a subscription item | — |
| `GetSubscriptionItemsItem` | GET `/v1/subscription_items/{item}` | Retrieve a subscription item | — |
| `PostSubscriptionItemsItem` | POST `/v1/subscription_items/{item}` | Update a subscription item | — |
| `DeleteSubscriptionItemsItem` | DELETE `/v1/subscription_items/{item}` | Delete a subscription item | — |
| `GetSubscriptionSchedules` | GET `/v1/subscription_schedules` | List all schedules | — |
| `PostSubscriptionSchedules` | POST `/v1/subscription_schedules` | Create a schedule | — |
| `GetSubscriptionSchedulesSchedule` | GET `/v1/subscription_schedules/{schedule}` | Retrieve a schedule | — |
| `PostSubscriptionSchedulesSchedule` | POST `/v1/subscription_schedules/{schedule}` | Update a schedule | — |
| `PostSubscriptionSchedulesScheduleCancel` | POST `/v1/subscription_schedules/{schedule}/cancel` | Cancel a schedule | — |
| `PostSubscriptionSchedulesScheduleRelease` | POST `/v1/subscription_schedules/{schedule}/release` | Release a schedule | — |
| `GetSubscriptions` | GET `/v1/subscriptions` | List subscriptions | — |
| `PostSubscriptions` | POST `/v1/subscriptions` | Create a subscription | — |
| `GetSubscriptionsSearch` | GET `/v1/subscriptions/search` | Search subscriptions | — |
| `GetSubscriptionsSubscriptionExposedId` | GET `/v1/subscriptions/{subscription_exposed_id}` | Retrieve a subscription | — |
| `PostSubscriptionsSubscriptionExposedId` | POST `/v1/subscriptions/{subscription_exposed_id}` | Update a subscription | — |
| `DeleteSubscriptionsSubscriptionExposedId` | DELETE `/v1/subscriptions/{subscription_exposed_id}` | Cancel a subscription | — |
| `DeleteSubscriptionsSubscriptionExposedIdDiscount` | DELETE `/v1/subscriptions/{subscription_exposed_id}/discount` | Delete a subscription discount | — |
| `PostSubscriptionsSubscriptionMigrate` | POST `/v1/subscriptions/{subscription}/migrate` | Migrate a subscription | — |
| `PostSubscriptionsSubscriptionResume` | POST `/v1/subscriptions/{subscription}/resume` | Resume a subscription | — |
| `GetTaxAssociationsFind` | GET `/v1/tax/associations/find` | Find a Tax Association | — |
| `PostTaxCalculations` | POST `/v1/tax/calculations` | Create a Calculation | — |
| `GetTaxCalculationsCalculation` | GET `/v1/tax/calculations/{calculation}` | Retrieve a Calculation | — |
| `GetTaxCalculationsCalculationLineItems` | GET `/v1/tax/calculations/{calculation}/line_items` | Retrieve a Calculation's line items | — |
| `GetTaxRegistrations` | GET `/v1/tax/registrations` | List registrations | — |
| `PostTaxRegistrations` | POST `/v1/tax/registrations` | Create a registration | — |
| `GetTaxRegistrationsId` | GET `/v1/tax/registrations/{id}` | Retrieve a registration | — |
| `PostTaxRegistrationsId` | POST `/v1/tax/registrations/{id}` | Update a registration | — |
| `GetTaxSettings` | GET `/v1/tax/settings` | Retrieve settings | — |
| `PostTaxSettings` | POST `/v1/tax/settings` | Update settings | — |
| `PostTaxTransactionsCreateFromCalculation` | POST `/v1/tax/transactions/create_from_calculation` | Create a Transaction from a Calculation | — |
| `PostTaxTransactionsCreateReversal` | POST `/v1/tax/transactions/create_reversal` | Create a reversal Transaction | — |
| `GetTaxTransactionsTransaction` | GET `/v1/tax/transactions/{transaction}` | Retrieve a Transaction | — |
| `GetTaxTransactionsTransactionLineItems` | GET `/v1/tax/transactions/{transaction}/line_items` | Retrieve a Transaction's line items | — |
| `GetTaxCodes` | GET `/v1/tax_codes` | List all tax codes | — |
| `GetTaxCodesId` | GET `/v1/tax_codes/{id}` | Retrieve a tax code | — |
| `GetTaxIds` | GET `/v1/tax_ids` | List all tax IDs | — |
| `PostTaxIds` | POST `/v1/tax_ids` | Create a tax ID | — |
| `GetTaxIdsId` | GET `/v1/tax_ids/{id}` | Retrieve a tax ID | — |
| `DeleteTaxIdsId` | DELETE `/v1/tax_ids/{id}` | Delete a tax ID | — |
| `GetTaxRates` | GET `/v1/tax_rates` | List all tax rates | — |
| `PostTaxRates` | POST `/v1/tax_rates` | Create a tax rate | — |
| `GetTaxRatesTaxRate` | GET `/v1/tax_rates/{tax_rate}` | Retrieve a tax rate | — |
| `PostTaxRatesTaxRate` | POST `/v1/tax_rates/{tax_rate}` | Update a tax rate | — |
| `GetTerminalConfigurations` | GET `/v1/terminal/configurations` | List all Configurations | — |
| `PostTerminalConfigurations` | POST `/v1/terminal/configurations` | Create a Configuration | — |
| `GetTerminalConfigurationsConfiguration` | GET `/v1/terminal/configurations/{configuration}` | Retrieve a Configuration | — |
| `PostTerminalConfigurationsConfiguration` | POST `/v1/terminal/configurations/{configuration}` | Update a Configuration | — |
| `DeleteTerminalConfigurationsConfiguration` | DELETE `/v1/terminal/configurations/{configuration}` | Delete a Configuration | — |
| `PostTerminalConnectionTokens` | POST `/v1/terminal/connection_tokens` | Create a Connection Token | — |
| `GetTerminalLocations` | GET `/v1/terminal/locations` | List all Locations | — |
| `PostTerminalLocations` | POST `/v1/terminal/locations` | Create a Location | — |
| `GetTerminalLocationsLocation` | GET `/v1/terminal/locations/{location}` | Retrieve a Location | — |
| `PostTerminalLocationsLocation` | POST `/v1/terminal/locations/{location}` | Update a Location | — |
| `DeleteTerminalLocationsLocation` | DELETE `/v1/terminal/locations/{location}` | Delete a Location | — |
| `PostTerminalOnboardingLinks` | POST `/v1/terminal/onboarding_links` | Create an Onboarding Link | — |
| `GetTerminalReaders` | GET `/v1/terminal/readers` | List all Readers | — |
| `PostTerminalReaders` | POST `/v1/terminal/readers` | Create a Reader | — |
| `GetTerminalReadersReader` | GET `/v1/terminal/readers/{reader}` | Retrieve a Reader | — |
| `PostTerminalReadersReader` | POST `/v1/terminal/readers/{reader}` | Update a Reader | — |
| `DeleteTerminalReadersReader` | DELETE `/v1/terminal/readers/{reader}` | Delete a Reader | — |
| `PostTerminalReadersReaderCancelAction` | POST `/v1/terminal/readers/{reader}/cancel_action` | Cancel the current reader action | — |
| `PostTerminalReadersReaderCollectInputs` | POST `/v1/terminal/readers/{reader}/collect_inputs` | Collect inputs using a Reader | — |
| `PostTerminalReadersReaderCollectPaymentMethod` | POST `/v1/terminal/readers/{reader}/collect_payment_method` | Hand off a PaymentIntent to a Reader and collect card details | — |
| `PostTerminalReadersReaderConfirmPaymentIntent` | POST `/v1/terminal/readers/{reader}/confirm_payment_intent` | Confirm a PaymentIntent on the Reader | — |
| `PostTerminalReadersReaderProcessPaymentIntent` | POST `/v1/terminal/readers/{reader}/process_payment_intent` | Hand-off a PaymentIntent to a Reader | — |
| `PostTerminalReadersReaderProcessSetupIntent` | POST `/v1/terminal/readers/{reader}/process_setup_intent` | Hand-off a SetupIntent to a Reader | — |
| `PostTerminalReadersReaderRefundPayment` | POST `/v1/terminal/readers/{reader}/refund_payment` | Refund a Charge or a PaymentIntent in-person | — |
| `PostTerminalReadersReaderSetReaderDisplay` | POST `/v1/terminal/readers/{reader}/set_reader_display` | Set reader display | — |
| `PostTerminalRefunds` | POST `/v1/terminal/refunds` | Create a refund using a Terminal-supported device. | — |
| `PostTestHelpersConfirmationTokens` | POST `/v1/test_helpers/confirmation_tokens` | Create a test Confirmation Token | — |
| `PostTestHelpersCustomersCustomerFundCashBalance` | POST `/v1/test_helpers/customers/{customer}/fund_cash_balance` | Fund a test mode cash balance | — |
| `PostTestHelpersIssuingAuthorizations` | POST `/v1/test_helpers/issuing/authorizations` | Create a test-mode authorization | — |
| `PostTestHelpersIssuingAuthorizationsAuthorizationCapture` | POST `/v1/test_helpers/issuing/authorizations/{authorization}/capture` | Capture a test-mode authorization | — |
| `PostTestHelpersIssuingAuthorizationsAuthorizationExpire` | POST `/v1/test_helpers/issuing/authorizations/{authorization}/expire` | Expire a test-mode authorization | — |
| `PostTestHelpersIssuingAuthorizationsAuthorizationFinalizeAmount` | POST `/v1/test_helpers/issuing/authorizations/{authorization}/finalize_amount` | Finalize a test-mode authorization's amount | — |
| `PostTestHelpersIssuingAuthorizationsAuthorizationFraudChallengesRespond` | POST `/v1/test_helpers/issuing/authorizations/{authorization}/fraud_challenges/respond` | Respond to fraud challenge | — |
| `PostTestHelpersIssuingAuthorizationsAuthorizationIncrement` | POST `/v1/test_helpers/issuing/authorizations/{authorization}/increment` | Increment a test-mode authorization | — |
| `PostTestHelpersIssuingAuthorizationsAuthorizationReverse` | POST `/v1/test_helpers/issuing/authorizations/{authorization}/reverse` | Reverse a test-mode authorization | — |
| `PostTestHelpersIssuingCardsCardShippingDeliver` | POST `/v1/test_helpers/issuing/cards/{card}/shipping/deliver` | Deliver a testmode card | — |
| `PostTestHelpersIssuingCardsCardShippingFail` | POST `/v1/test_helpers/issuing/cards/{card}/shipping/fail` | Fail a testmode card | — |
| `PostTestHelpersIssuingCardsCardShippingReturn` | POST `/v1/test_helpers/issuing/cards/{card}/shipping/return` | Return a testmode card | — |
| `PostTestHelpersIssuingCardsCardShippingShip` | POST `/v1/test_helpers/issuing/cards/{card}/shipping/ship` | Ship a testmode card | — |
| `PostTestHelpersIssuingCardsCardShippingSubmit` | POST `/v1/test_helpers/issuing/cards/{card}/shipping/submit` | Submit a testmode card | — |
| `PostTestHelpersIssuingPersonalizationDesignsPersonalizationDesignActivate` | POST `/v1/test_helpers/issuing/personalization_designs/{personalization_design}/activate` | Activate a testmode personalization design | — |
| `PostTestHelpersIssuingPersonalizationDesignsPersonalizationDesignDeactivate` | POST `/v1/test_helpers/issuing/personalization_designs/{personalization_design}/deactivate` | Deactivate a testmode personalization design | — |
| `PostTestHelpersIssuingPersonalizationDesignsPersonalizationDesignReject` | POST `/v1/test_helpers/issuing/personalization_designs/{personalization_design}/reject` | Reject a testmode personalization design | — |
| `PostTestHelpersIssuingSettlements` | POST `/v1/test_helpers/issuing/settlements` | Create a test-mode settlement | — |
| `PostTestHelpersIssuingSettlementsSettlementComplete` | POST `/v1/test_helpers/issuing/settlements/{settlement}/complete` | Complete a test-mode settlement | — |
| `PostTestHelpersIssuingTransactionsCreateForceCapture` | POST `/v1/test_helpers/issuing/transactions/create_force_capture` | Create a test-mode force capture | — |
| `PostTestHelpersIssuingTransactionsCreateUnlinkedRefund` | POST `/v1/test_helpers/issuing/transactions/create_unlinked_refund` | Create a test-mode unlinked refund | — |
| `PostTestHelpersIssuingTransactionsTransactionRefund` | POST `/v1/test_helpers/issuing/transactions/{transaction}/refund` | Refund a test-mode transaction | — |
| `PostTestHelpersRefundsRefundExpire` | POST `/v1/test_helpers/refunds/{refund}/expire` | Expire a pending refund. | — |
| `PostTestHelpersTerminalReadersReaderPresentPaymentMethod` | POST `/v1/test_helpers/terminal/readers/{reader}/present_payment_method` | Simulate presenting a payment method | — |
| `PostTestHelpersTerminalReadersReaderSucceedInputCollection` | POST `/v1/test_helpers/terminal/readers/{reader}/succeed_input_collection` | Simulate a successful input collection | — |
| `PostTestHelpersTerminalReadersReaderTimeoutInputCollection` | POST `/v1/test_helpers/terminal/readers/{reader}/timeout_input_collection` | Simulate an input collection timeout | — |
| `GetTestHelpersTestClocks` | GET `/v1/test_helpers/test_clocks` | List all test clocks | — |
| `PostTestHelpersTestClocks` | POST `/v1/test_helpers/test_clocks` | Create a test clock | — |
| `GetTestHelpersTestClocksTestClock` | GET `/v1/test_helpers/test_clocks/{test_clock}` | Retrieve a test clock | — |
| `DeleteTestHelpersTestClocksTestClock` | DELETE `/v1/test_helpers/test_clocks/{test_clock}` | Delete a test clock | — |
| `PostTestHelpersTestClocksTestClockAdvance` | POST `/v1/test_helpers/test_clocks/{test_clock}/advance` | Advance a test clock | — |
| `PostTestHelpersTreasuryInboundTransfersIdFail` | POST `/v1/test_helpers/treasury/inbound_transfers/{id}/fail` | Test mode: Fail an InboundTransfer | — |
| `PostTestHelpersTreasuryInboundTransfersIdReturn` | POST `/v1/test_helpers/treasury/inbound_transfers/{id}/return` | Test mode: Return an InboundTransfer | — |
| `PostTestHelpersTreasuryInboundTransfersIdSucceed` | POST `/v1/test_helpers/treasury/inbound_transfers/{id}/succeed` | Test mode: Succeed an InboundTransfer | — |
| `PostTestHelpersTreasuryOutboundPaymentsId` | POST `/v1/test_helpers/treasury/outbound_payments/{id}` | Test mode: Update an OutboundPayment | — |
| `PostTestHelpersTreasuryOutboundPaymentsIdFail` | POST `/v1/test_helpers/treasury/outbound_payments/{id}/fail` | Test mode: Fail an OutboundPayment | — |
| `PostTestHelpersTreasuryOutboundPaymentsIdPost` | POST `/v1/test_helpers/treasury/outbound_payments/{id}/post` | Test mode: Post an OutboundPayment | — |
| `PostTestHelpersTreasuryOutboundPaymentsIdReturn` | POST `/v1/test_helpers/treasury/outbound_payments/{id}/return` | Test mode: Return an OutboundPayment | — |
| `PostTestHelpersTreasuryOutboundTransfersOutboundTransfer` | POST `/v1/test_helpers/treasury/outbound_transfers/{outbound_transfer}` | Test mode: Update an OutboundTransfer | — |
| `PostTestHelpersTreasuryOutboundTransfersOutboundTransferFail` | POST `/v1/test_helpers/treasury/outbound_transfers/{outbound_transfer}/fail` | Test mode: Fail an OutboundTransfer | — |
| `PostTestHelpersTreasuryOutboundTransfersOutboundTransferPost` | POST `/v1/test_helpers/treasury/outbound_transfers/{outbound_transfer}/post` | Test mode: Post an OutboundTransfer | — |
| `PostTestHelpersTreasuryOutboundTransfersOutboundTransferReturn` | POST `/v1/test_helpers/treasury/outbound_transfers/{outbound_transfer}/return` | Test mode: Return an OutboundTransfer | — |
| `PostTestHelpersTreasuryReceivedCredits` | POST `/v1/test_helpers/treasury/received_credits` | Test mode: Create a ReceivedCredit | — |
| `PostTestHelpersTreasuryReceivedDebits` | POST `/v1/test_helpers/treasury/received_debits` | Test mode: Create a ReceivedDebit | — |
| `PostTokens` | POST `/v1/tokens` | Create a bank account token | — |
| `GetTokensToken` | GET `/v1/tokens/{token}` | Retrieve a token | — |
| `GetTopups` | GET `/v1/topups` | List all top-ups | — |
| `PostTopups` | POST `/v1/topups` | Create a top-up | — |
| `GetTopupsTopup` | GET `/v1/topups/{topup}` | Retrieve a top-up | — |
| `PostTopupsTopup` | POST `/v1/topups/{topup}` | Update a top-up | — |
| `PostTopupsTopupCancel` | POST `/v1/topups/{topup}/cancel` | Cancel a top-up | — |
| `GetTransfers` | GET `/v1/transfers` | List all transfers | — |
| `PostTransfers` | POST `/v1/transfers` | Create a transfer | — |
| `GetTransfersIdReversals` | GET `/v1/transfers/{id}/reversals` | List all reversals | — |
| `PostTransfersIdReversals` | POST `/v1/transfers/{id}/reversals` | Create a transfer reversal | — |
| `GetTransfersTransfer` | GET `/v1/transfers/{transfer}` | Retrieve a transfer | — |
| `PostTransfersTransfer` | POST `/v1/transfers/{transfer}` | Update a transfer | — |
| `GetTransfersTransferReversalsId` | GET `/v1/transfers/{transfer}/reversals/{id}` | Retrieve a reversal | — |
| `PostTransfersTransferReversalsId` | POST `/v1/transfers/{transfer}/reversals/{id}` | Update a reversal | — |
| `GetTreasuryCreditReversals` | GET `/v1/treasury/credit_reversals` | List all CreditReversals | — |
| `PostTreasuryCreditReversals` | POST `/v1/treasury/credit_reversals` | Create a CreditReversal | — |
| `GetTreasuryCreditReversalsCreditReversal` | GET `/v1/treasury/credit_reversals/{credit_reversal}` | Retrieve a CreditReversal | — |
| `GetTreasuryDebitReversals` | GET `/v1/treasury/debit_reversals` | List all DebitReversals | — |
| `PostTreasuryDebitReversals` | POST `/v1/treasury/debit_reversals` | Create a DebitReversal | — |
| `GetTreasuryDebitReversalsDebitReversal` | GET `/v1/treasury/debit_reversals/{debit_reversal}` | Retrieve a DebitReversal | — |
| `GetTreasuryFinancialAccounts` | GET `/v1/treasury/financial_accounts` | List all FinancialAccounts | — |
| `PostTreasuryFinancialAccounts` | POST `/v1/treasury/financial_accounts` | Create a FinancialAccount | — |
| `GetTreasuryFinancialAccountsFinancialAccount` | GET `/v1/treasury/financial_accounts/{financial_account}` | Retrieve a FinancialAccount | — |
| `PostTreasuryFinancialAccountsFinancialAccount` | POST `/v1/treasury/financial_accounts/{financial_account}` | Update a FinancialAccount | — |
| `PostTreasuryFinancialAccountsFinancialAccountClose` | POST `/v1/treasury/financial_accounts/{financial_account}/close` | Close a FinancialAccount | — |
| `GetTreasuryFinancialAccountsFinancialAccountFeatures` | GET `/v1/treasury/financial_accounts/{financial_account}/features` | Retrieve FinancialAccount Features | — |
| `PostTreasuryFinancialAccountsFinancialAccountFeatures` | POST `/v1/treasury/financial_accounts/{financial_account}/features` | Update FinancialAccount Features | — |
| `GetTreasuryInboundTransfers` | GET `/v1/treasury/inbound_transfers` | List all InboundTransfers | — |
| `PostTreasuryInboundTransfers` | POST `/v1/treasury/inbound_transfers` | Create an InboundTransfer | — |
| `GetTreasuryInboundTransfersId` | GET `/v1/treasury/inbound_transfers/{id}` | Retrieve an InboundTransfer | — |
| `PostTreasuryInboundTransfersInboundTransferCancel` | POST `/v1/treasury/inbound_transfers/{inbound_transfer}/cancel` | Cancel an InboundTransfer | — |
| `GetTreasuryOutboundPayments` | GET `/v1/treasury/outbound_payments` | List all OutboundPayments | — |
| `PostTreasuryOutboundPayments` | POST `/v1/treasury/outbound_payments` | Create an OutboundPayment | — |
| `GetTreasuryOutboundPaymentsId` | GET `/v1/treasury/outbound_payments/{id}` | Retrieve an OutboundPayment | — |
| `PostTreasuryOutboundPaymentsIdCancel` | POST `/v1/treasury/outbound_payments/{id}/cancel` | Cancel an OutboundPayment | — |
| `GetTreasuryOutboundTransfers` | GET `/v1/treasury/outbound_transfers` | List all OutboundTransfers | — |
| `PostTreasuryOutboundTransfers` | POST `/v1/treasury/outbound_transfers` | Create an OutboundTransfer | — |
| `GetTreasuryOutboundTransfersOutboundTransfer` | GET `/v1/treasury/outbound_transfers/{outbound_transfer}` | Retrieve an OutboundTransfer | — |
| `PostTreasuryOutboundTransfersOutboundTransferCancel` | POST `/v1/treasury/outbound_transfers/{outbound_transfer}/cancel` | Cancel an OutboundTransfer | — |
| `GetTreasuryReceivedCredits` | GET `/v1/treasury/received_credits` | List all ReceivedCredits | — |
| `GetTreasuryReceivedCreditsId` | GET `/v1/treasury/received_credits/{id}` | Retrieve a ReceivedCredit | — |
| `GetTreasuryReceivedDebits` | GET `/v1/treasury/received_debits` | List all ReceivedDebits | — |
| `GetTreasuryReceivedDebitsId` | GET `/v1/treasury/received_debits/{id}` | Retrieve a ReceivedDebit | — |
| `GetTreasuryTransactionEntries` | GET `/v1/treasury/transaction_entries` | List all TransactionEntries | — |
| `GetTreasuryTransactionEntriesId` | GET `/v1/treasury/transaction_entries/{id}` | Retrieve a TransactionEntry | — |
| `GetTreasuryTransactions` | GET `/v1/treasury/transactions` | List all Transactions | — |
| `GetTreasuryTransactionsId` | GET `/v1/treasury/transactions/{id}` | Retrieve a Transaction | — |
| `GetWebhookEndpoints` | GET `/v1/webhook_endpoints` | List all webhook endpoints | — |
| `PostWebhookEndpoints` | POST `/v1/webhook_endpoints` | Create a webhook endpoint | — |
| `GetWebhookEndpointsWebhookEndpoint` | GET `/v1/webhook_endpoints/{webhook_endpoint}` | Retrieve a webhook endpoint | — |
| `PostWebhookEndpointsWebhookEndpoint` | POST `/v1/webhook_endpoints/{webhook_endpoint}` | Update a webhook endpoint | — |
| `DeleteWebhookEndpointsWebhookEndpoint` | DELETE `/v1/webhook_endpoints/{webhook_endpoint}` | Delete a webhook endpoint | — |
| `PostV2BillingMeterEventAdjustments` | POST `/v2/billing/meter_event_adjustments` | Create a Meter Event Adjustment | — |
| `PostV2BillingMeterEventSession` | POST `/v2/billing/meter_event_session` | Create a Meter Event Stream Authentication Session | — |
| `PostV2BillingMeterEventStream` | POST `/v2/billing/meter_event_stream` | Create a Meter Event with asynchronous validation | — |
| `PostV2BillingMeterEvents` | POST `/v2/billing/meter_events` | Create a Meter Event with synchronous validation | — |
| `GetV2CommerceProductCatalogImports` | GET `/v2/commerce/product_catalog/imports` | List Product Catalog Imports | — |
| `PostV2CommerceProductCatalogImports` | POST `/v2/commerce/product_catalog/imports` | Create a Product Catalog Import | — |
| `GetV2CommerceProductCatalogImportsId` | GET `/v2/commerce/product_catalog/imports/{id}` | Retrieve a Product Catalog Import | — |
| `PostV2CoreAccountLinks` | POST `/v2/core/account_links` | Create an account link | — |
| `PostV2CoreAccountTokens` | POST `/v2/core/account_tokens` | Create an account token | — |
| `GetV2CoreAccountTokensId` | GET `/v2/core/account_tokens/{id}` | Retrieve an account token | — |
| `GetV2CoreAccounts` | GET `/v2/core/accounts` | List accounts | — |
| `PostV2CoreAccounts` | POST `/v2/core/accounts` | Create an account | — |
| `PostV2CoreAccountsAccountIdPersonTokens` | POST `/v2/core/accounts/{account_id}/person_tokens` | Create a person token | — |
| `GetV2CoreAccountsAccountIdPersonTokensId` | GET `/v2/core/accounts/{account_id}/person_tokens/{id}` | Retrieve a person token | — |
| `GetV2CoreAccountsAccountIdPersons` | GET `/v2/core/accounts/{account_id}/persons` | List persons | — |
| `PostV2CoreAccountsAccountIdPersons` | POST `/v2/core/accounts/{account_id}/persons` | Create a person | — |
| `GetV2CoreAccountsAccountIdPersonsId` | GET `/v2/core/accounts/{account_id}/persons/{id}` | Retrieve a person | — |
| `PostV2CoreAccountsAccountIdPersonsId` | POST `/v2/core/accounts/{account_id}/persons/{id}` | Update a person | — |
| `DeleteV2CoreAccountsAccountIdPersonsId` | DELETE `/v2/core/accounts/{account_id}/persons/{id}` | Delete a person | — |
| `GetV2CoreAccountsId` | GET `/v2/core/accounts/{id}` | Retrieve an account | — |
| `PostV2CoreAccountsId` | POST `/v2/core/accounts/{id}` | Update an account | — |
| `PostV2CoreAccountsIdClose` | POST `/v2/core/accounts/{id}/close` | Close an account | — |
| `GetV2CoreEventDestinations` | GET `/v2/core/event_destinations` | List Event Destinations | — |
| `PostV2CoreEventDestinations` | POST `/v2/core/event_destinations` | Create an Event Destination | — |
| `GetV2CoreEventDestinationsId` | GET `/v2/core/event_destinations/{id}` | Retrieve an Event Destination | — |
| `PostV2CoreEventDestinationsId` | POST `/v2/core/event_destinations/{id}` | Update an Event Destination | — |
| `DeleteV2CoreEventDestinationsId` | DELETE `/v2/core/event_destinations/{id}` | Delete an Event Destination | — |
| `PostV2CoreEventDestinationsIdDisable` | POST `/v2/core/event_destinations/{id}/disable` | Disable an Event Destination | — |
| `PostV2CoreEventDestinationsIdEnable` | POST `/v2/core/event_destinations/{id}/enable` | Enable an Event Destination | — |
| `PostV2CoreEventDestinationsIdPing` | POST `/v2/core/event_destinations/{id}/ping` | Ping an Event Destination | — |
| `GetV2CoreEvents` | GET `/v2/core/events` | List Events | — |
| `GetV2CoreEventsId` | GET `/v2/core/events/{id}` | Retrieve an Event | — |

## Обоснование выбора операций

- `create` (создание): POST `/v1/payouts` — оценка 104; следующий кандидат POST `/v1/transfers` — оценка 86; разница 18.
- `status` (проверка статуса): GET `/v1/payouts/{payout}` — оценка 85; следующий кандидат POST `/v1/payouts/{payout}` — оценка 28; разница 57.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `paid` | `approved` |
| `pending` | `in_progress` |
| `in_transit` | `in_progress` |
| `canceled` | `rejected` |
| `failed` | `rejected` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `amount` | `operation.amount` |
| `currency` | **TODO:** подтвердить схему платформы |
| `description` | **TODO:** подтвердить схему платформы |
| `destination` | **TODO:** подтвердить схему платформы |
| `expand` | **TODO:** подтвердить схему платформы |
| `metadata` | **TODO:** подтвердить схему платформы |
| `method` | **TODO:** подтвердить схему платформы |
| `payout_method` | **TODO:** подтвердить схему платформы |
| `source_type` | **TODO:** подтвердить схему платформы |
| `statement_descriptor` | **TODO:** подтвердить схему платформы |

## Локальная проверка данных

Ограничения из OpenAPI проверяются в `check_conditions` до обращения к провайдеру. При ошибке сервис возвращает `failure(:unprocessable_entity, ...)`.

| Поле | Проверяемые ограничения |
|---|---|
| `description` | maxLength: `5000` |
| `method` | enum: `instant, standard`; maxLength: `5000` |
| `source_type` | enum: `bank_account, card, fpx`; maxLength: `5000` |
| `statement_descriptor` | maxLength: `22` |

## Обработка ошибок

| HTTP | Код ошибки | Рекомендуемое действие |
|---:|---|---|


## Конфигурация ProviderGateway

Не задана. Укажите `provider_gateway.external_method` и `provider_gateway.gateway` в overrides после подтверждения бизнес-маршрута.

## Подпись webhook

В спецификации не обнаружена.

`process_callback` получает уже разобранный JSON в `payload`, без исходного тела и заголовков. Поэтому криптографическую проверку подписи нельзя корректно выполнить внутри сгенерированного сервиса: её следует делать на уровне платформы до разбора JSON. Сервис не имитирует проверку по повторно сериализованному объекту.

## Подтверждённые overrides

Не переданы. Элементы из свободного текста остаются TODO в предупреждениях.

## Предупреждения генератора

- Не удалось определить входящий webhook.
- TODO field_map currency: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
