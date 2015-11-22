template = :env

SparkleFormation::Registry.register(:"#{template}_#{:private_zone}") do | id, component = {}, config = {} |

  @outputs[:private_zone_id] = ref!(:"#{id}_hosted_zone")
  @outputs[:private_zone_name] = :"#{config[:name]}"

  # TODO pass as a parameter
  vpc_id = component[:components].select{ | key, component_data | component_data[:template_component].to_sym == :vpc }.values.first[:id]

  registry!(:hosted_zone, id,
           :name => config[:name],
           :vpc_id => ref!(:"#{vpc_id}_vpc")
  )
end
