atom_feed do |feed|
   feed.title(@channel.title)
   feed.updated(@items[0].created_at) if @items.length > 0

   @items.each do |item|
     feed.entry(item, :url => jump_channel_item_url(@channel, item)) do |entry|
       entry.title(item.link.og_title)
       entry.content(item.link.og_description, type: 'html')
       
       entry.author do |author|
         author.name(item.user.email)
       end
     end
   end
 end