class UsersController < ApplicationController
  before_action :only_user!, only:[:index, :edit, :image_edit, :update, :destroy, :delete]
  before_action :set_user, only:[:show, :edit, :image_edit, :update, :destroy]

  def index
    @incumbents = Incumbent.where(user_id: current_user.id,).order(is_active: :desc).order(updated_at: :desc)
    @locations = current_user.locations.order(prefecture: :desc).order(city: :desc)
    suggests = Suggest.where(user_id: current_user.id).order(target_date: :asc)
    @suggests = suggests.where(is_active: true).order(target_date: :asc)
    @offers = []
    suggests.each do |suggest|
      suggest.offers.each do |offer|
        if offer.is_approval == nil
          @offers.push(offer)
        else
          next
        end
      end
    end
    @reviews = Review.where(user_id: current_user.id, is_read: false).order(target_date: :asc)
    contracts = Contract.where(user_id: current_user.id).order(target_date: :asc)
    @contracts = contracts.where(status: 0)
    @review_contracts = contracts.where(status: 1)
  end

  def show
    # @reviews = @user.reviews.sample(4)
  end

  def edit
    redirect_to user_path(current_user) unless @user == current_user
  end

  def image_edit
    redirect_to user_path(current_user) unless @user == current_user
  end

  def update
    if @user == current_user
      if @user.update(user_params)
        flash[:success] = "プロフィールを変更しました"
        redirect_to user_path(@user)
      else
        render :edit
      end
    else
      flash[:alert] = "他人のプロフィールは編集できません"
      redirect_to user_path(current_user)
    end
  end

  def destroy
    if @user == current_user
      if @user.destroy
        redirect_to delete_path
      else
        flash[:alert] = "退会できませんでした"
        redirect_to user_path(current_user)
      end
    else
      flash[:alert] = "他の人を退会させることはできません"
      redirect_to user_path(current_user)
    end
  end

  def delete  
  end

  private
  def user_params
    params.require(:user).permit(:last_name, :first_name, :kana_last_name, :kana_first_name, :sex, :birthday, :phone_number, :postal_code, :prefecture, :city, :street, :building, :email, :introduction, :image)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def only_user!
    unless user_signed_in?
      redirect_to root_path
    end
  end
end
