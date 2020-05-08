module RepliesHelper

  def max_likes_reply(micropost)
    micropost_likes = {}
    micropost.received_replies.each do |m|
      micropost_likes[m] = m.likes_total
    end
    max_likes = (micropost_likes.max { |a, b| a[1] <=> b[1] })[0]
  end

end
