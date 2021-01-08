class FollowerPostingMailer < ApplicationMailer
  def follower_posting_email post
    @post = post
    followers = @post.user.followers
    followers.each do |follow|
      mail to: follow.email,
        subject: t("follower_mailer.follower_email.send_mail")
    end
  end
end
