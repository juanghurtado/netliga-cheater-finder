casper = require('casper').create()
fs = require('fs')
save = fs.pathJoin(fs.workingDirectory, "", "cheaters.log")

if not casper.cli.args[0]
	casper.echo "Please provide a username: ./run.sh <username> <password>"
	casper.exit()
	return

if not casper.cli.args[1]
	casper.echo "Please provide a password: ./run.sh <username> <password>"
	casper.exit()
	return

config =
	username: casper.cli.args[0]
	password: casper.cli.args[1]

LOGIN_LINK_SELECTOR = "#entrarCabecera"
LOGIN_FORM_SELECTOR = "#form_log_net"
CLASIFICATION_SELECTOR = "#menu_horizontal_principal li:nth-child(2) a"
TEAMS_SELECTOR = "li a strong"

casper.start "http://www.netliga.com"

# Login
casper.thenClick LOGIN_LINK_SELECTOR, ->
	@echo "Opening login window"

casper.then ->
	@echo "Inserting login data"

	@fill LOGIN_FORM_SELECTOR,
		user: config.username
		pnet_l: config.password
	, true

# Clasificación
casper.waitForSelector CLASIFICATION_SELECTOR

casper.then ->
	fileText = "--------------------------------------------------------\n"
	fileText += "Looking for cheaters: #{new Date()}\n"
	fileText += "--------------------------------------------------------\n"
	fs.write(save, fileText, 'w')

	liga = @evaluate ->
		__utils__.findAll("#ligaform .customSelectInner")[0].innerHTML

	@echo ""
	@echo "-----------------------------------------------------------------"
	@echo "League: #{liga}"
	@echo "-----------------------------------------------------------------"

casper.thenClick CLASIFICATION_SELECTOR, ->

# Ususarios
casper.waitForSelector TEAMS_SELECTOR, ->
	@echo "Retrieving teams"
	@echo ""

	teams = @evaluate ->
		__utils__.findAll("li a strong")

	unless teams and teams.length
		@echo "There are no teams!"
		return

	checkPlayers = (num, index, total) ->
		@thenClick ".tabla_t1 tr:nth-child(#{num + 1}) .clasifUsuario a"
		@waitForSelector ".tabla_t1", ->
			name = @evaluate ->
				__utils__.findAll("#contentWrappper h1")[0].innerHTML

			players = @evaluate ->
				__utils__.findAll("#lista_jug tr")

			totalPlayers = players.length - 5

			@echo "Team:    | #{name}"
			@echo "Players: | #{totalPlayers}"

			if (totalPlayers > 25)
				fileText = ""
				fileText += "Team: #{name}\n"
				fileText += "Players: #{totalPlayers}\n\n"
				fs.write(save, fileText, 'a')

				@echo ""
				@echo "CHEATER FOUND!"

			@echo "------------------------------------------------------------------------------------"

		@back()

	(i for i in [1..teams.length]).forEach(checkPlayers, @)

casper.run()
