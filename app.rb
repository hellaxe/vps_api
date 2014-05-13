require 'sinatra'
require 'sinatra/config_file'
require 'json'


class VpsApiApplication < Sinatra::Base

  register Sinatra::ConfigFile
  config_file './config/config.yml'

  get '/' do

  end

  get '/memory', provides: :json do
    content_type :json
    begin
      result = {}
      File.open([settings.memory_cgroup_path, settings.memory_stat].join('/'), 'r') do |f|
        while line = f.gets
          key, val = line.split(' ')
          result[key] = val
        end
      end
      result.to_json
    rescue Errno::ENOENT
      status 404
      {status: 404, reason: 'Not found'}.to_json
    rescue
      status 500
      {status: 500, reason: 'Error'}.to_json
    end
  end

  get '/memory/:container_id', provides: :json do
    content_type :json
    begin
      container_id = params[:container_id].gsub /[^a-z0-9]/, ''
      result = {}
      File.open([settings.memory_cgroup_path, settings.docker_folder, container_id, settings.memory_stat].join('/'), 'r') do |f|
        while line = f.gets
          key, val = line.split(' ')
          result[key] = val
        end
      end
        result.to_json
    rescue Errno::ENOENT
      status 404
      {status: 404, reason: 'Not found'}.to_json
    rescue
      status 500
      {status: 500, reason: 'Error'}.to_json
    end

  end

end
