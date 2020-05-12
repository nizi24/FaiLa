module MicropostsHelper

  USER_UNIQUE_NAME_REGEX = /@([a-z0-9_]{5,15})/i

  #マッチしたユーザー名からユーザーを捕捉して配列にする
  #ユーザー名をプロフィールへのリンクにするために使用
  def scan_user_name(micropost)
    if unique_names = micropost.content.scan(USER_UNIQUE_NAME_REGEX)
      @received_users = []
      unique_names.each do |unique_name|
        user = User.find_by(unique_name: unique_name[0])
        if user
          @received_users << user
          micropost.content.gsub!("@#{unique_name[0]} ", '')
        end
      end
    end
  end
end
