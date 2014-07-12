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
module Context
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def role(name, role_class=nil)
      role_names << name

      define_method :"set_#{name}" do |obj|
        obj.extend role_class unless role_class.nil?
        obj.context = self if obj.respond_to? :context=
        roles[name] = obj
        self
      end

      protected define_method(name) { roles[name] }
    end

    def role_names
      @role_names ||= []
    end
  end

  def call
    unfilled = unfilled_roles
    unless unfilled.empty?
      raise "Unfilled roles: #{unfilled}"
    end

    act
  end

  protected

  def roles
    @roles ||= {}
  end


  def unfilled_roles
    self.class.role_names.select { |name| roles[name].nil? }
  end
end
