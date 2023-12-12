class ReposController < ApplicationController
	include ReposHelper

  def index
    @repos = Rails.cache.fetch("repos", expires_in: 1.minute) do
      # Repo.all.order(git_updated_at: :desc)
      puts "fetching"
      ReposHelper.get_repos
    end

    # if repos.blank?
    #   repos = ReposHelper.get_repos
    #   repos&.each { |repo| repo.save }
    # end

    # @repos = repos
  end

  def repos
    render :json => ReposHelper.get_repos
  end
end
