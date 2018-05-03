class SendAnnualEmailJob < ApplicationJob
  queue_as :default

  def perform(client, report, year)
    @client = client
  	@report = report
  	@year = year
    InvoiceMailer.send_annual_report(@client, @report, @year).deliver_later
  end
end
