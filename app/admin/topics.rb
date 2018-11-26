ActiveAdmin.register Topic do
  permit_params :label

  index do
    selectable_column
    id_column
    column :label
    column :created_at
    column :updated_at
    actions
  end

  filter :label
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :label
    end
    f.actions
  end
end
