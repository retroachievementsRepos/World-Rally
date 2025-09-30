// World Rally
// #ID = 27016
// md5: e07e71e9d01b6aeb7622741b93a5b1fd - (Version 1.0, Checksum 0E56)

// Difficulty mode (core settings) functions
// -----------------------------------------

// Difficulty mode easy (core settings)
function isEasyDifficulty() {
    return byte(0x002BDE) == 0
}

// Difficulty mode normal (core settings)
function isNormalDifficulty() {
    return byte(0x002BDE) == 20
}

// Difficulty mode hard (core settings)
function isHardDifficulty() {
    return byte(0x002BDE) == 40
}

// Difficulty mode hardest (core settings)
function isHardestDifficulty() {
    return byte(0x002BDE) == 60
}

// Difficulty mode normal or higher (core settings)
function isNormalOrHigherDifficulty() {
    return byte(0x002BDE) >= 20
}


// Rally selection functions
// -------------------------

// Rally San Remo has been selected (any moment)
function isRallySanRemoSelected(){
    return byte(0x003370) == 1
}

// Rally Monte-Carlo has been selected (any moment)
function isRallyMonteCarloSelected(){
    return byte(0x003372) == 1
}

// Rally Monte-Carlo has been selected (any moment)
function isRallyAcropolisSelected(){
    return byte(0x003374) == 1
}

// Rally of the 1000 Lakes has been selected (any moment)
function isRally1000LakesSelected(){
    return byte(0x003376) == 1
}

// Rally playing functions
// -----------------------

// Get the current Rally playing
function getCurrentRally() => byte(0x003378)

// Is Rally San Remo the current rally playing?
function isPlayingRallySanRemo() {
    return getCurrentRally() == 0
}

// Is Rally Monte-Carlo the current rally playing?
function isPlayingRallyMonteCarlo() {
    return getCurrentRally() == 1
}

// Is Rally Acropolis the current rally playing?
function isPlayingRallyAcropolis() {
    return getCurrentRally() == 2
}

// Is Rally San Remo the current rally playing?
function isPlayingRally1000Lakes() {
    return getCurrentRally() == 3
}

// Get current stage
function getCurrentStage() => byte(0x00337A)

// Get stage status
// 0x00 = Running
// 0x02 = Exact moment/frame of stage end
// 0x01 = Stage cleared
function getStatusStage() => byte(0x0001c6)

// Is time exhausted? 80.0 seconds reached
function isTimeExhausted(){
    return byte(0x0001b4) == 1
} 

// Rally position functions
// ------------------------
function getStagePosition() => byte(0x00345C)

function getRallyPosition() => byte(0x003462)

function getWorldChampionshipPosition() => byte(0x003472)


// Rally points (Initial value 0xFF) functions
// -------------------------------------------

// Get Rally San Remo points
function getRallySanRemoPoints() => byte(0x0032EC)

// Get Rally Monte-Carlo points
function getRallyMonteCarloPoints() => byte(0x0032EE)

// Get Rally Acropolis points
function getRallyAcropolisPoints() => byte(0x0032F0)

// Get Rally of the 1000 Lakes points
function getRally1000LakesPoints() => byte(0x0032F2)

// Get World Championship points
function getWorldChampionshipPoints() => byte(0x00346C)



// Get the number of rallies completed
// function getTotalRalliesCompleted() => byte(0x00349a)


// Game metadata functions
// -----------------------
// Get how many extra credits have been used
function getExtraCreditsUsed() => byte(0x003538)

// One player mode and only one "active"
function isOnePlayerMode() {
    return byte(0x00354E) == 1 && byte(0x0033AC) == 1
}

function getGameStatus() => byte(0x003552)


// 0x00 = No credit is inserted yet
// 0x10 (16) = In the player selection screen, when you have more than 1 credit (not at the very start of the game/rom)
// 0x52 (82) = In the player selection screen, when you have only 1 credit
// 0x72 (114) = When the game finish (win or lose)
// These values stay until new credits inserted
// Check if your game is finished (win or lose) or no started (no credits insert)
function isGameFinished() {
    return getGameStatus() == 0 || getGameStatus() == 0x72
}

