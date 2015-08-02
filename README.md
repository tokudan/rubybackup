# rubybackup
A Backup script for Windows, intended to regularly backup data to a USB disk. Uses hardlinks.

## Usage
1. Install ruby.
2. Fix the path to ruby.exe: Open backup.cmd with an editor and update "%~dp0\%RUBY%\bin\ruby.exe" to point to your ruby installation
3. Update the source and destination paths at the top of backup.cmd
4. Update the exclusion list specified at the top of backup.cmd
