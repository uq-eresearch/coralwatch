with soft_corals as (
  select survey_id, cast(count(id) as real) as csoft
  from surveyrecord where coraltype = 'Soft' group by survey_id
),
min_records as (
  select survey_id, cast(count(id) as real) as ctotal
  from surveyrecord group by survey_id having count(id) >= 20
),
darkest as (
  select survey_id, cast(count(id) as real) as cdarkest
  from surveyrecord where darkestnumber < 3 group by survey_id
)
select 
  s.id,
  trim(r.country) as "country",
  trim(r.name) as "reef",
  trim(u.displayname) as "surveyor",
  s.date,
  m.ctotal as "records",
  s.latitude,
  s.longitude,
  csoft/ctotal as "soft coral ratio",
  cdarkest,
  cdarkest/ctotal as "darkest score ratio",
  s.groupName,
  s.comments
from survey s
  join min_records m on s.id = m.survey_id
  left join soft_corals soft on s.id = soft.survey_id
  join darkest d on s.id = d.survey_id
  join reef r on s.reef_id = r.id
  join appuser u on u.id = s.creator_id
where 
  ((cdarkest/ctotal) > 0.3)
order by s.date desc
