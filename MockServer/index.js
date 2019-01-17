// Mock用のJSONレスポンスサーバーの初期化設定
const jsonServer = require('json-server');
const server = jsonServer.create();

// Database構築用のJSONファイル
const router = jsonServer.router('datasource/db.json');

// 各種設定用
const middlewares = jsonServer.defaults();
const rewrite_rules = jsonServer.rewriter({
    "/api/mock/v1/meals/list/?page=:page" : "/get_meal_list/?page=:page",
    "/api/mock/v1/meals/detail/:id" : "/get_meal_by_id/:id",
});

// リクエストのルールを設定する
server.use(rewrite_rules);

// ミドルウェアを設定する (※コンソール出力するロガーやキャッシュの設定等)
server.use(middlewares);

// 受信したリクエストにおいてGET送信時のみ許可する
server.use(function (req, res, next) {
    if (req.method === 'GET') {
        next();
    }
});

// ルーティングを設定する
server.use(router);

// サーバをポート3000で起動する
server.listen(3000, () => {
    console.log('JSON Server is running');
});