function isInSelectionScreen() {
    return (getGameStatus() == 0x10 || getGameStatus() == 0x52) &&
        (!isRallySanRemoSelected() && !isRallyMonteCarloSelected() && !isRallyAcropolisSelected() && !isRally1000LakesSelected())
}

function isInTitleScreen() {
return byte(0x003552) == 0 &&
        (!isRallySanRemoSelected() && !isRallyMonteCarloSelected() && !isRallyAcropolisSelected() && !isRally1000LakesSelected())    
}

// When enters in the Continue Screen the value goes to 0x00 and then 0x01
function getContinueScreen() => byte(0x0033a8)


// Get current total score points 
function getScorePoints() {
    return (word(0x0001ca) * 65536) + word(0x0001cc)
}

// Get Chrono value during the stage
    // 472 = 47.2
    // At the end of the stage go to 0
function getChronoTime() => word(0x003F08)

// 0x00 to 0x05, change every frame
function getChronoFrame() => byte(0x003f06)

// Function to convert to hundreths of seconds relatively real (6 frames in 10 hundreths of seconds)
function convertChronoFrameToTime(previousFrame){
    if(previousFrame){
        return (prev(getChronoFrame()) * 10) / 6  
    }
    else{
        return (getChronoFrame() * 10) / 6            
    }
}

// Chrono stage status (0 inactive, 1 active)
function getChronoStatus() => byte(0x0001b2)


// Custom functions
/*
function isStageCleared() {
    return repeated(400, getChronoTime() > prev(getChronoTime())) && 
           getChronoTime() == 0 &&
           never(repeated(10, getChronoTime() > 600))
}
*/

function isStageCleared() {
    return getStatusStage() == 1 && prev(getStatusStage()) == 2 && 
           getChronoTime() == 0 && getChronoFrame() == 0 && getChronoStatus() == 0
}


function getCentisecStageTime(){
    return (prev(getChronoTime()) * 10) + convertChronoFrameToTime(previousFrame = true)
}


// Rally ASCII Time functions
function getRallyMinutesASCII() => low4(0x00328F)
function getRallyFirstDigitSecondsASCII() => low4(0x003291)
function getRallySecondDigitSecondsASCII() => low4(0x003290)
function getRallyTenthsOfSecondASCII() => low4(0x003292)

// Rally time
function getCentisecRallyTime(){
    return (getRallyMinutesASCII()  * 6000) +
        (getRallyFirstDigitSecondsASCII() * 1000) +
        (getRallySecondDigitSecondsASCII() * 100) +
        (getRallyTenthsOfSecondASCII() * 10)
}


// Dictionary for all rallies and stages

