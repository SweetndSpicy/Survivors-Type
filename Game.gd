class_name Game extends Node2D


func safely_get_node(path: NodePath) -> Node:
		var node = get_node_or_null(path)
		assert( node != null, "Node at '%s' is not found!" %path)
		return node
		
func safely_add_child(parent: Node, child: Node) -> void:
		if not is_instance_valid(parent):
			push_error("Parent Node is not valid.")
			return
		elif not is_instance_valid(child):
			push_error("Child Node is not valid.")
			return
		parent.call_deferred("add_child",child)
		
func safely_queue_free(node: Node) -> void:
		if is_instance_valid(node):
			node.queue_free()
		else:
			push_error("'%s' is invalid, can't be freed." %node)
