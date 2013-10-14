# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Secushare::Application.initialize!

#Formatting DateTime to look like "10/20/2011 10:28PM"  
Time::DATE_FORMATS[:default] = "%m/%d/%Y %l:%M%p"

