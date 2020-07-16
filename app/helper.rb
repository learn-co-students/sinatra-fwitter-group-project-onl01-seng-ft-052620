class Helpers
    def self.current_user(session_hash)
        User.find_by(id: session_hash[:user_id])
    end

    def self.logged_in?(session_hash)
        !!current_user(session_hash) 
    end
end