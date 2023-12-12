require 'minitest/autorun'
require 'mocha/minitest'
require 'json'

class ReposHelperTest < Minitest::Test
  include ReposHelper
  include ApplicationHelper

  def test_get_repos
    ApplicationHelper.expects(:get_json).with("https://api.github.com/orgs/aboutsource/repos?visibility=public&sort=updated").returns([])

    repos = ReposHelper.send(:get_repos)
    assert_nil repos
  end

  def test_transform_repo
    commits = JSON.parse(File.read("test/helpers/commits.json"), symbolize_names: true)
    ApplicationHelper.expects(:get_json).with("https://api.github.com/repos/aboutsource/crossroads.js/commits?per_page=1").returns(commits)

    repo = JSON.parse(File.read("test/helpers/single_repo.json"), symbolize_names: true)
    transformed = ReposHelper.send(:transform_repo, repo)

    assert_equal "crossroads.js", transformed[:name]
    assert_equal "\"Merge pull request #46\" by \"Thijs Cadier\"", transformed[:last_commit]
  end

  def test_get_last_commit
    commits = JSON.parse(File.read("test/helpers/commits.json"), symbolize_names: true)
    last_commit = ReposHelper.send(:get_last_commit, commits)
    assert_equal "\"Merge pull request #46\" by \"Thijs Cadier\"", last_commit

    last_commit = ReposHelper.send(:get_last_commit, [])
    assert_equal "\"no commit message\" by \"unknown author\"", last_commit
  end
end