# Pinterest風のアプリUIを実装するサンプル

こちらは会社の実務で実装する前の「お試し開発」の際に作成したサンプルになります。社内共有用の資料としておくつもりでしたが、色々なエッセンスが詰まっているサンプルやここに行き着くまでのプロセスを残しておく意図も含めてサンプルを公開しています。

### 1. 概要

APIから写真データを10件分ずつ取得してPinterest風のレイアウトで表示する部分を実現するサンプルになります。

※ サンプルで利用している写真素材につきましては、「[pixabay](https://pixabay.com/)」のものを利用しました。

### 2. 利用したライブラリの一覧紹介

実際のアプリで利用するUIになるべく近しい形で既に利用されているライブラリを活用した実装をするようにしました。
また、APIのリクエスト・レスポンスを想定した挙動を実現するために、シミュレータでも動作検証ができるようにMockサーバーを導入しています。

__2-1. iOSアプリ:__

下記はロジック構築に関連するライブラリになります。

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
- [FontAwesome.swift](https://github.com/thii/FontAwesome.swift)
- [PromiseKit](https://github.com/mxcl/PromiseKit)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [SwiftyMarkdown](https://github.com/SimonFairbairn/SwiftyMarkdown)

下記はUI構築の際に利用したライブラリになります。こちらのライブラリはCocoaPodsを利用せずにコードを手動で追加＆一部の処理にForkを加えています。

- [WaterFallLayout](https://github.com/sgr-ksmt/WaterfallLayout)

__2-2. Mockサーバー:__

- [json-server](https://github.com/typicode/json-server)

APIのモックサーバー構築用に利用しました。node.jsを利用した経験があるならば、すぐに導入できるかと思います。具体的な使い方は[こちら](https://blog.eleven-labs.com/en/json-server/)を参照して頂ければと思います。

### 3. Mockサーバーの起動

モック用サーバーを準備していますので実行する際は下記のようにお願いします。

__3-1. 必要なパッケージのインストール:__

```
$ cd MockServer
$ npm install
```

__3-2. サーバー起動:__

```
$ node index.js
```

### その他資料に関して

※ 現在鋭意作成中でございますので、しばらくお待ち頂ければ幸いです。
