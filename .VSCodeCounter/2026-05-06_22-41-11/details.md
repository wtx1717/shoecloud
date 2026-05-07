# Details

Date : 2026-05-06 22:41:11

Directory d:\\shoecloud\\lib

Total : 58 files,  4580 codes, 59 comments, 486 blanks, all 5125 lines

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [lib/README.md](/lib/README.md) | Markdown | 259 | 0 | 51 | 310 |
| [lib/app/app\_bootstrap.dart](/lib/app/app_bootstrap.dart) | Dart | 28 | 1 | 4 | 33 |
| [lib/app/router/app\_pages.dart](/lib/app/router/app_pages.dart) | Dart | 37 | 1 | 2 | 40 |
| [lib/app/router/app\_routes.dart](/lib/app/router/app_routes.dart) | Dart | 13 | 1 | 1 | 15 |
| [lib/app/shoecloud\_app.dart](/lib/app/shoecloud_app.dart) | Dart | 18 | 1 | 3 | 22 |
| [lib/app/theme/app\_theme.dart](/lib/app/theme/app_theme.dart) | Dart | 87 | 1 | 4 | 92 |
| [lib/core/constants/app\_constants.dart](/lib/core/constants/app_constants.dart) | Dart | 20 | 1 | 2 | 23 |
| [lib/core/network/api\_client.dart](/lib/core/network/api_client.dart) | Dart | 52 | 1 | 9 | 62 |
| [lib/core/nfc/deep\_link\_nfc\_manager.dart](/lib/core/nfc/deep_link_nfc_manager.dart) | Dart | 48 | 1 | 13 | 62 |
| [lib/core/nfc/nfc\_writer.dart](/lib/core/nfc/nfc_writer.dart) | Dart | 61 | 3 | 12 | 76 |
| [lib/core/storage/session\_storage.dart](/lib/core/storage/session_storage.dart) | Dart | 32 | 1 | 7 | 40 |
| [lib/features/activities/models/shoe\_activity.dart](/lib/features/activities/models/shoe_activity.dart) | Dart | 33 | 1 | 3 | 37 |
| [lib/features/auth/data/auth\_repository.dart](/lib/features/auth/data/auth_repository.dart) | Dart | 29 | 1 | 6 | 36 |
| [lib/features/auth/presentation/controllers/auth\_controller.dart](/lib/features/auth/presentation/controllers/auth_controller.dart) | Dart | 30 | 1 | 6 | 37 |
| [lib/features/auth/presentation/pages/login\_page.dart](/lib/features/auth/presentation/pages/login_page.dart) | Dart | 160 | 1 | 11 | 172 |
| [lib/features/common/presentation/pages/coming\_soon\_page.dart](/lib/features/common/presentation/pages/coming_soon_page.dart) | Dart | 20 | 1 | 4 | 25 |
| [lib/features/home/presentation/controllers/home\_controller.dart](/lib/features/home/presentation/controllers/home_controller.dart) | Dart | 31 | 1 | 7 | 39 |
| [lib/features/home/presentation/pages/home\_page.dart](/lib/features/home/presentation/pages/home_page.dart) | Dart | 64 | 1 | 7 | 72 |
| [lib/features/home/presentation/widgets/add\_shoe\_entry\_button.dart](/lib/features/home/presentation/widgets/add_shoe_entry_button.dart) | Dart | 52 | 1 | 5 | 58 |
| [lib/features/home/presentation/widgets/home\_header.dart](/lib/features/home/presentation/widgets/home_header.dart) | Dart | 40 | 1 | 3 | 44 |
| [lib/features/home/presentation/widgets/shoe\_overview\_card.dart](/lib/features/home/presentation/widgets/shoe_overview_card.dart) | Dart | 108 | 1 | 7 | 116 |
| [lib/features/main/presentation/pages/main\_page.dart](/lib/features/main/presentation/pages/main_page.dart) | Dart | 102 | 1 | 12 | 115 |
| [lib/features/privacy/presentation/pages/privacy\_page.dart](/lib/features/privacy/presentation/pages/privacy_page.dart) | Dart | 48 | 1 | 5 | 54 |
| [lib/features/privacy/presentation/widgets/policy\_content.dart](/lib/features/privacy/presentation/widgets/policy_content.dart) | Dart | 94 | 1 | 9 | 104 |
| [lib/features/profile/domain/profile\_service.dart](/lib/features/profile/domain/profile_service.dart) | Dart | 66 | 1 | 9 | 76 |
| [lib/features/profile/presentation/pages/profile\_edit\_page.dart](/lib/features/profile/presentation/pages/profile_edit_page.dart) | Dart | 321 | 1 | 19 | 341 |
| [lib/features/profile/presentation/pages/profile\_page.dart](/lib/features/profile/presentation/pages/profile_page.dart) | Dart | 130 | 1 | 6 | 137 |
| [lib/features/profile/presentation/widgets/feature\_tile.dart](/lib/features/profile/presentation/widgets/feature_tile.dart) | Dart | 64 | 1 | 4 | 69 |
| [lib/features/profile/presentation/widgets/profile\_header.dart](/lib/features/profile/presentation/widgets/profile_header.dart) | Dart | 159 | 1 | 8 | 168 |
| [lib/features/session/models/user\_login.dart](/lib/features/session/models/user_login.dart) | Dart | 33 | 1 | 5 | 39 |
| [lib/features/session/presentation/controllers/app\_session\_controller.dart](/lib/features/session/presentation/controllers/app_session_controller.dart) | Dart | 57 | 1 | 14 | 72 |
| [lib/features/shoes/data/shoe\_repository.dart](/lib/features/shoes/data/shoe_repository.dart) | Dart | 158 | 1 | 23 | 182 |
| [lib/features/shoes/domain/shoe\_service.dart](/lib/features/shoes/domain/shoe_service.dart) | Dart | 103 | 1 | 18 | 122 |
| [lib/features/shoes/models/shoe.dart](/lib/features/shoes/models/shoe.dart) | Dart | 114 | 1 | 7 | 122 |
| [lib/features/shoes/models/shoe\_catalog\_item.dart](/lib/features/shoes/models/shoe_catalog_item.dart) | Dart | 35 | 1 | 3 | 39 |
| [lib/features/shoes/presentation/pages/shoe\_activities\_page.dart](/lib/features/shoes/presentation/pages/shoe_activities_page.dart) | Dart | 163 | 1 | 13 | 177 |
| [lib/features/shoes/presentation/pages/shoe\_catalog\_detail\_page.dart](/lib/features/shoes/presentation/pages/shoe_catalog_detail_page.dart) | Dart | 74 | 1 | 4 | 79 |
| [lib/features/shoes/presentation/pages/shoe\_catalog\_page.dart](/lib/features/shoes/presentation/pages/shoe_catalog_page.dart) | Dart | 80 | 1 | 7 | 88 |
| [lib/features/shoes/presentation/pages/shoe\_create\_page.dart](/lib/features/shoes/presentation/pages/shoe_create_page.dart) | Dart | 108 | 1 | 11 | 120 |
| [lib/features/shoes/presentation/pages/shoe\_detail\_page.dart](/lib/features/shoes/presentation/pages/shoe_detail_page.dart) | Dart | 135 | 1 | 19 | 155 |
| [lib/features/shoes/presentation/pages/shoe\_edit\_page.dart](/lib/features/shoes/presentation/pages/shoe_edit_page.dart) | Dart | 167 | 1 | 13 | 181 |
| [lib/features/shoes/presentation/widgets/activity\_selection\_sheet.dart](/lib/features/shoes/presentation/widgets/activity_selection_sheet.dart) | Dart | 124 | 1 | 8 | 133 |
| [lib/features/shoes/presentation/widgets/nfc\_bind\_button.dart](/lib/features/shoes/presentation/widgets/nfc_bind_button.dart) | Dart | 122 | 1 | 7 | 130 |
| [lib/features/shoes/presentation/widgets/shoe\_detail\_header.dart](/lib/features/shoes/presentation/widgets/shoe_detail_header.dart) | Dart | 82 | 1 | 4 | 87 |
| [lib/features/shoes/presentation/widgets/shoe\_detail\_list.dart](/lib/features/shoes/presentation/widgets/shoe_detail_list.dart) | Dart | 129 | 1 | 10 | 140 |
| [lib/features/shoes/presentation/widgets/shoe\_stats\_card.dart](/lib/features/shoes/presentation/widgets/shoe_stats_card.dart) | Dart | 69 | 1 | 7 | 77 |
| [lib/features/shoes/presentation/widgets/sync\_action\_card.dart](/lib/features/shoes/presentation/widgets/sync_action_card.dart) | Dart | 66 | 1 | 4 | 71 |
| [lib/features/social/presentation/pages/social\_page.dart](/lib/features/social/presentation/pages/social_page.dart) | Dart | 42 | 1 | 3 | 46 |
| [lib/features/social/presentation/widgets/social\_card.dart](/lib/features/social/presentation/widgets/social_card.dart) | Dart | 66 | 1 | 4 | 71 |
| [lib/features/user/data/user\_repository.dart](/lib/features/user/data/user_repository.dart) | Dart | 24 | 1 | 5 | 30 |
| [lib/features/user/models/user\_profile.dart](/lib/features/user/models/user_profile.dart) | Dart | 208 | 1 | 28 | 237 |
| [lib/main.dart](/lib/main.dart) | Dart | 8 | 1 | 2 | 11 |
| [lib/shared/utils/time\_formatter.dart](/lib/shared/utils/time_formatter.dart) | Dart | 39 | 1 | 7 | 47 |
| [lib/shared/widgets/app\_card.dart](/lib/shared/widgets/app_card.dart) | Dart | 32 | 1 | 4 | 37 |
| [lib/shared/widgets/app\_empty\_state.dart](/lib/shared/widgets/app_empty_state.dart) | Dart | 59 | 1 | 4 | 64 |
| [lib/shared/widgets/app\_feedback.dart](/lib/shared/widgets/app_feedback.dart) | Dart | 25 | 1 | 5 | 31 |
| [lib/shared/widgets/app\_primary\_button.dart](/lib/shared/widgets/app_primary_button.dart) | Dart | 28 | 1 | 4 | 33 |
| [lib/shared/widgets/app\_shell.dart](/lib/shared/widgets/app_shell.dart) | Dart | 24 | 1 | 4 | 29 |

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)