
select 'Rotation', LeagueName, Season, count(*)
From Rotation r
 group by LeagueName, Season
  order by LeagueName, Season

select 'BoxScores', LeagueName, Season, count(*)
From BoxScores r
 group by LeagueName, Season
  order by LeagueName, Season