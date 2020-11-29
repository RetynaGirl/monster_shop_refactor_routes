class Item < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy

  validates_presence_of :name,
                        :description,
                        :image,
                        :price,
                        :inventory

  def self.active_items
    where(active: true)
  end

  def self.by_popularity(limit = nil, order = 'DESC')
    left_joins(:order_items)
      .select('items.id, items.name, COALESCE(sum(order_items.quantity), 0) AS total_sold')
      .group(:id)
      .order("total_sold #{order}")
      .limit(limit)
  end

  def sorted_reviews(limit = nil, order = :asc)
    reviews.order(rating: order).limit(limit)
  end

  def average_rating
    reviews.average(:rating)
  end

  def has_discount?(item_count)
    !merchant.discounts.where(items: 0..item_count).empty?
  end

  def discount_multiplier(item_count)
    applical_discounts = merchant.discounts.where(items: 0..item_count).order(percentage: :desc)

    if applical_discounts.empty?
      1.0
    else
      1 - (applical_discounts[0].percentage / 100)
    end
  end
end
