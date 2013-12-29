class HomeController < ApplicationController

  def templates
    partial = params[:template]

    render :partial => "templates/#{partial}", :layout => false
  end
end
