module Extensions
  module Templates

    # An extension method for convenient printing of values in ERB templates.
    #
    # The method provides several ways how to evaluate the value:
    #
    # 1. Using the key as a node attribute:
    #
    #    <%= print_value 'bar' -%> is evaluated as: `node[:bar]`
    #
    #    You may use a dot-separated key for nested attributes:
    #
    #    <%= print_value 'foo.bar' -%> is evaluated in multiple ways in this order:
    #
    #    a) as `node['foo.bar']`,
    #    b) as `node['foo_bar']`,
    #    c) as `node.foo.bar` (ie. `node[:foo][:bar]`)
    #
    # 2. You may also provide an explicit value for the method, which is then used:
    #
    #    <%= print_value 'bar', node[:foo] -%>
    #
    # You may pass a specific separator to the method:
    #
    #    <%= print_value 'bar', separator: '=' -%>
    #
    # Do not forget to use an ending dash (`-`) in the ERB block, so lines for missing values are not printed!
    #
    def print_value key, value=nil, options={}
      separator = options[:separator] || ': '
      existing_value   = value rescue nil
      existing_value ||= node.elasticsearch[key]
      existing_value ||= node.elasticsearch[key.tr('.', '_')]
      existing_value ||= key.to_s.split('.').inject(node.elasticsearch) { |result, attr| result.send(attr) } rescue nil

      [key, separator, existing_value, "\n"].join if existing_value
    end

  end
end
