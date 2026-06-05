# iOS App

iOS アプリ開発用のリポジトリです。

## Setup

```sh
git clone <repository-url>
cd ios-app
```

## Landing Page Preview

```sh
python3 -m http.server 4173 -d landing
```

Open http://localhost:4173.

The release notification form is front-end only for now. It does not send emails to an external service until a waitlist provider is selected.

## Notes

- Xcode プロジェクト作成後、この README を更新します。
- 証明書やプロビジョニングプロファイルなどの秘密情報は Git に含めません。
