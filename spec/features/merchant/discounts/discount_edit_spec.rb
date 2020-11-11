require 'rails_helper'

describe 'Discount Edit' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
    @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80_218)
    @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'megan@example.com', password: 'securepassword')
    @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5)
    @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3)
    @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1)
    @order_1 = @m_user.orders.create!(status: 'packaged')
    @order_2 = @m_user.orders.create!(status: 'pending')
    @order_3 = @m_user.orders.create!(status: 'cancelled')

    @discount_1 = @merchant_1.discounts.create!(title: 'Black Friday Sale', percentage: 5, items: 20, description: 'A discount for the wise ones')

    @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'admin@example.com', password: 'securepassword', role: :admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  describe 'visit page edit a discount' do
    xit do
      visit '/merchant'

      click_link('Bulk Discounts')

      within("#discount-#{@discount_1.id}") do
        click_link('Edit Discount')
      end
      # save_and_open_page
      expect(page).to have_current_path("/merchant/discounts/#{@discount_1.id}/edit")

      expect(page).to have_content('Edit Discount')

      fill_in('discount[title]', with: 'Edited Title Wooo')
      fill_in('discount[percentage]', with: '10')
      fill_in('discount[items]', with: '30')
      fill_in('discount[description]', with: 'This is a edited discount')

      click_button('Update Discount')
      # save_and_open_page
      @discount_1.reload

      expect(page).to have_current_path('/merchant/discounts')
      expect(page).to have_content("Bulk Discounts for #{@merchant_1.name}")
      expect(page).to have_link('Create Discount')

      within("#discount-#{@discount_1.id}") do
        expect(page).to have_content('Edited Title Wooo')
        expect(page).to have_content('10%')
        expect(page).to have_content(@discount_1.items)

        expect(page).to have_link('Edit Discount')
        expect(page).to have_button('Remove Discount')
      end
    end
  end
end
