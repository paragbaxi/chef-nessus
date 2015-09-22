#
# Cookbook Name:: nessus
# Recipe:: activate
#
# Copyright 2014, Risk I/O
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Activate! subscription
bash "activate_nessus" do
  code <<-EOH
    ( /opt/nessus/sbin/nessuscli fetch --register #{node.nessus.activation_code} && touch /opt/nessus/activated_by_chef ) || uptime
  EOH
  action :nothing
end
log "Nessus: Activating and updating plugins.. this can take a while" do
  notifies :run, "bash[activate_nessus]", :immediately
  only_if { !File.exists?('/opt/nessus/activated_by_chef') && !node.nessus.activation_code.nil? }
end

# Notify if activation failed
log "Nessus: Activation FAILED" do
  level :warn
  only_if { !File.exists?('/opt/nessus/activated_by_chef') }
end

# Update plugins
bash "update_nessus_plugins" do
  code <<-EOH
  /opt/nessus/sbin/nessuscli update
  EOH
  action :nothing
end
log "Nessus: Updating Plugins" do
  notifies :run, "bash[update_nessus_plugins]", :immediately
  only_if { File.exists?('/opt/nessus/activated_by_chef') }
end
