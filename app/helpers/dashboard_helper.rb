module DashboardHelper
    def generate_password
        chars = [('a'..'z'), ('A'..'Z'), (0..9)].map(&:to_a).flatten
        password = (0...12).map { chars[rand(chars.length)] }.join
    end

    def getMailingLists(user)
        url = ENV['LISTMONK_URL'] + "/api/subscribers/#{user.listmonk_id}"
        auth = {
            :username => ENV['LISTMONK_USERNAME'],
            :password => ENV['LISTMONK_PASSWORD']
        }
        response = HTTParty.get(url, basic_auth: auth)
        data = []
        for list in response["data"]["lists"]
            data.push(list["name"])
        end
        return data
    end
end
