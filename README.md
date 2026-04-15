# include_navi

Flutter アプリ「いんくるなび」のMVP実装です。

## GitHub Pages

このリポジトリは `main` ブランチの `docs/` フォルダを GitHub Pages の公開元にする前提です。

公開URL想定:

- `https://sachi-saiwai.github.io/include_navi/`

Pages 用ビルドを更新するコマンド:

```bash
flutter build web --release --base-href /include_navi/ --output docs
cp docs/index.html docs/404.html
```

GitHub 側の設定:

1. Repository Settings を開く
2. Pages を開く
3. Source を `Deploy from a branch` にする
4. Branch を `main`
5. Folder を `/docs`
6. Save

## 開発メモ

- MVP設計メモ: [notes/mvp_design.md](/Users/sachikosaga/Documents/flutter/include_navi/notes/mvp_design.md)
