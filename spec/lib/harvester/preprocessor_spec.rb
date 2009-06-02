require File.dirname(__FILE__) + '/../../spec_helper'

describe 'GNI::Preprocessor' do
  before(:all) do
    Scenario.load :application
    @data_source = DataSource.find(1)
  end
  
  describe 'should handle xml files' do
  
    before(:each) do
      Scenario.load :harvest_valid_tcs_xml
      ImportScheduler.all.each {|i| i.destroy}
      ImportScheduler.create(:data_source => @data_source, :status => ImportScheduler::PREPROCESSING, :message => 'Downloaded')
      @import_scheduler = ImportScheduler.current(@data_source)
    end
    
    it 'should copy xml file to repositories/1 directory' do
      @import_scheduler.status.should == ImportScheduler::PREPROCESSING
      File.exists?(@data_source.directory_path).should be_false
      ppr = GNI::Preprocessor.new
      ppr.do_preprocessing do |status|
        status.should == ImportScheduler::PROCESSING
        File.exists?(@data_source.directory_path).should be_true
        File.exists?(@data_source.directory_path + '/' + @data_source.id.to_s).should be_true
        file_type = IO.popen("file " + @data_source.directory_path + '/' + @data_source.id.to_s).read
        file_type.match(/XML/).should be_true
      end
    end
  end
  
  describe 'should handle zipped directory with Darwin Core Schema Files' do
    
    before(:each) do
      Scenario.load :harvest_valid_dwc_star
      ImportScheduler.all.each {|i| i.destroy}
      ImportScheduler.create(:data_source => @data_source, :status => ImportScheduler::PREPROCESSING, :message => 'Downloaded')
      @import_scheduler = ImportScheduler.current(@data_source)
    end
    
    it 'should unzip and copy dwc files and create tcs file' do
      @import_scheduler.status.should == ImportScheduler::PREPROCESSING
      File.exists?(@data_source.directory_path).should be_false
      ppr = GNI::Preprocessor.new
      ppr.do_preprocessing do |status|
        status.should == ImportScheduler::PROCESSING
        File.exists?(@data_source.directory_path).should be_true
        File.exists?(@data_source.directory_path + '/' + 'meta.xml').should be_true        
        File.exists?(@data_source.directory_path + '/' + @data_source.id.to_s).should be_true
        file_type = IO.popen("file " + @data_source.directory_path + '/' + @data_source.id.to_s).read
        file_type.match(/XML/).should be_true
      end
    end
  end

  describe 'should handle zipped Darwin Core Schema Files' do
    
    before(:each) do
      Scenario.load :harvest_valid_dwc_star_no_dir
      ImportScheduler.all.each {|i| i.destroy}
      ImportScheduler.create(:data_source => @data_source, :status => ImportScheduler::PREPROCESSING, :message => 'Downloaded')
      @import_scheduler = ImportScheduler.current(@data_source)
    end

    it 'should unzip and copy dwc files and create tcs file' do
      @import_scheduler.status.should == ImportScheduler::PREPROCESSING
      File.exists?(@data_source.directory_path).should be_false
      ppr = GNI::Preprocessor.new
      ppr.do_preprocessing do |status|
        status.should == ImportScheduler::PROCESSING
        File.exists?(@data_source.directory_path).should be_true
        File.exists?(@data_source.directory_path + '/' + 'meta.xml').should be_true        
        File.exists?(@data_source.directory_path + '/' + @data_source.id.to_s).should be_true
        file_type = IO.popen("file " + @data_source.directory_path + '/' + @data_source.id.to_s).read
        file_type.match(/XML/).should be_true
      end
    end
  end

  describe 'should handle html files containing 404 or 500 errors' do
    
    before(:each) do
      Scenario.load :harvest_404_html
      ImportScheduler.all.each {|i| i.destroy}
      ImportScheduler.create(:data_source => @data_source, :status => ImportScheduler::PREPROCESSING, :message => 'Downloaded')
      @import_scheduler = ImportScheduler.current(@data_source)
    end
    
    it 'should unzip and copy dwc files and create tcs file' do
      @import_scheduler.status.should == ImportScheduler::PREPROCESSING
      File.exists?(@data_source.directory_path).should be_false
      ppr = GNI::Preprocessor.new
      ppr.do_preprocessing do |status|
        status.should == ImportScheduler::FAILED
        File.exists?(@data_source.directory_path).should be_false
      end
    end
  end
  
end
