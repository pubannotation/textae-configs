module UsersHelper
  def user(user)
    link_to user.email, user_path(user)
  end

  def login_with_google
<<HEREDOC
<div style="display:inline-block; color:#fff">
  <div style="display:inline-block; margin: 0; padding:5px; background-color:#99f"><i class="fa fa-google" style="width:16px; height:20px"></i></div><div style="display:inline-block; margin:0; padding:5px; background-color:#88f"> Login with Google</div>
</div>
HEREDOC
  end

  def login_with_github
<<HEREDOC
<div style="display:inline-block; color:#fff; height:18px">
  <div style="display:inline-block; margin: 0; padding:5px; background-color:#866"><i class="fa fa-github" style="width:16px"></i></div><div style="display:inline-block; margin:0; padding:5px; background-color:#633"> Login with GitHub</div>
</div>
HEREDOC
  end

end
