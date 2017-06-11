class MetadataCreator
  attr_accessor :link, :page

  def initialize(link)
    @link = link
    @page = MetaInspector.new(link.url)
  end

  def perform
    @metadata = Metadata.create(
        url: link.url,
        title: page.best_title,
        description: page.best_description,
        domain: page.host,
        image: page.images.best
    )

    link.update(metadata: @metadata)
  end

  def self.perform(link)
    new(link).perform
  end
end
