require 'rails/generators/active_record'
 
module ActiveRecord
  module Generators
    class CangemGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def copy_role_migration
      	if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "role_migration_existing.rb", "db/migrate/add_cangem_to_#{table_name}.rb", migration_version: migration_version
        else
          migration_template "role_migration.rb", "db/migrate/cangem_create_#{table_name}.rb", migration_version: migration_version
        end
      end

      def copy_user_roles_migration
      	if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "user_role_migration_existing.rb", "db/migrate/add_cangem_to_#{table_name}.rb", migration_version: migration_version
        else
          migration_template "user_role_migration.rb", "db/migrate/cangem_create_#{table_name}.rb", migration_version: migration_version
        end
      end

      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end

      def inject_cangem_content
        content = model_contents

        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end

      def role_migration_data
<<RUBY
      	t.string :name
   RUBY
      end

      def user_role_migration_data
<<RUBY
      	t.belongs_to :user
      	t.belongs_to :role
   RUBY
      end

      def ip_column
        # Padded with spaces so it aligns nicely with the rest of the columns.
        "%-8s" % (inet? ? "inet" : "string")
      end

      def inet?
        postgresql?
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def postgresql?
        config = ActiveRecord::Base.configurations[Rails.env]
        config && config['adapter'] == 'postgresql'
      end

     def migration_version
       if rails5?
         "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
       end
     end
    end
  end
end