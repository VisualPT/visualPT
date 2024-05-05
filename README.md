[![wakatime](https://wakatime.com/badge/user/101a11b5-17a3-47c6-935c-58d4ffab60da/project/d93f104f-ff96-4d7d-bca8-5e54d6a0f910.svg)](https://wakatime.com/badge/user/101a11b5-17a3-47c6-935c-58d4ffab60da/project/d93f104f-ff96-4d7d-bca8-5e54d6a0f910)

# VisualPT

Collecting Data for VisualPT

## Getting Started

> **Warning**
>
> Setting up this dev environment can be a tricky process, as you will need to install various systems to run a debuggable iOS application on your machine. Any sticky errors that show up during this process should be documented and added to a [New Discussion](https://github.com/VisualPT/visualPT/discussions/new?category=q-a) to accelerate future onboarding experiences, thank you.

**Prerequisites:**

- [VSCode](https://docs.flutter.dev/tools/vs-code)
- [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Amplify CLI](https://docs.amplify.aws/cli/)
- [Device powered with iOS >= 14](https://cdn.statcdn.com/Infographic/images/normal/5824.jpeg)

**Installation**

Clone this repository, open the terminal, and cd to the cloned directory, then:

- Get all the Flutter/Dart dependencies

```
flutter pub get
```

- Get all the iOS platform-specific dependencies from inside the **ios** folder (remember to `cd` out)

```
cd ios && pod install && cd ..
```

**Build & Run**

- Create the build artifact for the iOS platform

```
flutter build ios
```

- Run the application in debug mode (ensure your device is connected)

```
flutter run
```

## Usage

VisualPT should be developed on a real device at all times, the XCode Simulator should not be used as it cannot access an on-device camera.

## Architecture

See [VisualPT Architecture Discussion](https://github.com/VisualPT/visualPT/discussions/41)
