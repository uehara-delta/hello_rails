module NumbersComponent
  def number(wrapper_options = nil)
    unless @number
      @number = "#{options[:number]}. ".html_safe if options[:number].present?
    end
  end
end

SimpleForm.include_component(NumbersComponent)
