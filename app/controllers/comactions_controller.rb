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
    uid = current_user.id
    @comactions = Comaction.includes(:user, :person, mission: [:company])
    if params[:filter] != nil
      filter = params[:filter]
      if filter == 'unscheduled'
        @comactions = @comactions
          .unscheduled(uid)
          .newer_than(7, uid)
          .page(params[:page] ? params[:page].to_i: 1)
      elsif filter == 'future'
        @comactions = @comactions
          .scheduled(uid).newer_than(0, uid)
          .page(params[:page] ? params[:page].to_i: 1)
      elsif filter == 'sourced'
        @comactions = @comactions
          .sourced(uid)
          .newer_than(7, uid)
          .page(params[:page] ? params[:page].to_i: 1)
      elsif filter == 'preselected'
        @comactions = @comactions
          .preselected(uid)
          .newer_than(7, uid)
          .page(params[:page] ? params[:page].to_i: 1)
      elsif filter == 'appoint'
        @comactions = @comactions
          .appoint(uid)
          .newer_than(7, uid)
          .page(params[:page] ? params[:page].to_i: 1)
      elsif filter == 'pres'
        @comactions = @comactions
          .pres(uid)
          .newer_than(7, uid)
          .page(params[:page] ? params[:page].to_i: 1)
      elsif filter == 'opres'
        @comactions = @comactions
          .opres(uid)
          .newer_than(7, uid)
          .page(params[:page] ? params[:page].to_i: 1)
      elsif filter == 'hired'
        @comactions = @comactions
          .hired(uid)
          .newer_than(7, uid)
          .page(params[:page] ? params[:page].to_i: 1)
      elsif filter == 'working'
        @comactions = @comactions
          .working(uid)
          .newer_than(7, uid)
          .page(params[:page] ? params[:page].to_i: 1)
      else
        @comactions = @comactions
          .page(params[:page] ? params[:page].to_i: 1)
      end
    else
      @comactions = @comactions.newer_than(3, uid)
        .page(params[:page] ? params[:page].to_i: 1)
    end

    @comactions = bin_filters(@comactions, params)
    @comactions = reorder(@comactions, params, 'comactions.name')

    @parameters = { 'params' => params, 'header' => [], 'tableDB' => 'comactions', 'query' => 'table_view' }

    @parameters['header'] << {
        'width' => 3,
        'label' => 'Nom',
        'attribute' => 'name'
      }
    @parameters['header'] << {
      'width' => 2,
      'label' => 'Date',
      'attribute' => 'start_time'
    }
    @parameters['header'] << {
      'width' => 2,
      'label' => 'Avec',
      'attribute' => 'people.lastname'
    }
    @parameters['header'] << {
      'width' => 1,
      'label' => 'Statut',
      'attribute' => 'status'
    }
    @parameters['header'] << { 'width' => 2,
      'label' => 'Mission',
      'attribute' => 'missions.name'
    }
    @parameters['header'] << { 'width' => 1,
      'label' => 'Resp.',
      'attribute' => 'users.name'
    }

    if params[:query].nil? || params[:query] != 'table_view'
      render 'calendar'
    else
      render 'index'
    end
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
    if params[:id].nil?
      set_next_url new_comaction_path
    else
      set_next_url edit_comaction_path(params[:id])
    end
    model = params['model'].to_s || 'person'
    dest = 'new_' + model + '_path'
    redirect_to send dest
  end
  #-----------------
  def create
    @person = Person.find(comaction_params[:person_id])
    @mission = Mission.find(comaction_params[:mission_id])

    @comaction = @person.comactions.build(comaction_params)
    @comaction.mission_id = @mission.id
    @comaction.user_id = current_user.id
    @comaction = trigger_nil_dates @comaction

    if @comaction.save
      if (@comaction.start_time.nil?  || @comaction.end_time.nil? )
        flash[:info] = 'Rendez-vous sauvegardé'
      else
        @comaction.send_meeting_email(current_user, 1)
        flash[:info] = 'Rendez-vous sauvegardé (un email a été envoyé)'
      end
      redirect_to comactions_path
    else
      flash[:danger] = 'Ce rendez-vous n\'a pas pu être ajouté'
      render :new
    end
  end

  def update
    @comaction = trigger_nil_dates @comaction

    if @comaction.update_attributes(comaction_params)
      if (@comaction.start_time.nil? || @comaction.end_time.nil? )
        flash[:success] = 'Rendez-vous sauvegardé'
      else
        @comaction.send_meeting_email(current_user, 0)
        flash[:success] = 'Rendez-vous mis à jour (un email a été envoyé)'
      end
      redirect_to @comaction
    else
      logger.warn(' update won\'t work #{@comaction.inspect }')
      flash[:danger] = 'Ce rendez-vous n\'a pas pu être mis à jour'
      render 'edit'
    end
  end

  def trigger_nil_dates (comaction)
    comaction.start_time = nil if comaction_params[:is_dated].to_i == 1
    comaction.end_time = nil if comaction_params[:is_dated].to_i == 1
    comaction
  end

  def destroy
    @comaction.destroy
    flash[:success] = 'Rendez-vous supprimé'
    redirect_to comactions_path
  end

  #---------------
  private
  #---------------
    def comaction_params
      params.require(:comaction).permit(:name, :status, :action_type, :start_time, :end_time, :user_id, :mission_id, :person_id, :is_dated)
    end

    def get_comaction
      @comaction = Comaction.find(params[:id])
      @comaction.is_dated = @comaction.nil? || @comaction.start_time.nil?  ? false : true
    end


end
