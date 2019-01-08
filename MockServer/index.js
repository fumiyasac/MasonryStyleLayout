const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('datasource/db.json');
const middlewares = jsonServer.defaults();

// db.jsonに対応させるデータ内容を記載する
server.use(jsonServer.rewriter({
    "/api/mock/v1/meals": "/get_meals"
}))

// ミドルウェアの設定 (コンソール出力するロガーやキャッシュの設定など)
server.use(middlewares);

server.use(function (req, res, next) {
    // GET送信時のみ許可する
    if (req.method === 'GET') {
        next();
    }
})

// db.jsonを基にデフォルトのルーティングを設定する
server.use(router);

// サーバをポート 3000 で起動する
server.listen(3000, () => {
    console.log('JSON Server is running');
});
