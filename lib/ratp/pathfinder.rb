module RATP::Pathfinder

  def djikstra from:, to:

    priority_queue = Hash.new{ |hash, key| hash[key] = {dist: Float::INFINITY, time: Float::INFINITY, via: nil, link: nil}}
    priority_queue[from] = {dist: 0, time: 0, via: nil, link: nil}

    expanded = []

    loop do

      # to_expand = priority_queue.min{ |(_,a), (_,b)| a[:dist] <=> b[:dist] }
      to_expand = priority_queue.min{ |(_,a), (_,b)| a[:time] <=> b[:time] }


      to_expand[0].links.select{|e| expanded.map{|e| e[0]}.exclude? e.node_b }.each do |link|
      # to_expand[0].links.each do |link|

        dist = to_expand[1][:dist] + link.dist

        time = to_expand[1][:time] + link.time
        time += 240 + 30 * to_expand[0].attributes[:correspondances].size if link.line != to_expand[1][:link].try(:line)

        # p "analysing #{to_expand[0].name} to #{link.node_b.name} - dist is #{dist} - actual is #{priority_queue[link.node_b][:dist]}"

        # if dist < priority_queue[link.node_b][:dist]
        if time < priority_queue[link.node_b][:time]
          priority_queue[link.node_b] = {dist: dist, time: time, via: to_expand[0], link: link}
        end

      end

      expanded << to_expand
      priority_queue.delete(to_expand[0])

      break if to_expand[0] == to
    end

    path = [expanded.pop]

    loop do
      popped = expanded.pop
      path << popped if popped[0] == path.last[1][:via]

      break if expanded.empty?
    end

    path.reverse.map{|e| {node: e[0]}.merge(e[1]) }
  end



  def a_star from:, to:

    priority_queue = Hash.new{ |hash, key| hash[key] = {dist: Float::INFINITY, e_dist: key.dist(to), time: Float::INFINITY, via: nil, link: nil}}
    priority_queue[from].merge!(dist: 0, time: 0, via: nil, link: nil)

    expanded = []

    loop do
      to_expand = priority_queue.min{ |(_,a), (_,b)| a[:time] + a[:e_dist] <=> b[:time] + b[:e_dist] }
      to_expand[0].links.select{|e| expanded.map{|e| e[0]}.exclude? e.node_b }.each do |link|

        dist = to_expand[1][:dist] + link.dist
        time = to_expand[1][:time] + link.time
        time += 240 + 30 * to_expand[0].attributes[:correspondances].size if link.line != to_expand[1][:link].try(:line)

        if time < priority_queue[link.node_b][:time]
          priority_queue[link.node_b].merge!(dist: dist, time: time, via: to_expand[0], link: link)
        end
      end

      expanded << to_expand
      priority_queue.delete(to_expand[0])

      break if to_expand[0] == to
    end

    path = [expanded.pop]

    loop do
      popped = expanded.pop
      path << popped if popped[0] == path.last[1][:via]

      break if expanded.empty?
    end

    path.reverse.map{|e| {node: e[0]}.merge(e[1]) }
  end


  extend self
end
