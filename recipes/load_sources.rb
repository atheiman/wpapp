file "/etc/apt/sources.list" do
    action :delete
end

cookbook_file "/etc/apt/sources.list" do
    source "sources.list"
    mode "0644"
end
