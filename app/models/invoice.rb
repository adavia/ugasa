class Invoice < ApplicationRecord
  belongs_to :client, counter_cache: true
  has_one :contract, through: :client

  # Validations
  validates_presence_of :code, :invoice_date, :total

  # Pagination
  self.per_page = 15

  def self.search(params)
    invoices ||= find_invoices(params)
  end

  def self.report(params)
    report = self
    report = report.where("clients.id = ?", params["client"]) if params["client"].present?
    report = report.where("YEAR(invoice_date) = ?", params["year"]) if params["year"].present?
    report = report.group("month")
    report
  end

  def self.monthly_email(params)
    report = self
    report = report.where("clients.id = ?", params["client"]) if params["client"].present?
    report = report.where("YEAR(invoice_date) = ?", params["year"]) if params["year"].present?
    report = report.where("MONTH(invoice_date) = ?", params["month"]) if params["month"].present?
    report
  end

  private

  def self.find_invoices(params)
    invoices = order(invoice_date: "ASC")
    invoices = invoices.where("clients.id = ?", params["client"]) if params["client"].present?
    invoices = invoices.where("code = ?", params["code"]) if params["code"].present?
    invoices = invoices.where("clients.location_id = ?", params["zone"]) if params["zone"].present?
    invoices = invoices.where("clients.responsible = ?", params["responsible"]) if params["responsible"].present?
    invoices = invoices.where("MONTH(invoice_date) = ?", params["month"]) if params["month"].present?
    invoices = invoices.where("YEAR(invoice_date) = ?", params["year"]) if params["year"].present?
    invoices
  end
end
