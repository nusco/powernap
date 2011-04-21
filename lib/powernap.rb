require_relative 'powernap/configuration'
require_relative 'powernap/application'
require_relative 'powernap/resource'

require_relative 'powernap/resource/mongoid'
PowerNap::PersistentResource = PowerNap::MongoidResource
