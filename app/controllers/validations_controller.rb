class ValidationsController < RestController
  update! do |success|
    success.html{redirect_back_or_default @validation.report}
  end
end