class AddPaymentCycleIdToProjectRequestForms < ActiveRecord::Migration
  def change
    add_column :project_request_forms, :payment_cycle_id, :integer
  end
end
