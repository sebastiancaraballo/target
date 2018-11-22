ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :name, :gender, :avatar

  index do
    selectable_column
    id_column
    column :provider
    column :uid
    column :email
    column :name
    column :gender
    column :push_token
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :updated_at
    actions
  end

  filter :provider
  filter :uid
  filter :email
  filter :name
  filter :gender
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :name
      f.input :gender
      f.input :password
      f.input :password_confirmation
    end

    f.inputs I18n.t('active_admin.forms.user.avatar_input'), multipart: true do
      f.input :avatar, as: :file
    end

    f.actions
  end
end
