# Makele β

## API v1ドキュメント

## 共通フィールド
すべてのJSONに含まれる共通のフィールド
|key|type|Description|
|:-|:-|:-|
|ok|boolean|正常に取得できたかどうかの状態|
|httpStatus|number|httpステータスコード|

## Games
### #play

#### リクエスト
| method | path |
| :- | :-|
|GET| api/v1/games/play/:id |
#### レスポンス
|key|type|Description|
|:-|:-|:-|
|data|object|ゲームプレイで使うGameとWordとQuestionのデータ|
|data.game|object|idパラメータで指定されたGameレコード|
|data.wordList|array|Gameに登録されたWordの文字列リスト|
|data.wordToday|string|本日の問題のWordの文字列|
|data.isPrivate|boolean|ゲームが非公開且つ作成者じゃない場合は true|
|data.hasNoWords|boolean|ゲームにWordが未登録の場合は true|

## Error Codes
各コントローラがエラー発生時に返すJSONの一覧
#### Users
|code|httpStatus|message|
|:-|:-|:-|
|1001|403|Your account is currently suspended.|
|1002|401|You are not logged in.|

#### Games
|code|httpStatus|message|
|:-|:-|:-|
|2001|404|This game is not found.|
|2002|404|This game has no words yet.|
|2003|403|This game is not currently published.|
|2004|403|This game is currently suspended.|
|2005|403|The owner of this game is suspended.|
|2006|401|You are not the owner of this game.|

#### Words
|code|httpStatus|message|
|:-|:-|:-|
|3001|404|This word is not found.|
