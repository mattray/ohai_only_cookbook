#
# Cookbook:: ohai_only
# Recipe:: default
#

ruby_block "evaluating ohai_only" do
  block do
    throw :end_client_run_early
  end
  only_if { node['ohai_only'] }
end
