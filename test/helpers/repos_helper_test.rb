require 'minitest/autorun'
# require 'mocha/minitest'
require 'json'

class ReposHelperTest < Minitest::Test
  include ReposHelper

  # TODO: use mocha to mock api response
  def test_transform_repo
    repo = JSON.parse(File.read("test/helpers/single_repo.json"), symbolize_names: true)
    assert_equal "crossroads.js", repo[:name]
  end

  def test_get_last_commit
    commits = JSON.parse(File.read("test/helpers/commits.json"), symbolize_names: true)
    last_commit = ReposHelper.send(:get_last_commit, commits)
    assert_equal "\"Merge pull request #46 from MadBomber/build-gem\n\nAdd gem tasks to main Rakefile\" by \"Thijs Cadier\"", last_commit

    last_commit = ReposHelper.send(:get_last_commit, [])
    assert_equal "\"no commit message\" by \"unknown author\"", last_commit
  end
end