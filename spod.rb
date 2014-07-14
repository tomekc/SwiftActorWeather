require 'rubygems'
require 'xcodeproj'

project = Xcodeproj::Project.open('ActorWeather.xcodeproj')

puts project.build_configurations
frameworks = project['Frameworks']
puts frameworks


exit
puts "Create workspace"

workspace = Xcodeproj::Workspace.new
workspace << 'ActorWeather.xcodeproj'

workspace << 'SwiftPods/Swactor/Swactor.xcodeproj'

workspace.save_as('ActorWeather.xcworkspace')

