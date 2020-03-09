# iOS

## グループ構成

```
[PROJECT]
├── Root/
│    ├──Application/
│    │    ├──AppDelegate.swift        	→ AppDelegate
│    │    ├──AppSettings.swift          → アプリケーション内共通定数定義
│    │    ├──AppStyles.swift	        → アプリケーション内共通スタイル定義
│    │    ├──AppScreens.swift           → アプリケーション内スクリーン定義
│    │    ├──AppBusEvents.swift       	→ アプリケーション内イベント定義（SwiftEventBus利用）
│    │    ├──AppRootViewController.swift→ アプリケーションのルートViewController
│    │    └──R.generated.swift		→ R.swiftにより自動生成
| 　 ├──ViewControllers/		→ 基本的に実装側はここで定義されているViewControllerを継承すること
│    ├──Services/			→ Service
│    ├──Models/				→ Model
│    ├──Modules/			→ Module
│    ├──Widgets/                        → Widgets
│    ├──Resources/
│    │    ├──Assets.xcassets		→ ネイティブ側で使う画像はこちら
│    │    ├──Localizable.strings	→ ネイティブ側で使う文字列はこちら
│    │    └──LaunchScreen.storyboard
│    └──Supporting Files/
│         └──Info.plist
├──Products/
└──Frameworks/
```

## Schema

### Develop
開発用

### Staging
ステージング用

### Production
本番用

## アーキテクチャ
基本は[VIPER](https://cheesecakelabs.com/blog/ios-project-architecture-using-viper/)で、以下を参考にちょっとカスタマイズしています。

参考:

	https://www.slideshare.net/UsrNameu1/viper-arch
	http://sssslide.com/www.slideshare.net/keisukeyamaguchi180410/router-module-in-viper-architecture
	https://qiita.com/Yaruki00/items/d350709678ff0aec93cc
	https://qiita.com/sztk1209/items/605ad32ab799530d57aa#_reference-b56a0f54c975c071db79
	https://qiita.com/hicka04/items/09534b5daffec33b2bec

### ものすごいざっくりModule内の構成説明

	Interfaces
		各interfaceの定義
	Presenter
		view/interactor/wireframeの参照の保持。

		PresenterInterfaceの実装→viewから呼び出される。

		InteractorOutputInterfaceの実装→interactorから呼び出される。
	Interactor
		outoutの参照の保持。

		InteractorInterfaceの実装→Presenterから呼び出される。サービスの呼び出しやIntercatorOutputInterfaceの呼び出しはここ。
	Wireframe
		WireframeInterfaceの実装→Module外から呼び出される唯一の人

		Presenter/Interactor/ViewControllerがどこのどいつかを全て知っているのはこいつ。

		画面遷移はここ。
	Views/
		Storyboard
			Storyboardです。
		ViewController
			ViewControllerです。

### Module実装
Interfacesに各protocolの定義を行い実装していく。

・参照関係
View（ViewController）→ Presenter 

Presenter → Interactor/Wireframe/View

Interactor → Service/InteractorOutput

InteractorOutput → Wireframe/View

## Lint

Lint自体はビルド時に自動で実行されます。
おまかせ修正は以下。

```
swiftlint autocorrect
```
