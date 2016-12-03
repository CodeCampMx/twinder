defmodule Twinder.Followers do

  def common_followers(username1, username2) do
    friends_for_u1 = find_friends(username1)
    friends_for_u2 = find_friends(username2)
    followers_of_u1 = find_followers_for(username1)
    followers_of_u2 = find_followers_for(username2)

    bff1 = for friend_id <- friends_for_u1,
               follower <- followers_of_u1,
               friend_id == follower.id,
               do: follower
    bff2 = for friend_id <- friends_for_u2,
               follower <- followers_of_u2,
               friend_id == follower.id,
               do: follower

    common_followers = for follower_u1 <- followers_of_u1,
                           follower_u2 <- followers_of_u2,
                           follower_u1.id == follower_u2.id,
                           do: follower_u1

    common_bff = common_bff(bff1,bff2)
    {common_followers, common_bff}
  end

  def common_bff_followers(bff) do
    bff_followers = for b <- bff, do: { b, ExTwitter.follower_ids(b.id) }
  end

  def matches(user, user2, followers, bff) do
    for f <- followers.items, f == user.id, do: {user.screen_name,user2.screen_name}
    relaciones = for {user1, followers1} <- bff_followers,
                     {user2, followers2} <- bff_followers,
                     do: Twinder.Followers.matches user1,user2, followers2, bff
    relaciones |> Enum.filter(fn x -> Enum.count(x)>0 end) |> Enum.map fn [h|_] -> h end

  end

  def common_bff(bff1, bff2) do
    for bff_of_u1 <- bff1, bff_of_u2 <- bff2, bff_of_u1.id == bff_of_u2.id, do: bff_of_u1
  end

  def find_followers_for(username) do
    join_followers(username, [],-1)
  end

  def join_followers(_,followers, 0) do
    followers
  end

  def join_followers(username,followers, cursor) do
    current_page_followers = ExTwitter.followers(username, count: 200, cursor: cursor)
    join_followers(username, followers ++ current_page_followers.items, current_page_followers.next_cursor)
  end

  def find_friends(username) do
    ExTwitter.friend_ids(username).items
  end

end
