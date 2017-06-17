module ApplicationHelper
  def link_image_path(link)
    if link.metadata.present? && link.metadata.image.present?
      link.metadata.image.expiring_url
    else
      'placeholder.png'
    end
  end

  def link_domain(link)
    link.domain || link.url
  end
end
