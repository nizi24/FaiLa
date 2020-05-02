module LikesHelper

  #Userモデルのalredy_liked?で使用
  def sort_object(object)
    object_type = { likeable_id: object.id }
    case object
    when Article
      object_type.merge({ likeable_type: 'Article' })
    when Comment
      object_type.merge({ likeable_type: 'Comment'})
    else
      object_type = nil
    end
  end

end
