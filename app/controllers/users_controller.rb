require 'date'
require 'uuid'
class UsersController < ApplicationController


  def index
    @users = UserModel.find_all
    Rails.logger.debug @users.size
  end

  def create
    uid = UUID.new
    user = UserModel.new(ActiveSupport::JSON.decode(params[:data]))
    UserModel.add(uid, user)

    render :text => nil, :status => :ok
  end

end