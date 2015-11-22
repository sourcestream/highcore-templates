template = :env

SparkleFormation::Registry.register(:"#{template}_#{:vpc}") do | id, component = {}, config = {} |

  @outputs[:vpc_id] = ref!(:"#{id}_vpc")

  registry!(:vpc, id,
           :cidr_block => ref!(:"#{id}_cidr"),
  )

end
