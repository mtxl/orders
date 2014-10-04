module I18nPatch
  def self.included(base)
    base.send(:include, BackendInstanceMethods)
  end

  module BackendInstanceMethods
    def init_translations(locale)
      locale = locale.to_s
      # TODO check if locale has more 2 char (rn-GB)
      paths = ::I18n.load_path.select {|path| File.basename(path, '.*')[-2..-1] == locale}
      load_translations(paths)
      translations[locale] ||= {}
    end
  end
end

Redmine::I18n::Backend.send(:include, I18nPatch)
