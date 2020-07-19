class GroupsController < ApplicationController
  before_action :set_group_item, only: [:edit, :update, :destroy, :show]

	def index
		@groups = current_user.groups.by_alpha_order
	end

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(group_params)
		@group.user_id = current_user.id

    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_path, notice: 'Group was successfully created.' }
      else
        format.html { render :new }
      end
  	end
	end

	def edit
	end

 def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to groups_path, notice: 'Group was successfully updated.' }        
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
  	@group.destroy

    respond_to do |format|
      format.html { redirect_to groups_path, notice: 'Group was Removed'}
    end
  end

  def show
    @group = Group.find(params[:id])
    @expenses = @group.expenses.order('createdAt desc')
    @extexpenses = Expense.external(ids).by_user(current_user).by_recent_created
  end


	private 

	def group_params
		params.require(:group).permit(:name, :icon)
	end

	def set_group_item
		@group = Group.find(params[:id])
	end

  def ids
    ids = current_user.expenses.pluck(:id)
  end

end
