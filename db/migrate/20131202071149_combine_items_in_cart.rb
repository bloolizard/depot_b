class CombineItemsInCart < ActiveRecord::Migration
  def up
  	# replace multiple items for a single product in a cart with a single item
  	Cart.all.each do |cart|
  		# count the number of each product in the cart
  		sums = cart.line_items.group(:product_id).sum(:quanity)

  		sums.each do |product_id, quanity|
  			if quanity > 1
  				# remove the individual items
  				cart.line_items.where(product_id: product_id).delete_all

  				# replace with a single item
  				item = cart.line_items.build(product_id: product_id)
  				item.quanity = quanity
  				item.save!
  			end
  		end
  end

  def down
  	# split items with quanity > 1 into multiple items
  	LineItem.where("quanity>1").each do |line_item|
  		# add individual items
  		line_item.quanity.times do
  			LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id
  		end

  		line_item.destroy
  	end
  end
end
