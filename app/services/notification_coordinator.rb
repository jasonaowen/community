require 'set'

class NotificationCoordinator
  attr_reader :notifiers, :email_recipients

  def initialize(*notifiers)
    @notifiers = notifiers
    @email_recipients = Hash.new { |h, k| h[k] = [] }
  end

  def notify
    users.each do |u|
      notifiers.each do |n|
        if n.possible_recipient?(u) && n.should_email?(u)
          email_recipients[n] << u
          break
        end
      end
    end

    notifiers.each do |n|
      n.notify(email_recipients[n])
    end
  end

private
  def users
    @users ||= notifiers.map do |n|
      n.possible_recipients
    end.inject(Set.new) { |s1, s2| s1 | s2 }
  end
end
