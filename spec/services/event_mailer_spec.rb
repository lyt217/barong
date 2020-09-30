# frozen_string_literal: true

describe EventMailer do
  let(:event_mailer) { EventMailer.new('', '', '')}
  let(:event) {
    {:record=>
      {:user=>
        {:uid=>"ID8434CD6E8E",
         :email=>"admin@barong.io",
         :role=>"admin",
         :level=>1,
         :otp=>false,
         :state=>"active",
         :referral_uid=>nil,
         :created_at=>"2020-05-26T07:01:04Z",
         :updated_at=>"2020-05-26T08:30:54Z"},
       :user_ip=>"::1",
       :user_agent=>"PostmanRuntime/7.25.0"},
     :name=>"system.session.create",
     :state=>"sdasd"
    }
  }

  describe "#nested_hash_value" do
    it 'return event value' do
      expect(event_mailer.send(:safe_dig, event, %i[name])).to eq event[:name]
      expect(event_mailer.send(:safe_dig, event, %i[record user state])).to eq event[:record][:user][:state]
      expect(event_mailer.send(:safe_dig, event, %i[record user uid])).to eq event[:record][:user][:uid]
      expect(event_mailer.send(:safe_dig, event, %i[record user_agent])).to eq event[:record][:user_agent]
      expect(event_mailer.send(:safe_dig, event, %i[record user_ip])).to eq event[:record][:user_ip]
      expect(event_mailer.send(:safe_dig, event, %i[record name])).to eq nil
    end
  end

  describe 'database connection' do
    it 'should reconnect to database' do
      ActiveRecord::Base.clear_all_connections!

      event_mailer.send(:reconnect)

      expect(ActiveRecord::Base.connected?).to eq true
    end

    it 'shouldnt reconnect to database' do
      ActiveRecord::Base.clear_all_connections!

      expect(ActiveRecord::Base.connected?).to eq false
    end
  end
end
