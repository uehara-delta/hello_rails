# Scaffold で生成されたコードを理解する

## Gemfile

使用しているGem

* rails
* mysql2
* puma
 * app server
* sass-rails
 * SCSS for stylesheets
* uglifier
 * compressor for JavScript assets
* coffee-rails
 * CoffeeScript for .coffee assets and views
* turbolinks
 * Turbolinks makes navigating your web application faster.
 * 画面遷移を Ajaxを使用した画面遷移に置き換える(pjaxと同じような仕組み)
* jbuilder
 * Build JSON APIs with ease
* bootsnap
 * Reduces boot times through caching

### 開発、テスト環境

* byebug
 * Call 'byebug' anywhere in the code to stop execution and get a debugger console

### 開発環境

* web-console
 * Access an interactive console on exception pages or by calling 'console' anywhere in the code.
* listen
 * listens to file modifications and notifies you about the changes
* spring, spring-watcher-listen
 * Spring speeds up development by keeping your application running in the background.


## app/assets

### stylesheets/scaffolds.scss

scaffold で生成されたページの CSS が記載されている。

## app/channels

Action Cable 関連(WebSocketsを扱うために使用)。

## app/controllers

### application_controller.rb

各コントローラの共通基底クラス。
共通で定義したいリクエストの前処理などを定義できる。

### entries_contorller.rb

コントローラクラス

* 実装されているメソッド
 * index
 * show
 * new
 * edit
 * create
 * update
 * destroy

## app/models

### entry.rb

* メソッドなどの実装はなし
* ApplicationRecord を継承
 * ApplicationRecord は ActiveRecord:Base を継承

## app/views/entries

### erbファイル

* _form.html.erb
* edit.html.erb
* index.html.erb
* new.html.erb
* show.html.erb

### jbuilderファイル

* _entry.json.jbuilder
* index.json.jbuilder
* show.json.jbuilder

## app/views/layouts

### erbファイル

* application.html.erb

ActionMailerに関するビューはとりあえず無視
* mailer.html.erb
* mailer.txt.erb

## bin

存在する実行コマンド

* bundle
* rails
* rake
* setup
* update
* yarn

## config
