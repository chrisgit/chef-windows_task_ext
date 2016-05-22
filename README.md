Windows Task Ext
====================
We want to use the Start In / Working Directory (cwd) functionality of the Windows Task resource as documented here: https://github.com/chef-cookbooks/windows#windows_task
Unfortunately the cwd functionality was not implimented until the Windows cookbook version 1.39.0.
The code to alter the cwd of the Windows Task in the Windows cookbook works well with Chef 12 but fails with Chef 11.
To alter the cwd, the Windows cookbook outputs the Schedule Task to an XML file and uses Ruby's REXML/document, which unfortunately has a few issues in Ruby 1.9.3 (the version supplied with Chef 11).
After burning up a weekend trying to get the Schedule Task XML to work with the version of REXML supplied with Ruby 1.9.3 I gave up and resorted to three alternative solutions.

1. Let the Windows cookbook create the schedule task, then use an execute resource to update the schedule task using the "schtasks" command passing in the full path to the program (or script) we want to run and using the /V1 parameter to set the working directory and /F parameter to force an update of the task.
The is fine if the schedule task working directory is the same as the location of the program (or script) you wish to run, however it will not work if your working directory needs to be different from the program (or script) directory.

2. Create a new resource and provider for schedule taks and use the PowerShell commandlets: https://technet.microsoft.com/en-us/library/jj649816(v=wps.630).aspx
The advantage is that we can create a really good idempotent resource with this method (out of the box the Windows task resource looks at the user and command for idempotency). The disadvantage is that to create a simple resource you have to create actions and triggers then attach them to the task.
There is already a pending pull request to improve the Schedule Task resource to use Win32/OLE https://github.com/chef-cookbooks/windows/pull/255

3. Create a new provider and resource based on the existing Windows task provider and resource to allow a schedule task to be imported.
Advantages are the resource can be complex, can use a Start In / Working directory. Disadvantages are it's hard to make idempotent.

Rather than create a new resource (which means changing the code to use a new resource name) and new provider this horrible monkey patch uses the existing Windows task resource and providers.

Requirements
------------
Includes the Windows cookbook and monkey patches the task resource (to add a path) and task provider to impliment a basic import facility.

Usage
-----
Add cookbook to your Berksfile.
````
cookbook 'windows_task_ext', git: 'c:/temp/chef\serverspec/chef-windows_task_ext'
````
Add a dependency to this cookbook in your metadata.rb.
````
depends 'windows_task_ext'
````

Export your scheduled task, add it as a cookbook file or upload to your repository/file store.
Use the :import actions, below assumes the schedule task is included as part of your cookbook and stored in the files folder.
````
directory 'c:/temp' do
	action :create
end

cookbook_file 'c:/temp/chef-client.xml' do
	source 'chef-client.xml'
	action :create
end

windows_task 'chef-client' do
  user windows_username
  password windows_username_password
  path 'c:/temp/chef-client.xml'
  action :import
end

````

Contributing
------------
Fork or branch, enhance, add tests as appropriate, pull request.

License and Authors
-------------------
Authors: Chris Sullivan
