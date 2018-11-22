ActiveAdmin.register Match do
  actions :index, :show

  index do
    selectable_column
    id_column
    column :first_user
    column :second_user
    column :spot
    column :created_at
    column :updated_at
    actions
  end

  filter :first_user
  filter :second_user
  filter :spot
  filter :created_at
  filter :updated_at
end
