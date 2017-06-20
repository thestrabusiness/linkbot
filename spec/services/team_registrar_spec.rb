require 'rails_helper'

RSpec::Matchers.define_negated_matcher :not_change, :change

describe TeamRegistrar do
  describe '.perform' do
    before(:each) do
      allow_any_instance_of(Slack::Web::Client).to receive(:oauth_access).and_return(slack_api_response)
      allow_any_instance_of(SlackRubyBotServer::Service).to receive(:create!).and_return('Team Instance Created')
    end

    context 'with valid parameters' do
      before(:each) do
        allow_any_instance_of(TeamMemberRegistrar).to receive(:perform).and_return(true)
      end

      it 'creates a new team that matches the response from the slack API' do
        TeamRegistrar.perform('code', nil)
        team = Team.last

        expect(Team.count).to eq 1
        expect(team.team_id).to eq slack_api_response['team_id']
        expect(team.token).to eq slack_api_response['bot']['bot_access_token']
        expect(team.name).to eq slack_api_response['team_name']
      end

      it 'calls the TeamMemberRegistrar service' do
        expect_any_instance_of(TeamMemberRegistrar).to receive(:perform)
        TeamRegistrar.perform('code', nil)
      end

      it 'starts an instance of the bot' do
        expect_any_instance_of(SlackRubyBotServer::Service).to receive(:create!)
        TeamRegistrar.perform('code', nil)
      end
    end

    context 'with invalid parameters' do
      before(:each) do
        allow(TeamRegistrar).to receive(:perform).and_raise(ArgumentError.new('Required arguments :code missing'))
      end

      context 'such as a missing code' do
        it 'raises an ArgumentError' do
          expect{ TeamRegistrar.perform(nil,nil) }
              .to raise_error(ArgumentError)
        end

        it 'does not create a new team' do
          expect { TeamRegistrar.perform(nil,nil) }
              .to raise_error(ArgumentError)
              .and not_change(Team, :count)
        end

        it 'does not call the TeamMemberRegistrar service' do
          expect { TeamRegistrar.perform(nil,nil) }
              .to raise_error(ArgumentError)

          expect_any_instance_of(TeamMemberRegistrar).to_not receive(:perform)
        end


        it 'does not start an instance of the bot' do
          expect { TeamRegistrar.perform(nil,nil) }
              .to raise_error(ArgumentError)

          expect_any_instance_of(SlackRubyBotServer::Service).to_not receive(:create!)
        end
      end
    end

    context 'when a rollback exception is raised' do
      context 'by TeamRegistrar' do
        before(:each) do
          allow_any_instance_of(TeamRegistrar).to receive(:perform).and_raise(ActiveRecord::Rollback)
          expect { TeamRegistrar.perform('code',nil) }
              .to raise_error(ActiveRecord::Rollback)
        end

        it 'does not create a new team' do
          expect(Team.count).to eq 0
        end

        it 'does not start an instance of the bot' do
          expect_any_instance_of(SlackRubyBotServer::Service).to_not receive(:create!)
        end
      end

      context 'by TeamMemberRegistrar' do
        before(:each) do
          allow_any_instance_of(TeamMemberRegistrar).to receive(:perform).and_return(false)
        end

        it 'does not create a new team' do
          expect(Team.count).to eq 0
        end

        it 'does not start an instance of the bot' do
          expect_any_instance_of(SlackRubyBotServer::Service).to_not receive(:create!)
        end
      end
    end
  end

  def slack_api_response
    {
        "ok"=>true,
        "access_token"=>"xoxp-31319969300-31323300724-186703078213-7d1d32b4cb2a15d519de8d6161798d66",
        "scope"=>"identify,bot,mpim:history,channels:read,groups:read,mpim:read,users:read,users.profile:read,chat:write:bot,identity.basic,identity.email,identity.team,links:read",
        "user_id"=>"U0X9H8UMA",
        "team_name"=>"WHAK",
        "team_id"=>"T0X9DUH8U",
        "bot"=> {
            "bot_user_id"=>"U5F4HRNUX", "bot_access_token"=>"xoxb-185153872983-VSkfHJY9RHpcWYez1raBGWVc"
        }
    }
  end
end
