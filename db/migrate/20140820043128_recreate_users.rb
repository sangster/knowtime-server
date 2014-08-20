# This file is part of the KNOWtime server.
#
# The KNOWtime server is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# The KNOWtime server is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with the KNOWtime server.  If not, see <http://www.gnu.org/licenses/>.
class RecreateUsers < ActiveRecord::Migration
  def up
    drop_table :users

    create_table :users do |t|
      t.integer :data_set_id
      t.uuid    :uuid,        default: 'uuid_generate_v4()',              unique: true
      t.boolean :active,      default: false,                null: false
      t.boolean :seems_valid, default: false,                null: false
      t.string  :trip_id,     default: nil

      t.timestamps
    end

    add_index :users, :data_set_id
    add_index :users, :uuid
  end

  def down
    drop_table :users
    CreateUsers.new.migrate :up # go back to the previous version of this table
  end
end
