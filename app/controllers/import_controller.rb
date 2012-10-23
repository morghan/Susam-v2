class ImportController < ApplicationController

  filter_access_to :all
  before_filter :login_required

  require 'csv'

  def index
     @batches = Batch.active
  end

  def import_csv

    if request.post? && params[:file].present?
      filename = params[:file].read
      n, errs = 0, []
      #@last_admitted_student = Student.find(:last)
      
      CSV.parse(filename) do |row|
        n += 1
        next if n == 1 or row.join.blank?

        st = Student.new
        st.admission_no = row[0]
        st.first_name = row[1]
        st.last_name = row[2]
        st.date_of_birth = row[3]
        st.email = row[4]
        st.batch_id = params[:course][:course_id]
        
        #by Default take this parameter from local configuration
        st.is_sms_enabled = 1
        st.country_id = 73
        st.nationality_id = 73
        st.admission_date = DateTime.now.strftime('%m/%d/%Y')
        st.is_active = 1
        st.gender = 'm'
        #st.batch_id = 1

        begin
          st.create_user_and_validate
          st.save!
        rescue Exception => e
          errs << e.to_s + " '" + st.admission_no + "' "
        end
        
        gu = Guardian.new
        gu.first_name = row[5]
        gu.last_name = row[6]
        gu.relation = row[7]
        gu.email = row[8]
        #params default
        gu.country_id = 73;
        _st = Student.find_by_admission_no st.admission_no
        gu.ward_id = _st.id

        begin
          gu.validate
          gu.create_guardian_user(_st)
          gu.save!
          
        rescue Exception => e
          errs << e.to_s + " '" + gu.name + " " + gu.last_name + " ' "
        end
        
      end

      if errs.any?
        flash[:notice] = errs.to_s
      else
        flash[:notice] = "Successfull "
      end

    else
      flash[:notice] = "Error file not choosen, select the batch and the correct file"
    end

    #refirect to index for show messages
    redirect_to :action => 'index'
  end

  private
  def list_batches
    unless params[:course_id] == ''
      @batches = Batch.find(:all, :conditions=>"course_id = #{params[:course_id]}",:order=>"id DESC")
    else
      @batches = []
    end
    render(:update) do |page|
      page.replace_html 'course_batches', :partial=> 'list_batches'
    end
  end
end
