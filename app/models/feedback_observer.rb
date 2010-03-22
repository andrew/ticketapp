class FeedbackObserver < ActiveRecord::Observer
  def after_create(feedback)
     UserNotifier.deliver_new_feedback
  end
end
