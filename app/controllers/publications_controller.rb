class PublicationsController < ApplicationController
  before_action :authorize_request, except: [:published]
  before_action :set_publication, only: [:show, :update, :destroy]

  def index
    @publications = @current_user.publications.active.search(params[:title]).status_filter(params[:status]).ordered

    render json: @publications, status: :ok
  rescue => e
    render json: { error: 'Failed to fetch publications', details: e.message }, status: :internal_server_error
  end


  def published
    @publications = Publication.where(status: 'published', deleted_at: nil).ordered

    render json: @publications.as_json(only: [:id, :title, :content, :status, :user_id]), status: :ok
  rescue => e
    render json: { error: 'Failed to fetch published publications', details: e.message }, status: :internal_server_error
  end

  def create
    @publication = @current_user.publications.build(publication_params)
    if @publication.save
      render json: @publication, status: :created
    else
      render json: { errors: @publication.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing => e
    render json: { error: 'Missing parameters', details: e.message }, status: :bad_request
  rescue => e
    render json: { error: 'Failed to create publication', details: e.message }, status: :internal_server_error
  end

  def show
    render json: @publication, status: :ok
  end

  def update
    if @publication.update(publication_params)
      render json: @publication, status: :ok
    else
      render json: { errors: @publication.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing => e
    render json: { error: 'Missing parameters', details: e.message }, status: :bad_request
  rescue => e
    render json: { error: 'Failed to update publication', details: e.message }, status: :internal_server_error
  end

  def destroy
    @publication.soft_delete
    head :no_content
  end

  def bulk_destroy
    publication_ids = params[:ids]
    return render json: { error: 'No IDs provided' }, status: :unprocessable_entity if publication_ids.blank?

    publications = @current_user.publications.active.where(id: publication_ids)
    count = publications.update_all(deleted_at: Time.current,status: "archived")

    render json: { message: "#{count} publications deleted successfully" }, status: :ok
  rescue => e
    render json: { error: 'Failed to bulk delete publications', details: e.message }, status: :internal_server_error
  end

  def undo_delete
    publication_ids = params[:ids]
    return render json: { error: 'No IDs provided' }, status: :unprocessable_entity if publication_ids.blank?

    publications = @current_user.publications.deleted.where(id: publication_ids)
    count = publications.update_all(deleted_at: nil, status: "draft")

    render json: { message: "#{count} publications restored successfully" }, status: :ok
  rescue => e
    render json: { error: 'Failed to restore publications', details: e.message }, status: :internal_server_error
  end

  def deleted
    @publications = @current_user.publications.deleted.order(deleted_at: :desc)

    render json: @publications, status: :ok
  rescue => e
    render json: { error: 'Failed to fetch deleted publications', details: e.message }, status: :internal_server_error
  end

  private

  def set_publication
    @publication = @current_user.publications.find_by(id: params[:id], deleted_at: nil)
    return render json: { error: 'Publication not found' }, status: :not_found unless @publication
  end

  def publication_params
    params.require(:publication).permit(:title, :content, :status)
  end
end
