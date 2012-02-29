require 'date'
require 'uuid'
class UsersController < ApplicationController

  def search
    data = ActiveSupport::JSON.decode(params[:data])
    query = data["search_query"]
    Rails.logger.info "searching...#{query}"
    results = UserModel.search(query)

    hash = []
    results.each do |result|
      Rails.logger.info result.inspect
      hash << result
    end

    respond_to do |format|
      format.json { render :json => hash.as_json }
    end
  end

  def index
    @users = UserModel.find_all

    hash = []
    @users.each do |user|
      Rails.logger.info user.value.class
      hash << user.value
    end

    respond_to do |format|
      format.html
      format.json { render :json => hash.as_json }
    end
  end

  def create
    uid = rand(10000).to_s.to_java
    data = HashIt.new(ActiveSupport::JSON.decode(params[:data]))
    user = UserModel.new(data.firstname, data.lastname)
    UserModel.add(uid, user)
    render :text => nil, :status => :ok
  end

end