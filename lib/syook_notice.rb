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
			@list.each do |l|
				obj = l
				obj = JSON.parse(obj)
				obj["name"] = obj["name"].split(" ").map(&:capitalize).join(" ")
				regex = Regexp.union(obj.keys)
				msg = @msg
				msg = msg.gsub(regex, obj)
				msg = msg.gsub("\n", "<br>")
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
				if (msg.include?( obj["name"]) && msg.include?(obj["subdomain"]))
					puts "sending to #{obj["name"]} of #{obj["subdomain"]}"
					response = HTTParty.post("https://api.sendgrid.com/v3/mail/send", headers: @@header, body: json.to_json )
					puts response
					sleep 3
					next
				end
				puts "Going to next"
				next
			
		end
	end
end

	# data =  [ { name: 'aniket rao', email: 'aniket@syook.com', subdomain: 'sandbox' }, { name: 'tejas gowda', email: 'tejas@syook.com', subdomain: 'randbox'},{	name: 'aman agarwal',email: 'aman@syook.com',subdomain: 'newbox'},{name: 'arjun nagarajan' , email: 'arjun@syook.com',subdomain: 'gearbox' },{name: 'pallavi hegde' , email: 'pallavi@syook.com',subdomain: 'nobox' },{name: 'saurabh' , email: 'saurabh@syook.com',subdomain: 'wrongbox' },{name: 'nithil' , email: 'nithil@syook.com',subdomain: 'somebox' },{name: 'rachit aggarwal' , email: 'rachit@syook.com',subdomain: 'lunchbox' },{name: 'meghal' , email: 'meghal@syook.com',subdomain: 'sabox' }]

	# msg = "Dear name ji,\n\nWe take this opportunity to thank you for your business. 2017 has been a great year for us and hope it has been the same for you too.\n\nWith a vision to constantly improve your Syook experience, there will be a minor change in the link to access your account. If your current website is subdomain.syook.com, it will now change to subdomain.syookpro.com. There will also be an update to the mobile app. For this week, both the links will work. Starting Jan 2nd, the link of subdomain.syook.com will stop working.\n\nEverything else remains the same. There is no change in the way you use the system.\n\nThe entire Syook team would also like to take this opportunity to wish you a very happy and prosperous new year 2018."
	
	# subject = "Changes to your subdomain"
	# s = SyookNotice.new(data, msg,subject )
	# s.sendmsg