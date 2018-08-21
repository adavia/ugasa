class InvoiceMailer < ApplicationMailer
  default from: "info@ugasa.mx"

  def send_monthly_report(client, date, total)
    @client = client
    @date = date
    @total = total
    filename = "reporte_uga_#{@date}.pdf"
    pdf = MonthlyReportPdf.new(@client, @date, @total)
    attachments[filename] = pdf.render
    mail(to: @client.emails.map(&:address).join(","), subject: "Reporte UGA mensual #{@date}")
  end

  def send_annual_report(client, invoices, year)
    @client = client
    @invoices = invoices
    @year = year
    filename = "reporte_uga_#{@year}_anual.pdf"
    pdf = AnnualReportPdf.new(@client, @invoices, @year)
    attachments[filename] = pdf.render
    mail(to: @client.emails.map(&:address).join(","), subject: "Reporte UGA anual #{@year}")
  end
end