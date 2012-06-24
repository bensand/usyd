require 'rubygems'
require 'sinatra'
# require 'haml'
require 'maruku'

configure do
  set :views, File.dirname(__FILE__)
end

get '/' do
  @files = `ls */*.md`
  haml :index
end

get '/:slug' do
  filename =  File.join(params[:slug], params[:slug]+'.md')
  Maruku.new(File.read(filename)).to_html
end
