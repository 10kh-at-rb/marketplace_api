RSpec.shared_examples "paginated list" do
  specify { expect(json_response).to have_key(:meta) }
  specify { expect(json_response[:meta]).to have_key(:pagination) }
  specify { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
  specify { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
  specify { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }
end
