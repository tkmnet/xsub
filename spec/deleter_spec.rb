require 'stringio'

RSpec.describe Xsub::Deleter do

  before(:each) do
    @deleter = Xsub::Deleter.new( Dummy.new )
    $stdout = StringIO.new  # supress stdout
  end

  after(:each) do
    $stdout = STDOUT
  end

  context "when job_id is given" do

    it "calls Scheduler#delete" do
      argv = %w(1234)
      expect(@deleter.scheduler).to receive(:status).and_return("running")
      expect(@deleter.scheduler).to receive(:delete).with("1234").and_call_original
      @deleter.run(argv)
    end

    it "does not call #delete when job is finished" do
      argv = %w(1234)
      allow(@deleter.scheduler).to receive(:status).and_return(:finished)
      expect(@deleter.scheduler).to_not receive(:delete)
      @deleter.run(argv)
    end
  end

  context "when job_id is not given" do

    it "raises an error" do
      expect {
        @deleter.run([])
      }.to raise_error "job_id is not given"
    end
  end
end

