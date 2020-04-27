module SectionsHelper

  def display_network?(network)
    IPAddr.new(network).ipv4? && IPAddr.new(network).prefix >= 24
  end
end
