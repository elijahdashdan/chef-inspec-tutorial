# copyright: 2018, The Authors

title "NGINX section"

nginx_params = yaml(content: inspec.profile.file('params.yml')).params
required_ver = nginx_params['version']
required_mods = nginx_params['modules']

# you can also use plain tests
describe file("/tmp") do
  it { should be_directory }
end

# you add controls here
control "nginx-version" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title "NGINX version"             # A human-readable title
  desc "The required verison of NGINX"
  describe nginx do                  # The actual test
    its('version') { should cmp >= required_ver }
  end
end

control "nginx-modules" do
  impact 1.0
  title "Check NGINX modules"
  desc "verify NGINX modules should be installed"
  describe nginx do
    required_mods.each do |required_mod|
    its('modules') {should include required_mod}
    end
  end
end

control "nginx-conf" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title "NGINX configuration"             # A human-readable title
  desc "The NGINX configuration should be owned by root"
  describe file('/etc/nginx/nginx.conf') do                  # The actual test
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should_not be_readable.by('others') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end
end
