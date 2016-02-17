class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if @user
      @user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    
    can :manage, [Question, Answer, Comment], user: user
    can :manage, Attachment, attachable: { user: user }
    can :set_best, Answer, question: { user: user }

    alias_action :vote_up, :vote_down, :vote_reset, to: :vote
    can :vote, [Question, Answer]
    cannot :vote, [Question, Answer], user: user

    can :me, User, id: user.id

    can :create, Subscription do |s|
      !s.question.subscribed?(user)
    end

    can :destroy, Subscription do |s|
      s.question.subscribed?(user)
    end
  end
end