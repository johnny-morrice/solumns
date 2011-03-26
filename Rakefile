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

desc "Check that the player can move blocks with the arrow keys"
task :test_drop do
	gracket "test/gui/drop.rkt"
end

desc "Test that we can keep a record of high scores okay."
task :test_record do
	gracket "test/gui/record.rkt"
end

desc "Try a minimal prototype of solumns"
task :test_game do
	gracket "test/gui/game.rkt"
end

desc "Try a prototype of solumns with score information displayed."
task :test_score do
	gracket "test/gui/score.rkt"
end

desc "Test a version of solumns with high score gathering"
task :test_hiscore do
	gracket "test/gui/hiscore.rkt"
end

desc "Check to see if we can fill in a high score properly"
task :test_fill_hiscore do
	gracket "test/gui/fill-hiscore.rkt"
end

desc "Check that the algorithms can create colours"
task :test_cmap do
	gracket "test/gui/colour-mapping.rkt"
end

desc "Test user input"
task :test_input do
	gracket "test/gui/input.rkt"
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

desc "Run all (automated) tests"
task :test => [:test_grid, :test_random,
	:test_bruteforce, :test_cmap]

desc "Run solumns"
task :solumns do
	gracket "solumns/main.rkt"
end
