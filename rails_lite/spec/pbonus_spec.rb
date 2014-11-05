require 'webrick'
require 'phase4/session'
require 'phase4/controller_base'

describe Phase4::Flash do
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cook) { WEBrick::Cookie.new('_rails_lite_app_flash', { xyz: 'abc' }.to_json) }

  it "deserializes json cookie and loads next key if one exists" do
    req.cookies << cook
    flash = Phase4::Flash.new(req)
    flash['xyz'].should == 'abc'
  end

  describe "#store_session" do
    context "without cookies in request" do
      before(:each) do
        flash = Phase4::Flash.new(req)
        flash['first_key'] = 'first_val'
        flash.store_flash(res)
      end

      it "adds new cookie with '_rails_lite_app_flash' name to response" do
        cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
        cookie.should_not be_nil
      end

      it "stores the cookie in json format" do
        cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
        JSON.parse(cookie.value).should be_instance_of(Hash)
      end
    end

    context "with cookies in request" do
      before(:each) do
        cook = WEBrick::Cookie.new('_rails_lite_app_flash', { pho: "soup" }.to_json)
        req.cookies << cook
      end

      it "reads the pre-existing cookie data into hash" do
        flash = Phase4::Flash.new(req)
        flash['pho'].should == 'soup'
      end

      it "saves new data and deletes old data" do
        flash = Phase4::Flash.new(req)
        flash['machine'] = 'mocha'
        flash.store_flash(res)
        cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
        h = JSON.parse(cookie.value)
        h['pho'].should be_nil
        h['machine'].should == 'mocha'
      end
    end
  end
end

describe Phase4::ControllerBase do
  before(:all) do
    class CatsController < Phase4::ControllerBase
    end
  end
  after(:all) { Object.send(:remove_const, "CatsController") }

  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cats_controller) { CatsController.new(req, res) }

  describe "#flash" do
    it "returns a session instance" do
      expect(cats_controller.flash).to be_a(Phase4::Flash)
    end

    it "returns the same instance on successive invocations" do
      first_result = cats_controller.flash
      expect(cats_controller.flash).to be(first_result)
    end
  end
  
  describe "#render_content" do
    it "should not display newly added values after a render" do
      cats_controller.flash['test_key'] = 'test_value'
      cats_controller.render_content('test', 'text/plain')
      cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
      h = JSON.parse(cookie.value)
      expect(h['test_key']).to be_nil
    end
    
    it "should display values added with the new keyword after a render" do
      cats_controller.flash.now['test_key'] = 'test_value'
      cats_controller.render_content('test', 'text/plain')
      cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
      h = JSON.parse(cookie.value)
      expect(h['test_key']).to eq('test_value')
    end
    
  end
  
  describe "#redirect" do
    it "should display newly added values after a redirect" do
      cats_controller.flash['test_key'] = 'test_value'
      cats_controller.redirect_to('/')
      cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
      h = JSON.parse(cookie.value)
      expect(h['test_key']).to eq('test_value')
    end
    
    it "should not display values added with the new keyword after a redirect" do
      cats_controller.flash.now['test_key'] = 'test_value'
      cats_controller.redirect_to('/')
      cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
      h = JSON.parse(cookie.value)
      expect(h['test_key']).to be_nil
    end
    
  end
  
end