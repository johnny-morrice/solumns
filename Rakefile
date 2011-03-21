def gracket args
	sh "gracket -W info -l errortrace -t #{args}"
end

def racket args
	sh "racket -W info -l errortrace -t #{args}"
end

task :racket do
	if ENV["ARGS"]
		gracket ENV["ARGS"]
	else
		raise "Usage: rake racket ARGS=\"arg1 arg2...\""
	end
end

desc "Test the grid file."
task :test_grid do
	racket "test/grid.rkt"
end

desc "Test the brute-force sub-optimising algorithm."
task :test_bruteforce do
	racket "test/brute-force.rkt"
end


desc "Generate random columns."
task :test_random do
	racket "test/random.rkt"
end

desc "Run solumns"
task :solumns do
	gracket "solumns/main.rkt"
end

