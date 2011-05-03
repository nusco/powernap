require 'rack/utils'
require 'json'

module Rack
  # Manages representation formats on the response. It assumes that
  # JSON is both the default format when there is no URL extension,
  # and the format returned by the underlying app.
  class Representations
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      return [status, headers, body] unless ['GET', 'HEAD'].include?(env['REQUEST_METHOD'])

      # FIXME: default behavior if no extension...?
      return [status, headers, body] unless env['PATH_INFO'] =~ /\.([a-z0-9]*)$/
      extension = $1
      
      case extension
      when 'html'
        # FIXME: do this
        [status, headers, body.map {|json| "<p>#{json}</p>"}]
      when 'txt'
        txt = body.map do |el|
          JSON.parse(el).map {|k, v| "#{k}: #{v}"}.join '\n'
        end
        [status, headers, txt]
      when 'json'
        [status, headers, body]
      else
        [415, headers, body]
      end
    end
  end
end
