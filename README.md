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
- [WaterFallLayout](https://github.com/sgr-ksmt/WaterfallLayout)

__2-2. Mockサーバー:__

- [json-server](https://github.com/typicode/json-server)

APIのモックサーバー構築用に利用しました。node.jsを利用した経験があるならば、すぐに導入できるかと思います。具体的な使い方は[こちら](https://blog.eleven-labs.com/en/json-server/)を参照して頂ければと思います。

### 3. Mockサーバーの起動

iOSシミュレータでAPI通信(GET)Mock用サーバーを準備していますので、実行する際は下記のような手順でお願いします。

1. 実機検証はできません。
2. 事前にnode.jsのインストールが必要になります。

__3-1. 必要なパッケージのインストール:__

```
$ cd MockServer
$ npm install
```

__3-2. サーバー起動:__

```
$ node index.js
```

### 4. その他

ひととおりこのような形までプロトタイプを作成するまでにあたり、まとめているメモや図解を掲載しています。

__4-1. UI実装をする前にまとめておくメモ:__

![4-1図解](https://github.com/fumiyasac/MasonryStyleLayout/blob/master/images/ui_practice.jpg)

__4-2. このサンプルで実践したアーキテクチャ:__

![4-2図解](https://github.com/fumiyasac/MasonryStyleLayout/blob/master/images/architecture_practice.png)

__4-3. 改善を施した方が良い気がする部分:__

+ せっかくMVVMにしているのに一時的な値を保持するためだけにStateを準備しているのはあまりよくないのでは？
+ UICollectionViewのレイアウト構築用にAPIレスポンス内に「画像の縦横比」または「幅・高さ」のキーを返せばもっと楽ができる＆ライブラリとも合わせやすいのでは？
