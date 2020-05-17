ApiPagination.configure do |config|
  config.total_header = 'Total-Records'

  # Set this to add a header with the current page number.
  config.page_header = 'Page'
end
