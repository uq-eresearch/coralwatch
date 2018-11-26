with soft_corals as (
  select survey_id, cast(count(id) as real) as csoft
  from surveyrecord where coraltype = 'Soft' group by survey_id
),
min_records as (
  select survey_id, cast(count(id) as real) as ctotal
  from surveyrecord group by survey_id having count(id) >= 6
),
darkest as (
  select survey_id, cast(count(id) as real) as cdarkest
  from surveyrecord where darkestnumber < 3 group by survey_id
)
select 
  s.*
from survey s
  join min_records m on s.id = m.survey_id
  left join soft_corals soft on s.id = soft.survey_id
  join darkest d on s.id = d.survey_id
where 
  ((csoft is null) or ((csoft/ctotal) < 0.3)) and
  ((cdarkest/ctotal) > 0.0465) and
  s.datesubmitted < (now() at time zone 'utc' - interval '12 hour') and
  br_mailed is null
order by s.date desc
