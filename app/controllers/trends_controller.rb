class TrendsController < ApplicationController

  def create
    trend = current_user.add_trend(params[:name], params[:url])
    if trend.nil?
      respond_to do |format|
        format.json {render json:  {errors: 'You already have the trending topic'}, status: 422 }
      end
    else
      respond_to do |format|
        format.json  {render json: trend , status: 200}
      end
    end
  end

end