# ShoeCloud `lib` 架构说明

本文档面向当前 `lib` 目录下的新正式架构，说明项目定位、模块拆分、已实现功能、未实现功能、当前缺点、后续改进方向，以及每个保留代码文件的职责。

## 1. 项目简介

ShoeCloud 是一个围绕“跑鞋管理 + 活动同步 + NFC 绑定”展开的 Flutter 客户端项目。当前版本聚焦于以下业务主线：

- 用户登录与本地会话持久化
- 个人鞋库浏览、详情查看、编辑与删除
- 从预置鞋库中选鞋并添加到个人鞋库
- 将待处理活动同步到指定跑鞋
- 查看已同步活动并撤销同步
- 通过 NFC 写入深链并从深链跳转到跑鞋详情
- 个人资料查看与基础字段编辑
- 社区入口与隐私政策展示

本次重构后，旧的 `pages / components / api / stores / viewmodels / utils / routes / nfc / constants` 目录已全部移除，`lib` 仅保留新的正式项目结构。

## 2. 正式架构

### 2.1 目录分层

- `main.dart`
  - 唯一应用入口，负责启动依赖装配与根组件
- `app/`
  - 应用装配层，负责依赖注册、路由、主题、应用根节点
- `core/`
  - 基础设施层，负责网络、存储、常量、NFC 与深链能力
- `features/`
  - 按业务域拆分的正式模块层
- `shared/`
  - 跨模块复用的通用组件与工具
- `assets/`
  - 项目使用的静态图片资源

### 2.2 模块边界

- `presentation`
  - 页面、组件、控制器，只负责视图、交互和轻量页面状态
- `domain`
  - 业务服务层，组合仓储能力，承接页面动作
- `data`
  - 数据访问层，统一封装接口请求与数据读取
- `models`
  - 功能域模型，负责定义结构化数据

### 2.3 运行流程

1. `main.dart` 启动应用。
2. `app/app_bootstrap.dart` 注册 `SessionStorage`、`ApiClient`、各类 `Repository`、`Service` 与 `Controller`。
3. `app/shoecloud_app.dart` 构建 `GetMaterialApp`，挂载统一主题与路由。
4. `features/main/presentation/pages/main_page.dart` 作为底部三栏主壳，完成会话恢复、首页数据加载和 NFC 深链监听初始化。
5. 各业务页面通过 `Get.find()` 获取服务与控制器，使用 `Repository` 访问远端 JSON 与接口。

## 3. 已实现功能

### 3.1 核心能力

- 登录页支持手机号与密码校验、隐私政策勾选、登录状态提交
- 会话层支持 `token` 与 `userId` 本地持久化
- 首页支持未登录空态、无鞋空态、鞋库列表加载与下拉刷新
- 鞋库支持浏览预置鞋款、查看鞋款详情、补全信息并添加到个人鞋库
- 跑鞋详情页支持查看统计、查看元数据、进入活动记录、进入编辑页
- 跑鞋编辑页支持修改昵称、尺码、价格、退役状态，以及删除跑鞋
- 活动同步支持检查待同步活动、单条同步、多条活动选择同步
- 活动列表支持查看已同步活动，并撤销同步
- NFC 支持写入 `shoecloud://bind/...` 深链，并支持读取深链后跳转到对应跑鞋
- 个人中心支持登录态展示、个人资料页跳转、基础资料与身体数据字段编辑
- 社区页保留了原有四张入口卡片
- 隐私政策页支持中英双语切换

### 3.2 本次迁移完成的内容

- 旧架构目录与重复文件已清理
- 原有主要业务流已迁移到 `features/*`
- 新主题、新卡片、新按钮、新空态、新反馈样式已统一
- 所有保留 Dart 文件均补充了简要文件头注释

## 4. 未实现功能

- 注册、找回密码、验证码登录等完整账号体系
- 活动详情地图、轨迹、分段与更深入的数据分析页面
- 图片上传、更换头像、更换跑鞋图等媒体能力
- 社区内容流、详情页、评论、点赞、发布等真实社区能力
- 个性化标签、跑鞋寿命预警、统计报表、筛选面板等增强能力
- 完整的异常页、离线策略、统一重试机制与埋点系统

## 5. 当前缺点

### 5.1 架构层面

