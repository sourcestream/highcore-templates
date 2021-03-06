template = :highcore
template_component = :api

SparkleFormation::Registry.register(:"#{template}_#{template_component}") do | id, component = {}, config = {} |

  domain = config[:public_zone] ? ref!(:"#{id}_public_record_set") : attr!("#{id}_instance".to_sym, :public_dns_name)
  @outputs[:"#{id}_#{template_component}_url"] = join!(["https://", domain])

  api_domain = join!("#{id}-", _stack_name, ".", ref!(:public_zone))
  ref_params = {
      :api_domain => config[:api_domain] || api_domain
  }

  if config[:monitoring_hostname]
    ref_params[:monitoring_hostname] = ref!(:monitoring_hostname)

    # Security groups
    registry!(:security_group_ingress, :"#{id}_monitoring_5671",
             :group_id => ref!(:monitoring_security_group),
             :port => 5671,
             :source_security_group_id => ref!(:"#{id}_security_group")
    )
  end

  files = [
      -> {[:files_known_hosts, id,
           :host_keys => [config[:repository_host_key]]]},
      -> {[:files_ansible_ec2_inventory, id,
           :stack_name => ref!('AWS::StackName'),
           :region => ref!('AWS::Region')]},
      -> {[:files_ansible_vars, id,
           component[:parameters],
           ref_params]},
      -> {[:files_ansible_provision, id,
           :repository => config[:playbook_repository],
           :version => config[:playbook_version],
           :playbook => template]}
  ]

  files = files << -> {[:files_ansible_vault_password, id, :password => ref!(:vault_password)]} if config[:vault_password]
  files = files << -> {[:files_private_key, id, :key => ref!(:private_key)]} if config[:private_key]

  registry!(:single_instance, id.to_sym,
            :role => template_component,
            :security_groups => [ref!(:office_network_security_group)],
            :private_zone_id => ref!(:private_zone_id),
            :private_zone_name => ref!(:private_zone_name),
            :image_id => config[:image_id],
            # :spot_price => ref!(:"#{id}_spot_price"),
            # :with_wait_handle => false,
            :files => files,
            :packages => {},
            :commands => {
                :provision => {
                    :command => 'ansible-provision'
                }
            }
  )

  # DNS
  registry!(:record_set, :"#{id}_public",
           :name => api_domain,
           :target => attr!("#{id}_instance".to_sym, :public_dns_name),
           :hosted_zone_name => ref!(:public_zone),
           :type => 'CNAME',
  ) if config[:public_zone]

  registry!(:"#{template}_common")
end
