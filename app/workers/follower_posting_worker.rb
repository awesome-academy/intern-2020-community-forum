class FollowerPostingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform post_id
    @post = Post.find_by id: post_id
    FollowerPostingMailer.send("follower_posting_email", @post)
                         .deliver
  end
end
