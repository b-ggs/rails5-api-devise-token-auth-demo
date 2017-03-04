module ItemsHelper
  def build_item(append_to_name = '')
    Item.new(
      name: "Foobar" + append_to_name,
      description: "I am a foobar!",
      quantity: 1
    )
  end
end
