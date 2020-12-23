module Acme
  class Ping < Grape::API
    format :json

    moesif_options = {
      'application_id' => 'Your Moesif Application Id',
      'skip' => Proc.new { |env, headers, body|
        if env.key?("REQUEST_URI")
            # Skip probes to health 
            env["REQUEST_URI"].include? "/health"
        else
            false
        end
      }
    }

    insert_after Grape::Middleware::Formatter, MoesifRack::MoesifMiddleware, moesif_options

    get '/ping' do
      { ping: 'pong' }
    end
  end
end
