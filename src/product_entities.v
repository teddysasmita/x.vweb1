module main

@[table: 'products']

struct Product {
	t_id    int    @[primary; sql: serial]
	id 		int
	name       string @[sql_type: 'TEXT']
	created_at string @[default: 'CURRENT_TIMESTAMP']
	mod_at string @[sql_type: 'TIMESTAMP']
	deleted_at string @[sql_type: 'TIMESTAMP']
	active bool @[default: TRUE]
	mod_by int
	created_by int
	deleted_by int
}
