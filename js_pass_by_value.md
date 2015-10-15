# Goal
Phoenix-FrameworkでのJavaScriptへの値の渡し方を習得する。

# Dev-Environment
OS: Windows8.1
Erlang: Eshell V7.1, OTP-Version 18.1
Elixir: v1.1.1
Phoenix Framework: v1.0.3
PostgreSQL: postgres (PostgreSQL) 9.4.4

# Wait a minute
この記事ではJavaScriptへ、
Phoenix-Frameworkで使っている変数の値を渡す方法を記述しています。

後半の方は知的好奇心を満たすためだけのものですので、ご注意下さい。

Ruby on RailsでJavaScriptへ渡している方法と同じなので、
そちらの方法をご存知の方は見る必要がないと思います。

# Index
From Phoenix to JavaScript you pass a value
|> Before you start
|> Pass a value
|> Using content_tag/3
|> Little experiment
|> Extra

## Before you start
検証を行うためのプロジェクトを準備します。
既に作成している適当なプロジェクトがあれば、そちらで試しても構いません。

#### Example:

```cmd
>cd path/to/create/directory

>mix phoenix.new pass_by_value

>cd pass_by_value

>mix ecto.create

>mix phoenix.server
Ctrl+C
```

準備終わり。

## Pass a value
早速、JavaScriptへ値を渡してみましょう。

デフォルトで生成されているPageコントローラのindexアクションで適当な変数を渡します。

#### File: web/controllers/page_controller.ex

```elixir
defmodule PassByValue.PageController do
  use PassByValue.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", hoge: "hoge"
  end
end
```

indexテンプレートを以下のように編集して下さい。

#### File: web/templates/page/index.html.eex

```html
<script language="JavaScript">
function sample() {
  var e = document.getElementById("hoge");
  var value = e.getAttribute("data-hoge");
  window.alert(value)
}
</script>

<div id="hoge" data-hoge="<%= @hoge %>">
  <a onclick="sample()">hoge</a>
</div>
```

動作的には、aタグのリンクをクリックすると渡している値をアラートで表示するだけです。

HTML5にある独自データ属性を利用しています。
(data-*で記述される属性です。)

## Using content_tag/3
Phoenix.HTMLのcontent_tag/3関数を利用して、書き換えてみます。

#### File: web/templates/page/index.html.eex

```html
<script language="JavaScript">
function sample() {
  var e = document.getElementById("hoge");
  var value = e.getAttribute("data-hoge");
  window.alert(value)
}
</script>

<%= content_tag(:div, raw("<a onclick=\"sample()\">hoge</a>"),
                  id: "hoge", data: [hoge: @hoge]) %>
```

少し、ごちゃごちゃしたような気が...まぁいいや。

## Little experiment
幾つか思いついたことを実験してみます。

#### Q: Elixirの埋め込みコード使えるの？
#### A: 使えます。

記述しているのはEExテンプレートに対してですので、
こういう風にElixirコードの埋め込みでも書けます。

#### Example:

```html
<script language="JavaScript">
function sample() {
  window.alert("<%= @hoge %>")
}
</script>

<a onclick="sample()">hoge</a>
```

ただ、個人的にはあんまりよくない書き方な気がする。
JavaScriptのコードに対して、埋め込みとはいえ別言語の記述が混じるわけですから。

最終出力は、結局HTMLやJavaScriptになるとしても、
プログラムをする時に、複数の言語が混在するわけですから...

#### Q: マップやリストの値を渡したらどうなるか？
#### A: 実行時エラーになる。

渡す値のデータ形式がElixirのマップやリストだったらどうなるでしょうか？
まずは、content_tag/3を使って渡してみた。

実行時エラーとなりました。

正確に書くなら、content_tag/3の引数(属性)を解釈する段階で失敗する。
属性の解釈ができないと書いた方が良いかもしれない。
関数の問題なのでどうにもならん。
(詳しく知りたければ、Phoenix_HTMLのソース見て下さい。)

おそらく、マップを渡しても同様のエラーになるのが簡単に予想できるので、
content_tag/3を使わないで渡してみる。

#### Example:

