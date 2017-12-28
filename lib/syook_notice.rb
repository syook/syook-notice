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
			json = { "personalizations"=> [ { "to"=> [ { "email"=> obj["email"] } ] } ], "subject" => @subject, "content" => [ { "type" => "text/html", "value" => "#{msg}" } ], "from"=> { "email"=> "support@syook.com" }, "template_id" => "c1e54d1c-72da-451c-9ee4-afa2938f695d" }
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