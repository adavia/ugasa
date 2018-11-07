module V1
  class InvoicesController < ApplicationController
    skip_before_action :authorize_request, only: [:download_monthly_email, :download_annual_email]
    before_action :set_client, except: [:unique_code, :search, 
      :report, :send_monthly_email, :send_annual_email, :download_monthly_email, :download_annual_email]
    before_action :set_client_invoice, only: [:show, :update, :destroy]

    # GET /clients/:client_id/invoices
    def index
      @invoices = Invoice
        .order(invoice_date: 'DESC')
        .page(params[:page])
        .includes(:client)
        .where(client: @client)
      render(
        json: @invoices, 
        meta: { total_invoices: @invoices.total_entries },
        status: :ok
      )
    end

    # GET /clients/:client_id/invoices/:id
    def show
      render json: @invoice, status: :ok
    end

    # POST /clients/:client_id/invoices
    def create
      Invoice.transaction do
        invoice = @client.invoices.create!(invoice_params)
        @client.update_column(:total_oil_sum, @client.total_oil_sum += invoice.total)
        render json: invoice, meta: { total_invoices: @client.invoices.count }, status: :created
      end
    end

    # PUT /clients/:client_id/invoices/:id
    def update
      Invoice.transaction do
        @client.update_column(:total_oil_sum, @client.total_oil_sum -= @invoice.total)
        @invoice.update(invoice_params)
        @client.update_column(:total_oil_sum, @client.total_oil_sum += @invoice.total)
        render json: @invoice, status: :ok
      end
    end

    # DELETE /clients/:client_id/invoices/:id
    def destroy
      Invoice.transaction do
        @client.update_column(:total_oil_sum, @client.total_oil_sum -= @invoice.total)
        @invoice.destroy
        @invoices = Invoice
          .order(invoice_date: 'DESC')
          .page(params[:page])
          .includes(:client)
          .where(client: @client)
        render json: @invoices, meta: { total_invoices: @invoices.total_entries }, status: :ok
      end
    end

    # Verify code is unique
    def unique_code
      @invoice = Invoice.where(code: params[:field])
      render json: @invoice.present?, status: :ok
    end

    # Search query
    def search
      @invoices = Invoice
        .includes(:contract)
        .joins(:client)
        .search(params[:invoice])
      @total = @invoices.sum(&:total)
      @client_payment = @invoices.first.try(:contract) ? @invoices.first.contract.oil_payment : 0
      render( 
        json: @invoices.page(params[:page]), 
        meta: { 
          total_oil: @total, 
          total_invoices: @invoices.size,
          total_payment: @total * @client_payment 
        }, 
        status: :ok
      )
    end

    # Generate chart report
    def report
      @report = Invoice.select("MONTH(invoice_date) AS month, SUM(total) AS total")
        .joins(:client)
        .report(params[:invoice])
      render(
        json: @report,
        meta: { annual_client_total: Invoice.sum(:total) },
        each_serializer: ReportSerializer, 
        status: :ok
      )
    end

    def download_monthly_email
      @client = Client.find(params[:client])
      @invoices = Invoice.joins(:client)
      @total = @invoices.monthly_email(params).sum(:total)
      if @total != 0
        @month = I18n.l(DateTime.parse(Date::MONTHNAMES[params[:month].to_i]), format: "%B")
        @year = params[:year]
        @date = "#{@month}_#{@year}"
        pdf = MonthlyReportPdf.new(@client, @date, @total)
        send_data pdf.render,
          filename: "reporte_uga_#{@date}.pdf",
          type: 'application/pdf',
          disposition: 'attachment'
      end
    end

    def download_annual_email
      @invoices = Invoice.select("MONTH(invoice_date) AS month, SUM(total) AS total")
      .joins(:client)
      .report(params)
      if @invoices.length > 0 
        @client = Client.find(params[:client])
        @year = params[:year]
        @report = @invoices.map { |i| [I18n.l(DateTime.parse(Date::MONTHNAMES[i.month]), format: "%B"), i.total] }.to_h
        pdf = AnnualReportPdf.new(@client, @report, @year)
        send_data pdf.render,
          filename: "reporte_uga_#{@year}.pdf",
          type: 'application/pdf',
          disposition: 'attachment'
      end
    end

     # Send email report
     def send_monthly_email
      @client = Client.find(params[:invoice][:client])
      @invoices = Invoice.joins(:client)
      @total = @invoices.monthly_email(params[:invoice]).sum(:total)

      if @total != 0
        @month = I18n.l(DateTime.parse(Date::MONTHNAMES[params[:invoice][:month].to_i]), format: "%B")
        @year = params[:invoice][:year]
        @report_date = "#{@month}_#{@year}"
        SendMonthlyEmailJob.set(wait: 10.seconds).perform_later(@client, @report_date, @total)
        render(
          json: { message: "An email report has been sent successfully to this client" }, 
          status: :ok
        )
      else 
        render(
          json: { message: "No result were found applying this filter criteria" }, 
          status: :unprocessable_entity
        )
      end
    end

    # Send email report
    def send_annual_email
      @invoices = Invoice.select("MONTH(invoice_date) AS month, SUM(total) AS total")
      .joins(:client)
      .report(params[:invoice])
      if @invoices.length > 0 
        @client = Client.find(params[:invoice][:client])
        @year = params[:invoice][:year]
        @report = @invoices.map { |i| [I18n.l(DateTime.parse(Date::MONTHNAMES[i.month]), format: "%B"), i.total] }.to_h
        SendAnnualEmailJob.set(wait: 10.seconds).perform_later(@client, @report, @year)
        render(
          json: { message: "An email report has been sent successfully to this client" }, 
          status: :ok
        )
      else
        render(
          json: { message: "No result were found applying this filter criteria" }, 
          status: :unprocessable_entity
        )
      end
    end

    private

    def invoice_params
      params.require(:invoice).permit(
        :code, 
        :receiver, 
        :invoice_date, 
        :total, 
        :notes, 
        :client
      )
    end

    def set_client
      @client = Client.find(params[:client_id])
    end

    def set_client_invoice
      @invoice = @client.invoices.find_by!(id: params[:id]) if @client
    end
  end
end
