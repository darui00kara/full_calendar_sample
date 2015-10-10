# Goal
Phoenix-Framework上でFullCalendar(js)を動作させる。

# Dev-Environment
OS: Windows8.1  
Erlang: Eshell V7.1, OTP-Version 18.1  
Elixir: v1.1.1  
Phoenix Framework: v1.0.3  
PostgreSQL: postgres (PostgreSQL) 9.4.4  
FullCalendar: v2.4.0  

# Wait a minute
FullCalendar(js)を使って、カレンダーを表示してみます。

# Index
FullCalendar with Phoenix-Framework 
|> Before you start  
|> Placement of files  
|> Let's run!!  

## Before you start
プロジェクトの準備とFullCalendarのダウンロードを行います。

プロジェクトの準備。

```cmd
>cd path/to/create/project
>mix phoenix.new full_calendar_sample
>cd full_calendar_sample
>mix ecto.create
>mix phoenix.server
Ctrl+C
```

FullCalendarのダウンロード。

#### 以下の公式サイトよりダウンロードして下さい。
#### FullCalendar Download: [http://fullcalendar.io/download/](http://fullcalendar.io/download/)

私がダウンロードしたのは、v2.4.0です。

## Placement of files
FullCalendarのファイルをPhoenix-Frameworkへ配置します。

配置するファイルは5つです。

- fullcalendar-2.4.0/fullcalendar.js
- fullcalendar-2.4.0/
- fullcalendar-2.4.0/lib/jquery.min.js
- fullcalendar-2.4.0/lib/moment.min.js
- fullcalendar-2.4.0/lang/ja.js (任意、日本語表示したい場合)

プロジェクトに以下のように配置して下さい。

#### Example:

```txt
full_calendar_sample
|
priv
  |
  static
    |
    |-css
    |  |-fullcalendar.min.css
    |
    |-js
       |-fullcalendar.js
       |-jquery.min.js
       |-moment.min.js
       |-ja.js (任意、日本語表示したい場合)
```

これで配置完了です。

## Let's run!!
お待ちかねのカレンダーを出してみましょう。

cssとjsの読み込みをレイアウトテンプレートで行います。

#### web/templates/layout/app.html.eex

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    ...
    <link rel="stylesheet" href="<%= static_path(@conn, "/css/fullcalendar.min.css") %>">

    <script src="<%= static_path(@conn, "/js/jquery.min.js") %>"></script>
    <script src="<%= static_path(@conn, "/js/moment.min.js") %>"></script>
    <script src="<%= static_path(@conn, "/js/fullcalendar.js") %>"></script>
    <script src="<%= static_path(@conn, "/js/ja.js") %>"></script>
  </head>

  ...
</html>
```

デフォルトで配置されているindexテンプレートを以下のように変更します。

#### web/templates/page/index.html.eex

```html
<script language="JavaScript">
$(document).ready(function() {
  $('#calendar').fullCalendar({

  });
});
</script>

<div id="calendar"></div>
```

基本的な使い方は公式サイトのUsageを見て下さい。
参考: [http://fullcalendar.io/docs/usage/](http://fullcalendar.io/docs/usage/)

試しにカレンダーでイベント(予定)を表示してみます。

#### web/templates/page/index.html.eex

```html
<script language="JavaScript">
$(document).ready(function() {
  $('#calendar').fullCalendar({
    events: [
        {
          title: 'サンプル1',
          start: '2015-10-15'
        },
        {
          title: 'サンプル2',
          start: '2015-10-16',
          end: '2015-10-18'
        },
        {
          title: 'サンプル3',
          start: '2015-10-18',
          url: "http://www.google.co.jp"
        },
        {
          title: 'サンプル4',
          start: '2015-10-01',
          end: '2015-10-07'
        }
      ]
  });
});
</script>

<div id="calendar"></div>
```

# Speaking to oneself
割かし簡単に動いた。
取り急ぎ最初の使い方まで。

# Bibliography
[FullCalendar](http://fullcalendar.io/)