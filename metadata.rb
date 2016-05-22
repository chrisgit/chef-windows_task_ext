name 'windows_task_ext'
maintainer 'Chris Sullivan'
maintainer_email 'n/a'
license 'All rights reserved'
description 'Installs/Configures extension to Windows Cookbook Task resource'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '16.5.11'

issues_url 'https://github.com/chrisgit/chef-windows_task_ext/issues' if respond_to?(:issues_url)
source_url 'https://github.com/chrisgit/chef-windows_task_ext' if respond_to?(:source_url)

supports 'windows'

depends 'windows'