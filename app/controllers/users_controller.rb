require 'date'
require 'uuid'
class UsersController < ApplicationController


  def index
    @users = UserModel.find_all

    hash = []
    @users.each do |user|
      hash << user.value
    end

    respond_to do |format|
      format.html
      format.json { render :json => hash.as_json }
    end
  end

  def create
    uid = UUID.new
    user = UserModel.new(ActiveSupport::JSON.decode(params[:data]))
    UserModel.add(uid, user)
    render :text => nil, :status => :ok
  end

end