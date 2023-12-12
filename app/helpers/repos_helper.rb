module ReposHelper
	include ApplicationHelper

	GET_REPOS_URL = "https://api.github.com/orgs/aboutsource/repos?visibility=public&sort=updated"
	GET_COMMITS_URL = "https://api.github.com/repos/aboutsource/%s/commits?per_page=1"

	class << self

		def get_repos
			repos = ApplicationHelper.get_json(GET_REPOS_URL)
			return nil if repos.blank?

			repos.map { |repo| transform_repo(repo) }.compact
		end

		private

		def transform_repo(repo)
			repo_name = repo[:name]
			return nil if repo_name.blank?

			commits = get_commits(repo_name)
			updated = DateTime.parse(repo[:updated_at])

			Repo.new(name: repo_name, last_commit: get_last_commit(commits), git_updated_at: updated)
		end

		def get_commits(repo_name)
			commits_url = GET_COMMITS_URL % [repo_name]
			ApplicationHelper.get_json(commits_url)
		end

		def get_last_commit(commits)
			message = commits.dig(0, :commit, :message) || "no commit message"
			author = commits.dig(0, :commit, :author, :name) || "unknown author"

			"\"#{message}\" by \"#{author}\""
		end
	end
end
