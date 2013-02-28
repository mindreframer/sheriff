
deputies = Deputy.where(["last_report_at < ? ", 1.months.ago ]).where("deleted_at is NULL")
names = deputies.map(&:name)
filtered  = names.grep(/apps/).sort
to_delete = Deputy.where(:name => filtered)
to_delete.map(&:delete)