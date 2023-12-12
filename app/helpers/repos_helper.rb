module ReposHelper
	include ApplicationHelper

	GET_REPOS_URL = "https://api.github.com/orgs/aboutsource/repos?visibility=public&sort=updated"
	GET_COMMITS_URL = "https://api.github.com/repos/aboutsource/%s/commits?per_page=1"

	class << self

		def get_repos
			# return [
			# 	{
			# 		name: 'test',
			# 		last_commit: 'gfy'
			# 	},
			# 	{
			# 		name: 'test2',
			# 		last_commit: 'this commit message is really long to test what it looks like if the commit message is really long'
			# 	},
			# 	{
			# 		name: 'test3',
			# 		last_commit: 'hello my name is fred'
			# 	}
			# ]
			# repos = []

			repos = ApplicationHelper.get_json(GET_REPOS_URL)
			return nil if repos.blank?

			repos.map { |repo| transform_repo(repo) }.compact
		end

		private

		def transform_repo(repo)
			repo_name = repo[:name]
			return nil if repo_name.blank?

			commits = get_commits(repo_name)

			{
				name: repo_name,
				last_commit: get_last_commit(commits)
			}
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
