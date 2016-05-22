# Add :import action and path attribute
module Resource
	module ExtendTask
		def initialize(name, run_context=nil)
			super(name, run_context)
			@allowed_actions.push(:import)
		end
		
		def path(arg=nil)
			@allowed_actions.push(:import)
			set_or_return(
			  :path,
			  arg,
			  :kind_of => String	
			)
		end
	end
end

Chef::Resource::WindowsTask.send(:include, Resource::ExtendTask) if defined?(Chef::Resource::WindowsTask)