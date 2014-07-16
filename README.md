# NetLiga cheater finder

This script scraps NetLiga to find teams with more than 25 players on the default league of the given username.

It logs the results to `./cheaters.log` and outputs info to screen.

## Usage

1. Install NodeJS (on OSX with Homebrew: `brew install node`)
2. Install PhantomJS (on OSX with Homebrew: `brew install phantomjs`)
3. Install CasperJS: `npm install -g casperjs`
4. Run the startup script, passing login data: `./run.sh <username> <password>`
