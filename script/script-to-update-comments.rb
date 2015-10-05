# I ran this script on prod to add
# pods to all the comments

Comment.all.each do |comment|
  if comment.pod.nil?
    if comment.parent
      comment.pod = comment.parent.pod
      comment.save
    end
  end
end
