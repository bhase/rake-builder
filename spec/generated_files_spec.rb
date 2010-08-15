require File.dirname(__FILE__) + '/spec_helper.rb'

describe 'when handling generated files' do

  include RakeCppHelper

  before( :each ) do
    Rake::Task.clear
    @project = cpp_task( :executable )
    @expected_generated = Rake::Cpp.expand_paths_with_root(
                            [
                             'main.o',
                             'rake-cpp-testfile.txt',
                             @project.makedepend_file,
                             @project.target
                            ],
                            SPEC_PATH
                          )
  end

  after( :each ) do
    Rake::Task[ 'clean' ].execute
  end

  it 'lists generated files' do
    @project.generated_files.sort.should == @expected_generated.sort
  end

  it 'removes generated files with \'clean\'' do
    Rake::Task[ 'run' ].invoke
    @expected_generated.each do |f|
      exist?( f ).should be_true
    end
    Rake::Task[ 'clean' ].invoke
    @expected_generated.each do |f|
      exist?( f ).should be_false
    end
  end

end

describe 'when adding generated files' do

  include RakeCppHelper

  before( :each ) do
    @file = 'foobar.txt'
    @file_with_path = Rake::Cpp.expand_path_with_root( @file, SPEC_PATH )
  end

  it 'includes added files' do
    @project = cpp_task( :executable ) do |app|
      app.generated_files << @file_with_path
    end
    @project.generated_files.include?( @file_with_path ).should be_true
  end

  it 'expands the paths of added files' do
    @project = cpp_task( :executable ) do |app|
      app.generated_files << @file
    end
    @project.generated_files.include?( @file_with_path ).should be_true
  end

end