- 虽然已经完成页面、组件、工具、模型、API 的分离，但部分页面仍承载一定流程编排逻辑，后续还可以继续向更细粒度的应用服务拆分
- `GetX` 目前同时承担依赖注入与局部状态管理，后续如业务继续扩张，需要进一步收束控制器职责
- 旧后端资源组织方式仍会泄漏到部分仓储实现中，例如特定 JSON 路径拼接，这部分遵循本次“不改后端来源逻辑”的约束暂未重做

### 5.2 工程层面

- 缺少单元测试、Widget 测试和集成测试
- 缺少环境区分、日志分级、持续集成与发布规范
- 缺少统一国际化方案，当前文案仍以内置中文为主

### 5.3 产品层面

- 登录仍依赖当前后端返回结构，不是完整生产级认证体系
- 社区页与部分个人中心入口仍是占位入口
- UI 已统一为一套正式风格，但局部页面仍有继续精修空间

## 6. 可扩展改进方向

- 为 `repository / service / controller` 增加测试覆盖
- 引入环境配置，区分开发、测试、生产域名与开关
- 为社区、活动详情、跑鞋标签、寿命预警补齐正式页面
- 将部分页面流程继续抽离到更明确的应用服务
- 建立国际化、埋点、错误监控与离线缓存策略
- 将当前静态资源、文案、主题 token 做进一步集中化管理

## 7. 新项目结构

```text
lib/
├─ main.dart
├─ app/
│  ├─ app_bootstrap.dart
│  ├─ shoecloud_app.dart
│  ├─ router/
│  │  ├─ app_pages.dart
│  │  └─ app_routes.dart
│  └─ theme/
│     └─ app_theme.dart
├─ core/
│  ├─ constants/
│  │  └─ app_constants.dart
│  ├─ network/
│  │  └─ api_client.dart
│  ├─ nfc/
│  │  ├─ deep_link_nfc_manager.dart
│  │  └─ nfc_writer.dart
│  └─ storage/
│     └─ session_storage.dart
├─ features/
│  ├─ activities/
│  ├─ auth/
│  ├─ common/
│  ├─ home/
│  ├─ main/
│  ├─ privacy/
│  ├─ profile/
│  ├─ session/
│  ├─ shoes/
│  ├─ social/
│  └─ user/
├─ shared/
│  ├─ utils/
│  └─ widgets/
└─ assets/
```

## 8. 文件职责清单

### 8.1 根入口与应用装配

- `main.dart`
  - 启动 Flutter 应用并接入新架构
- `app/app_bootstrap.dart`
  - 注册全局依赖与业务服务
- `app/shoecloud_app.dart`
  - 构建根 `GetMaterialApp`
- `app/router/app_routes.dart`
  - 定义统一路由常量
- `app/router/app_pages.dart`
  - 注册页面到路由表
- `app/theme/app_theme.dart`
  - 定义全局配色、输入框、按钮、卡片等统一风格

### 8.2 基础设施

- `core/constants/app_constants.dart`
  - 保存基础常量与接口路径
- `core/network/api_client.dart`
  - 封装 Dio 请求与统一响应处理
- `core/storage/session_storage.dart`
  - 持久化登录态信息
- `core/nfc/deep_link_nfc_manager.dart`
  - 监听 NFC 深链并完成跳转
- `core/nfc/nfc_writer.dart`
  - 构造并写入 NFC NDEF 数据

### 8.3 会话、用户与认证

- `features/session/models/user_login.dart`
  - 定义轻量登录态模型
- `features/session/presentation/controllers/app_session_controller.dart`
  - 管理全局登录态、用户档案与启动恢复流程
- `features/user/models/user_profile.dart`
  - 定义完整用户档案模型
- `features/user/data/user_repository.dart`
  - 获取与更新用户资料
- `features/auth/data/auth_repository.dart`
  - 执行登录数据请求
- `features/auth/presentation/controllers/auth_controller.dart`
  - 控制登录提交与会话更新
- `features/auth/presentation/pages/login_page.dart`
  - 展示登录表单与提交入口

### 8.4 首页与主壳

- `features/main/presentation/pages/main_page.dart`
  - 底部三栏主壳，负责应用启动后的壳层流程
- `features/home/presentation/controllers/home_controller.dart`
  - 加载首页鞋库列表
- `features/home/presentation/pages/home_page.dart`
  - 首页鞋库视图与空态入口
