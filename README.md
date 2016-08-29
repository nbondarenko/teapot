# About Teapot Data Analyser
This is a simple single-page application powered by Ruby on Rails and AngularJS that provides the main functions for data samples analysis.

##Demo
 Application is deployed to Heroku, so you can test it [here](https://obscure-savannah-34208.herokuapp.com)
##Features
* App is based on JSON API implemented using Ruby on Rails
* Handling responses using AngularJS
* Simple user authorization
* Tests using rspec gem

##Usage
You can make use of the application only if you are an authorizated user.  
To analyse dataset enter it in the appropriate format in the textarea and click on 'Calculate' button. If errors were  occured, check a format of input and try again. To check a correlation coeficient for two datasets go to Correlation check panel, enter your datasets and click on 'Calculate' button.
##Setup
To launch an application on local server, you must have ruby and npm installed on your PC.  
If you have, follow this instructions:  
1. Copy project from Github to your PC  
2. Go to the root directory and open terminal here.  
4. Run `bundle install` to install all the dependencies.  
5. Run `rake db:migrate` to create local database.  
6. Run `rails s` to start a local server.  
Now you are able to access it at localhost:3000.  
To launch tests run `rspec` for all and `rspec file_path` to run every test individually.
