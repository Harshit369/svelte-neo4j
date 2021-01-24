CREATE CONSTRAINT teamIdConstraint
ON (t:Team)
ASSERT t.id IS UNIQUE;

CREATE CONSTRAINT teamNameConstraint
ON (t:Team)
ASSERT t.name IS UNIQUE;

load csv with headers from "file:///team.csv" as team
MERGE (t:Team {id: team.team_id, name: team.team_name });



CREATE CONSTRAINT playerIdConstraint
ON (p:Player)
ASSERT t.id IS UNIQUE;

CREATE CONSTRAINT playerNameConstraint
ON (p:Player)
ASSERT t.player IS UNIQUE;

load csv with headers from "file:///player.csv" as row
MERGE (p:Player { id: row.player_id, name: row.player_name, dob: row.dob, battingStyle: row.batting_hand, bowlingStyle: row.bowling_skill, country: row.country_name });



CREATE CONSTRAINT matchIdConstraint
ON (m:Match)
ASSERT m.id IS UNIQUE;

load csv with headers from "file:///match.csv" as row
Merge (m:Match { id: row.match_id , playedOn: row.match_date, outcome: row.outcome_type })
Merge (v:Venue { name: row.venue_name })
Set v.city = row.city_name, v.country = row.country_name 
Merge (s:Season { name: row.season_year })
WITH m,v,s,row
Match (tossWinner:Team { name: row.toss_winner })
Match (matchWinner:Team { name: row.match_winner })
Match (p:Player { name: row.manofmach })
Create (m)-[wb:WON_BY { margin: row.win_margin, type: row.win_type }]->(matchWinner)
Create (m)-[twb:TOSS_WON_BY { decision: row.toss_name }]->(tossWinner)
Create (m)-[pa:PLAYED_AT {}]->(v)
Create (m)-[po:PART_OF {}]->(s)
Create (m)-[mom:MOM {}]->(p);

load csv with headers from "file:///match.csv" as row
Match (m: Match {id: row.match_id})
Match (t1:Team { name: row.team1 })
Match (t2:Team { name: row.team2 })
Create (t1)-[played1:PLAYED ]->(m)
Create (t2)-[played2:PLAYED ]->(m);




load csv with headers from "file:///player_match.csv" as row
WITH row WHERE row.season_year IS NOT NULL
Match (match:Match {id: row.match_id})
Match (player:Player {id: row.player_id})
Match (team:Team {name: row.player_team})
With row,match,player,team
Call apoc.create.relationship(player, "PLAYED_FOR_" + toString(team.id), {as: row.role_desc, withAge: row.age_as_on_match}, match)
YIELD rel
return rel;


load csv with headers from "file:///player_match.csv" as row
WITH row WHERE row.season_year IS NOT NULL
Match (match:Match {id: row.match_id})
Match (player:Player {id: row.player_id})
Match (team:Team {name: row.player_team})
With row,match,player,team
Call apoc.create.relationship(player, "PLAYED_" + toString(match.id) + "_FOR", {}, team) YIELD rel
return rel;






CREATE CONSTRAINT ballIdConstraint
ON (b:Ball)
ASSERT b.id IS UNIQUE;

:auto USING PERIODIC COMMIT 5000
load csv with headers from "file:///ball_by_ball.csv" as row
Merge (ball:Ball { id: randomUUID(), runs: row.runs_scored, extra: row.extra_runs, extraType: row.extra_type, wicket: toBoolean(row.out_type <> "Not Applicable")  })

set ball.wicketType = case when row.wicket then row.out_type else '' end

with row, ball

Match (match:Match { id: row.match_id})
Match (striker:Player { id: row.striker})
Match (nonStriker:Player { id: row.non_striker})
Match (bowler:Player { id: row.bowler})

with row, ball, match, striker, nonStriker, bowler

Create (ball)-[bi:BOWLED_IN { innings: row.innings_no, over: row.over_id, ball: row.ball_id }]->(match)
Create (ball)-[fb:FACED_BY { battingPosition: row.striker_batting_position, gotOut: toBoolean(row.out_type <> "Not Applicable" AND striker.id = row.player_out) }]->(striker)
Create (ball)-[fbn:FACED_BY_NS { gotOut: toBoolean(row.out_type <> "Not Applicable" AND nonStriker.id = row.player_out) }]->(nonStriker)
Create (ball)-[bb:BOWLED_BY { wicket: toBoolean(row.bowler_wicket) }]->(bowler);



:auto USING PERIODIC COMMIT 5000
load csv with headers from "file:///ball_by_ball.csv" as row
WITH row 
WHERE row.out_type <> "Not Applicable"
Match (b:Ball { wicket: TRUE })-[bi:BOWLED_IN { innings: row.innings_no, over: row.over_id, ball: row.ball_id }]->(m:Match {id: row.match_id})
Set b.wicketType = row.out_type;
