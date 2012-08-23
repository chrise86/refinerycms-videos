Refinery::User.all.each do |user|
  if user.plugins.where(:name => 'videos').blank?
    user.plugins.create(:name => 'videos',
                        :position => (user.plugins.maximum(:position) || -1) +1)
  end
end if defined?(Refinery::User)

if defined?(Refinery::Page) && !Refinery::Page.exists?(:link_url => "/videos")
  page = Refinery::Page.create(
    :title => 'Videos',
    :link_url => '/videos',
    :deletable => false,
    :show_in_menu => false,
    #:position => ((Refinery::Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => '^/videos(\/|\/.+?|)$'
  )
  
  Refinery::Pages.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end
end
