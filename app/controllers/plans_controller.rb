class PlansController < ApplicationController
  # GET /plans
  # GET /plans.xml
  def index
    @plans = Plan.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plans }
    end
  end

  # GET /plans/1
  # GET /plans/1.xml
  def show
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @plan }
    end
  end

  # GET /plans/new
  # GET /plans/new.xml
  def new
    @plan = Plan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @plan }
    end
  end

  # GET /plans/1/edit
  def edit
    @plan = Plan.find(params[:id])
  end

  # POST /plans
  # POST /plans.xml
  def create
    @plan = Plan.new(params[:plan])
		total = @plan.examen_1 + @plan.examen_2 + @plan.examen_3 + @plan.acumulado
		if total == 100
		  respond_to do |format|
		    if @plan.save
		      flash[:notice] = 'Ponderation was successfully created.'
		      format.html { redirect_to(@plan) }
		      format.xml  { render :xml => @plan, :status => :created, :location => @plan }
		    else
		      format.html { render :action => "new" }
		      format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
		    end
		  end
		else
			flash[:notice] = 'Ponderation exceeds or is below 100 points.'
			render :action => "new"
		end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    @plan = Plan.find(params[:id])
		h = params[:plan]
		total2 = h[:examen_1].to_f + h[:examen_2].to_f + h[:examen_3].to_f + h[:acumulado].to_f
		if total2 == 100
		  respond_to do |format|
		    if @plan.update_attributes(params[:plan])
		      flash[:notice] = 'Ponderation was successfully updated.'
		      format.html { redirect_to(@plan) }
		      format.xml  { head :ok }
		    else
		      format.html { render :action => "edit" }
		      format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
		    end
		  end
		else
			flash[:notice] = 'Ponderation exceeds or is below 100 points.'
			render :action => "edit"
		end
  end

  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to(plans_url) }
      format.xml  { head :ok }
    end
  end
end
