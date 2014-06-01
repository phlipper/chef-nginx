if defined?(ChefSpec)
	def create_nginx_site(resource_name)
		ChefSpec::Matchers::ResourceMatcher.new(:nginx_site, :create, resource_name)
	end

	def delete_nginx_site(resource_name)
		ChefSpec::Matchers::ResourceMatcher.new(:nginx_site, :delete, resource_name)
	end

	def enable_nginx_site(resource_name)
		ChefSpec::Matchers::ResourceMatcher.new(:nginx_site, :enable, resource_name)
	end

	def disable_nginx_site(resource_name)
		ChefSpec::Matchers::ResourceMatcher.new(:nginx_site, :disable, resource_name)
	end
end
