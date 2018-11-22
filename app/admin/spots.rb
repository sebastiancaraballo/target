ActiveAdmin.register Spot do
  permit_params :title, :latitude, :longitude, :radius, :user_id, :topic_id

  index do
    selectable_column
    id_column
    column :title
    column :latitude
    column :longitude
    column :radius
    column :user
    column :topic
    column :created_at
    column :updated_at
    actions
  end

  filter :title
  filter :latitude
  filter :longitude
  filter :radius
  filter :user
  filter :topic
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :latitude
      f.input :longitude
      f.input :radius, min: 1
      f.input :user, label: I18n.t('active_admin.forms.spot.user_input_label'),
                     as: :select, collection: SpotDecorator.users
      f.input :topic, label: I18n.t('active_admin.forms.spot.topic_input_label'),
                      as: :select, collection: SpotDecorator.topics
    end
    f.actions
  end
end
