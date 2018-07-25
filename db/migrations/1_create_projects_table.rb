Sequel.migration do
  change do
    create_table :projects do
      primary_key :id, type: :Bignum
      String :type
      column :data, 'json'
    end
  end
end