rallies = {
    0: {
        "name": "Rally San Remo",
        "leaderboard": {
            "id": 127421,
            "title": "Rally San Remo",
            "description": "Leaderboard Rally San Remo with only 1 credit in one player mode, in Normal or Higher difficulty"
        },
        "completed": {
            "id": 538397,
            "title": "Piano Piano",
            "description": "Complete Rally San Remo, Italy, in one player mode, in Normal or Higher difficulty",
            "points": 5
        },
        "completedOneCredit": {
            "id": 507130,
            "title": "Arrivederci San Remo",
            "description": "Complete Rally San Remo, Italy, with only 1 credit in one player mode, in Normal or Higher difficulty",
            "points": 10
        },
        "victory": {
            "id": 506658,
            "title": "Gladiator",
            "description": "Win Rally San Remo, Italy, with only 1 credit in one player mode, in Normal or Higher difficulty",
            "points": 10
        },
        "stages": {
            0: {
                "idAchievement": 506655,
                "idLeaderboard": 127072,
                "name" : "Peranaldo",
                "stage": 1,
                "winningTitle": "Miki Biasion",
                "winningPoints" : 2,
            },
            1: {
                "idAchievement": 506656,
                "idLeaderboard": 127073,    
                "name" : "Totip",
                "stage": 2,
                "winningTitle": "Giandomenico Basso",
                "winningPoints" : 3,
            },
            2: {
                "idAchievement": 506657,    
                "idLeaderboard": 127097, 
                "name" : "Ospedaletti",
                "stage": 3,
                "winningTitle": "Paolo Andreucci",
                "winningPoints" : 5,
            }
       }
    },
    1: {
        "name": "Rally Monte-Carlo",
        "leaderboard": {
            "id": 127422,
            "title": "Rally Monte-Carlo",
            "description": "Leaderboard Rally Monte-Carlo with only 1 credit in one player mode, in Normal or Higher difficulty"
        },
        "completed": {
            "id": 538398,
            "title": "Allez Allez",
            "description": "Complete Rally Monte-Carlo, Monaco, in one player mode, in Normal or Higher difficulty",
            "points": 5
        },
        "completedOneCredit": {
            "id": 507136,
            "title": "A Walk Along the Cote D'Azur",
            "description": "Complete Rally Monte-Carlo, Monaco, with only 1 credit in one player mode, in Normal or Higher difficulty",
            "points": 10
        },
        "victory": {
            "id": 507059,
            "title": "Casino Royale",
            "description": "Win Rally Monte-Carlo, Monaco, with only 1 credit in one player mode, in Normal or Higher difficulty",
            "points": 10
        },
        "stages": {
            0: {
                "idAchievement": 507060,
                "idLeaderboard": 127098,
                "name" : "Moulinon",
                "stage": 1,
                "winningTitle": "Didier Auriol",
                "winningPoints" : 3,
            },
            1: {
                "idAchievement": 507061,
                "idLeaderboard": 127099,    
                "name" : "Sisteron",
                "stage": 2,
                "winningTitle": "Sebastian Ogier",
                "winningPoints" : 4,
            },
            2: {
                "idAchievement": 507062,    
                "idLeaderboard": 127100, 
                "name" : "Col De Turini",
                "stage": 3,
                "winningTitle": "Sebastian Loeb",
                "winningPoints" : 5,
            }
        }
    },
    2: {
        "name": "Rally Acropolis",
        "leaderboard": {
            "id": 127423,
            "title": "Rally Acropolis",
            "description": "Leaderboard Rally Acropolis with only 1 credit in one player mode, in Normal or Higher difficulty"
        },
        "completed": {
            "id": 507131,
            "title": "Olympic Games",
            "description": "Complete Rally Acropolis, Greece, in one player mode, in Normal or Higher difficulty",
            "points": 5
        },
        "completedOneCredit": {
            "id": 538399,
            "title": "Footsteps of Hercules",
            "description": "Complete Rally Acropolis, Greece, with only 1 credit in one player mode, in Normal or Higher difficulty",
            "points": 10
        },
        "victory": {
            "id": 507132,
            "title": "Greek God",
            "description": "Win Rally Acropolis, Greece, with only 1 credit in one player mode, in Normal or Higher difficulty",
            "points": 10
        },
        "stages": {
            0: {
                "idAchievement": 507123,
                "idLeaderboard": 127101,
                "name" : "Tarzan",
                "stage": 1,
                "winningTitle": "George Moschous",
                "winningPoints" : 3,
            },
            1: {
                "idAchievement": 507124,
                "idLeaderboard": 127102,    
                "name" : "Vari",
                "stage": 2,
                "winningTitle": "Anastasios Markouizos",
                "winningPoints" : 5,
            },
            2: {
                "idAchievement": 507125,    
                "idLeaderboard": 127103, 
                "name" : "Kinetta",
                "stage": 3,
                "winningTitle": "Tassos Livieratos",
                "winningPoints" : 10,
            }
        }
    },
    3: {
        "name": "Rally of the 1000 Lakes",
        "leaderboard": {
            "id": 127424,
            "title": "Rally of the 1000 Lakes",
            "description": "Leaderboard Rally of the 1000 Lakes with only 1 credit in one player mode, in Normal or Higher difficulty"
        },
        "completed": {
            "id": 538400,
            "title": "Break the Ice",
            "description": "Complete Rally of the 1000 Lakes, Finland, in one player mode, in Normal or Higher difficulty",
            "points": 5
        },
        "completedOneCredit": {
            "id": 507137,
            "title": "Let It Go, Let It Go...",
            "description": "Complete Rally of the 1000 Lakes, Finland, with only 1 credit in one player mode, in Normal or Higher difficulty",
            "points": 10
        },
        "victory": {
            "id": 507133,
            "title": "King in the North",
            "description": "Win Rally 1000 Lakes, Finland, with only 1 credit in one player mode, in Normal or Higher difficulty",
            "points": 25
        },
        "stages": {
            0: {
                "idAchievement": 507126,
                "idLeaderboard": 127104,
                "name" : "Myhipaa",
                "stage": 1,
                "winningTitle": "Marcus Gronholm",
                "winningPoints" : 4,
            },
            1: {
                "idAchievement": 507127,
                "idLeaderboard": 127105,    
                "name" : "Konivuori",
                "stage": 2,
                "winningTitle": "Juha Kankkunen",
                "winningPoints" : 5,
            },
            2: {
                "idAchievement": 507128,    
                "idLeaderboard": 127106, 
                "name" : "Laajavuori",
                "stage": 3,
                "winningTitle": "Tommi Makinen",
                "winningPoints" : 10,
            }
        }
    },
}

