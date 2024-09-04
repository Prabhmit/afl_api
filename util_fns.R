#* @apiTitle FitzRoy API

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
  list(msg = paste0("The message is: '", msg, "'"))
}


#* Fetch AFL match data for a given year
#* @param season The season to fetch data for
#* @get /afl_matches
function(season="2024") {

  season_tbl <- fetch_fixture(season=season, comp='AFLM')
  season_tbl <- season_tbl %>% select(utcStartTime, status,
                                      round.name,round.roundNumber,venue.name,
                                      home.team.club.name, home.team.providerId, home.team.club.providerId,
                                      home.score.goals, home.score.behinds, home.score.totalScore,
                                      away.team.club.name, away.team.providerId, away.team.club.providerId,
                                      away.score.goals, away.score.behinds, away.score.totalScore)
  # Return the data as JSON
  list(data = season_tbl)
}


#* Fetch AFL round ladder data for a season
#* @param season The season to fetch data for
#* @get /afl_rounds
function(season="2024"){

  required_cols <- c("season","round_name", "round_number", "position", "played", 
                   "pointsFor", "pointsAgainst", "minScore", "maxScore", 
                   "avgWinMargin", "avgLossMargin", "playersUsed", "form",
                   "positionChange","team.club.providerId", "team.club.name",
                   "quartersWon.winQ1", "quartersWon.winQ2","quartersWon.winQ3", 
                   "quartersWon.winQ4", "quartersWon.total", "thisSeasonRecord.ladderPosition", 
                   "thisSeasonRecord.aggregatePoints", "thisSeasonRecord.percentage",
                   "thisSeasonRecord.winRatio", "thisSeasonRecord.winLossRecord.wins",
                   "thisSeasonRecord.winLossRecord.losses", "thisSeasonRecord.winLossRecord.draws",
                   "thisSeasonRecord.winLossRecord.played",
                   "homeRecord.wins","homeRecord.losses", "homeRecord.draws", "homeRecord.played",                       
                   "interstateRecord.wins", "interstateRecord.losses", "interstateRecord.draws",
                   "interstateRecord.played", "lastFiveGamesRecord.wins", "lastFiveGamesRecord.losses",              
                   "lastFiveGamesRecord.draws", "lastFiveGamesRecord.played", "dayRecord.wins",                          
                   "dayRecord.losses", "dayRecord.draws", "dayRecord.played", "nightRecord.wins",                         
                   "nightRecord.losses", "nightRecord.draws", "nightRecord.played", "localRecord.wins", 
                   "localRecord.losses", "localRecord.draws", "localRecord.played")

  season_tbl <- fetch_fixture(season=season, comp='AFLM')
  rounds <- unique(season_tbl$round.roundNumber)
  # Season 2024 has a round 0
  if (rounds[1] == 0){
    rounds <- rounds + 1
  }
  rounds_df <- list()
  for (round in rounds) {
    tryCatch({
      ladder <- fetch_ladder_afl(season=season, round_number=round,  comp='AFLM')
      if (!is.null(ladder)){
        ladder <- ladder %>% select(required_cols)
        rounds_df[[round]] <- ladder 
      }
    }, error = function(e){
      cat("An error occurred: ", conditionMessage(e), "\n")
    })
  }
  all_rounds_df <- do.call(rbind, rounds_df)
  list(data = all_rounds_df)
}


#* Fetch AFL all players stats for each round of a season
#* @param season The season to fetch data for
#* @get /player_stats
function(season="2024"){
  player_stats <- fetch_player_stats_afl(season=season, comp='AFLM')
  players_stats <- player_stats %>% select(status, round.name, round.roundNumber, venue.name, 
                                           home.team.club.name, away.team.club.name, 
                                           teamId, player.player.player.givenName, player.player.player.surname,
                                           player.captain, player.player.player.playerId, player.jumperNumber, 
                                           player.player.position, timeOnGroundPercentage,
                                           goals, behinds, kicks, handballs, 
                                           disposals, marks, bounces, tackles, 
                                           contestedPossessions, totalPossessions, 
                                           inside50s, marksInside50, contestedMarks, 
                                           hitouts, onePercenters, disposalEfficiency, 
                                           clangers, freesFor, freesAgainst, dreamTeamPoints,
                                           rebound50s, goalAccuracy, ratingPoints)
  list(data = players_stats)
  }

