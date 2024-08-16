defmodule Algora.Multistream do
  alias Algora.{YouTube, Twitch, Twitter}

  def create_destination(user) do
    case user.provider do
      "google" -> create_youtube_destination(user)
      "twitch" -> create_twitch_destination(user)
      "twitter" -> create_twitter_destination(user)
      _ -> {:error, :unsupported_provider}
    end
  end

  defp create_youtube_destination(user) do
    with {:ok, stream_key} <- YouTube.get_stream_key(user) do
      # Create multistream destination using YouTube RTMP URL and stream key
    end
  end

  defp create_twitch_destination(user) do
    with {:ok, stream_key} <- Twitch.get_stream_key(user) do
      # Create multistream destination using Twitch RTMP URL and stream key
    end
  end

  defp create_twitter_destination(user) do
    with {:ok, stream_key} <- Twitter.get_stream_key(user) do
      # Create multistream destination using Twitter RTMP URL and stream key
    end
  end
end