// Lookups for Rich presence
// -------------------------
ralliesLookup = {
    0: "Rally San Remo",
    1: "Rally Monte-Carlo",
    2: "Rally Acropolis",
    3: "Rally of the 1000 Lakes"
}

stagesSanRemoLookup = {
    0: "Peranaldo",
    1: "Totip",
    2: "Ospedaletti"
}

stagesMonteCarloLookup = {
    0: "Moulinon",
    1: "Sisteron",
    2: "Col de Turini"
}

stagesAcropolisLookup = {
    0: "Tarzan",
    1: "Vari",
    2: "Kinetta"
}

stages1000LakesLookup = {
    0: "Myhipaa",
    1: "Konivuori",
    2: "Laajavuori"
}





// Achievement functions
// ---------------------

// Achievement function for completed rallies
function setAchievementCompleteRally(rallyId, isExtraCreditsAllowed){
    trigger = isOnePlayerMode() && isNormalOrHigherDifficulty() &&
              getWorldChampionshipPoints() != 0xFF
              
    if !isExtraCreditsAllowed {        
        trigger = trigger && getExtraCreditsUsed() == 0
    }
     
              
    if(rallyId == 0){
        trigger = trigger && isRallySanRemoSelected() && getRallySanRemoPoints() != 0xFF && prev(getRallySanRemoPoints()) == 0xFF 
    }
    else if (rallyId == 1){
        trigger = trigger && isRallyMonteCarloSelected() && getRallyMonteCarloPoints() != 0xFF && prev(getRallyMonteCarloPoints()) == 0xFF 
    }
    else if (rallyId == 2){
        trigger = trigger && isRallyAcropolisSelected() && getRallyAcropolisPoints() != 0xFF && prev(getRallyAcropolisPoints()) == 0xFF 
    }
    else if (rallyId == 3){
        trigger = trigger && isRally1000LakesSelected() && getRally1000LakesPoints() != 0xFF && prev(getRally1000LakesPoints()) == 0xFF 
    }
    else {}
    
    
    if isExtraCreditsAllowed {    
        achievement(id = rallies[rallyId]["completed"]["id"], 
                    title = rallies[rallyId]["completed"]["title"],
                    points = rallies[rallyId]["completed"]["points"],
                    type="progression",
                    description = rallies[rallyId]["completed"]["description"],
                    trigger = trigger)
    }
    else {
        achievement(id = rallies[rallyId]["completedOneCredit"]["id"], 
                    title = rallies[rallyId]["completedOneCredit"]["title"],
                    points = rallies[rallyId]["completedOneCredit"]["points"],
                    type="",
                    description = rallies[rallyId]["completedOneCredit"]["description"],
                    trigger = trigger)
    }
}

