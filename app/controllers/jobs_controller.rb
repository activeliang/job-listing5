class JobsController < ApplicationController
  before_action :validate_search_key, only: [:search]

  def search
    if @query_string.present?
      search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
      @jobs = search_result.recent.paginate(:page => params[:page], :per_page => 5 )
    end
  end

  def index
    @jobs = case params[:order]
    when 'by_lower_bound'
      Job.where(:is_hidden=>false).order("wage_lower_bound DESC")
    when "by_upper_bound"
      Job.where(:is_hidden=>false).order("wage_upper_bound DESC")
    else
    Job.where(:is_hidden=>false).order("created_at DESC")
    end
  end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "This Job already archieved"
      redirect_to root_path
    end
  end
  def new
    @job = Job.new
  end

  def create
    @job = Job.new(jobs_params)
    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(jobs_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path
  end

  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
    if params[:q].present?
      @search_criteria =  {
        title_or_company_or_city_cont: @query_string
      }
    end
  end


  def search_criteria(query_string)
    { :title_cont => query_string }
  end

  private
  def jobs_params
    params.require(:job).permit(:title,:description,:wage_upper_bound,:wage_lower_bound,:contact_email,:is_hidden,:category,:company,:city)
  end
end
