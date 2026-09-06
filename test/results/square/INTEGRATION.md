# Руководство по интеграции Square

> Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

**Результат автоматической проверки:** найдено предупреждений: 8. Проверьте раздел «Предупреждения генератора» перед подключением.

## Подключение

- Базовый URL по умолчанию: `https://connect.squareup.com`
- Переменная окружения: `SQUARE_BASE_URL`
- API-ключ: `SQUARE_API_KEY`

Адреса из OpenAPI:

- API: `https://connect.squareup.com`

## Авторизация

- `oauth2`: oauth2,  ``
- `oauth2ClientSecret`: apiKey, header `Authorization`

## Методы

`create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

| Операция | API-адрес | Назначение | Идемпотентность |
|---|---|---|---|
| `RevokeToken` | POST `/oauth2/revoke` | RevokeToken | — |
| `ObtainToken` | POST `/oauth2/token` | ObtainToken | — |
| `RetrieveTokenStatus` | POST `/oauth2/token/status` | RetrieveTokenStatus | — |
| `V1ListOrders` | GET `/v1/{location_id}/orders` | V1ListOrders | — |
| `V1RetrieveOrder` | GET `/v1/{location_id}/orders/{order_id}` | V1RetrieveOrder | — |
| `V1UpdateOrder` | PUT `/v1/{location_id}/orders/{order_id}` | V1UpdateOrder | — |
| `RegisterDomain` | POST `/v2/apple-pay/domains` | RegisterDomain | — |
| `ListBankAccounts` | GET `/v2/bank-accounts` | ListBankAccounts | — |
| `CreateBankAccount` | POST `/v2/bank-accounts` | CreateBankAccount | — |
| `GetBankAccountByV1Id` | GET `/v2/bank-accounts/by-v1-id/{v1_bank_account_id}` | GetBankAccountByV1Id | — |
| `GetBankAccount` | GET `/v2/bank-accounts/{bank_account_id}` | GetBankAccount | — |
| `DisableBankAccount` | POST `/v2/bank-accounts/{bank_account_id}/disable` | DisableBankAccount | — |
| `ListBookings` | GET `/v2/bookings` | ListBookings | — |
| `CreateBooking` | POST `/v2/bookings` | CreateBooking | — |
| `SearchAvailability` | POST `/v2/bookings/availability/search` | SearchAvailability | — |
| `BulkRetrieveBookings` | POST `/v2/bookings/bulk-retrieve` | BulkRetrieveBookings | — |
| `RetrieveBusinessBookingProfile` | GET `/v2/bookings/business-booking-profile` | RetrieveBusinessBookingProfile | — |
| `ListBookingCustomAttributeDefinitions` | GET `/v2/bookings/custom-attribute-definitions` | ListBookingCustomAttributeDefinitions | — |
| `CreateBookingCustomAttributeDefinition` | POST `/v2/bookings/custom-attribute-definitions` | CreateBookingCustomAttributeDefinition | — |
| `RetrieveBookingCustomAttributeDefinition` | GET `/v2/bookings/custom-attribute-definitions/{key}` | RetrieveBookingCustomAttributeDefinition | — |
| `UpdateBookingCustomAttributeDefinition` | PUT `/v2/bookings/custom-attribute-definitions/{key}` | UpdateBookingCustomAttributeDefinition | — |
| `DeleteBookingCustomAttributeDefinition` | DELETE `/v2/bookings/custom-attribute-definitions/{key}` | DeleteBookingCustomAttributeDefinition | — |
| `BulkDeleteBookingCustomAttributes` | POST `/v2/bookings/custom-attributes/bulk-delete` | BulkDeleteBookingCustomAttributes | — |
| `BulkUpsertBookingCustomAttributes` | POST `/v2/bookings/custom-attributes/bulk-upsert` | BulkUpsertBookingCustomAttributes | — |
| `ListLocationBookingProfiles` | GET `/v2/bookings/location-booking-profiles` | ListLocationBookingProfiles | — |
| `RetrieveLocationBookingProfile` | GET `/v2/bookings/location-booking-profiles/{location_id}` | RetrieveLocationBookingProfile | — |
| `ListTeamMemberBookingProfiles` | GET `/v2/bookings/team-member-booking-profiles` | ListTeamMemberBookingProfiles | — |
| `BulkRetrieveTeamMemberBookingProfiles` | POST `/v2/bookings/team-member-booking-profiles/bulk-retrieve` | BulkRetrieveTeamMemberBookingProfiles | — |
| `RetrieveTeamMemberBookingProfile` | GET `/v2/bookings/team-member-booking-profiles/{team_member_id}` | RetrieveTeamMemberBookingProfile | — |
| `RetrieveBooking` | GET `/v2/bookings/{booking_id}` | RetrieveBooking | — |
| `UpdateBooking` | PUT `/v2/bookings/{booking_id}` | UpdateBooking | — |
| `CancelBooking` | POST `/v2/bookings/{booking_id}/cancel` | CancelBooking | — |
| `ListBookingCustomAttributes` | GET `/v2/bookings/{booking_id}/custom-attributes` | ListBookingCustomAttributes | — |
| `RetrieveBookingCustomAttribute` | GET `/v2/bookings/{booking_id}/custom-attributes/{key}` | RetrieveBookingCustomAttribute | — |
| `UpsertBookingCustomAttribute` | PUT `/v2/bookings/{booking_id}/custom-attributes/{key}` | UpsertBookingCustomAttribute | — |
| `DeleteBookingCustomAttribute` | DELETE `/v2/bookings/{booking_id}/custom-attributes/{key}` | DeleteBookingCustomAttribute | — |
| `ListCards` | GET `/v2/cards` | ListCards | — |
| `CreateCard` | POST `/v2/cards` | CreateCard | — |
| `RetrieveCard` | GET `/v2/cards/{card_id}` | RetrieveCard | — |
| `DisableCard` | POST `/v2/cards/{card_id}/disable` | DisableCard | — |
| `ListCashDrawerShifts` | GET `/v2/cash-drawers/shifts` | ListCashDrawerShifts | — |
| `RetrieveCashDrawerShift` | GET `/v2/cash-drawers/shifts/{shift_id}` | RetrieveCashDrawerShift | — |
| `ListCashDrawerShiftEvents` | GET `/v2/cash-drawers/shifts/{shift_id}/events` | ListCashDrawerShiftEvents | — |
| `BatchDeleteCatalogObjects` | POST `/v2/catalog/batch-delete` | BatchDeleteCatalogObjects | — |
| `BatchRetrieveCatalogObjects` | POST `/v2/catalog/batch-retrieve` | BatchRetrieveCatalogObjects | — |
| `BatchUpsertCatalogObjects` | POST `/v2/catalog/batch-upsert` | BatchUpsertCatalogObjects | — |
| `CreateCatalogImage` | POST `/v2/catalog/images` | CreateCatalogImage | — |
| `UpdateCatalogImage` | PUT `/v2/catalog/images/{image_id}` | UpdateCatalogImage | — |
| `CatalogInfo` | GET `/v2/catalog/info` | CatalogInfo | — |
| `ListCatalog` | GET `/v2/catalog/list` | ListCatalog | — |
| `UpsertCatalogObject` | POST `/v2/catalog/object` | UpsertCatalogObject | — |
| `RetrieveCatalogObject` | GET `/v2/catalog/object/{object_id}` | RetrieveCatalogObject | — |
| `DeleteCatalogObject` | DELETE `/v2/catalog/object/{object_id}` | DeleteCatalogObject | — |
| `SearchCatalogObjects` | POST `/v2/catalog/search` | SearchCatalogObjects | — |
| `SearchCatalogItems` | POST `/v2/catalog/search-catalog-items` | SearchCatalogItems | — |
| `UpdateItemModifierLists` | POST `/v2/catalog/update-item-modifier-lists` | UpdateItemModifierLists | — |
| `UpdateItemTaxes` | POST `/v2/catalog/update-item-taxes` | UpdateItemTaxes | — |
| `ListChannels` | GET `/v2/channels` | ListChannels | — |
| `BulkRetrieveChannels` | POST `/v2/channels/bulk-retrieve` | BulkRetrieveChannels | — |
| `RetrieveChannel` | GET `/v2/channels/{channel_id}` | RetrieveChannel | — |
| `ListCustomers` | GET `/v2/customers` | ListCustomers | — |
| `CreateCustomer` | POST `/v2/customers` | CreateCustomer | — |
| `BulkCreateCustomers` | POST `/v2/customers/bulk-create` | BulkCreateCustomers | — |
| `BulkDeleteCustomers` | POST `/v2/customers/bulk-delete` | BulkDeleteCustomers | — |
| `BulkRetrieveCustomers` | POST `/v2/customers/bulk-retrieve` | BulkRetrieveCustomers | — |
| `BulkUpdateCustomers` | POST `/v2/customers/bulk-update` | BulkUpdateCustomers | — |
| `ListCustomerCustomAttributeDefinitions` | GET `/v2/customers/custom-attribute-definitions` | ListCustomerCustomAttributeDefinitions | — |
| `CreateCustomerCustomAttributeDefinition` | POST `/v2/customers/custom-attribute-definitions` | CreateCustomerCustomAttributeDefinition | — |
| `RetrieveCustomerCustomAttributeDefinition` | GET `/v2/customers/custom-attribute-definitions/{key}` | RetrieveCustomerCustomAttributeDefinition | — |
| `UpdateCustomerCustomAttributeDefinition` | PUT `/v2/customers/custom-attribute-definitions/{key}` | UpdateCustomerCustomAttributeDefinition | — |
| `DeleteCustomerCustomAttributeDefinition` | DELETE `/v2/customers/custom-attribute-definitions/{key}` | DeleteCustomerCustomAttributeDefinition | — |
| `BulkUpsertCustomerCustomAttributes` | POST `/v2/customers/custom-attributes/bulk-upsert` | BulkUpsertCustomerCustomAttributes | — |
| `ListCustomerGroups` | GET `/v2/customers/groups` | ListCustomerGroups | — |
| `CreateCustomerGroup` | POST `/v2/customers/groups` | CreateCustomerGroup | — |
| `RetrieveCustomerGroup` | GET `/v2/customers/groups/{group_id}` | RetrieveCustomerGroup | — |
| `UpdateCustomerGroup` | PUT `/v2/customers/groups/{group_id}` | UpdateCustomerGroup | — |
| `DeleteCustomerGroup` | DELETE `/v2/customers/groups/{group_id}` | DeleteCustomerGroup | — |
| `SearchCustomers` | POST `/v2/customers/search` | SearchCustomers | — |
| `ListCustomerSegments` | GET `/v2/customers/segments` | ListCustomerSegments | — |
| `RetrieveCustomerSegment` | GET `/v2/customers/segments/{segment_id}` | RetrieveCustomerSegment | — |
| `RetrieveCustomer` | GET `/v2/customers/{customer_id}` | RetrieveCustomer | — |
| `UpdateCustomer` | PUT `/v2/customers/{customer_id}` | UpdateCustomer | — |
| `DeleteCustomer` | DELETE `/v2/customers/{customer_id}` | DeleteCustomer | — |
| `CreateCustomerCard` | POST `/v2/customers/{customer_id}/cards` | CreateCustomerCard | — |
| `DeleteCustomerCard` | DELETE `/v2/customers/{customer_id}/cards/{card_id}` | DeleteCustomerCard | — |
| `ListCustomerCustomAttributes` | GET `/v2/customers/{customer_id}/custom-attributes` | ListCustomerCustomAttributes | — |
| `RetrieveCustomerCustomAttribute` | GET `/v2/customers/{customer_id}/custom-attributes/{key}` | RetrieveCustomerCustomAttribute | — |
| `UpsertCustomerCustomAttribute` | POST `/v2/customers/{customer_id}/custom-attributes/{key}` | UpsertCustomerCustomAttribute | — |
| `DeleteCustomerCustomAttribute` | DELETE `/v2/customers/{customer_id}/custom-attributes/{key}` | DeleteCustomerCustomAttribute | — |
| `AddGroupToCustomer` | PUT `/v2/customers/{customer_id}/groups/{group_id}` | AddGroupToCustomer | — |
| `RemoveGroupFromCustomer` | DELETE `/v2/customers/{customer_id}/groups/{group_id}` | RemoveGroupFromCustomer | — |
| `ListDevices` | GET `/v2/devices` | ListDevices | — |
| `ListDeviceCodes` | GET `/v2/devices/codes` | ListDeviceCodes | — |
| `CreateDeviceCode` | POST `/v2/devices/codes` | CreateDeviceCode | — |
| `GetDeviceCode` | GET `/v2/devices/codes/{id}` | GetDeviceCode | — |
| `GetDevice` | GET `/v2/devices/{device_id}` | GetDevice | — |
| `ListDisputes` | GET `/v2/disputes` | ListDisputes | — |
| `RetrieveDispute` | GET `/v2/disputes/{dispute_id}` | RetrieveDispute | — |
| `AcceptDispute` | POST `/v2/disputes/{dispute_id}/accept` | AcceptDispute | — |
| `ListDisputeEvidence` | GET `/v2/disputes/{dispute_id}/evidence` | ListDisputeEvidence | — |
| `CreateDisputeEvidenceFile` | POST `/v2/disputes/{dispute_id}/evidence-files` | CreateDisputeEvidenceFile | — |
| `CreateDisputeEvidenceText` | POST `/v2/disputes/{dispute_id}/evidence-text` | CreateDisputeEvidenceText | — |
| `RetrieveDisputeEvidence` | GET `/v2/disputes/{dispute_id}/evidence/{evidence_id}` | RetrieveDisputeEvidence | — |
| `DeleteDisputeEvidence` | DELETE `/v2/disputes/{dispute_id}/evidence/{evidence_id}` | DeleteDisputeEvidence | — |
| `SubmitEvidence` | POST `/v2/disputes/{dispute_id}/submit-evidence` | SubmitEvidence | — |
| `ListEmployees` | GET `/v2/employees` | ListEmployees | — |
| `RetrieveEmployee` | GET `/v2/employees/{id}` | RetrieveEmployee | — |
| `SearchEvents` | POST `/v2/events` | SearchEvents | — |
| `DisableEvents` | PUT `/v2/events/disable` | DisableEvents | — |
| `EnableEvents` | PUT `/v2/events/enable` | EnableEvents | — |
| `ListEventTypes` | GET `/v2/events/types` | ListEventTypes | — |
| `ListGiftCards` | GET `/v2/gift-cards` | ListGiftCards | — |
| `CreateGiftCard` | POST `/v2/gift-cards` | CreateGiftCard | — |
| `ListGiftCardActivities` | GET `/v2/gift-cards/activities` | ListGiftCardActivities | — |
| `CreateGiftCardActivity` | POST `/v2/gift-cards/activities` | CreateGiftCardActivity | — |
| `RetrieveGiftCardFromGAN` | POST `/v2/gift-cards/from-gan` | RetrieveGiftCardFromGAN | — |
| `RetrieveGiftCardFromNonce` | POST `/v2/gift-cards/from-nonce` | RetrieveGiftCardFromNonce | — |
| `LinkCustomerToGiftCard` | POST `/v2/gift-cards/{gift_card_id}/link-customer` | LinkCustomerToGiftCard | — |
| `UnlinkCustomerFromGiftCard` | POST `/v2/gift-cards/{gift_card_id}/unlink-customer` | UnlinkCustomerFromGiftCard | — |
| `RetrieveGiftCard` | GET `/v2/gift-cards/{id}` | RetrieveGiftCard | — |
| `ListInventoryAdjustmentReasons` | GET `/v2/inventory/adjustment-reasons` | ListInventoryAdjustmentReasons | — |
| `CreateInventoryAdjustmentReason` | POST `/v2/inventory/adjustment-reasons/create` | CreateInventoryAdjustmentReason | — |
| `DeleteInventoryAdjustmentReason` | POST `/v2/inventory/adjustment-reasons/delete` | DeleteInventoryAdjustmentReason | — |
| `RestoreInventoryAdjustmentReason` | POST `/v2/inventory/adjustment-reasons/restore` | RestoreInventoryAdjustmentReason | — |
| `RetrieveInventoryAdjustmentReason` | POST `/v2/inventory/adjustment-reasons/retrieve` | RetrieveInventoryAdjustmentReason | — |
| `UpdateInventoryAdjustmentReason` | PUT `/v2/inventory/adjustment-reasons/update` | UpdateInventoryAdjustmentReason | — |
| `DeprecatedRetrieveInventoryAdjustment` | GET `/v2/inventory/adjustment/{adjustment_id}` | DeprecatedRetrieveInventoryAdjustment | — |
| `UpdateInventoryAdjustment` | PUT `/v2/inventory/adjustments/update` | UpdateInventoryAdjustment | — |
| `RetrieveInventoryAdjustment` | GET `/v2/inventory/adjustments/{adjustment_id}` | RetrieveInventoryAdjustment | — |
| `DeprecatedBatchChangeInventory` | POST `/v2/inventory/batch-change` | DeprecatedBatchChangeInventory | — |
| `DeprecatedBatchRetrieveInventoryChanges` | POST `/v2/inventory/batch-retrieve-changes` | DeprecatedBatchRetrieveInventoryChanges | — |
| `DeprecatedBatchRetrieveInventoryCounts` | POST `/v2/inventory/batch-retrieve-counts` | DeprecatedBatchRetrieveInventoryCounts | — |
| `BatchChangeInventory` | POST `/v2/inventory/changes/batch-create` | BatchChangeInventory | — |
| `BatchRetrieveInventoryChanges` | POST `/v2/inventory/changes/batch-retrieve` | BatchRetrieveInventoryChanges | — |
| `BatchRetrieveInventoryCounts` | POST `/v2/inventory/counts/batch-retrieve` | BatchRetrieveInventoryCounts | — |
| `DeprecatedRetrieveInventoryPhysicalCount` | GET `/v2/inventory/physical-count/{physical_count_id}` | DeprecatedRetrieveInventoryPhysicalCount | — |
| `RetrieveInventoryPhysicalCount` | GET `/v2/inventory/physical-counts/{physical_count_id}` | RetrieveInventoryPhysicalCount | — |
| `RetrieveInventoryCount` | GET `/v2/inventory/{catalog_object_id}` | RetrieveInventoryCount | — |
| `RetrieveInventoryChanges` | GET `/v2/inventory/{catalog_object_id}/changes` | RetrieveInventoryChanges | — |
| `ListInvoices` | GET `/v2/invoices` | ListInvoices | — |
| `CreateInvoice` | POST `/v2/invoices` | CreateInvoice | — |
| `SearchInvoices` | POST `/v2/invoices/search` | SearchInvoices | — |
| `GetInvoice` | GET `/v2/invoices/{invoice_id}` | GetInvoice | — |
| `UpdateInvoice` | PUT `/v2/invoices/{invoice_id}` | UpdateInvoice | — |
| `DeleteInvoice` | DELETE `/v2/invoices/{invoice_id}` | DeleteInvoice | — |
| `CreateInvoiceAttachment` | POST `/v2/invoices/{invoice_id}/attachments` | CreateInvoiceAttachment | — |
| `DeleteInvoiceAttachment` | DELETE `/v2/invoices/{invoice_id}/attachments/{attachment_id}` | DeleteInvoiceAttachment | — |
| `CancelInvoice` | POST `/v2/invoices/{invoice_id}/cancel` | CancelInvoice | — |
| `PublishInvoice` | POST `/v2/invoices/{invoice_id}/publish` | PublishInvoice | — |
| `ListBreakTypes` | GET `/v2/labor/break-types` | ListBreakTypes | — |
| `CreateBreakType` | POST `/v2/labor/break-types` | CreateBreakType | — |
| `GetBreakType` | GET `/v2/labor/break-types/{id}` | GetBreakType | — |
| `UpdateBreakType` | PUT `/v2/labor/break-types/{id}` | UpdateBreakType | — |
| `DeleteBreakType` | DELETE `/v2/labor/break-types/{id}` | DeleteBreakType | — |
| `ListEmployeeWages` | GET `/v2/labor/employee-wages` | ListEmployeeWages | — |
| `GetEmployeeWage` | GET `/v2/labor/employee-wages/{id}` | GetEmployeeWage | — |
| `CreateScheduledShift` | POST `/v2/labor/scheduled-shifts` | CreateScheduledShift | — |
| `BulkPublishScheduledShifts` | POST `/v2/labor/scheduled-shifts/bulk-publish` | BulkPublishScheduledShifts | — |
| `SearchScheduledShifts` | POST `/v2/labor/scheduled-shifts/search` | SearchScheduledShifts | — |
| `RetrieveScheduledShift` | GET `/v2/labor/scheduled-shifts/{id}` | RetrieveScheduledShift | — |
| `UpdateScheduledShift` | PUT `/v2/labor/scheduled-shifts/{id}` | UpdateScheduledShift | — |
| `PublishScheduledShift` | POST `/v2/labor/scheduled-shifts/{id}/publish` | PublishScheduledShift | — |
| `CreateShift` | POST `/v2/labor/shifts` | CreateShift | — |
| `SearchShifts` | POST `/v2/labor/shifts/search` | SearchShifts | — |
| `GetShift` | GET `/v2/labor/shifts/{id}` | GetShift | — |
| `UpdateShift` | PUT `/v2/labor/shifts/{id}` | UpdateShift | — |
| `DeleteShift` | DELETE `/v2/labor/shifts/{id}` | DeleteShift | — |
| `ListTeamMemberWages` | GET `/v2/labor/team-member-wages` | ListTeamMemberWages | — |
| `GetTeamMemberWage` | GET `/v2/labor/team-member-wages/{id}` | GetTeamMemberWage | — |
| `CreateTimecard` | POST `/v2/labor/timecards` | CreateTimecard | — |
| `SearchTimecards` | POST `/v2/labor/timecards/search` | SearchTimecards | — |
| `RetrieveTimecard` | GET `/v2/labor/timecards/{id}` | RetrieveTimecard | — |
| `UpdateTimecard` | PUT `/v2/labor/timecards/{id}` | UpdateTimecard | — |
| `DeleteTimecard` | DELETE `/v2/labor/timecards/{id}` | DeleteTimecard | — |
| `ListWorkweekConfigs` | GET `/v2/labor/workweek-configs` | ListWorkweekConfigs | — |
| `UpdateWorkweekConfig` | PUT `/v2/labor/workweek-configs/{id}` | UpdateWorkweekConfig | — |
| `ListLocations` | GET `/v2/locations` | ListLocations | — |
| `CreateLocation` | POST `/v2/locations` | CreateLocation | — |
| `ListLocationCustomAttributeDefinitions` | GET `/v2/locations/custom-attribute-definitions` | ListLocationCustomAttributeDefinitions | — |
| `CreateLocationCustomAttributeDefinition` | POST `/v2/locations/custom-attribute-definitions` | CreateLocationCustomAttributeDefinition | — |
| `RetrieveLocationCustomAttributeDefinition` | GET `/v2/locations/custom-attribute-definitions/{key}` | RetrieveLocationCustomAttributeDefinition | — |
| `UpdateLocationCustomAttributeDefinition` | PUT `/v2/locations/custom-attribute-definitions/{key}` | UpdateLocationCustomAttributeDefinition | — |
| `DeleteLocationCustomAttributeDefinition` | DELETE `/v2/locations/custom-attribute-definitions/{key}` | DeleteLocationCustomAttributeDefinition | — |
| `BulkDeleteLocationCustomAttributes` | POST `/v2/locations/custom-attributes/bulk-delete` | BulkDeleteLocationCustomAttributes | — |
| `BulkUpsertLocationCustomAttributes` | POST `/v2/locations/custom-attributes/bulk-upsert` | BulkUpsertLocationCustomAttributes | — |
| `RetrieveLocation` | GET `/v2/locations/{location_id}` | RetrieveLocation | — |
| `UpdateLocation` | PUT `/v2/locations/{location_id}` | UpdateLocation | — |
| `CreateCheckout` | POST `/v2/locations/{location_id}/checkouts` | CreateCheckout | — |
| `ListLocationCustomAttributes` | GET `/v2/locations/{location_id}/custom-attributes` | ListLocationCustomAttributes | — |
| `RetrieveLocationCustomAttribute` | GET `/v2/locations/{location_id}/custom-attributes/{key}` | RetrieveLocationCustomAttribute | — |
| `UpsertLocationCustomAttribute` | POST `/v2/locations/{location_id}/custom-attributes/{key}` | UpsertLocationCustomAttribute | — |
| `DeleteLocationCustomAttribute` | DELETE `/v2/locations/{location_id}/custom-attributes/{key}` | DeleteLocationCustomAttribute | — |
| `ListTransactions` | GET `/v2/locations/{location_id}/transactions` | ListTransactions | — |
| `RetrieveTransaction` | GET `/v2/locations/{location_id}/transactions/{transaction_id}` | RetrieveTransaction | — |
| `CaptureTransaction` | POST `/v2/locations/{location_id}/transactions/{transaction_id}/capture` | CaptureTransaction | — |
| `VoidTransaction` | POST `/v2/locations/{location_id}/transactions/{transaction_id}/void` | VoidTransaction | — |
| `CreateLoyaltyAccount` | POST `/v2/loyalty/accounts` | CreateLoyaltyAccount | — |
| `SearchLoyaltyAccounts` | POST `/v2/loyalty/accounts/search` | SearchLoyaltyAccounts | — |
| `RetrieveLoyaltyAccount` | GET `/v2/loyalty/accounts/{account_id}` | RetrieveLoyaltyAccount | — |
| `AccumulateLoyaltyPoints` | POST `/v2/loyalty/accounts/{account_id}/accumulate` | AccumulateLoyaltyPoints | — |
| `AdjustLoyaltyPoints` | POST `/v2/loyalty/accounts/{account_id}/adjust` | AdjustLoyaltyPoints | — |
| `SearchLoyaltyEvents` | POST `/v2/loyalty/events/search` | SearchLoyaltyEvents | — |
| `ListLoyaltyPrograms` | GET `/v2/loyalty/programs` | ListLoyaltyPrograms | — |
| `RetrieveLoyaltyProgram` | GET `/v2/loyalty/programs/{program_id}` | RetrieveLoyaltyProgram | — |
| `CalculateLoyaltyPoints` | POST `/v2/loyalty/programs/{program_id}/calculate` | CalculateLoyaltyPoints | — |
| `ListLoyaltyPromotions` | GET `/v2/loyalty/programs/{program_id}/promotions` | ListLoyaltyPromotions | — |
| `CreateLoyaltyPromotion` | POST `/v2/loyalty/programs/{program_id}/promotions` | CreateLoyaltyPromotion | — |
| `RetrieveLoyaltyPromotion` | GET `/v2/loyalty/programs/{program_id}/promotions/{promotion_id}` | RetrieveLoyaltyPromotion | — |
| `CancelLoyaltyPromotion` | POST `/v2/loyalty/programs/{program_id}/promotions/{promotion_id}/cancel` | CancelLoyaltyPromotion | — |
| `CreateLoyaltyReward` | POST `/v2/loyalty/rewards` | CreateLoyaltyReward | — |
| `SearchLoyaltyRewards` | POST `/v2/loyalty/rewards/search` | SearchLoyaltyRewards | — |
| `RetrieveLoyaltyReward` | GET `/v2/loyalty/rewards/{reward_id}` | RetrieveLoyaltyReward | — |
| `DeleteLoyaltyReward` | DELETE `/v2/loyalty/rewards/{reward_id}` | DeleteLoyaltyReward | — |
| `RedeemLoyaltyReward` | POST `/v2/loyalty/rewards/{reward_id}/redeem` | RedeemLoyaltyReward | — |
| `ListMerchants` | GET `/v2/merchants` | ListMerchants | — |
| `ListMerchantCustomAttributeDefinitions` | GET `/v2/merchants/custom-attribute-definitions` | ListMerchantCustomAttributeDefinitions | — |
| `CreateMerchantCustomAttributeDefinition` | POST `/v2/merchants/custom-attribute-definitions` | CreateMerchantCustomAttributeDefinition | — |
| `RetrieveMerchantCustomAttributeDefinition` | GET `/v2/merchants/custom-attribute-definitions/{key}` | RetrieveMerchantCustomAttributeDefinition | — |
| `UpdateMerchantCustomAttributeDefinition` | PUT `/v2/merchants/custom-attribute-definitions/{key}` | UpdateMerchantCustomAttributeDefinition | — |
| `DeleteMerchantCustomAttributeDefinition` | DELETE `/v2/merchants/custom-attribute-definitions/{key}` | DeleteMerchantCustomAttributeDefinition | — |
| `BulkDeleteMerchantCustomAttributes` | POST `/v2/merchants/custom-attributes/bulk-delete` | BulkDeleteMerchantCustomAttributes | — |
| `BulkUpsertMerchantCustomAttributes` | POST `/v2/merchants/custom-attributes/bulk-upsert` | BulkUpsertMerchantCustomAttributes | — |
| `RetrieveMerchant` | GET `/v2/merchants/{merchant_id}` | RetrieveMerchant | — |
| `ListMerchantCustomAttributes` | GET `/v2/merchants/{merchant_id}/custom-attributes` | ListMerchantCustomAttributes | — |
| `RetrieveMerchantCustomAttribute` | GET `/v2/merchants/{merchant_id}/custom-attributes/{key}` | RetrieveMerchantCustomAttribute | — |
| `UpsertMerchantCustomAttribute` | POST `/v2/merchants/{merchant_id}/custom-attributes/{key}` | UpsertMerchantCustomAttribute | — |
| `DeleteMerchantCustomAttribute` | DELETE `/v2/merchants/{merchant_id}/custom-attributes/{key}` | DeleteMerchantCustomAttribute | — |
| `RetrieveLocationSettings` | GET `/v2/online-checkout/location-settings/{location_id}` | RetrieveLocationSettings | — |
| `UpdateLocationSettings` | PUT `/v2/online-checkout/location-settings/{location_id}` | UpdateLocationSettings | — |
| `RetrieveMerchantSettings` | GET `/v2/online-checkout/merchant-settings` | RetrieveMerchantSettings | — |
| `UpdateMerchantSettings` | PUT `/v2/online-checkout/merchant-settings` | UpdateMerchantSettings | — |
| `ListPaymentLinks` | GET `/v2/online-checkout/payment-links` | ListPaymentLinks | — |
| `CreatePaymentLink` | POST `/v2/online-checkout/payment-links` | CreatePaymentLink | — |
| `RetrievePaymentLink` | GET `/v2/online-checkout/payment-links/{id}` | RetrievePaymentLink | — |
| `UpdatePaymentLink` | PUT `/v2/online-checkout/payment-links/{id}` | UpdatePaymentLink | — |
| `DeletePaymentLink` | DELETE `/v2/online-checkout/payment-links/{id}` | DeletePaymentLink | — |
| `CreateOrder` | POST `/v2/orders` | CreateOrder | — |
| `BatchRetrieveOrders` | POST `/v2/orders/batch-retrieve` | BatchRetrieveOrders | — |
| `CalculateOrder` | POST `/v2/orders/calculate` | CalculateOrder | — |
| `CloneOrder` | POST `/v2/orders/clone` | CloneOrder | — |
| `ListOrderCustomAttributeDefinitions` | GET `/v2/orders/custom-attribute-definitions` | ListOrderCustomAttributeDefinitions | — |
| `CreateOrderCustomAttributeDefinition` | POST `/v2/orders/custom-attribute-definitions` | CreateOrderCustomAttributeDefinition | — |
| `RetrieveOrderCustomAttributeDefinition` | GET `/v2/orders/custom-attribute-definitions/{key}` | RetrieveOrderCustomAttributeDefinition | — |
| `UpdateOrderCustomAttributeDefinition` | PUT `/v2/orders/custom-attribute-definitions/{key}` | UpdateOrderCustomAttributeDefinition | — |
| `DeleteOrderCustomAttributeDefinition` | DELETE `/v2/orders/custom-attribute-definitions/{key}` | DeleteOrderCustomAttributeDefinition | — |
| `BulkDeleteOrderCustomAttributes` | POST `/v2/orders/custom-attributes/bulk-delete` | BulkDeleteOrderCustomAttributes | — |
| `BulkUpsertOrderCustomAttributes` | POST `/v2/orders/custom-attributes/bulk-upsert` | BulkUpsertOrderCustomAttributes | — |
| `SearchOrders` | POST `/v2/orders/search` | SearchOrders | — |
| `RetrieveOrder` | GET `/v2/orders/{order_id}` | RetrieveOrder | — |
| `UpdateOrder` | PUT `/v2/orders/{order_id}` | UpdateOrder | — |
| `ListOrderCustomAttributes` | GET `/v2/orders/{order_id}/custom-attributes` | ListOrderCustomAttributes | — |
| `RetrieveOrderCustomAttribute` | GET `/v2/orders/{order_id}/custom-attributes/{custom_attribute_key}` | RetrieveOrderCustomAttribute | — |
| `UpsertOrderCustomAttribute` | POST `/v2/orders/{order_id}/custom-attributes/{custom_attribute_key}` | UpsertOrderCustomAttribute | — |
| `DeleteOrderCustomAttribute` | DELETE `/v2/orders/{order_id}/custom-attributes/{custom_attribute_key}` | DeleteOrderCustomAttribute | — |
| `PayOrder` | POST `/v2/orders/{order_id}/pay` | PayOrder | — |
| `ListPayments` | GET `/v2/payments` | ListPayments | — |
| `CreatePayment` | POST `/v2/payments` | CreatePayment | — |
| `CancelPaymentByIdempotencyKey` | POST `/v2/payments/cancel` | CancelPaymentByIdempotencyKey | — |
| `GetPayment` | GET `/v2/payments/{payment_id}` | GetPayment | — |
| `UpdatePayment` | PUT `/v2/payments/{payment_id}` | UpdatePayment | — |
| `CancelPayment` | POST `/v2/payments/{payment_id}/cancel` | CancelPayment | — |
| `CompletePayment` | POST `/v2/payments/{payment_id}/complete` | CompletePayment | — |
| `ListPayouts` | GET `/v2/payouts` | ListPayouts | — |
| `GetPayout` | GET `/v2/payouts/{payout_id}` | GetPayout | — |
| `ListPayoutEntries` | GET `/v2/payouts/{payout_id}/payout-entries` | ListPayoutEntries | — |
| `ListPaymentRefunds` | GET `/v2/refunds` | ListPaymentRefunds | — |
| `RefundPayment` | POST `/v2/refunds` | RefundPayment | — |
| `GetPaymentRefund` | GET `/v2/refunds/{refund_id}` | GetPaymentRefund | — |
| `ListSites` | GET `/v2/sites` | ListSites | — |
| `RetrieveSnippet` | GET `/v2/sites/{site_id}/snippet` | RetrieveSnippet | — |
| `UpsertSnippet` | POST `/v2/sites/{site_id}/snippet` | UpsertSnippet | — |
| `DeleteSnippet` | DELETE `/v2/sites/{site_id}/snippet` | DeleteSnippet | — |
| `CreateSubscription` | POST `/v2/subscriptions` | CreateSubscription | — |
| `BulkSwapPlan` | POST `/v2/subscriptions/bulk-swap-plan` | BulkSwapPlan | — |
| `SearchSubscriptions` | POST `/v2/subscriptions/search` | SearchSubscriptions | — |
| `RetrieveSubscription` | GET `/v2/subscriptions/{subscription_id}` | RetrieveSubscription | — |
| `UpdateSubscription` | PUT `/v2/subscriptions/{subscription_id}` | UpdateSubscription | — |
| `DeleteSubscriptionAction` | DELETE `/v2/subscriptions/{subscription_id}/actions/{action_id}` | DeleteSubscriptionAction | — |
| `ChangeBillingAnchorDate` | POST `/v2/subscriptions/{subscription_id}/billing-anchor` | ChangeBillingAnchorDate | — |
| `CancelSubscription` | POST `/v2/subscriptions/{subscription_id}/cancel` | CancelSubscription | — |
| `ListSubscriptionEvents` | GET `/v2/subscriptions/{subscription_id}/events` | ListSubscriptionEvents | — |
| `PauseSubscription` | POST `/v2/subscriptions/{subscription_id}/pause` | PauseSubscription | — |
| `ResumeSubscription` | POST `/v2/subscriptions/{subscription_id}/resume` | ResumeSubscription | — |
| `SwapPlan` | POST `/v2/subscriptions/{subscription_id}/swap-plan` | SwapPlan | — |
| `CreateTeamMember` | POST `/v2/team-members` | CreateTeamMember | — |
| `BulkCreateTeamMembers` | POST `/v2/team-members/bulk-create` | BulkCreateTeamMembers | — |
| `BulkUpdateTeamMembers` | POST `/v2/team-members/bulk-update` | BulkUpdateTeamMembers | — |
| `ListJobs` | GET `/v2/team-members/jobs` | ListJobs | — |
| `CreateJob` | POST `/v2/team-members/jobs` | CreateJob | — |
| `RetrieveJob` | GET `/v2/team-members/jobs/{job_id}` | RetrieveJob | — |
| `UpdateJob` | PUT `/v2/team-members/jobs/{job_id}` | UpdateJob | — |
| `SearchTeamMembers` | POST `/v2/team-members/search` | SearchTeamMembers | — |
| `RetrieveTeamMember` | GET `/v2/team-members/{team_member_id}` | RetrieveTeamMember | — |
| `UpdateTeamMember` | PUT `/v2/team-members/{team_member_id}` | UpdateTeamMember | — |
| `RetrieveWageSetting` | GET `/v2/team-members/{team_member_id}/wage-setting` | RetrieveWageSetting | — |
| `UpdateWageSetting` | PUT `/v2/team-members/{team_member_id}/wage-setting` | UpdateWageSetting | — |
| `CreateTerminalAction` | POST `/v2/terminals/actions` | CreateTerminalAction | — |
| `SearchTerminalActions` | POST `/v2/terminals/actions/search` | SearchTerminalActions | — |
| `GetTerminalAction` | GET `/v2/terminals/actions/{action_id}` | GetTerminalAction | — |
| `CancelTerminalAction` | POST `/v2/terminals/actions/{action_id}/cancel` | CancelTerminalAction | — |
| `DismissTerminalAction` | POST `/v2/terminals/actions/{action_id}/dismiss` | DismissTerminalAction | — |
| `CreateTerminalCheckout` | POST `/v2/terminals/checkouts` | CreateTerminalCheckout | — |
| `SearchTerminalCheckouts` | POST `/v2/terminals/checkouts/search` | SearchTerminalCheckouts | — |
| `GetTerminalCheckout` | GET `/v2/terminals/checkouts/{checkout_id}` | GetTerminalCheckout | — |
| `CancelTerminalCheckout` | POST `/v2/terminals/checkouts/{checkout_id}/cancel` | CancelTerminalCheckout | — |
| `DismissTerminalCheckout` | POST `/v2/terminals/checkouts/{checkout_id}/dismiss` | DismissTerminalCheckout | — |
| `CreateTerminalRefund` | POST `/v2/terminals/refunds` | CreateTerminalRefund | — |
| `SearchTerminalRefunds` | POST `/v2/terminals/refunds/search` | SearchTerminalRefunds | — |
| `GetTerminalRefund` | GET `/v2/terminals/refunds/{terminal_refund_id}` | GetTerminalRefund | — |
| `CancelTerminalRefund` | POST `/v2/terminals/refunds/{terminal_refund_id}/cancel` | CancelTerminalRefund | — |
| `DismissTerminalRefund` | POST `/v2/terminals/refunds/{terminal_refund_id}/dismiss` | DismissTerminalRefund | — |
| `CreateTransferOrder` | POST `/v2/transfer-orders` | CreateTransferOrder | — |
| `SearchTransferOrders` | POST `/v2/transfer-orders/search` | SearchTransferOrders | — |
| `RetrieveTransferOrder` | GET `/v2/transfer-orders/{transfer_order_id}` | RetrieveTransferOrder | — |
| `UpdateTransferOrder` | PUT `/v2/transfer-orders/{transfer_order_id}` | UpdateTransferOrder | — |
| `DeleteTransferOrder` | DELETE `/v2/transfer-orders/{transfer_order_id}` | DeleteTransferOrder | — |
| `CancelTransferOrder` | POST `/v2/transfer-orders/{transfer_order_id}/cancel` | CancelTransferOrder | — |
| `ReceiveTransferOrder` | POST `/v2/transfer-orders/{transfer_order_id}/receive` | ReceiveTransferOrder | — |
| `StartTransferOrder` | POST `/v2/transfer-orders/{transfer_order_id}/start` | StartTransferOrder | — |
| `BulkCreateVendors` | POST `/v2/vendors/bulk-create` | BulkCreateVendors | — |
| `BulkRetrieveVendors` | POST `/v2/vendors/bulk-retrieve` | BulkRetrieveVendors | — |
| `BulkUpdateVendors` | PUT `/v2/vendors/bulk-update` | BulkUpdateVendors | — |
| `CreateVendor` | POST `/v2/vendors/create` | CreateVendor | — |
| `SearchVendors` | POST `/v2/vendors/search` | SearchVendors | — |
| `RetrieveVendor` | GET `/v2/vendors/{vendor_id}` | RetrieveVendor | — |
| `UpdateVendor` | PUT `/v2/vendors/{vendor_id}` | UpdateVendor | — |
| `ListWebhookEventTypes` | GET `/v2/webhooks/event-types` | ListWebhookEventTypes | — |
| `ListWebhookSubscriptions` | GET `/v2/webhooks/subscriptions` | ListWebhookSubscriptions | — |
| `CreateWebhookSubscription` | POST `/v2/webhooks/subscriptions` | CreateWebhookSubscription | — |
| `RetrieveWebhookSubscription` | GET `/v2/webhooks/subscriptions/{subscription_id}` | RetrieveWebhookSubscription | — |
| `UpdateWebhookSubscription` | PUT `/v2/webhooks/subscriptions/{subscription_id}` | UpdateWebhookSubscription | — |
| `DeleteWebhookSubscription` | DELETE `/v2/webhooks/subscriptions/{subscription_id}` | DeleteWebhookSubscription | — |
| `UpdateWebhookSubscriptionSignatureKey` | POST `/v2/webhooks/subscriptions/{subscription_id}/signature-key` | UpdateWebhookSubscriptionSignatureKey | — |
| `TestWebhookSubscription` | POST `/v2/webhooks/subscriptions/{subscription_id}/test` | TestWebhookSubscription | — |

## Обоснование выбора операций

- `create` (создание): POST `/v2/payments` — оценка 86; следующий кандидат POST `/v2/catalog/images` — оценка 48; разница 38.
- `status` (проверка статуса): GET `/v2/payments/{payment_id}` — оценка 85; следующий кандидат GET `/v2/payouts/{payout_id}` — оценка 50; разница 35.

## Маппинг статусов

| Статус провайдера | Статус Space Payments |
|---|---|
| `APPROVED` | `approved` |
| `PENDING` | `in_progress` |
| `COMPLETED` | `approved` |
| `CANCELED` | `rejected` |
| `FAILED` | `rejected` |

`fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

