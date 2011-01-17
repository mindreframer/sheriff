class SummariesController < RestController

  new! do |format|
    format.html{render 'edit'}
  end

  create! do |success, error|
    error.html{render 'edit'}
  end

  
end