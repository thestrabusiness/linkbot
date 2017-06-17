module ApplicationHelper
  def link_image(link)
    if link.metadata.present? && link.metadata.image.present?
      image_tag(link.metadata.image.expiring_url, class: 'link-image')
    else
      inline_svg('placeholder.svg', class: 'link-image')
    end
  end

  def link_domain(link)
    link.domain || link.url
  end
end
