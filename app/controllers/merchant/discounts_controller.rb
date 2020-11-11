class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
    @merchant = current_user.merchant
    @discount = params[:discount] || Discount.new
  end

  def create
    @merchant = current_user.merchant
    begin
      @merchant.discounts.create!(discount_params)
      flash[:success] = 'Discount added successfully!'
      redirect_to '/merchant/discounts'
    rescue ActiveRecord::RecordInvalid => e
      create_error_response(e)
      render :new
    end
  end

  private

  def discount_params
    params.require(:discount).permit(
      :title,
      :percentage,
      :items,
      :description
    )
  end

  def create_error_response(error)
    flash[:error] = error.message.delete_prefix('Validation failed: ')
  end
end