// Achievement function for victory in rallies
function setAchievementVictoryRally(rallyId){
    trigger = isOnePlayerMode() && isNormalOrHigherDifficulty() && getExtraCreditsUsed() == 0 &&
              getWorldChampionshipPoints() >= 20
              
    if(rallyId == 0){
        trigger = trigger && isRallySanRemoSelected() && getRallySanRemoPoints() == 20 && prev(getRallySanRemoPoints()) == 0xFF 
    }
    else if (rallyId == 1){
        trigger = trigger && isRallyMonteCarloSelected() && getRallyMonteCarloPoints() == 20 && prev(getRallyMonteCarloPoints()) == 0xFF 
    }
    else if (rallyId == 2){
        trigger = trigger && isRallyAcropolisSelected() && getRallyAcropolisPoints() == 20 && prev(getRallyAcropolisPoints()) == 0xFF 
    }
    else if (rallyId == 3){
        trigger = trigger && isRally1000LakesSelected() && getRally1000LakesPoints() == 20 && prev(getRally1000LakesPoints()) == 0xFF 
    }
    else {}
    
    achievement(id = rallies[rallyId]["victory"]["id"], 
                title = rallies[rallyId]["victory"]["title"],
                points = rallies[rallyId]["victory"]["points"],
                type= "",
                description = rallies[rallyId]["victory"]["description"],
                trigger = trigger)
}


// Achievement function for victory in rally stages
function setAchievementVictoryStage(rallyId, stage){
    id = rallies[rallyId]["stages"][stage]["idAchievement"]
    title = rallies[rallyId]["stages"][stage]["winningTitle"]
    points = rallies[rallyId]["stages"][stage]["winningPoints"]
    type = ""
    description = format("Win {0} Stage - {1} Stage {2} in one player mode, in Normal or Higher difficulty", 
            rallies[rallyId]["stages"][stage]["name"], 
            rallies[rallyId]["name"],
            rallies[rallyId]["stages"][stage]["stage"])
    trigger = isOnePlayerMode() && isNormalOrHigherDifficulty() &&
                  getCurrentStage() == stage &&
                  isStageCleared() &&
                  getStagePosition() == 0
                  
    if(rallyId == 0){
        trigger = trigger && isRallySanRemoSelected() && isPlayingRallySanRemo()
    }
    else if (rallyId == 1){
        trigger = trigger && isRallyMonteCarloSelected() && isPlayingRallyMonteCarlo()
    }
    else if (rallyId == 2){
        trigger = trigger && isRallyAcropolisSelected() && isPlayingRallyAcropolis()
    }
    else if (rallyId == 3){
        trigger = trigger && isRally1000LakesSelected() && isPlayingRally1000Lakes()
    }
    else {}
    
    achievement(id=id, title=title, points=points, type=type, description=description, trigger=trigger)
}

// Achievement function for game completed
function setGameCompletedAchievement(id, title, points, type, description, isPositionRequired, positionReq, isExtraCreditsLimited, extraCredits){
    trigger = isOnePlayerMode() && isNormalOrHigherDifficulty() && 
              isRallySanRemoSelected() && isRallyMonteCarloSelected() && isRallyAcropolisSelected() && isRally1000LakesSelected() &&
              getRallySanRemoPoints() != 0xFF && getRallyMonteCarloPoints() != 0xFF && getRallyAcropolisPoints() != 0xFF && getRally1000LakesPoints() != 0xFF &&
              getWorldChampionshipPoints() != 0xFF && prev(getWorldChampionshipPoints()) < getWorldChampionshipPoints()
     
     if(isExtraCreditsLimited){
         trigger = trigger && getExtraCreditsUsed() <= extraCredits
     }         
     if(isPositionRequired){
         trigger = trigger && getWorldChampionshipPosition() <= positionReq
     }
     
     achievement(id=id, title=title, points=points, type=type, description=description, trigger=trigger)
}

