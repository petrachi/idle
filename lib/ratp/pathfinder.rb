module RATP::Pathfinder

  def djikstra_dist from:, to:
    to_expand = Hash.new{ |hash, key| hash[key] = {dist: Float::INFINITY, via: nil, link: nil}}
    to_expand[from][:dist] = 0

    expanded = {}

    loop do
      node, values = to_expand.min{ |(_,a), (_,b)| a[:dist] <=> b[:dist] }

      if node == to
        expanded[node] = to_expand.delete(node)
        break
      end

      node.links(exclude_nodes: expanded.keys).each do |link|
        dist = values[:dist] + link.dist

        if dist < to_expand[link.node_b][:dist]
          to_expand[link.node_b][:dist] = dist
          to_expand[link.node_b][:via] = node
          to_expand[link.node_b][:link] = link
        end
      end

      expanded[node] = to_expand.delete(node)
    end

    path = [to]

    loop do
      break unless expanded[path.first][:via]
      path.insert(0, expanded[path.first][:via])
    end

    path.map{ |e| {node: e}.merge(expanded[e]) }
  end

  def djikstra_step_by_step from:, to:
    to_expand = Hash.new{ |hash, key| hash[key] = {dist: Float::INFINITY, via: nil, link: nil}}
    to_expand[from][:dist] = 0

    expanded = {}
    expanded_list = []

    loop do
      node, values = to_expand.min{ |(_,a), (_,b)| a[:dist] <=> b[:dist] }

      expanded[node] = to_expand.delete(node)
      expanded_list << {node: node}.merge(expanded[node])
      break if node == to

      node.links(exclude_nodes: expanded.keys).each do |link|
        dist = values[:dist] + link.dist

        if dist < to_expand[link.node_b][:dist]
          to_expand[link.node_b][:dist] = dist
          to_expand[link.node_b][:via] = node
          to_expand[link.node_b][:link] = link
        end
      end
    end

    expanded_list
  end

  def astar_dist from:, to:
    to_expand = Hash.new{ |hash, key| hash[key] = {dist: Float::INFINITY, dist_to: key.dist(to), via: nil, link: nil}}
    to_expand[from][:dist] = 0

    expanded = {}

    loop do
      node, values = to_expand.min{ |(_,a), (_,b)| a[:dist] + a[:dist_to] <=> b[:dist] + b[:dist_to] }

      if node == to
        expanded[node] = to_expand.delete(node)
        break
      end

      node.links(exclude_nodes: expanded.keys).each do |link|
        dist = values[:dist] + link.dist

        if dist < to_expand[link.node_b][:dist]
          to_expand[link.node_b][:dist] = dist
          to_expand[link.node_b][:via] = node
          to_expand[link.node_b][:link] = link
        end
      end

      expanded[node] = to_expand.delete(node)
    end

    path = [to]

    loop do
      break unless expanded[path.first][:via]
      path.insert(0, expanded[path.first][:via])
    end

    path.map{ |e| {node: e}.merge(expanded[e]) }
  end


  def astar_step_by_step from:, to:
    to_expand = Hash.new{ |hash, key| hash[key] = {dist: Float::INFINITY, dist_to: key.dist(to), via: nil, link: nil}}
    to_expand[from][:dist] = 0

    expanded = {}
    expanded_list = []

    loop do
      node, values = to_expand.min{ |(_,a), (_,b)| a[:dist] + a[:dist_to] <=> b[:dist] + b[:dist_to] }

      expanded[node] = to_expand.delete(node)
      expanded_list << {node: node}.merge(expanded[node])
      break if node == to

      node.links(exclude_nodes: expanded.keys).each do |link|
        dist = values[:dist] + link.dist

        if dist < to_expand[link.node_b][:dist]
          to_expand[link.node_b][:dist] = dist
          to_expand[link.node_b][:via] = node
          to_expand[link.node_b][:link] = link
        end
      end
    end

    expanded_list
  end

  def astar_time from:, to:
    to_expand = Hash.new{ |hash, key| hash[key] = {time: Float::INFINITY, dist_to: key.dist(to), via: nil, link: nil}}
    to_expand[from][:time] = 0

    expanded = {}

    loop do
      node, values = to_expand.min{ |(_,a), (_,b)| a[:time] + a[:dist_to] <=> b[:time] + b[:dist_to] }

      if node == to
        expanded[node] = to_expand.delete(node)
        break
      end

      node.links(exclude_nodes: expanded.keys).each do |link|
        time = values[:time] + link.time(corres: values[:link])

        if time < to_expand[link.node_b][:time]
          to_expand[link.node_b][:time] = time
          to_expand[link.node_b][:via] = node
          to_expand[link.node_b][:link] = link
        end
      end

      expanded[node] = to_expand.delete(node)
    end

    path = [to]

    loop do
      break unless expanded[path.first][:via]
      path.insert(0, expanded[path.first][:via])
    end

    path.map{ |e| {node: e}.merge(expanded[e]) }
  end

  extend self
end
