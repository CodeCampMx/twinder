defmodule Twinder.FollowerTest do
  use ExUnit.Case

  test "given two usernames give me the common followers" do
    followers = Twinder.Follower.followers_for("user1","user2")
    assert followers, ["neodevelop","jmalonsos","other"]
  end

end
