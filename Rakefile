def gracket args
	sh "gracket -W info -l errortrace -t #{args}"
end

desc "Just run racket on a file."
task :racket do
	if ENV["ARGS"]
		gracket ENV["ARGS"]
	else
		raise "Usage: rake racket ARGS=\"arg1 arg2...\""
	end
end

desc "Test the grid file."
task :test_grid do
	gracket "test/grid.rkt"
end

desc "Test the brute-force sub-optimising algorithm."
task :test_bruteforce do
	gracket "test/brute-force.rkt"
end

desc "Run solumns"
task :solumns do
	gracket "solumns/main.rkt"
end
