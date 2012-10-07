class NotasController < ApplicationController
  # GET /notas
  # GET /notas.xml
  def index
    @notas = Nota.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notas }
    end
  end

  # GET /notas/1
  # GET /notas/1.xml
  def show
    @nota = Nota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nota }
    end
  end

  # GET /notas/new
  # GET /notas/new.xml
  def new
    @nota = Nota.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota }
    end
  end

  # GET /notas/1/edit
  def edit
    @nota = Nota.find(params[:id])
  end

  # POST /notas
  # POST /notas.xml
  def create
    @nota = Nota.new(params[:nota])
		@plan = Plan.find_by_subject_id(@nota.subject_id)
		if !@nota.examen_1
			@nota.examen_1 = 0
		end
		if !@nota.examen_2
			@nota.examen_2 = 0
		end
		if !@nota.examen_3
			@nota.examen_3 = 0
		end
		if !@nota.acumulado
			@nota.acumulado = 0
		end
		
		if @nota.examen_1 > @plan.examen_1 || @nota.examen_2 > @plan.examen_2 || 
			 @nota.examen_3 > @plan.examen_3 || @nota.acumulado > @plan.acumulado
			flash[:notice] = "Scores can not be greater than ponderation values."
			redirect_to ("/plans/"+@plan.id.to_s)
		else
			if @nota.save
		    flash[:notice] = 'Score was successfully created.'
				redirect_to ("/plans/"+@plan.id.to_s) 
		  else
		    flash[:notice] = 'Something went wrong when creating score.'
				render :action => "new"
		  end
		end
  end

  # PUT /notas/1
  # PUT /notas/1.xml
  def update
    @nota = Nota.find(params[:id])
    @plan = Plan.find_by_subject_id(@nota.subject_id)
		h = params[:nota]
		if h[:examen_1].to_f > @plan.examen_1 || h[:examen_2].to_f > @plan.examen_2 || 
			 h[:examen_3].to_f > @plan.examen_3 || h[:acumulado].to_f > @plan.acumulado
			flash[:notice] = "Scores can not be greater than ponderation values: 
			Exam 1: #{@plan.examen_1}, Exam 2: #{@plan.examen_2}, Exam 3: #{@plan.examen_3}, 
			Acumulative: #{@plan.acumulado}"
			render :action => "edit"
		else
      if @nota.update_attributes(params[:nota])
        flash[:notice] = 'Score was successfully updated.'
				redirect_to ("/plans/"+@plan.id.to_s) 
      else
				flash[:notice] = 'Something went wrong when updating score.'
				render :action => "edit" 
      end
		end
  end

  # DELETE /notas/1
  # DELETE /notas/1.xml
  def destroy
    @nota = Nota.find(params[:id])
    @nota.destroy

    respond_to do |format|
      format.html { redirect_to(notas_url) }
      format.xml  { head :ok }
    end
  end
end
