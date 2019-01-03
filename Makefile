run:
	rails s -b 0.0.0.0 -p 3000 -e development

# start:
# 	foreman start -f Procfile.dev
docs-api:
	rake rswag:specs:swaggerize
	
install:
	bundle install

update:
	bundle update

create:
	@rails db:create:all

migrate:
	@rails db:migrate

seed:
	rails db:seed

console:
	rails console

teste:
	bin/rspec

reset:
	bundle install; rails db:drop:all db:create:all db:migrate

rollback:
	rails db:rollback