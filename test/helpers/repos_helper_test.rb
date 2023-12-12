require 'minitest/autorun'
require 'mocha/minitest'
require 'json'

class ReposHelperTest < Minitest::Test
  include ReposHelper

  def test_repo_transformation
    repo = JSON.parse(File.read("test/helpers/single_repo.json"), symbolize_names: true)
    assert_equal "crossroads.js", repo[:name]

    transformed = ReposHelper.send(:transform_repo, repo)
    assert_equal "crossroads.js", transformed[:name]
    assert_equal "unknown", transformed[:last_commit]
  end
end