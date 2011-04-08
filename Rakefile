def gracket args
	sh "gracket -W info -l errortrace -t #{args}"
end

def racket args
	sh "racket -W info -l errortrace -t #{args}"
end

def solumns_exe
	if RUBY_PLATFORM =~ /(win|w)32$/
		"solumns.exe"
	else
		"solumns"
	end
end

desc "Test a game where the columns are shuffled."
task :test_shuffle do
	gracket "test/gui/shuffler.rkt"
end

desc "Check we can shuffle a list"
task :test_shuffling do
	racket "test/shuffle.rkt"
end

desc "Check cycles can be detected and prevented"
task :test_cycle do
	racket "test/cycle-detector.rkt"
end

desc "Check that we can play a game without cycles occuring"
task :test_acyclic do
	gracket "test/gui/acyclic.rkt"
end

desc "Check the GUI looks correct."
task :test_draw do
	gracket "test/gui/draw.rkt"
end

desc "Test a game that occasionally gives random columns to reduce cycles."
task :test_occasional do
	gracket "test/gui/occasional.rkt"
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

desc "Test a version of solumns that can be restarted."
task :test_restart do
	gracket "test/gui/restart.rkt"
end

desc "Test a version of solumns that fades out eliminated blocks."
task :test_fade do
	gracket "test/gui/fade.rkt"
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

desc "Test the pause status machine is sane"
task :test_pause_status do
	racket "test/pause.rkt"
end

desc "Test a game that can be paused"
task :test_pause do
	gracket "test/gui/pauser.rkt"
end

desc "Test generation of random columns."
task :test_random do
	racket "test/random.rkt"
end

desc "Test game where output columns are randomly rotated."
task :test_rotate do
	gracket "test/gui/rotator.rkt"
end

desc "Run all (automated) tests"
task :test => [:test_grid, :test_random,
	:test_bruteforce, :test_cmap, :test_record,
        :test_shuffling, :test_cycle, :test_pause_status]

desc "Run solumns"
task :run do
	gracket "solumns/main.rkt"
end

file "work" do
	mkdir "work"
end

file "release" do
	mkdir "release"
end

desc "Create distribution"
task :dist => ["release"] do
	sh "raco distribute release work/#{solumns_exe}"
	sh "cp data release/bin -R"
end

desc "Compile"
task :build => ["work"] do
	sh "raco exe --ico data/logo.ico --gui -o work/#{solumns_exe} solumns/main.rkt"
end

desc "Wordcount"
task :words do
	sh "wc `find -regex '.+.rkt'` | sort -n"
end
