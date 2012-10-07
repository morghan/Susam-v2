class AssignmentAnswer < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :student
  validates_presence_of :title,:content
  has_attached_file :attachment ,
    :path => ":rails_root/public/uploads/assignments/:assignment_employee_id/:assignment_id/answers/:student_id/:basename.:extension"

  def download_allowed_for user
    return true if user.admin?
    return  (user.employee_record.id==self.assignment.employee_id) if user.employee?
    return (self.student_id == user.student_record.id) if user.student?
    false
  end
end
