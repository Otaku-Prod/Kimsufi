external_url 'http://gitlab.example.com:8929'
gitlab_rails['gitlab_shell_ssh_port'] = 2224
gitlab_rails['initial_root_password'] = File.read('/run/secrets/gitlab_root_password').gsub("\n", "")