require "fileutils"

def run cmd
	if windows?
		sh "start #{cmd}"
	else
		sh cmd
	end
end

def gracket args
	run "gracket -W info -l errortrace -t #{args}"
end

def racket args
	run "racket -W info -l errortrace -t #{args}"
end

def windows?
	RUBY_PLATFORM =~ /(win|w)32$/
end

# location of solumns binary after build
def solumns_bin
	"work/solumns"
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
task :test_grid => [:build_c] do
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
task :run => [:build] do
	run solumns_bin 
end

file "work" do
	mkdir "work"

end

file "release" do
	mkdir "release"
end

desc "Create distribution"
task :dist => ["release"] do
	if windows?
		sh "windows/release.bat"
	else
		sh "raco distribute release #{solumns_bin}"
	end
	FileUtils.cp_r "data", "release/"
end

desc "Clean"
task :clean do
	FileUtils.rm_rf "work"
	FileUtils.rm_rf "release"
	FileUtils.rm_rf "lib"
	FileUtils.rm_rf "profile/lib"
end

desc "Create windows installer"
task :wix => [:build, :dist] do
	if windows?
		FileUtils.cp "windows/installer/solumns.wxs", "release"
		FileUtils.cp "windows/installer/COPYING.rtf", "release"
		sh "windows/create-installer.bat"
	else
		raise "Only works on windows"
	end
end

file "lib" do
	FileUtils.mkdir "lib"
end

desc "Build the C libray."
task :build_c => ["work", "lib"] do
	if windows?
		sh "windows/build_c.bat"
	else
		sh "gcc -std=c99 -shared -Wall -fPIC -o lib/elimination.so cbits/elimination.c"
	end

end

task :build => ["work", :build_c] do
	if windows?
		sh "windows/build.bat"
	else
		sh "raco exe --gui -o #{solumns_bin} solumns/main.rkt"
	end
end

def udeb_usage_message
	"rake dh_make VERSION=x.y-z"
end

def udeb_usage_error
	raise udeb_usage_message
end

desc "Build ubuntu .deb package.  #{udeb_usage_message}"
task :udeb => [:clean, :build, :dist] do
	ver = ENV["VERSION"]
	if ver
		if ver =~ /^(\d+)\.(\d+)-(\d+)$/
			deb_name = "solumns-#{ver}"
			package_path = "release/ubuntu/#{deb_name}"
			fs_path = "#{package_path}/usr/"
			share_path = "#{fs_path}/share/"
			logo_path = "#{share_path}/solumns/"
			pixmap_path = "#{share_path}/pixmaps/"
			icon_path = "#{share_path}/icons/"
			doc_path = "#{share_path}/doc/solumns/"
			menu_path = "#{share_path}/menu/"
			debian_path = "#{package_path}/DEBIAN/"
			desktop_path = "#{share_path}/applications"
			games_path = "#{fs_path}/games/"
			FileUtils.mkdir_p package_path
			FileUtils.mkdir_p share_path
			FileUtils.mkdir_p  debian_path
			FileUtils.mkdir_p logo_path
			FileUtils.mkdir_p icon_path
			FileUtils.mkdir_p pixmap_path
			FileUtils.mkdir_p doc_path
			FileUtils.mkdir_p menu_path
			FileUtils.mkdir_p desktop_path
			FileUtils.mkdir_p games_path
			FileUtils.cp "release/bin/solumns", games_path
			FileUtils.cp_r "release/lib", fs_path
			FileUtils.cp "data/logo.png", logo_path
			FileUtils.cp_r "data/hicolor", icon_path
			FileUtils.cp "data/solumns.xpm", pixmap_path
			FileUtils.cp "ubuntu/control", debian_path
			FileUtils.cp "ubuntu/postinst", debian_path
			FileUtils.cp "ubuntu/postrm", debian_path
			FileUtils.cp "ubuntu/copyright", doc_path
			FileUtils.cp "ubuntu/menu", "#{menu_path}/solumns"
			FileUtils.cp "ubuntu/solumns.desktop", desktop_path
			FileUtils.cp "ubuntu/build-package.sh", "release/ubuntu"
			sh "cd release/ubuntu && fakeroot ./build-package.sh"
		else
			udeb_usage_error
		end

	else
		udeb_usage_error
	end
end

desc "Wordcount"
task :words do
	run "wc `find -regex '.+.rkt'` | sort -n"
end
