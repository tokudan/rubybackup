# rubybackup
A Backup script for Windows, intended to regularly backup data to a USB disk. Uses hardlinks.

The original ruby seems to have issues with filename encodings, you may want to try jruby if you get errors that some files cannot be found.

## Usage
1. Install ruby (jruby suggested).
2. Fix the path to jruby.exe: Open backup.cmd with an editor and update "%~dp0\%RUBY%\bin\jruby.exe" to point to your ruby installation
3. Update the source and destination paths at the top of backup.cmd
4. Update the exclusion list specified at the top of backup.cmd
