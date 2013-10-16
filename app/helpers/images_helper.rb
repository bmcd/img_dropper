module ImagesHelper
  def get_title(title)
    if title && title.length > 16
      return title[0..15] + "..."
    elsif title
      return title
    else
      return "Untitled Image"
    end
  end
end
