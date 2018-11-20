module AdminRailsAdmin
  extend ActiveSupport::Concern
  included do
    rails_admin do
      common_attrs = %w[name email]
      list do
        common_attrs.each { |attr| field attr }
        field :created_at
        field :updated_at
      end
      show do
        field :id
        common_attrs.each { |attr| field attr }
        field :created_at
        field :updated_at
      end
      edit do
        common_attrs.each { |attr| field attr }
        field :password
      end
    end
  end
end
