module Refinery
  module Crud

    puts "MONKEY PATCHING Refinery::Crud"

    def self.default_options(model_name)
      class_name = "#{model_name.to_s.camelize.gsub('/', '::')}".gsub('::::', '::')
      this_class = class_name.constantize.base_class
      singular_name = this_class.to_s.demodulize.underscore
      plural_name = singular_name.pluralize

      {
        :conditions => '',
        :include => [],
        :order => ('position ASC' if this_class.table_exists? && this_class.column_names.include?('position')),
        :paging => true,
        :per_page => false,
        :redirect_to_url => "refinery.#{Refinery.route_for_model(class_name.constantize, :plural => true)}",
        :searchable => true,
        :search_conditions => '',
        :sortable => true,
        :title_attribute => "title",
        :xhr_paging => false,
        :class_name => class_name,
        :singular_name => singular_name,
        :plural_name => plural_name
      }
    end
  end
end
