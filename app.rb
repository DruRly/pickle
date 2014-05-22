require 'rubygems'
require 'sinatra'
require 'mongo'
require 'json/ext' # required for .to_json

include Mongo

configure do
  conn = MongoClient.new("localhost", 27017)
  set :mongo_connection, conn
  set :mongo_db, conn.db('pickle')
end

post '/failure' do
  content_type :json
  new_id = settings.mongo_db['test'].insert params
  document_by_id(new_id)
end
