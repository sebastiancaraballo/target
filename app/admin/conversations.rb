ActiveAdmin.register Conversation do
  actions :index, :show

  index do
    selectable_column
    id_column
    column :match
    column :first_user_unread_messages
    column :second_user_unread_messages
    column :created_at
    column :updated_at
    actions
  end

  filter :match
  filter :first_user_unread_messages
  filter :second_user_unread_messages
  filter :created_at
  filter :updated_at
end
