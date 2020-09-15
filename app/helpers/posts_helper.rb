module PostsHelper
  def post_status post
    if post.on?
      {
        css: Settings.status.on_status,
        status: t("post.index.on_status")
      }
    elsif post.off?
      {
        css: Settings.status.off_status,
        status: t("post.index.off_status")
      }
    else
      {
        css: Settings.status.pending_status,
        status: t("post.index.pending_status")
      }
    end
  end

  def list_topics
    Topic.pluck :name, :id
  end

  def post_topic
    @post.topic.present? ? @post.topic.name : true
  end

  def post_order
    {
      max_post: :desc,
      min_post: :asc
    }
  end
end
