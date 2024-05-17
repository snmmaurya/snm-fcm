# frozen_string_literal: true

RSpec.describe Snm::Fcm do
  before do
    stub_request(:post, "https://www.googleapis.com/auth/cloud-platform").to_return(:status => 200, :body => "6f0c11ca3ccd42f17a604e581987d36b27a3db47a6e109070391236b1b19dfa7592664ea3c1c133c1f3ab785674f6ff84badc291ff4e831294d790183edbf6e185e7845a48044a4cb61f87c3f5f04bd1523158f3bb6f72792c5181c56da9c8db46190162")
    @msg_data = {
      'message'=> {
        'token'=> 'android-device-fcm-token',
        'notification'=>
        {
          'title'=> 'Lorem ipsum',
          'body'=> 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          'image'=> 'https://www.snmmaurya.com/images/me.jpg'
        },
        'data'=> {
          'key1'=> 'value1',
          'key2'=> 'value2'
          }
        }
    }
    stub_request(:post, "https://fcm.googleapis.com/v1/projects/snm-fcm/messages:send").with(
    body: @msg_data.to_json,
    headers: {
    'Authorization'=>'Bearer ya29.c.c0AY_VpZhvc4XmnRbKy9zguDy7BWxwkLyP-XHKgh3JJoRcB-xNQFCJxcLdNrnKv3pvu6h_ehrNbNNONVzsfgpDkS8ZNlOljSqBwffIVTKZtIVa0DlRNWUeNkxaSIoOOGaT90k7MO1F1cUCkdXNWOyVadAXLZ7EEcLB8yYspQDbHKFIbUlywZ2J7dls1CKYrccnXe0P5WUlIwdeThHNuNn9Qobk7a3JZtKCHTStTGtyBIf4OKGttVFyTUHQq3Iy8cfgg-lSnZB-yUsvdOxeAXGStw_KVvWbXlbTLXlMAmUd-WQy5jx9_4RgdcBGb7mciA9J9GPWFsGmnJvYm8Kz7_f8T1DGjAVZc69sEQ6FoeH1VCiTI5JLhPnDHwKsG385DjhoZ1pZmabBSr_aeihX37kJwRa_bnjRn04zj9aUR5BvXvfu1lw48Ybbjp6nmVYhc0QkMWep6eXI2I9ykXR_fFYuvWp5W721BgOkZocS-SQ2ehJZ3ZhjgUS58Iv0jtR1s7-QBcRgdsBemhsIISXId0_Fh-y-8UX6RfQiugvnnIIt149z1JRcQdf_2gioizpyyjfyskckFh3Qdw6VjJnjmvMhO04qdhQZOrZSw7Mr59jia9FcznXl54xnywde4-m6iUZ3g-n_hY9n4O3yxsdolQojrr-dFzBV12_zBfoQOmnJOFQjWv_V_-S0k-BBQRvMteIZX6YQIeO9disnbYxvfXdZoF0cOYBbi-Mqd5u-BsUMmM_V1ntUyZJZFk2q4JWd0rZigedv8o_eFMgIbgJIWwzfavOyQp82OXXx_ul8goQhVJRysuxnchmdeie_eZ6822mnWmlUm7u4Oqy_VIS_qm2cvQOtycioFy2wbd8s2IW7j5SeReijIl-bmioBgwi682mtrXleSgfOuFwOV19WFzaadYknjO5zOXbx4sfWpsQp-3-gfck6o4jzw84v51Xpv_QtuOj88b0v2OnYut1otXQ7tR_YOxsr9oyl-dJ9ygvUm8pXl9vaFUztnwn',
    'Connection'=>'close',
    'Content-Type'=>'application/json',
    'Host'=>'fcm.googleapis.com',
    'User-Agent'=>'http.rb/5.2.0'
    }).to_return(status: 200, body: {"name"=>"projects/snm-fcm/messages/0:1715935676674045%f570bc3bf570bc3b"}.to_json, headers: {})
  end

  it "has a version number" do
    expect(Snm::Fcm::VERSION).not_to be nil
  end

  it "should be configure and setup" do
    Snm::Fcm::Notification.configure do |config|
      config.credentails_file_path = '/Users/snmmaurya/Documents/workplanet/mine/gems/snm-fcm/spec/fixtures/snm-fcm.json'
      config.redis_endpoint = 'redis://localhost:6379/1'
    end
    expect(Snm::Fcm::Notification.setup).not_to be_nil
  end

  it "It should send notification" do
    Snm::Fcm::Notification.configure do |config|
      config.credentails_file_path = '/Users/snmmaurya/Documents/workplanet/mine/gems/snm-fcm/spec/fixtures/snm-fcm.json'
      config.redis_endpoint = 'redis://localhost:6379/1'
    end
    Snm::Fcm::Notification.setup
    output = Snm::Fcm::Notification.deliver(@msg_data)
    expect(output).to eq({"name"=>"projects/snm-fcm/messages/0:1715935676674045%f570bc3bf570bc3b"})
  end
end
