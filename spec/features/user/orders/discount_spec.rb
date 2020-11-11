require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Order Show Page' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5)
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30)
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1)
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'megan_1@example.com', password: 'securepassword')
      # @order_1 = @user.orders.create!(status: "packaged")
      # @order_2 = @user.orders.create!(status: "pending")
      # @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
      # @order_item_2 = @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 20, fulfilled: true)
      # @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)

      @discount_1 = @megan.discounts.create!(title: 'Black Friday Sale', percentage: 5, items: 4, description: 'A discount for the wise ones')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I see order information on the show page with discounts' do
      5.times do
          visit "/items/#{@ogre.id}"

          click_button('Add to Cart')
        end

      visit item_path(@hippo)
      click_button 'Add to Cart'



      visit '/cart'

      click_button 'Check Out'

      order = Order.last
      # require 'pry'; binding.pry

      expect(current_path).to eq('/profile/orders')
      expect(page).to have_content('Order created successfully!')
      expect(page).to have_link('Cart: 0')

      within "#order-#{order.id}" do
        expect(page).to have_link(order.id)

        click_link(order.id)
      end

      expect(page).to have_content("Total: #{number_to_currency(145)}")

      expect(page).to have_content(19)

      expect(page).to have_content(95)
    end
  end
end
