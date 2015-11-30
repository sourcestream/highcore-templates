template = :env

SparkleFormation::Registry.register(:"#{template}_#{:security}") do | id, component = {}, config = {} |

  @outputs[:instance_profile] = ref!(:"#{id}_instance_profile")
  @outputs[:office_network_cidr] = ref!(:"#{id}_office_network")
  @outputs[:instance_role] = ref!(:"#{id}_iam_role")

  registry!(:iam_role, id)
  registry!(:instance_profile, id,
           :roles => _array(ref!(:"#{id}_iam_role"))
  )
end


