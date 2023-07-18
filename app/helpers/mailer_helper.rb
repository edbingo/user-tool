module MailerHelper
    def addToMailingList(user)
        url = ENV['LISTMONK_URL'] + "/api/subscribers"
        auth = {
            :username => ENV['LISTMONK_USERNAME'],
            :password => ENV['LISTMONK_PASSWORD']
        }
        response = HTTParty.post(url,
            :headers => { 'Content-Type' => 'application/json' },
            :body => { email: user.email, name: user.name, status: "enabled", lists: [5,6,7] }.to_json,
            :basic_auth => auth
        )
        data = JSON.parse(response.body)
        if data["message"] = "E-Mail existiert bereits."
            response = HTTParty.get(url,
                query: { page: 1, per_page: "all", query: "subscribers.email = '#{user.email}'" }, basic_auth: auth
            )
            data = JSON.parse(response.body)
            user.update(listmonk_id: data["data"]["results"].first["id"])
        else
            user.update(listmonk_id: data["data"]["id"])
        end
    end

    def updateMailingList(user)
        url = ENV['LISTMONK_URL'] + "/api/subscribers/#{user.listmonk_id}"
        auth = {
            :username => ENV['LISTMONK_USERNAME'],
            :password => ENV['LISTMONK_PASSWORD']
        }
        response = HTTParty.get(url, basic_auth: auth)
        data = []
        for list in response["data"]["lists"]
            data.push(list["id"])
        end
        response = HTTParty.put(url,
            :headers => { 'Content-Type' => 'application/json' },
            :body => { email: user.email, name: user.name, status: "enabled", lists: data }.to_json,
            :basic_auth => auth
        )
    end

    def removeFromMailingList(user)
        url = ENV['LISTMONK_URL'] + "/api/subscribers/#{user.listmonk_id}"
        auth = {
            :username => ENV['LISTMONK_USERNAME'],
            :password => ENV['LISTMONK_PASSWORD']
        }
        response = HTTParty.delete(url, basic_auth: auth)        
        unless response["data"] == true
            return false
        end
    end

    def sendResetLink(user)
        url = ENV['LISTMONK_URL'] + "/api/tx"
        auth = {
            :username => ENV['LISTMONK_USERNAME'],
            :password => ENV['LISTMONK_PASSWORD']
        }
        reset_link = ENV["DOMAIN"] + "/password_resets/" + user.reset_token + "/edit?email=#{user.email}"
        puts reset_link
        response = HTTParty.post(url,
            :headers => { 'Content-Type' => 'application/json' },
            :body => { subscriber_id: user.listmonk_id, template_id: 6, data: { reset_link: "#{reset_link}" } }.to_json,
            :basic_auth => auth
        )
        byebug
    end
end
