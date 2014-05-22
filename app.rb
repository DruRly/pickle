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

get '/failures' do
  content_type :json
  settings.mongo_db['test'].find.to_a.to_json
end

post '/failures' do
  content_type :json
  new_id = settings.mongo_db['test'].insert params
  document_by_id(new_id)
end

helpers do
  def object_id val
    BSON::ObjectId.from_string(val)
  end

  def document_by_id id
    id = object_id(id) if String === id
    settings.mongo_db['test'].
      find_one(:_id => id).to_json
  end
end

# Example Post: HTTParty.post 'http://localhost:4567/failures', body: { "name" => 'blah' }
