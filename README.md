# iOS App

スマホ疲れをやさしく休ませる iOS アプリ「やすみどき」の開発リポジトリです。

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

## Core Tests

Domain logic lives in `Core/YasumidokiCore`.

```sh
swift test --package-path Core/YasumidokiCore
```

## iOS App

The app target lives in `Yasumidoki/`.

```sh
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj -scheme Yasumidoki -destination 'generic/platform=iOS Simulator' build
```

Open `Yasumidoki/Yasumidoki.xcodeproj` in Xcode to run the app in Simulator.

## Notes

- MVP scope: home room, fatigue check, tiny recovery action, completion, and seven-day reflection.
- Local app data is stored as JSON in Application Support.
- 証明書やプロビジョニングプロファイルなどの秘密情報は Git に含めません。
