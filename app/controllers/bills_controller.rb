# Bills actions
class BillsController < ApplicationController
  before_action :set_bill, only: [:edit, :update, :destroy]

  # GET /bills
  def index
    @bills = Bill.by_recent.page(params[:page])
  end

  # GET /bills/1
  # GET /bills/1.pdf
  def show
    @bill = Bill.includes(motions: [:meeting],
                          sections:
                              [sub_sections:
                                   [paragraphs: :sub_paragraphs]])
                .find(params[:id])

    @versions = @bill.versions.reorder('created_at DESC')
    default_attachments = { attachments: true }
    @attach = params[:attach] || default_attachments
  end

  # GET /bills/new
  def new
    @bill = Bill.new
    @bill.recitals.build
    @bill.sections.build
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills
  # POST /bills.json
  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to @bill, notice: 'Bill was successfully created.' }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1
  # PATCH/PUT /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url, notice: 'Bill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bill
    @bill = Bill.includes(sections:
                              [sub_sections:
                                   [paragraphs: :sub_paragraphs]])
                .find(params[:id])
  end

  # Never trust parameters from the scary internet,
  #   only allow the white list through.
  def bill_params
    # TODO: refactor parameters
    # Levels attributes
    sub_paragraphs_attributes = [
      :heading,
      :subheading,
      :chapeau,
      :continuation,
      :text,
      :id,
      :_destroy
    ]
    paragraphs_attributes = [
      :heading,
      :subheading,
      :chapeau,
      :continuation,
      :text,
      :id,
      :_destroy,
      sub_paragraphs_attributes: sub_paragraphs_attributes
    ]
    sub_sections_attributes = [
      :heading,
      :subheading,
      :chapeau,
      :continuation,
      :text,
      :id,
      :_destroy,
      paragraphs_attributes: paragraphs_attributes
    ]
    sections_attributes = [
      :heading,
      :subheading,
      :chapeau,
      :continuation,
      :text,
      :id,
      :_destroy,
      sub_sections_attributes: sub_sections_attributes
    ]
    params.require(:bill)
      .permit(:title,
              :short_title,
              :type,
              :position,
              :enacting_formula,

              recitals_attributes: [:prefix,
                                    :clause,
                                    :id,
                                    :_destroy],

              sections_attributes: sections_attributes,

              attachments_attributes: [:title,
                                       :description,
                                       :file,
                                       :id,
                                       :_destroy])
  end
end
