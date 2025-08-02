require "test_helper"

class ProfileUploadTest < ActionDispatch::IntegrationTest
  test "should upload avatar successfully" do
    # Create a test image file
    image_file = fixture_file_upload('test_image.png', 'image/png')

    post profiles_upload_avatar_path, params: {
      profile: { avatar: image_file }
    }

    assert_response :success

    response_data = JSON.parse(response.body)
    assert response_data['success'], "Expected success but got: #{response_data['error']}"
    assert_not_nil response_data['avatar_url']
  end

  test "should reject non-image files" do
    # Create a test text file
    text_file = fixture_file_upload('test_file.txt', 'text/plain')
    
    post profiles_upload_avatar_path, params: {
      profile: { avatar: text_file }
    }
    
    assert_response :success
    
    response_data = JSON.parse(response.body)
    assert_not response_data['success']
    assert_includes response_data['error'], 'must be a JPEG, PNG, GIF, or WebP image'
  end

  test "should access profile index page" do
    get root_path
    assert_response :success
    assert_select 'img#profilePic'
    assert_select '.upload-overlay'
  end
end
