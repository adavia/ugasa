class SendMonthlyEmailJob < ApplicationJob
  queue_as :default

  def perform(client, report_date, total)
  	@client = client
  	@report_date = report_date
  	@total = total
    InvoiceMailer.send_monthly_report(@client, @report_date, @total).deliver_later
  end
end
