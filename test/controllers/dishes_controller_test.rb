require 'test_helper'

class DishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dish = dishes(:one)
    @user = users(:admin)
  end

  test "should get index" do
    get dishes_url, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end

  test "forbidden returned by create if restricted action" do
    @user = users(:waiter)
    post dishes_url, params: { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 403

    @user = users(:chef)
    post dishes_url, params: { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 403
  end

  test "should create dish" do
    assert_difference('Dish.count') do
      post dishes_url, params: { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name }, headers: { 'Authorization': generate_jwt(@user) }
    end

    assert_response 201
  end

  test "not_found_error returned by show for invalid id" do
    get dish_url(-1), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 404
  end

  test "should show dish" do
    get dish_url(@dish), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end

  test "forbidden returned by update if restricted action" do
    @user = users(:waiter)
    put dish_url(@dish), params: { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 403

    @user = users(:chef)
    put dish_url(@dish), params: { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 403
  end

  test "not_found_error returned by update for invalid id" do
    @new_dish = dishes(:two)
    put dish_url(-1), params: { cost: @new_dish.cost, description: @new_dish.description, image: @new_dish.image, name: @new_dish.name }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 404
  end

  test "should update dish" do
    @new_dish = dishes(:two)
    put dish_url(@dish), params: { cost: @new_dish.cost, description: @new_dish.description, image: @new_dish.image, name: @new_dish.name }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end

  test "forbidden returned by destroy if restricted action" do
    @user = users(:waiter)
    delete dish_url(@dish), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 403

    @user = users(:chef)
    delete dish_url(@dish), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 403
  end

  test "should destroy dish" do
    assert_difference('Dish.count', -1) do
      delete dish_url(@dish), headers: { 'Authorization': generate_jwt(@user) }
    end

    assert_response 204
  end
end
