template = :env

SparkleFormation::Registry.register(:"#{template}_#{:subnet}") do | id, component = {}, config = {} |

  @outputs[:subnet_ids] ||= []
  @outputs[:subnet_ids] << ref!(:"#{id}_subnet")

  # TODO pass as a parameter
  vpc_id = component[:components].select{ | key, component_data | component_data[:template_component].to_sym == :vpc }.values.first[:id]

  registry!(:subnet, id,
      :cidr_block => ref!(:"#{id}_cidr"),
      :vpc_id => ref!(:"#{vpc_id}_vpc"),
      :route_table_id => ref!(:"#{vpc_id}_route_table"),
      :availability_zone => ref!(:"#{id}_az"),
  )

end