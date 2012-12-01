class Admin::Setting < ActiveRecord::Base
  attr_accessible :app_version, :slogan

  before_create do |setting|
    raise ActiveRecord::ActiveRecordError if Admin::Setting.count > 0
  end

end