## Маппинг полей операции

Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

| Поле API провайдера | Источник в Space Payments |
|---|---|
| `source_id` | **TODO:** подтвердить схему платформы |
| `idempotency_key` | **TODO:** подтвердить схему платформы |
| `amount_money.amount` | **TODO:** подтвердить схему платформы |
| `amount_money.currency` | **TODO:** подтвердить схему платформы |
| `tip_money.amount` | **TODO:** подтвердить схему платформы |
| `tip_money.currency` | **TODO:** подтвердить схему платформы |
| `app_fee_money.amount` | **TODO:** подтвердить схему платформы |
| `app_fee_money.currency` | **TODO:** подтвердить схему платформы |
| `app_fee_allocations` | **TODO:** подтвердить схему платформы |
| `delay_duration` | **TODO:** подтвердить схему платформы |
| `delay_action` | **TODO:** подтвердить схему платформы |
| `autocomplete` | **TODO:** подтвердить схему платформы |
| `order_id` | **TODO:** подтвердить схему платформы |
| `customer_id` | **TODO:** подтвердить схему платформы |
| `location_id` | **TODO:** подтвердить схему платформы |
| `team_member_id` | **TODO:** подтвердить схему платформы |
| `reference_id` | **TODO:** подтвердить схему платформы |
| `verification_token` | **TODO:** подтвердить схему платформы |
| `accept_partial_authorization` | **TODO:** подтвердить схему платформы |
| `buyer_email_address` | **TODO:** подтвердить схему платформы |
| `buyer_phone_number` | **TODO:** подтвердить схему платформы |
| `billing_address.address_line_1` | **TODO:** подтвердить схему платформы |
| `billing_address.address_line_2` | **TODO:** подтвердить схему платформы |
| `billing_address.address_line_3` | **TODO:** подтвердить схему платформы |
| `billing_address.locality` | **TODO:** подтвердить схему платформы |
| `billing_address.sublocality` | **TODO:** подтвердить схему платформы |
| `billing_address.sublocality_2` | **TODO:** подтвердить схему платформы |
| `billing_address.sublocality_3` | **TODO:** подтвердить схему платформы |
| `billing_address.administrative_district_level_1` | **TODO:** подтвердить схему платформы |
| `billing_address.administrative_district_level_2` | **TODO:** подтвердить схему платформы |
| `billing_address.administrative_district_level_3` | **TODO:** подтвердить схему платформы |
| `billing_address.postal_code` | **TODO:** подтвердить схему платформы |
| `billing_address.country` | **TODO:** подтвердить схему платформы |
| `billing_address.first_name` | **TODO:** подтвердить схему платформы |
| `billing_address.last_name` | **TODO:** подтвердить схему платформы |
| `shipping_address.address_line_1` | **TODO:** подтвердить схему платформы |
| `shipping_address.address_line_2` | **TODO:** подтвердить схему платформы |
| `shipping_address.address_line_3` | **TODO:** подтвердить схему платформы |
| `shipping_address.locality` | **TODO:** подтвердить схему платформы |
| `shipping_address.sublocality` | **TODO:** подтвердить схему платформы |
| `shipping_address.sublocality_2` | **TODO:** подтвердить схему платформы |
| `shipping_address.sublocality_3` | **TODO:** подтвердить схему платформы |
| `shipping_address.administrative_district_level_1` | **TODO:** подтвердить схему платформы |
| `shipping_address.administrative_district_level_2` | **TODO:** подтвердить схему платформы |
| `shipping_address.administrative_district_level_3` | **TODO:** подтвердить схему платформы |
| `shipping_address.postal_code` | **TODO:** подтвердить схему платформы |
| `shipping_address.country` | **TODO:** подтвердить схему платформы |
| `shipping_address.first_name` | **TODO:** подтвердить схему платформы |
| `shipping_address.last_name` | **TODO:** подтвердить схему платформы |
| `note` | **TODO:** подтвердить схему платформы |
| `statement_description_identifier` | **TODO:** подтвердить схему платформы |
| `cash_details.buyer_supplied_money.amount` | **TODO:** подтвердить схему платформы |
| `cash_details.buyer_supplied_money.currency` | **TODO:** подтвердить схему платформы |
| `cash_details.change_back_money.amount` | **TODO:** подтвердить схему платформы |
| `cash_details.change_back_money.currency` | **TODO:** подтвердить схему платформы |
| `external_details.type` | **TODO:** подтвердить схему платформы |
| `external_details.source` | **TODO:** подтвердить схему платформы |
| `external_details.source_id` | **TODO:** подтвердить схему платформы |
| `external_details.source_fee_money.amount` | **TODO:** подтвердить схему платформы |
| `external_details.source_fee_money.currency` | **TODO:** подтвердить схему платформы |
| `customer_details.customer_initiated` | **TODO:** подтвердить схему платформы |
| `customer_details.seller_keyed_in` | **TODO:** подтвердить схему платформы |
| `offline_payment_details.client_created_at` | **TODO:** подтвердить схему платформы |

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
- Для POST /v2/payments не поддерживается объявленная схема авторизации; требуется явная реализация.
- Для GET /v2/payments/{payment_id} не поддерживается объявленная схема авторизации; требуется явная реализация.
- Обнаружены внешние $ref. Они сохранены без сетевой загрузки; перед генерацией объедините схемы или подтвердите локальные копии.
- TODO required_if cash_details: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO required_if external_details: условная обязательность указана только в description; подтвердите правило в overrides.
- TODO field_map source_id: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
- TODO field_map idempotency_key: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides.