// Leaderboard functions
// ---------------------

// Rally leaderboard
function setRallyLeaderboard(rallyId){
    start = isOnePlayerMode() && isNormalOrHigherDifficulty() && getExtraCreditsUsed() == 0 && !isGameFinished() &&
//              getCurrentStage() == 0 &&
              getChronoStatus() == 1 && prev(getChronoStatus()) == 0
              
    cancel = getContinueScreen() == 1 && prev(getContinueScreen()) == 0        // In Continue Screen
//                (getExtraCreditsUsed() > 0 && prev(getExtraCreditsUsed()) == 0) || // Used extra credits (this case must not be reached because before this pops the continue screen)
//                isGameFinished() // ¿?

//    submit = getCurrentStage() == 2 && repeated(3, getStatusStage() == 2) && (prev(getCentisecRallyTime()) < getCentisecRallyTime())
    
    submit = getCurrentStage() == 2 && getStatusStage() == 0 && (prev(getCentisecRallyTime()) < getCentisecRallyTime())
    
    if(rallyId == 0){
        start = start && isRallySanRemoSelected() && isPlayingRallySanRemo()
        cancel = cancel || !isPlayingRallySanRemo()
        submit = submit && isPlayingRallySanRemo()
    }
    else if (rallyId == 1){
        start = start && isRallyMonteCarloSelected() && isPlayingRallyMonteCarlo()
        cancel = cancel || !isPlayingRallyMonteCarlo()
        submit = submit && isPlayingRallyMonteCarlo()
    }
    else if (rallyId == 2){
        start = start && isRallyAcropolisSelected() && isPlayingRallyAcropolis()
        cancel = cancel || !isPlayingRallyAcropolis()
        submit = submit && isPlayingRallyAcropolis()
    }
    else if (rallyId == 3){
        start = start && isRally1000LakesSelected() && isPlayingRally1000Lakes()
        cancel = cancel || !isPlayingRally1000Lakes()
        submit = submit && isPlayingRally1000Lakes()
    }
    else {}
    
    leaderboard(id = rallies[rallyId]["leaderboard"]["id"],
                title = rallies[rallyId]["leaderboard"]["title"],
                description = rallies[rallyId]["leaderboard"]["description"],
                start = start,
                cancel = cancel,
                submit = submit,
                value  = getCentisecRallyTime(),
                format = "MILLISECS", 
                lower_is_better = true                
    )
}

// Stage leaderboard
function setStageLeaderboard(rallyId, stage){
    id = rallies[rallyId]["stages"][stage]["idLeaderboard"]
    title = format("{0} Stage {1} - {2}", 
            rallies[rallyId]["name"],
            rallies[rallyId]["stages"][stage]["stage"],             
            rallies[rallyId]["stages"][stage]["name"])
    description = format("Leaderboard {0} Stage {1} - {2} in one player mode, in Normal or Higher difficulty", 
            rallies[rallyId]["name"],
            rallies[rallyId]["stages"][stage]["stage"],             
            rallies[rallyId]["stages"][stage]["name"])

    start  = isOnePlayerMode() && isNormalOrHigherDifficulty() && !isGameFinished() &&
                  getCurrentStage() == stage &&
                  getChronoStatus() == 1 && prev(getChronoStatus()) == 0
                  
    cancel = getChronoTime() == 0xFFFF && prev(getChronoTime() == 600) // When time exceeded value goes from 600 to 0xFFFF // TODO: Rethink if change this behaviour
    submit = isStageCleared()
    value  = getCentisecStageTime()
    
    
    if(rallyId == 0){
        start = start && isRallySanRemoSelected() && isPlayingRallySanRemo()
        cancel = cancel || !isPlayingRallySanRemo()
    }
    else if (rallyId == 1){
        start = start && isRallyMonteCarloSelected() && isPlayingRallyMonteCarlo()
        cancel = cancel || !isPlayingRallyMonteCarlo()
    }
    else if (rallyId == 2){
        start = start && isRallyAcropolisSelected() && isPlayingRallyAcropolis()
        cancel = cancel || !isPlayingRallyAcropolis()
    }
    else if (rallyId == 3){
        start = start && isRally1000LakesSelected() && isPlayingRally1000Lakes()
        cancel = cancel || !isPlayingRally1000Lakes()
    }
    else {}
    
 
    leaderboard(id=id, title=title, description=description, start=start, cancel=cancel, submit=submit, value=value, format = "MILLISECS", lower_is_better = true)   
}



