defmodule Twinder.Followers do

  def followers_for(username1, username2) do
    friends_for_u1 = find_friends_for(username1)
    friends_for_u2 = find_friends_for(username2)
    followers_of_u1 = find_followers(username1)
    followers_of_u2 = find_followers(username2)
    #following_for_u1 = for f <- friends_u1, f.following == true, do: f
    #following_for_u2 = for f <- friends_u2, f.following == true, do: f
    {friends_for_u1, followers_of_u1, friends_for_u2, followers_of_u2}
  end

  def find_friends_for(username) do
    join_friends(username, [],-1)
  end

  def join_friends(_,friends, 0) do
    friends
  end

  def join_friends(username,friends, cursor) do
    current_page_friends = ExTwitter.friends(username, count: 200, cursor: cursor)
    join_friends(username, friends ++ current_page_friends.items, current_page_friends.next_cursor)
  end

  def find_followers(username) do
    ExTwitter.follower_ids(username)
  end

end
