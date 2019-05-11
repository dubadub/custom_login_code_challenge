class Session
  NUMBER_OF_FAILED_ATTEMPTS_BEFORE_LOCK = 3

  include ActiveModel::AttributeAssignment, ActiveModel::Conversion, ActiveModel::Validations

  attr_accessor :handle, :password

  define_model_callbacks :validation

  before_validation :set_user

  validate :check_user_presence
  validate :check_user_is_not_locked, if: :user?
  validate :check_user_password, if: :user?, unless: :locked?

  def initialize(attributes={})
    assign_attributes(attributes) if attributes
    super()
  end

  def save
    return false if invalid?

    @user.update(failed_logins_count: 0) unless @user.failed_logins_count == 0

    true
  end

  def user_id
    @user.try(:id)
  end

  private

  # Predicates

  def valid?
    run_callbacks(:validation) do
      super
    end
  end

  def invalid?
    !valid?
  end

  def user?
    !!@user
  end

  def locked?
    !!@locked
  end

  # Side-effects

  def set_user
    @user = User.find_by('lower(handle) = ?', handle.downcase) if handle
  end

  def check_user_presence
    return if @user

    errors.add(:base, I18n.t("sessions.user_not_found"))
  end

  def check_user_is_not_locked
    return if @user.failed_logins_count < NUMBER_OF_FAILED_ATTEMPTS_BEFORE_LOCK

    @locked = true

    errors.add(:base, I18n.t("sessions.we_locked_account"))
  end

  def check_user_password
    return if @user.password == password

    @user.increment!(:failed_logins_count)

    if @user.failed_logins_count >= NUMBER_OF_FAILED_ATTEMPTS_BEFORE_LOCK
      errors.add(:base, I18n.t("sessions.we_locked_account"))
    else
      if @user.failed_logins_count == NUMBER_OF_FAILED_ATTEMPTS_BEFORE_LOCK - 1
        errors.add(:base, I18n.t("sessions.we_will_lock_account"))
      else
        errors.add(:base, I18n.t("sessions.user_not_found"))
      end
    end
  end

end