// Achievements - Stages
// ---------------------

// Win any stage

achievement(
    id = 507129,
    title = "[VOID]", points = 1,
    description = "[Deleted] Win a rally stage in one player mode",
    trigger = always_false()
)


// Achievement every stage
for ral in rallies {
    for st in rallies[ral]["stages"]{
        setAchievementVictoryStage(ral, st)
    }
}


// Achievements - Rallies Completed
// --------------------------------

for raId in rallies {
    setAchievementCompleteRally(raId, true)
    setAchievementCompleteRally(raId, false)
}


// Achievements - Rallies Won
// --------------------------
for raId in rallies {
    setAchievementVictoryRally(raId)
}


// Achievements - Game Completed
// -----------------------------
setGameCompletedAchievement(id = 507134,
    title = "The Job Is Done", points = 25, type="win_condition",
    description = "Beat the game in one player mode, in Normal or Higher difficulty",
    isPositionRequired = false, positionReq = 0, isExtraCreditsLimited = false, extraCredits = 0)
    
setGameCompletedAchievement(id = 507138,
    title = "The Stig", points = 50, type="",
    description = "Finish in third position, or better, in the World Championship with only 1 credit in one player mode, in Normal or Higher difficulty",
    isPositionRequired = true, positionReq = 2, isExtraCreditsLimited = true, extraCredits = 0)
    
setGameCompletedAchievement(id = 507135,
    title = "Carlos Sainz", points = 50, type="",
    description = "Win the World Championship with a maximum of 3 credits in one player mode, in Normal or Higher difficulty",
    isPositionRequired = true, positionReq = 0, isExtraCreditsLimited = true, extraCredits = 2)    
    

// Leaderboards - Stages
// ---------------------

for ral in rallies {
    for st in rallies[ral]["stages"]{
        setStageLeaderboard(ral, st)
    }
}


// Leaderboards - Rallies
// ---------------------

for raId in rallies{
    setRallyLeaderboard(raId)    
}


// Leaderboard Score Points
// ------------------------
// TODO: Keep testing
leaderboard(
        id = 127131, 
        title = "Total Score Points",
        description = "Total Score Points with only 1 credit in one player mode, in Normal or Higher difficulty",
        start  = isOnePlayerMode() && isNormalOrHigherDifficulty() && getExtraCreditsUsed() == 0 &&
                (isRallySanRemoSelected() || isRallyMonteCarloSelected() || isRallyAcropolisSelected() || isRally1000LakesSelected()) &&
                !isGameFinished() && getChronoStatus() == 1 && prev(getChronoStatus()) == 0, // When the Chrono starts counting
        cancel = always_false(),
        submit = (getContinueScreen() == 1 && prev(getContinueScreen()) == 0) ||                  // Continue screen         
                 (getWorldChampionshipPoints() != 0xFF && 
                    getRallySanRemoPoints() != 0xFF && 
                    getRallyMonteCarloPoints() != 0xFF && 
                    getRallyAcropolisPoints() != 0xFF && 
                    getRally1000LakesPoints() != 0xFF), // Game beaten
//                (isTimeExhausted() && !prev(isTimeExhausted())) ||                              // Max time stage reached, 80.0 seconds

        value  = getScorePoints(),
        format = "POINTS", lower_is_better = false
    )


