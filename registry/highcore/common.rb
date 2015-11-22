template = :highcore

SparkleFormation::Registry.register(:"#{template}_common") do
  registry!(:security_group, :office_network,
           :rules => [{
               :port => '22',
               :cidr_ip => ref!(:office_network_cidr),
           }],
           :vpc_id => ref!(:vpc_id)
  )
end
