module ErrorCollection
  def collect_errors_from(*objects)

    objects.each do |object|
      object.errors.messages.each do |attribute, errors|
        errors.each do |error|
          self.errors.add("#{underscored_klass}_#{attribute.to_s}",
                          error)
        end
      end
    end
  end

  private

  def underscored_klass
    self.class.to_s.underscore
  end
end
