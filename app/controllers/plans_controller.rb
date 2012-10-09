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
		if @plan.examen_1 && @plan.examen_2 && @plan.examen_3 && @plan.examen_4 &&
  		 @plan.acumulado_1 && @plan.acumulado_2 && @plan.acumulado_3 && @plan.acumulado_4
			total_1 = @plan.examen_1 + @plan.acumulado_1
			total_2 = @plan.examen_2 + @plan.acumulado_2
			total_3 = @plan.examen_3 + @plan.acumulado_3
			total_4 = @plan.examen_4 + @plan.acumulado_4
			if total_1 == 100 and total_2 == 100 and total_3 == 100 and total_4 == 100
				respond_to do |format|
				  if @plan.save
				    flash[:notice] = 'Ponderacion creada con exito.'
				    format.html { redirect_to(@plan) }
				    format.xml  { render :xml => @plan, :status => :created, :location => @plan }
				  else
				    format.html { render :action => "new" }
				    format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
				  end
				end
			else
				flash[:notice] = 'Ponderacion de parcial excede o es menor que 100 puntos.'
				redirect_to new_subject_ponderation_path(:id=>@plan.subject_id)
			end
		else
			flash[:notice] = 'Ponderacion no puede ser vacia.'
			redirect_to new_subject_ponderation_path(:id=>@plan.subject_id)
		end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    @plan = Plan.find(params[:id])
		h = params[:plan]
		total_1 = h[:examen_1].to_f + h[:acumulado_1].to_f
		total_2 = h[:examen_2].to_f + h[:acumulado_2].to_f
		total_3 = h[:examen_3].to_f + h[:acumulado_3].to_f
		total_4 = h[:examen_4].to_f + h[:acumulado_4].to_f
		if total_1 == 100 and total_2 == 100 and total_3 == 100 and total_4 == 100
		  respond_to do |format|
		    if @plan.update_attributes(params[:plan])
		      flash[:notice] = 'Ponderacion actualizada con exito.'
		      format.html { redirect_to(@plan) }
		      format.xml  { head :ok }
		    else
		      format.html { render :action => "edit" }
		      format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
		    end
		  end
		else
			flash[:notice] = 'Ponderacion de parcial excede o es menor que 100 puntos.'
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
