module ApplicationHelper

  def full_title(page_title = '')
    base_title = "Memolet"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def icon_for(object, options = { name: "noname", size: 80 })

    if object and object.picture?
      icon = object.picture.url
    else
      icon = "misc/noimage.png"
    end
    name = options[:name]
    size = options[:size]

    image_tag(icon, alt: name, width: size, height: size, class: "mr-3 icon")
  end
  
  def timestamp(object)
    "created #{time_ago_in_words(object.created_at)} ago." +
    " updated #{time_ago_in_words(object.updated_at)} ago."
  end

end
