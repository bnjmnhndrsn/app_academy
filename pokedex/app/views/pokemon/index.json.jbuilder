json.array!(@pokemon) do |pmon|
  json.partial!("pokemon/pokemon", pokemon: pmon, show_toys: false)
end