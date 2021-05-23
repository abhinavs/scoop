<img src="https://raw.githubusercontent.com/abhinavs/scoop/master/public/images/scoop-header.png" />

# Scoop
## a production-ready Sinatra boilerplate project using Corneal, ActiveRecord, Capistrano, Puma & Nginx

[Sinatra](http://sinatrarb.com/) is a Ruby framework that helps you quickly create web applications, APIs and microservices. Its minimalism not only attracted a lot of developers, but it also inspired [Flask](https://flask.palletsprojects.com/en/2.0.x/) in Python and [Express](https://expressjs.com/) in Node.js

If you are developing microservices or web APIs, Sinatra is a great choice. However, bootstraping a Sinatra project that is optimized for development speed as well as is easy to deploy has become non trivial because 
1. Documentation is not easy to find (you mostly find Ruby on Rails specific tips)
2. You need to write code to set up and connect DB, manage migrations etc.
3. You need to create a right directory structure yourself and configure it accordingly
4. You also miss a boot file that you can use with console and with custom rake tasks/scripts
5. Setting up projects for deployment is tedious and error prone, with a lot of details to be filled in for Capistrano, Puma and Nginx.

[Scoop](https://github.com/abhinavs/scoop) solves it by providing a good boilerplate that can be a starting point for your next project. It solves all the above mentioned problems and comes up with easy to edit configuration files that can help you correctly configure servers.

Scoop uses
1. [Corneal](http://thebrianemory.github.io/corneal/) to make scaffolding models, controllers and views
2. ActiveRecord as database ORM
3. Capistrano for deployment
4. Puma as app server
5. Nginx as a proxy server

In addition, 
1. it is also JSON API ready with JSON, CORS and JSONP support already enabled,
2. has a RoR like console, and
3. comes up with example script and rake task that can be used to perform tasks that load the environment

Try Sinatra & Scoop by forking [Scoop Repository](https://github.com/abhinavs/scoop/fork)

### Installation & set up
It is very easy to start using scoop as a base for your project, you need to do the following on your development machine
  - `git clone git@github.com:abhinavs/scoop.git APP_NAME` (replace `APP_NAME` with the name of your application, and replace `abhinavs` with your username if you have forked the repo)
  - `rvm install 3.0.1`
  - `gem install corneal`
  - `gem install foreman`
  - `gem install bundler`
  - `cd scoop; bundle install`

You should also see `config/database.yml` file, and change name of the database. After that create the database 
`bundle exec rake db:create` 

### Development
Scoop used Corneal - it is a Sinatra app generator with useful utilities
  - Generate a model: `corneal model NAME`
  - Generate a controller: `corneal controller NAME`
  - Generate a controller with no views: `corneal controller NAME --no-views`
  - Generate a model with its associated views and controllers: `corneal scaffold NAME`

Scoop has JSON integration, and it is perfect for APIs. You can check out [pincodr's controller](https://github.com/abhinavs/pincodr/blob/master/app/controllers/pincodr_controller.rb) to see how to create APIs.

You can migrate data using the following command
`bundle exec rake db:migrate`

### Starting development server
You can start the development server using foreman
`foreman start`

If you open the `http://localhost:9393` you should see a page getting rendered. You can also see `http://localhost:9393/status` for JSON response. Both of these routes are inside `app/controllers/example_controller.rb`

### Console & Rake tasks
From the application directory, do `bundle exec rake console` to open rails like console.

If you want to run create and run custom rake tasks, look at `Rakefile` and `bin/example_script.rb` for example

### Deploying to production
Our production set up uses
  - rvm as ruby version manager
  - We add puma as a `sysctl` service for easy management

>Please note - if you need help in installing RVM and other essential packages, you can check out [this guide on Soopr](https://www.soopr.co/blog/deploy-ruby-on-rails-app-on-aws-graviton-part-1). If you need help in installing database, you can see "Creating A Database" section on [Go Rails' guide](https://gorails.com/deploy/ubuntu/20.04#database)

Assuming you have created the database, and have installed `rvm`, install ruby on the **server(s)** by`rvm install 3.0.1`

  - `rvm use --default 3.0.1` # You can also set it as default
  - `gem install bundler` # Install bundler
  - `sudo apt-get install nginx`

To start with first see `config/deploy.rb` and `config/deploy/production.rb` files, and change the following details
  - Server IPs (`instances` in `config/deploy/production.rb`)
  - Name of the application (`application`)
  - Git repo URL (`repo_url`)
  - Full path of the directory in which you want code to be deployed (`deploy_to`)
  - Name of the deploying user (`deploy_user`) - this user will ssh into the system
  - SSH key (`deploy_ssh_keys`)

### Installing puma as a service
Modify `config/scoop-puma.example.service` 
  - Update `WorkingDirectory`, `ExecStart`, `ExecStop` with right working directory
  - Update `SyslogIdentifier` with the name you want to give. I generally prefer to keep it as the name of the app and puma (scoop-puma) so that you can deploy multiple services.

Modify `config/deploy.rb` and replace `scoop-puma` with the name you have chosen.


Login to the **server(s)** and do the following
  - Create the directory you have mentioned in your `deploy_to` variable
  - Create an .prod-env in that directory (look at `config/prod-env`) file as an example. You need DATABASE_URL, SINATRA_ENV & RACK_ENV variables. Add any other credentials you have to use.

From your local machine, deploy code by `cap production deploy`  - this step may not succeed, but ensure your code reaches the server.

On the **server(s)**, now we need to install puma as a service (I am copying it as scoop-puma.service, you should use the service name you have given in SyslogIdentifier)
  - `cp config/scoop-puma.example.service /usr/lib/systemd/system/scoop-puma.service` 
  - `sudo systemctl daemon-reload`
  - `sudo systemctl enable scoop-puma.service`


From your local machine, deploy code once again using `cap production deploy` - ideally this time, deployment should succeed and puma server should come up.

Check if puma server is up or not by `sudo service scoop-puma status`

### Config Nginx
Modify `scoop.nginx.conf' and change the following things
  - Name of the server `server_name`
  - Path wherever you see - this path is the server path, and will have `current` in it.

On the `server(s)` copy this config file to /etc/nginx/sites-enabled/scoop.conf and restart the nginx (`sudo service nginx restart`) 

(You might have to symlink scoop.conf file in sites-available directory too - you can do that by `sudo ln -s /etc/nginx/sites-enabled/scoop.conf /etc/nginx/sites-available/scoop.conf`)

### Final Deploy
Deploy it once again `cap production deploy` 


contact: [abhinav][1] | [homepage][2]

 [1]: https://twitter.com/abhinav "abhinav"
 [2]: https://www.abhinav.co "homepage"

## Other Projects
If you like Scoop, do check out my other projects
*   [cookie](https://github.com/abhinavs/cookie) - a free landing website boilerplate using Jekyll and Tailwind CSS
*   [moonwalk](https://github.com/abhinavs/moonwalk) - a fast and minimal blog theme with clean dark mode
*   [soopr](https://www.soopr.co) - a tool that supports you in content marketing
*   [apicagent](https://www.apicagent.com) - a FREE API that extracts device details from user-agent string
*   [pincodr](https://pincodr.apiclabs.com) - a FREE API for Indian pincodes
*   [humangous](https://www.humangous.co) - create public and private 'working with you' guides
*   [blockr](https://www.abhinav.co/blockr) - a CLI tool to help you easily block and unblock websites
*   [microrequests](https://www.abhinav.co/microrequests) - a Python library to help you consume microservice efficiently


✨⚡You can read more about me on my [blog](https://www.abhinav.co/about/) or follow me on Twitter- [@abhinav](https://twitter.com/abhinav)