```elixir
defmodule PassByValue.PageController do
  use PassByValue.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", hoge: ["hoge", "huge", "foo", "bar"]
  end
end

<div id="hoge" data-hoge="<%= @hoge %>">
  <a onclick="sample()">hoge</a>
</div>
```

実行して動作を確認したが、リストの内容が一つの文字列(?)になって表示される。
["hoge", "huge", "foo", "bar"]　--> hogehugefoobar、といったように。

とりあえず、実行はできるようなのでマップの方も渡してみる。

#### Example:

```elixir
defmodule PassByValue.PageController do
  use PassByValue.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", hoge: %{"foo" => "bar"}
  end
end
```

実行エラーで落ちますね。
エラーの内容を読むと、EEx(HTML)テンプレートで解釈できるデータ形式じゃないからっぽいですね。

そりゃそうか...ってことはEEx(HTML)テンプレートをこう変えてあげれば問題ないですね。

#### Example:

```html
<div id="hoge" data-hoge="<%= @hoge["foo"] %>">
  <a onclick="sample()">hoge</a>
</div>
```

こうすれば、key:"foo"の値がでますね。

しかしそうすると、Ectoでよく使うデータ形式である、
リストマップ([%{...}, %{...}])で複数のデータを渡したい時はどうしましょうね。

もう少し、実験してみましょう。

#### Q: EctoでDBを検索して返ってくる値を渡せないの？
#### A: JSON形式に変換して渡す

この方法が正しいのか分かりません。
ただ、複数の値を渡すための共通のデータ形式が、JSONしか思いつかなかったんです。
なので、一例としてって程度で...

これは動かない...

#### Example:

```elixir
defmodule PassByValue.PageController do
  use PassByValue.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", users: [%{name: "hoge"},
                                      %{name: "huge"},
                                      %{name: "foo"},
                                      %{name: "bar"}]
  end
end

<%= for user <- @users do %>
  <div id="user" data-user-name="<%= user.name %>">
    <a onclick="sample()"><%= user.name %></a>
  </div>
<% end %>
```

いっそのこと、JavaScriptの関数の引数で渡してみましょうか。
そうすれば、JavaScriptの関数内に直接埋め込みコードを記述するわけではないので、見苦しくはならないはず...

しかし、マップは参照してあげないとEExで解釈できない。
よし！JSONにエンコードしたデータを渡そう！！(妙案)

これで、一応実行できる。

#### Example:

```elixir
defmodule PassByValue.PageController do
  use PassByValue.Web, :controller

  def index(conn, _params) do
    users = Poison.encode!([%{name: "hoge", age: 20},
                            %{name: "huge", age: 21},
                            %{name: "foo", age: 23},
                            %{name: "bar", age: 25}])
    render conn, "index.html", users: users
  end
end

<script language="JavaScript">
function sample(users) {
  console.info(users)
  window.alert(users)
}
</script>

<a onclick="sample(<%= @users %>)">users</a>
```

しかし、視覚的にはConsoleからしか確認できないため、
画面に出力できるように少し修正する。

#### Example:

```html
<script language="JavaScript">
function sample(users) {
  console.info(users)
  for(var i in users) {
    $("#output").append("<li>" + users[i].name + "(" + users[i].age + ")" + "</li>")
  }
}
</script>

<a onclick="sample(<%= @users %>)">users</a>
<ul id="output"></ul>
```

usersリンクをクリックすると各ユーザのデータがliタグで表示されます。
段々と脱線してきたので、これで実験終わりにします。

動かなかったら、多分jQueryが必要かも...？

# Speaking to oneself
お好きな方法をお使い下さい。
どれを使うかの判断は、お任せします。

# Bibliography
HTML5.jp: [http://www.html5.jp/tag/attributes/data.html](http://www.html5.jp/tag/attributes/data.html)
JavaScript プログラミング講座: [http://hakuhin.jp/js/json.html](http://hakuhin.jp/js/json.html)
JavaScriptのデバッグが捗る！コンソールにログを出力する方法: [http://www.hp-stylelink.com/news/2014/01/20140112.php](http://www.hp-stylelink.com/news/2014/01/20140112.php)
設計力に学ぶデザインドリル jQuery入門: [http://www.jquerystudy.info/index.html](http://www.jquerystudy.info/index.html)