- `features/home/presentation/widgets/add_shoe_entry_button.dart`
  - 复用的添加跑鞋入口按钮
- `features/home/presentation/widgets/home_header.dart`
  - 首页头部品牌区块
- `features/home/presentation/widgets/shoe_overview_card.dart`
  - 首页鞋款概览卡片

### 8.5 跑鞋与活动

- `features/activities/models/shoe_activity.dart`
  - 定义活动概要模型
- `features/shoes/models/shoe.dart`
  - 定义跑鞋详情模型与统计模型
- `features/shoes/models/shoe_catalog_item.dart`
  - 定义预置鞋库模型
- `features/shoes/data/shoe_repository.dart`
  - 处理跑鞋、活动、同步相关的数据访问
- `features/shoes/domain/shoe_service.dart`
  - 组合仓储能力，提供跑鞋业务动作
- `features/shoes/presentation/pages/shoe_catalog_page.dart`
  - 展示预置鞋库列表
- `features/shoes/presentation/pages/shoe_catalog_detail_page.dart`
  - 展示预置鞋款详情
- `features/shoes/presentation/pages/shoe_create_page.dart`
  - 补全跑鞋信息并确认添加
- `features/shoes/presentation/pages/shoe_detail_page.dart`
  - 展示个人跑鞋详情并承接同步、编辑、NFC 绑定
- `features/shoes/presentation/pages/shoe_edit_page.dart`
  - 编辑与删除个人跑鞋
- `features/shoes/presentation/pages/shoe_activities_page.dart`
  - 展示单鞋活动列表并支持撤销同步
- `features/shoes/presentation/widgets/shoe_detail_header.dart`
  - 跑鞋详情头图与特性标签
- `features/shoes/presentation/widgets/shoe_stats_card.dart`
  - 跑鞋统计信息卡片
- `features/shoes/presentation/widgets/shoe_detail_list.dart`
  - 跑鞋元数据列表与活动入口
- `features/shoes/presentation/widgets/sync_action_card.dart`
  - 活动同步行动卡片
- `features/shoes/presentation/widgets/activity_selection_sheet.dart`
  - 多活动待同步选择面板
- `features/shoes/presentation/widgets/nfc_bind_button.dart`
  - NFC 绑定入口与提示弹层

### 8.6 个人中心、社区与通用页面

- `features/profile/domain/profile_service.dart`
  - 更新个人资料字段并维护会话中的资料快照
- `features/profile/presentation/pages/profile_page.dart`
  - 个人中心入口页
- `features/profile/presentation/pages/profile_edit_page.dart`
  - 资料编辑页
- `features/profile/presentation/widgets/profile_header.dart`
  - 个人中心头部用户信息区域
- `features/profile/presentation/widgets/feature_tile.dart`
  - 个人中心复用功能卡片
- `features/social/presentation/pages/social_page.dart`
  - 社区入口展示页
- `features/social/presentation/widgets/social_card.dart`
  - 社区入口卡片
- `features/privacy/presentation/pages/privacy_page.dart`
  - 隐私政策容器页
- `features/privacy/presentation/widgets/policy_content.dart`
  - 隐私政策正文内容
- `features/common/presentation/pages/coming_soon_page.dart`
  - 通用开发中占位页

### 8.7 共享工具与共享组件

- `shared/utils/time_formatter.dart`
  - 格式化时长、活动时长与配速
- `shared/widgets/app_card.dart`
  - 通用圆角卡片容器
- `shared/widgets/app_primary_button.dart`
  - 通用主按钮
- `shared/widgets/app_empty_state.dart`
  - 通用空状态视图
- `shared/widgets/app_feedback.dart`
  - 通用反馈提示
- `shared/widgets/app_shell.dart`
  - 通用安全区页面外壳

## 9. 当前结论

现在的 `lib` 已经完成从旧演示式结构向正式模块化结构的迁移：

- 旧文件与重复文件已从正式运行链路中移除
- 主页面、组件、工具、模型、API 已完成分层
- 主要业务已迁移到新架构下的正式模块
- 文件级注释已经统一为简要职责说明

后续最值得继续推进的工作是：

1. 补齐 `flutter analyze`、`flutter test` 与真机验证
2. 继续补完社区、活动详情、媒体上传等未完成能力
3. 为新架构补充测试、环境配置、日志与监控体系
