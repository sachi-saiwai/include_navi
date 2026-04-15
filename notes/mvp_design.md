# いんくるなび MVP 実装メモ

## 1. 実装方針の要約

- `domain / application / infrastructure / presentation` を分離し、状態管理ライブラリやバックエンドを固定しない。
- MVP動作確認用としてインメモリ実装を採用しつつ、将来差し替えるためのリポジトリ / サービス境界を定義する。
- 未定事項は仮仕様化せず、`TODO` / `FIXME` / `Not implemented` としてコード上に明示する。
- AI機能は実装しない。将来差し込みやすいよう、振り返り画面とPDF出力まわりは拡張余地だけ残す。
- 認証は `iOS + Supabase + Google Sign-In` 前提に切り替え、設定値は `--dart-define` で注入する。
- Supabase未設定時は、画面確認のため `admin (demo)` 表示のローカル親ユーザーでログインできる退避路を用意する。

## 2. ディレクトリ構成案

```text
lib/
  app/
    app.dart
    app_scope.dart
    dependencies.dart
  application/
    app_controller.dart
  domain/
    models/
    repositories/
    services/
  infrastructure/
    adapters/
    repositories/
  presentation/
    screens/
    widgets/
notes/
  mvp_design.md
docs/
  GitHub Pages 公開物
```

## 3. 画面遷移案

```text
ログイン
  -> 子ども一覧
    -> 子ども作成/編集
    -> 記録一覧
      -> 記録入力
      -> 記録詳細
      -> 振り返り
      -> 招待/共有
      -> PDF出力
```

補足:
- `記録一覧 -> PDF出力` は別画面ではなく、一覧画面上の導線として実装。
- 先生側の閲覧UIは未定のため、今回の画面遷移には含めていない。

## 4. ドメインモデル定義

- `AppUser`
  - `id`
  - `role`
  - `displayName`
  - `email`
- `ChildProfile`
  - `id`
  - `ownerUserId`
  - `nickname`
  - `traitsMemo`
  - `createdAt`
  - `updatedAt`
- `RecordEntry`
  - `id`
  - `childId`
  - `date`
  - `condition`
  - `trouble`
  - `trigger`
  - `after`
  - `createdAt`
  - `updatedAt`
- `RecordFieldValue`
  - `tags[]`
  - `text`
- `Invitation`
  - `id`
  - `childId`
  - `invitedUserId`
  - `createdAt`
- `PdfExport`
  - `id`
  - `childId`
  - `createdByUserId`
  - `fileUrl`
  - `createdAt`
  - `fileBytes`

## 5. 未定事項を保持したままのデータ層インターフェース

- `AuthGateway`
  - `signInWithGoogle()`
  - `signOut()`
- `ChildProfileRepository`
  - `fetchByOwnerUserId(ownerUserId)`
  - `findById(id)`
  - `save(profile)`
- `RecordRepository`
  - `fetchByChildId(childId)`
  - `findById(id)`
  - `save(record)`
- `InvitationRepository`
  - `fetchByChildId(childId)`
  - `save(invitation)`
- `PdfExportService`
  - `exportChildRecords(createdBy, child, records)`

## 6. UIの骨組みコード

- ログイン画面
  - Googleログインボタン
  - 実Google認証差し替え前提の注記
- 子ども一覧画面
  - 子ども追加
  - 子ども選択
  - 子ども編集
- 子ども作成/編集画面
  - ニックネーム
  - 特性メモ
- 記録入力画面
  - 日付
  - 今日のコンディション
  - 困りごと
  - きっかけ
  - そのあと
  - 各項目にタグ欄と自由記述欄
- 記録一覧画面
  - 時系列一覧
  - 振り返り画面導線
  - PDF出力導線
  - 招待/共有導線
- 記録詳細画面
  - 入力項目表示
  - ABC表示文言セクション
  - 未定マッピングは固定しない
- 振り返り画面
  - 導線のみ
  - 詳細可視化は未実装
- 招待/共有画面
  - Invitation保存の土台
  - 共有詳細は未実装

## 7. 未定事項に対する TODO / FIXME の一覧

- Googleログイン実装は対象OSと認証情報確定後に本実装へ差し替え
- Supabase URL / Anon Key / Google iOS Client ID / Google Web Client ID / iOS URL Scheme の実値投入が必要
- Supabase未設定時の demo ログインは開発用退避路であり、本番運用前に無効化または実認証必須化が必要
- タグ管理方式は未定のため、MVPではカンマ区切り入力
- 必須/任意は未定のため、必須バリデーションなし
- 1日に複数記録できるか未定のため、重複制御なし
- 記録編集可否 / 削除可否は未定のため、詳細は閲覧のみ
- `困りごと` / `そのあと` と `起きたこと` / `本人の変化` の対応関係は未定
- 振り返り画面の可視化ロジックは未定のため未実装
- PDFの保存先 / 共有方法 / 出力単位は未定
- 招待フロー詳細、先生側閲覧UI、先生の編集可否は未定

## 8. iOS + Supabase ログイン設定メモ

実行時に以下の `--dart-define` が必要:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
GOOGLE_IOS_CLIENT_ID
GOOGLE_WEB_CLIENT_ID
```

iOS ネイティブ設定で別途必要:

- [ios/Runner/Info.plist](/Users/sachikosaga/Documents/flutter/include_navi/ios/Runner/Info.plist) の `GIDClientID`
- 同ファイルの `CFBundleURLSchemes`

補足:
- `CFBundleURLSchemes` には Google の `REVERSED_CLIENT_ID` を入れる必要がある。
- 値が未設定のままだと、アプリはビルドできてもGoogleログインは成立しない。
