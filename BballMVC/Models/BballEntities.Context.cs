﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BballMVC.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class BballEntities1 : DbContext
    {
        public BballEntities1()
            : base("name=BballEntities1")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<AdjustmentsCodes> AdjustmentsCodes { get; set; }
        public virtual DbSet<DailySummary> DailySummary { get; set; }
        public virtual DbSet<Adjustments> Adjustments { get; set; }
        public virtual DbSet<BoxScores> BoxScores { get; set; }
        public virtual DbSet<Lines> Lines { get; set; }
        public virtual DbSet<SeasonInfo> SeasonInfo { get; set; }
        public virtual DbSet<ParmTable> ParmTables { get; set; }
        public virtual DbSet<BoxScoresLast5Min> BoxScoresLast5Min { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Team> Team { get; set; }
        public virtual DbSet<Rotation> Rotation { get; set; }
        public virtual DbSet<TodaysMatchups> TodaysMatchups { get; set; }
        public virtual DbSet<vPostGameAnalysis> vPostGameAnalysis { get; set; }
        public virtual DbSet<BoxScoresSeeds> BoxScoresSeeds { get; set; }
    
        public virtual int Bball_UpdateAdjs(Nullable<System.DateTime> processDate, Nullable<int> testMode)
        {
            var processDateParameter = processDate.HasValue ?
                new ObjectParameter("ProcessDate", processDate) :
                new ObjectParameter("ProcessDate", typeof(System.DateTime));
    
            var testModeParameter = testMode.HasValue ?
                new ObjectParameter("testMode", testMode) :
                new ObjectParameter("testMode", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("Bball_UpdateAdjs", processDateParameter, testModeParameter);
        }
    
        public virtual ObjectResult<string> spTeamLookup(Nullable<System.DateTime> startDate, string leagueName, string teamSource, string teamName)
        {
            var startDateParameter = startDate.HasValue ?
                new ObjectParameter("StartDate", startDate) :
                new ObjectParameter("StartDate", typeof(System.DateTime));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var teamSourceParameter = teamSource != null ?
                new ObjectParameter("TeamSource", teamSource) :
                new ObjectParameter("TeamSource", typeof(string));
    
            var teamNameParameter = teamName != null ?
                new ObjectParameter("TeamName", teamName) :
                new ObjectParameter("TeamName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("spTeamLookup", startDateParameter, leagueNameParameter, teamSourceParameter, teamNameParameter);
        }
    
        public virtual ObjectResult<string> TeamLookup(Nullable<System.DateTime> startDate, string leagueName, string teamSource, string teamName)
        {
            var startDateParameter = startDate.HasValue ?
                new ObjectParameter("StartDate", startDate) :
                new ObjectParameter("StartDate", typeof(System.DateTime));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var teamSourceParameter = teamSource != null ?
                new ObjectParameter("TeamSource", teamSource) :
                new ObjectParameter("TeamSource", typeof(string));
    
            var teamNameParameter = teamName != null ?
                new ObjectParameter("TeamName", teamName) :
                new ObjectParameter("TeamName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("TeamLookup", startDateParameter, leagueNameParameter, teamSourceParameter, teamNameParameter);
        }
    
        public virtual int TeamLookupByCovers(string leagueName, Nullable<System.DateTime> gameDate, string teamSearchArg)
        {
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var gameDateParameter = gameDate.HasValue ?
                new ObjectParameter("GameDate", gameDate) :
                new ObjectParameter("GameDate", typeof(System.DateTime));
    
            var teamSearchArgParameter = teamSearchArg != null ?
                new ObjectParameter("TeamSearchArg", teamSearchArg) :
                new ObjectParameter("TeamSearchArg", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("TeamLookupByCovers", leagueNameParameter, gameDateParameter, teamSearchArgParameter);
        }
    
        public virtual ObjectResult<TeamLookupSourceToSource_Result> TeamLookupSourceToSource(Nullable<System.DateTime> startDate, string leagueName, string teamSourceFrom, string teamSourceTo, string teamName)
        {
            var startDateParameter = startDate.HasValue ?
                new ObjectParameter("StartDate", startDate) :
                new ObjectParameter("StartDate", typeof(System.DateTime));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var teamSourceFromParameter = teamSourceFrom != null ?
                new ObjectParameter("TeamSourceFrom", teamSourceFrom) :
                new ObjectParameter("TeamSourceFrom", typeof(string));
    
            var teamSourceToParameter = teamSourceTo != null ?
                new ObjectParameter("TeamSourceTo", teamSourceTo) :
                new ObjectParameter("TeamSourceTo", typeof(string));
    
            var teamNameParameter = teamName != null ?
                new ObjectParameter("TeamName", teamName) :
                new ObjectParameter("TeamName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<TeamLookupSourceToSource_Result>("TeamLookupSourceToSource", startDateParameter, leagueNameParameter, teamSourceFromParameter, teamSourceToParameter, teamNameParameter);
        }
    
        public virtual ObjectResult<string> TeamLookupTeamNameByTeamNameInDatabase(Nullable<System.DateTime> startDate, string leagueName, string teamSource, string teamNameInDatabase)
        {
            var startDateParameter = startDate.HasValue ?
                new ObjectParameter("StartDate", startDate) :
                new ObjectParameter("StartDate", typeof(System.DateTime));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var teamSourceParameter = teamSource != null ?
                new ObjectParameter("TeamSource", teamSource) :
                new ObjectParameter("TeamSource", typeof(string));
    
            var teamNameInDatabaseParameter = teamNameInDatabase != null ?
                new ObjectParameter("TeamNameInDatabase", teamNameInDatabase) :
                new ObjectParameter("TeamNameInDatabase", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("TeamLookupTeamNameByTeamNameInDatabase", startDateParameter, leagueNameParameter, teamSourceParameter, teamNameInDatabaseParameter);
        }
    
        public virtual int uspCalcTodaysMatchups(string userName, string leagueName, Nullable<System.DateTime> gameDate, Nullable<bool> display)
        {
            var userNameParameter = userName != null ?
                new ObjectParameter("UserName", userName) :
                new ObjectParameter("UserName", typeof(string));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var gameDateParameter = gameDate.HasValue ?
                new ObjectParameter("GameDate", gameDate) :
                new ObjectParameter("GameDate", typeof(System.DateTime));
    
            var displayParameter = display.HasValue ?
                new ObjectParameter("Display", display) :
                new ObjectParameter("Display", typeof(bool));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("uspCalcTodaysMatchups", userNameParameter, leagueNameParameter, gameDateParameter, displayParameter);
        }
    
        public virtual int uspInsertAdjustments(string leagueName, string team, string adjustmentDesc, Nullable<double> adjustmentAmount, string player, string description)
        {
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var teamParameter = team != null ?
                new ObjectParameter("Team", team) :
                new ObjectParameter("Team", typeof(string));
    
            var adjustmentDescParameter = adjustmentDesc != null ?
                new ObjectParameter("AdjustmentDesc", adjustmentDesc) :
                new ObjectParameter("AdjustmentDesc", typeof(string));
    
            var adjustmentAmountParameter = adjustmentAmount.HasValue ?
                new ObjectParameter("AdjustmentAmount", adjustmentAmount) :
                new ObjectParameter("AdjustmentAmount", typeof(double));
    
            var playerParameter = player != null ?
                new ObjectParameter("Player", player) :
                new ObjectParameter("Player", typeof(string));
    
            var descriptionParameter = description != null ?
                new ObjectParameter("Description", description) :
                new ObjectParameter("Description", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("uspInsertAdjustments", leagueNameParameter, teamParameter, adjustmentDescParameter, adjustmentAmountParameter, playerParameter, descriptionParameter);
        }
    
        public virtual int uspInsertLine(string leagueName, Nullable<System.DateTime> gameDate, Nullable<int> rotNum, string teamAway, string teamHome, Nullable<double> line, string playType, string playDuration, Nullable<System.DateTime> createDate, string lineSource)
        {
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var gameDateParameter = gameDate.HasValue ?
                new ObjectParameter("GameDate", gameDate) :
                new ObjectParameter("GameDate", typeof(System.DateTime));
    
            var rotNumParameter = rotNum.HasValue ?
                new ObjectParameter("RotNum", rotNum) :
                new ObjectParameter("RotNum", typeof(int));
    
            var teamAwayParameter = teamAway != null ?
                new ObjectParameter("TeamAway", teamAway) :
                new ObjectParameter("TeamAway", typeof(string));
    
            var teamHomeParameter = teamHome != null ?
                new ObjectParameter("TeamHome", teamHome) :
                new ObjectParameter("TeamHome", typeof(string));
    
            var lineParameter = line.HasValue ?
                new ObjectParameter("Line", line) :
                new ObjectParameter("Line", typeof(double));
    
            var playTypeParameter = playType != null ?
                new ObjectParameter("PlayType", playType) :
                new ObjectParameter("PlayType", typeof(string));
    
            var playDurationParameter = playDuration != null ?
                new ObjectParameter("PlayDuration", playDuration) :
                new ObjectParameter("PlayDuration", typeof(string));
    
            var createDateParameter = createDate.HasValue ?
                new ObjectParameter("CreateDate", createDate) :
                new ObjectParameter("CreateDate", typeof(System.DateTime));
    
            var lineSourceParameter = lineSource != null ?
                new ObjectParameter("LineSource", lineSource) :
                new ObjectParameter("LineSource", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("uspInsertLine", leagueNameParameter, gameDateParameter, rotNumParameter, teamAwayParameter, teamHomeParameter, lineParameter, playTypeParameter, playDurationParameter, createDateParameter, lineSourceParameter);
        }
    
        public virtual int uspInsertLinesFromRotation(Nullable<System.DateTime> gameDate, string leagueName)
        {
            var gameDateParameter = gameDate.HasValue ?
                new ObjectParameter("GameDate", gameDate) :
                new ObjectParameter("GameDate", typeof(System.DateTime));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("uspInsertLinesFromRotation", gameDateParameter, leagueNameParameter);
        }
    
        public virtual int uspInsertMatchupResults(string userName, string leagueName)
        {
            var userNameParameter = userName != null ?
                new ObjectParameter("UserName", userName) :
                new ObjectParameter("UserName", typeof(string));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("uspInsertMatchupResults", userNameParameter, leagueNameParameter);
        }
    
        public virtual ObjectResult<uspQueryAdjustments_Result> uspQueryAdjustments(Nullable<System.DateTime> gameDate, string leagueName)
        {
            var gameDateParameter = gameDate.HasValue ?
                new ObjectParameter("GameDate", gameDate) :
                new ObjectParameter("GameDate", typeof(System.DateTime));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<uspQueryAdjustments_Result>("uspQueryAdjustments", gameDateParameter, leagueNameParameter);
        }
    
        public virtual ObjectResult<uspQueryCalcTeamStrength_Result> uspQueryCalcTeamStrength(string userName, Nullable<System.DateTime> gameDate, string leagueName, string team, string venue, string season, Nullable<double> tmStrAdjPct, Nullable<double> bxScLinePct, Nullable<double> avgLgScoreAway, Nullable<double> avgLgScoreHome, Nullable<int> varLgAvgGamesBack)
        {
            var userNameParameter = userName != null ?
                new ObjectParameter("UserName", userName) :
                new ObjectParameter("UserName", typeof(string));
    
            var gameDateParameter = gameDate.HasValue ?
                new ObjectParameter("GameDate", gameDate) :
                new ObjectParameter("GameDate", typeof(System.DateTime));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var teamParameter = team != null ?
                new ObjectParameter("Team", team) :
                new ObjectParameter("Team", typeof(string));
    
            var venueParameter = venue != null ?
                new ObjectParameter("Venue", venue) :
                new ObjectParameter("Venue", typeof(string));
    
            var seasonParameter = season != null ?
                new ObjectParameter("Season", season) :
                new ObjectParameter("Season", typeof(string));
    
            var tmStrAdjPctParameter = tmStrAdjPct.HasValue ?
                new ObjectParameter("TmStrAdjPct", tmStrAdjPct) :
                new ObjectParameter("TmStrAdjPct", typeof(double));
    
            var bxScLinePctParameter = bxScLinePct.HasValue ?
                new ObjectParameter("BxScLinePct", bxScLinePct) :
                new ObjectParameter("BxScLinePct", typeof(double));
    
            var avgLgScoreAwayParameter = avgLgScoreAway.HasValue ?
                new ObjectParameter("AvgLgScoreAway", avgLgScoreAway) :
                new ObjectParameter("AvgLgScoreAway", typeof(double));
    
            var avgLgScoreHomeParameter = avgLgScoreHome.HasValue ?
                new ObjectParameter("AvgLgScoreHome", avgLgScoreHome) :
                new ObjectParameter("AvgLgScoreHome", typeof(double));
    
            var varLgAvgGamesBackParameter = varLgAvgGamesBack.HasValue ?
                new ObjectParameter("varLgAvgGamesBack", varLgAvgGamesBack) :
                new ObjectParameter("varLgAvgGamesBack", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<uspQueryCalcTeamStrength_Result>("uspQueryCalcTeamStrength", userNameParameter, gameDateParameter, leagueNameParameter, teamParameter, venueParameter, seasonParameter, tmStrAdjPctParameter, bxScLinePctParameter, avgLgScoreAwayParameter, avgLgScoreHomeParameter, varLgAvgGamesBackParameter);
        }
    
        public virtual ObjectResult<uspQueryLeagueAverages_Result> uspQueryLeagueAverages(Nullable<System.DateTime> gameDate, string leagueName, string season, string subSeason)
        {
            var gameDateParameter = gameDate.HasValue ?
                new ObjectParameter("GameDate", gameDate) :
                new ObjectParameter("GameDate", typeof(System.DateTime));
    
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            var seasonParameter = season != null ?
                new ObjectParameter("Season", season) :
                new ObjectParameter("Season", typeof(string));
    
            var subSeasonParameter = subSeason != null ?
                new ObjectParameter("SubSeason", subSeason) :
                new ObjectParameter("SubSeason", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<uspQueryLeagueAverages_Result>("uspQueryLeagueAverages", gameDateParameter, leagueNameParameter, seasonParameter, subSeasonParameter);
        }
    
        public virtual int uspUpdateAdjustments()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("uspUpdateAdjustments");
        }
    
        public virtual ObjectResult<uspQueryTeams_Result> uspQueryTeams(string leagueName)
        {
            var leagueNameParameter = leagueName != null ?
                new ObjectParameter("LeagueName", leagueName) :
                new ObjectParameter("LeagueName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<uspQueryTeams_Result>("uspQueryTeams", leagueNameParameter);
        }
    }
}
