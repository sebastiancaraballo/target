ActiveAdmin.register Message do
  actions :index, :show
  index do
    selectable_column
    id_column
    column :conversation
    column :sender
    column :content
    column :created_at
    column :updated_at
    actions
  end

  filter :conversation
  filter :sender
  filter :created_at
  filter :updated_at
end
