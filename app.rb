require 'sinatra'
require 'sinatra/config_file'
require 'json'


class VpsApiApplication < Sinatra::Base

  register Sinatra::ConfigFile
  config_file './config/config.yml'

  get '/' do

  end

  get '/memory_stats' do
    result = {}
    File.open([settings.memory_cgroup_path, settings.memory_stat].join('/'), 'r') do |f|
      while line = f.gets
        key, val = line.split(' ')
        result[key] = val
      end
    end
    content_type :json
    result.to_json
  end

  get '/memory_stats/:container_id' do

  end

end
