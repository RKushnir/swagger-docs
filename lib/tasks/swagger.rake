namespace :swagger do

  desc "Generate Swagger documentation files"
  task docs: [:environment] do |t,args|
    apis    = Swagger::Docs::Config.registered_apis
    results = Swagger::Docs::Generator.write_docs(apis)
    results.each do |api_version, v|
      puts "%{api_version}: %{processed} processed / %{skipped} skipped" % {
        api_version: api_version,
        processed:   v[:processed].count,
        skipped:     v[:skipped].count
      }
    end
  end
end
