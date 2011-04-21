require_relative 'powernap/configuration'
require_relative 'powernap/application'
require_relative 'powernap/resource'

require_relative 'powernap/mongoid_resource'
PowerNap::PersistentResource = PowerNap::MongoidResource
