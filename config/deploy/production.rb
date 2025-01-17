set :rails_env, "production"

# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}
server 'sakura', roles: %w{web app db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{mrhorin@sakura}
role :web, %w{mrhorin@sakura}
role :db,  %w{mrhorin@sakura}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#   keys: [File.expand_path('/wordle_maker_api/.ssh/id_rsa')],
#   port: 28527,
# }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }

# Prevent an error: 'manpath can't set the locale make sure $lc_* and $lang are correct'
set :default_env, {
  LANG: 'C.UTF-8'
}

append :linked_files, "config/credentials/production.key", "config/ga4_credential.json", "public/robots.txt"

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/credentials/production.key ]")
          upload! 'config/credentials/production.key', "#{shared_path}/config/credentials/production.key"
        end
      end
    end

    before :linked_files, :set_ga4_credential do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/ga4_credential.json ]")
          upload! 'config/ga4_credential.json', "#{shared_path}/config/ga4_credential.json"
        end
      end
    end

    before :linked_files, :set_robots_txt do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/public/robots.txt ]")
          upload! 'public/robots.txt', "#{shared_path}/public/robots.txt"
        end
      end
    end
  end
end