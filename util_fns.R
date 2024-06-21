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
  # Return the data as JSON
  list(data = season_tbl)
}


#* Fetch AFL round ladder data for a season
#* @param season The season to fetch data for
#* @get /afl_rounds
function(season="2024"){
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
  list(data = player_stats)
  }

