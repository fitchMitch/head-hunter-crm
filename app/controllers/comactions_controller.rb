# Table name: comactions
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :string
#  type_action:string
#  due_date   :date
#  done_date  :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  mission_id :integer
#  person_id  :integer
class ComactionsController < ApplicationController
  before_action :logged_in_user
  before_action :get_comaction,   only: [:edit, :show, :update, :destroy]

  def new
    @comaction = Comaction.new
  end
  #-----------------
  def index
    @comactions = Comaction.joins(:user, :person, :mission).select('missions.*, users.*, people.*,comactions.*').page(params[:page] ? params[:page].to_i: 1).reload
    @comactions = bin_filters(@comactions, params)
    @comactions = reorder(@comactions, params,'comactions.name')

    @parameters = {'params'=> params, 'header' => [],'tableDB'=> "comactions"}

    @parameters['header']<<{'width'=>2,'label'=>'Action','attribute'=>'name'}
    @parameters['header']<<{'width'=>1,'label'=>'Statut', 'attribute'=>'status'}
    @parameters['header']<<{'width'=>1,'label'=>'Réalisé','attribute'=>'done_date'}
    @parameters['header']<<{'width'=>2,'label'=>'Mission','attribute'=>'missions.name'}
    @parameters['header']<<{'width'=>1,'label'=>'Resp.','attribute'=>'users.name'}
    @parameters['header']<<{'width'=>2,'label'=>'Avec','attribute'=>'people.lastname'}
    @parameters['header']<<{'width'=>2,'label'=>'Promis','attribute'=>'due_date'}
  end
  #-----------------
  def edit
    @person = Person.find(@comaction.person_id)
    @company = Company.find(@comaction.company_id)
  end
  #-----------------
  def show
  end
  #-----------------
  def create
    @person = Person.find(mission_params[:person_id])
    @comaction = @person.missions.build(mission_params)

    if !@person.nil? && !@company.nil? && @comaction.save
      flash[:info] =  "Comaction sauvegardée :-)"
      redirect_to missions_path
    else
      flash[:alert] = "Cette mission n'a pas pu être ajoutée"
      render :new
    end
  end

  def update
    if @comaction.update_attributes(mission_params)
      flash[:success] = "Comaction mise à jour"
      redirect_to @comaction
    else
      flash[:alert] = "Cette mission n'a pas pu être mise à jour"
      render 'edit'
    end
  end

  def destroy
    @comaction.destroy
    flash[:success] = "Comaction supprimée"
    redirect_to missions_path
  end

  #---------------
  private
  #---------------
    def comaction_params
      params.require(:comaction).permit(:name , :status, :type_action, :due_date, :done_date, :user_id, :mission_id, :person_id)
    end

    def get_comaction
      @comaction = Comaction.find(params[:id])
    end
end
