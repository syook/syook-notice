	require 'json'
	require 'httparty'
	class SyookNotice
		@@header = { "Content-Type" => "application/json", "Authorization" => "Bearer #{ENV["SENDGRID_SYOOK"]}" }

		def initialize(list, msg, subject)
			@list = list.map(&:to_json)
			@msg = msg
			@subject = subject
		end

		def sendmsg
			@list.each do |obj|
				obj = JSON.parse(obj)
				regex = Regexp.union(obj.keys)
				msg.gsub!(regex, obj)
				msg.gsub!("\n", "<br>")
				json = {
								"personalizations"=> [
									{
										"to"=> [
											{
											"email"=> obj["email"]
											}
										]
									}
								],
								"subject" => @subject,
								"content" => [
															{
																"type" => "text/html",
																"value" => "#{msg}"
															}
														],
								"from"=> {
									"email"=> "support@syook.com"
								},
								"template_id" => "c1e54d1c-72da-451c-9ee4-afa2938f695d"
								}
			response = HTTParty.post("https://api.sendgrid.com/v3/mail/send", headers: @@header, body: json.to_json )
			puts "done"
			puts response
		end
	end
end

	# l =  [ { name: 'Aniket Rao', email: 'aniketrao21@gmail.com', subdomain: 'sandbox', subject: 'changes to your domain' }, { name: 'Aniket Rao', email: 'aniket@syook.com', subdomain: 'sandbox', subject: 'changes to your domain' }]

	#  msg = "name your subdomain has changed please check it."   
	# s = SyookNotice.new((l.map{|n| n.to_json}), msg )
	# s.sendmsg
# msg = "Dear name ji,\n\nWe take this opportunity to thank you for your business. 2017 has been a great year for us and hope it has been the same for you too.\n\nWith a vision to constantly improve your Syook experience, there will be a minor change in the link to access your account. If your current website is subdomain.syook.com, it will now change to subdomain.syookpro.com. There will also be an update to the mobile app. For this week, both the links will work. Starting Jan 2nd, the link of subdomain.syook.com will stop working.\n\nEverything else remains the same. There is no change in the way you use the system.\n\nThe entire Syook team would also like to take this opportunity to wish you a very happy and prosperous new year 2018."

