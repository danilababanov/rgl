require 'dot/dot'

# Minimal Dot support based on Dave Thomas dot module (included in
# rdoc). dot/dot.rb is a modified version which also contains support for
# undirected graphs.
module RGL
  module Graph
	# Return a DOT::DOTDigraph for directed graphs or a DOT::DOTSubgraph for an
	# undirected Graph. _params_ can contain any graph property specified in
	# dot/dot.rb.
	def to_dot_graph( params = {} )
	  params['name'] ||= self.class.name.gsub(/:/,'_')
	  fontsize = params['fontsize'] ? params['fontsize'] : '8'
	  graph = (directed? ? DOT::DOTDigraph : DOT::DOTSubgraph).new(params)
	  edge_class = directed? ? DOT::DOTDirectedEdge : DOT::DOTEdge
#	  each_vertex do |v|
#		graph << DOT::DOTNode.new('name' => escape(v.to_s),
#								  'fontsize' => fontsize,
#								  'label' => v.to_s)
#	  end
	  each_edge do |u,v|
		graph << edge_class.new('from' => '"'+ u.to_s + '"',
								'to' => '"'+ v.to_s + '"',
								'fontsize' => fontsize)
	  end
	  graph
	end

	# Output the DOT-graph to stream _s_.
	def print_dotted_on (params = {}, s=$stdout)
	  s << to_dot_graph(params).to_s << "\n"
	end

	# Call +dotty+ for the graph which is written to the file 'graph.dot' in the
	# current directory.
	def dotty( params = {} )
	  dotfile = "graph.dot"
	  File.open(dotfile, "w") {|f|
		print_dotted_on(params, f)
	  }
	  system "dotty #{dotfile}"
	end

	# Use +do+ to create a graphical representation of the graph. Returns the
	# filename of the graphics file.
	def write_to_graphic_file(fmt='png', dotfile="graph")
      src = dotfile + ".dot"
      dot = dotfile + "." + fmt
      
      File.open(src, 'w') do |f|
        f << self.to_dot_graph.to_s << "\n"
      end
      
      system( "dot -T#{fmt} #{src} -o #{dot}" )
      dot
    end
  end
end
