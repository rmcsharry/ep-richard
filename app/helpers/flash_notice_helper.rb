module FlashNoticeHelper    
  def build_flash_comment(comment)      
    if comment.nil?
      msg = "There are no comments on any of the games...yet!"
    else        
      url = "/pod_admin/games/" + comment.game.id.to_s
      msg = "The most recent comment was from <strong>" + comment.parent_name + 
            "</strong> on <strong>" + comment.created_at.strftime("%d %b %y") + 
            "</strong> at <strong>" + comment.created_at.strftime("%H:%M") + 
            "</strong>:<br/><br/><i>" + comment.body + "</i>" +
            "<br/><br/>on the game <a href='" + url + "'>" +
             comment.game.name + "</a>"
    end 
    msg.html_safe
  end
end