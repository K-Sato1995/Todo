[![pipeline status](https://git.ruby-dev.jp/rookies/el-training-sato/badges/master/pipeline.svg)](https://git.ruby-dev.jp/rookies/el-training-sato/commits/master) [![coverage report](https://git.ruby-dev.jp/rookies/el-training-sato/badges/master/coverage.svg)](https://git.ruby-dev.jp/rookies/el-training-sato/commits/master)

# README

## デプロイ方法
- アプリのディレクトリに移動する  
`$ cd rails-app`  
- リモートリポジトリの登録  
`$ git remote add heroku https://git.heroku.com/xxxxx-xxxxx-xxxxx.git`  
- デプロイ  
`$ git push heroku master`  
- アクセス確認  
`$ heroku open`

## Installation
- $ git clone https://git.ruby-dev.jp/rookies/el-training-sato.git
- $ cd todo
- $ cp config/databse.yml.sample  config/database.yml
- $ bundle install
- $ bin/rails s
- 以上のコマンドを入力後  http://localhost:3000/で立ち上げることができることをご確認ください。

## Ruby version

2.4.4

## rails version

5.1.6

## users
|Column|Type|Options|
|------|----|-------|
|name  |string|null: false|
|email |string|null: false, unique: true|
|password|string|null: false|

### Association
- has_many :tasks

## tasks
|Column|Type|Options|
|------|----|-------|
|title |string|null: false, add_index|
|detail|text|null: false|
|user_id|integer|null: false, foreign_key: true|
|deadline|datetime|null: false|
|priority|string|
|status|string|

### Association
- belongs_to :user
- has_many :categories, through::task_categories

## categories
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|

### Association
- has_many :tasks, through::task_categories

## task_categories
|Column|Type|Options|
|------|----|-------|
|todo_id|integer|null: false|
|category_id|integer|null: false|

### Association
- belongs_to :task
- belongs_to :category
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
=======
>>>>>>> step_7
