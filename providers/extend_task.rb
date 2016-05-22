module Provider
	module ExtendTask
		def action_import
			if @current_resource.exists
				unless @new_resource.force
					Chef::Log.info "Schedule task #{@new_resource.name} already exists. Skipping"
					return
				end
				Chef::Log.info "Schedule task #{@new_resource.name} already exists. Force update specified."
			end
			
			if @new_resource.path.nil? || ::File.exist?(@new_resource.path) == false
			  Chef::Log.warn "Schedule task #{@new_resource.name} does not specify a file to import. Skipping"
			  return
			end
			
			converge_by("Importing schedule task #{@new_resource.name}") do
				import_cmd = "schtasks /create /tn \"#{@new_resource.name}\" /xml \"#{@new_resource.path}\" /RU #{@new_resource.user} /RP #{@new_resource.password} /F"
				Chef::Log.debug "Running scheduled task import with #{import_cmd}"
				shell_result = shell_out(import_cmd)
				raise "Failed to import scheduled task #{@new_resource.name}\n#{shell_result.stderr}" if shell_result.exitstatus != 0
			end
		end
	end
end

Chef::Provider::WindowsTask.send(:include, Provider::ExtendTask) if defined?(Chef::Provider::WindowsTask)
