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


desc "Check the GUI looks correct."
task :test_draw do
	gracket "test/gui/grid.rkt"
end

desc "Check the GUI can be resized and redrawn okay."
task :test_refresh do
	gracket "test/gui/refresh.rkt"
end

desc "Check that the algorithms can create colours"
task :test_cmap do
	gracket "test/gui/colour-mapping.rkt"
end

desc "Test user input"
task :test_input do
	gracket "test/gui/frame.rkt"
end

desc "Test gravity, neighbouring column elimination." 
task :test_grid do
	racket "test/grid.rkt"
end

desc "Test the brute-force sub-optimising algorithm."
task :test_bruteforce do
	racket "test/brute-force.rkt"
end

desc "Test generation of random columns."
task :test_random do
	racket "test/random.rkt"
end

desc "Test everything"
task :test => [:test_grid, :test_random,
	:test_bruteforce, :test_input,
	:test_cmap, :test_draw]

desc "Run solumns"
task :solumns do
	gracket "solumns/main.rkt"
end
