require File.dirname(__FILE__) + '/../spec_helper'

describe CompaniesController, 'index' do
  controller_name :companies

  before do
    get :index
    @companies = assigns[:companies]
  end

  it 'should success' do
    response.should be_success
  end

  it 'should find companies' do
    @companies.should_not be_nil
  end

  it 'should paginate companies' do
    @companies.should be_respond_to(:current_page)
  end
end
