# Table name: comactions
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :string
#  action_type:string
#  start_time   :datetime
#  end_time   :datetime
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
    @comaction.is_dated = true
  end
  #-----------------
  def index
    @comactions = Comaction.includes(:user, :person, :mission)
    if params[:filter] != nil
      filter = params[:filter]
      if filter == 'unscheduled'
        @comactions = @comactions.unscheduled.newer_than(7)
      elsif filter == 'future'
        @comactions = @comactions.scheduled.newer_than(0)
      elsif filter == 'sourced'
        @comactions = @comactions.sourced.newer_than(7)
      elsif filter == 'preselected'
        @comactions = @comactions.preselected.newer_than(7)
      elsif filter == 'appoint'
        @comactions = @comactions.appoint.newer_than(7)
      elsif filter == 'pres'
        @comactions = @comactions.pres.newer_than(7)
      elsif filter == 'opres'
        @comactions = @comactions.opres.newer_than(7)
      elsif filter == 'hired'
        @comactions = @comactions.hired.newer_than(7)
      elsif filter == 'working'
        @comactions = @comactions.working.newer_than(7)
      else
        #
      end
    else
      @comactions = @comactions.newer_than(3)
    end
    @comactions = @comactions.page(params[:page] ? params[:page].to_i: 1)
    @comactions = bin_filters(@comactions, params)
    @comactions = reorder(@comactions, params,'comactions.name')
    #byebug

    @parameters = {'params'=> params, 'header' => [],'tableDB'=> "comactions"}

    @parameters['header']<<{'width'=>2,'label'=>'Action','attribute'=>'name'}
    @parameters['header']<<{'width'=>1,'label'=>'Statut', 'attribute'=>'status'}
    @parameters['header']<<{'width'=>2,'label'=>'Mission','attribute'=>'missions.name'}
    @parameters['header']<<{'width'=>1,'label'=>'Resp.','attribute'=>'users.name'}
    @parameters['header']<<{'width'=>2,'label'=>'Avec','attribute'=>'people.lastname'}
    @parameters['header']<<{'width'=>2,'label'=>'Date','attribute'=>'start_time'}
  end
  #-----------------
  def edit
    @user = current_user
  end
  #-----------------
  def show
  end
  #-----------------
  def add_ext
    model = params['model'].to_s || 'person'
    dest = "new_" + model + "_path"
    if params[:id].nil?
      set_next_url new_comaction_path
    else
      set_next_url edit_comaction_path(params[:id])
    end
    redirect_to send dest
  end
  #-----------------
  def create
    @person = Person.find(comaction_params[:person_id])
    @mission = Mission.find(comaction_params[:mission_id])

    @comaction = @person.comactions.build(comaction_params)
    @comaction.mission_id = @mission.id
    @comaction.user_id = current_user.id
    @comaction.start_time = comaction_params[:is_dated].to_i == 1 ? @comaction.start_time : nil

    if @comaction.save
      flash[:info] =  "Rendez-vous sauvegardé"
      redirect_to comactions_path
    else
      flash[:alert] = "Ce rendez-vous n'a pas pu être ajouté"
      render :new
    end
  end

  def update
    @comaction.start_time = comaction_params[:is_dated].to_i == 1 ? @comaction.start_time : nil
    if @comaction.update_attributes(comaction_params)
      flash[:success] = "Rendez-vous mis à jour"
      redirect_to @comaction
    else
      flash[:alert] = "Ce rendez-vous n'a pas pu être mis à jour"
      render 'edit'
    end
  end

  def destroy
    @comaction.destroy
    flash[:success] = "Rendez-vous supprimé"
    redirect_to comactions_path
  end

  #---------------
  private
  #---------------
    def comaction_params
      params.require(:comaction).permit(:name , :status, :action_type, :start_time, :end_time, :user_id, :mission_id, :person_id, :is_dated)
    end

    def get_comaction
      @comaction = Comaction.find(params[:id])
      @comaction.is_dated = @comaction.nil? || @comaction.start_time == nil ? false : true
    end
end
