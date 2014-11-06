namespace :swagger do

  desc "Generate Swagger documentation files"
  task docs: [:environment] do |t,args|
    apis    = Swagger::Docs::Config.registered_apis
    results = Swagger::Docs::Generator.write_docs(apis)
    results.each do |k,v|
      puts "%{k}: %{processed} processed / %{skipped} skipped" % {
        k:         k,
        processed: v[:processed].count,
        skipped:   v[:skipped].count
      }
    end
  end
end
