OAUTH2_CONFIG = OpenStruct.new(YAML.load(File.open("config/oauth2.yml")))
UI_CONFIG = OpenStruct.new(YAML.load(File.open("config/ui.yml")))