// Rich Presence
// -------------

rich_presence_conditional_display(isInTitleScreen(), "In title screen")
rich_presence_conditional_display(isInSelectionScreen(), "In Rally selection screen")
rich_presence_conditional_display(isGameFinished() && getWorldChampionshipPosition() == 0, "Game finished, 🥇 World Championship,💰:{0}, 🔁 {1}",
                        rich_presence_value("Points", getScorePoints()),
                        rich_presence_value("Continues", getExtraCreditsUsed())
)
rich_presence_conditional_display(isGameFinished() && getWorldChampionshipPosition() == 1, "Game finished, 🥈 World Championship,💰:{0}, 🔁 {1}",
                        rich_presence_value("Points", getScorePoints()),
                        rich_presence_value("Continues", getExtraCreditsUsed())
)
rich_presence_conditional_display(isGameFinished() && getWorldChampionshipPosition() == 2, "Game finished, 🥉 World Championship,💰:{0}, 🔁 {1}",
                        rich_presence_value("Points", getScorePoints()),
                        rich_presence_value("Continues", getExtraCreditsUsed())
)
rich_presence_conditional_display(isGameFinished(), "Game finished, 🏅{0} World Championship, 💰:{1}, 🔁 {2}",
                        rich_presence_value("Position", getWorldChampionshipPosition() + 1),
                        rich_presence_value("Points", getScorePoints()),
                        rich_presence_value("Continues", getExtraCreditsUsed())
)
                          


rich_presence_conditional_display(getCurrentRally() == 0, "Playing {0}, {1}, 🚩:{2}, 🔁:{3}, 💰:{4}",
                        rich_presence_lookup("Rally", getCurrentRally(), ralliesLookup),
                        rich_presence_lookup("StageSanRemo", getCurrentStage(), stagesSanRemoLookup),
                        rich_presence_value("StageNumber", getCurrentStage() + 1),
                        rich_presence_value("Continues", getExtraCreditsUsed()),
                        rich_presence_value("Points", getScorePoints())                        
)
                                  
rich_presence_conditional_display(getCurrentRally() == 1, "Playing {0}, {1}, 🚩:{2}, 🔁:{3}, 💰:{4}",
                        rich_presence_lookup("Rally", getCurrentRally(), ralliesLookup),
                        rich_presence_lookup("StageMonteCarlo", getCurrentStage(), stagesMonteCarloLookup),
                        rich_presence_value("StageNumber", getCurrentStage() + 1),
                        rich_presence_value("Continues", getExtraCreditsUsed()),
                        rich_presence_value("Points", getScorePoints()) 
)

rich_presence_conditional_display(getCurrentRally() == 2, "Playing {0}, {1}, 🚩:{2}, 🔁:{3}, 💰:{4}",
                        rich_presence_lookup("Rally", getCurrentRally(), ralliesLookup),
                        rich_presence_lookup("StageAcropolis", getCurrentStage(), stagesAcropolisLookup),
                        rich_presence_value("StageNumber", getCurrentStage() + 1),
                        rich_presence_value("Continues", getExtraCreditsUsed()),
                        rich_presence_value("Points", getScorePoints()) 
)

rich_presence_display("Playing {0}, {1}, 🚩:{2}, 🔁:{3}, 💰:{4}",
                        rich_presence_lookup("Rally", getCurrentRally(), ralliesLookup),
                        rich_presence_lookup("Stage1000Lakes", getCurrentStage(), stages1000LakesLookup),
                        rich_presence_value("StageNumber", getCurrentStage() + 1),
                        rich_presence_value("Continues", getExtraCreditsUsed()),
                        rich_presence_value("Points", getScorePoints()) 
)