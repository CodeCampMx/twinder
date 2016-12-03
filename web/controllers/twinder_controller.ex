defmodule Twinder.TwinderController do
  use Twinder.Web, :controller

  def index(conn, params) do
    %{"user1" => user1, "user2" => user2} = params
    {followers, bff} = Twinder.Followers.common_followers(user1, user2)
    json conn, %{ followers: followers, bff: bff }
  end
end
