class WelcomeController < ApplicationController
   def index
     flash[:notice] = "你好！Rails"
   end
end
