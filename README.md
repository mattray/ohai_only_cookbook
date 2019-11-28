# ohai_only

This cookbook is used to have the chef-client exit out immediately but still save ohai data on the Chef Server and Automate. It is managed by an attribute `node['ohai_only']` that is set to `false` by default. If the attribute is set to `true` the Chef client run will end as soon as the condition is met during the converge phase. Because it is in the converge phase the `ohai_only::default` recipe needs to be at the beginning of the run_list or other resources may still be executed. The `run_list` of the node is unchanged, but additional resources after this recipe are no longer converged.

## Toggling ohai_only
You can control this attribute via policyfiles, roles, environments, etc. as long as you ensure that you reset it back to `false` when you are ready to re-enable the rest of your run_list. If you are using `chef-client -j file.json` to manage attributes, this persists on the Chef server and you can toggle it back and forth with different JSON files.

### Enabling ohai_only via JSON file

```
{"ohai_only":true}
```

`chef-client -j ohai_only_true.json`

### Disabling ohai_only via JSON file
```
{"ohai_only":false}
```

`chef-client -j ohai_only_false.json`


## Testing

The `kitchen.yml` has tests for `true` and `false`, here's what the (truncated) Chef-client runs look like:

### True
```
       Starting Chef Infra Client, version 15.5.17
       resolving cookbooks for run list: ["ohai_only::default", "ohai_only::next"]
       Synchronizing Cookbooks:
         - ohai_only (0.1.0)
       Installing Cookbook Gems:
       Compiling Cookbooks...
       Converging 2 resources
       Recipe: ohai_only::default
         * ruby_block[evaluating ohai_only] action run

           Running handlers:
           Running handlers complete
           Chef Infra Client finished, 0/0 resources updated in 01 seconds
       Downloading files from <trueth-ubuntu-1804>
       Finished converging <trueth-ubuntu-1804> (0m2.94s).
```

### False

```
     Starting Chef Infra Client, version 15.5.17
       resolving cookbooks for run list: ["ohai_only::default", "ohai_only::next"]
       Synchronizing Cookbooks:
         - ohai_only (0.1.0)
       Installing Cookbook Gems:
       Compiling Cookbooks...
       Converging 2 resources
       Recipe: ohai_only::default
         * ruby_block[evaluating ohai_only] action run (skipped due to only_if)
       Recipe: ohai_only::next
         * log[ohai_only was set to false] action write


       Running handlers:
       Running handlers complete
       Chef Infra Client finished, 1/2 resources updated in 01 seconds
       Downloading files from <falseth-ubuntu-1804>
       Finished converging <falseth-ubuntu-1804> (0m2.95s).
```
