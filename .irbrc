
# Monkeypatching
class Object
  def own_methods
    methods - Object.methods
  end
end
