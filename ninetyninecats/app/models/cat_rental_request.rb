class CatRentalRequest < ActiveRecord::Base
  STATUS_TYPES = ["PENDING", "APPROVED", "DENIED"]

  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: STATUS_TYPES }
  validate :overlapping_approved_requests

  belongs_to :cat

  def pending?
    self.status == "PENDING"
  end

  def overlapping_requests
    sql = <<-SQL
    (start_date <= ? AND end_date >= ?)
    OR
    (start_date >= ? AND start_date <= ?)
    SQL

    query = CatRentalRequest.where("cat_id = ?", cat_id)
    .where(sql, start_date, start_date, start_date, end_date)

    persisted?  ? query.where("id != ?", id) : query
  end

  def overlapping_approved_requests
    return nil if status == 'DENIED'
    unless overlapping_requests.where("status = 'APPROVED'").length == 0
      errors[:overlapping_requests] << "no overlapping requests"
    end
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  def deny!
    self.update!(status: "DENIED")
  end

  def approve!
    CatRentalRequest.transaction do
      self.update!(status: "APPROVED")
      overlapping_pending_requests.each(&:deny!)
    end
  end
end
