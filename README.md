# memo-app
Thank you for coming!

## About this app
フィヨルドブートキャンプのプラクティス課題で、sinatraにてメモアプリを作成しました。
今回はDB編です。

## Usage

### DB
1. PostgreSQLの使用が可能になっていること。
2. テーブルを作成する。
  ```create table memos (```
  ```id serial,```
  ```title text,```
  ```content text,```
  ```primary key (id)```
  ```);```

### git
1. ```https://github.com/shugoStr/memo-app.git``` にてクローン。
2. ```gem install sinatra``` を実行。
3. ```cd memo-app```後に、```bundle install``` を実行。
4. ```bundle exec ruby app.rb``` にてアプリ起動。
5. ```http://localhost:4567``` へアクセス。
6. メモの追加・削除・編集が行えます。
