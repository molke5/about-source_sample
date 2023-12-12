class ReposController < ApplicationController
	include ReposHelper

  def index
    @repos = ReposHelper.get_repos
  end
end
