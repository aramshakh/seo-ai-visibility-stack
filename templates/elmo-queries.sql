-- Elmo: queries to run after the first cycle.
-- docker exec -it elmo-postgres-1 psql -U postgres -d elmo

-- 0. Disable the self-referencing prompts the onboarding wizard generated.
--    Don't delete them: runs are linked to them.
-- update prompts set enabled=false where brand_id='<brand>' and value ilike '%<brand-name>%';

-- 1. Mentions per AI surface
select model, count(*) as runs, sum(brand_mentioned::int) as mentions
from prompt_runs
group by 1
order by 1;

-- 2. Who gets named instead of you
select c as competitor, count(*) as mentions
from prompt_runs, unnest(competitors_mentioned) c
group by 1
order by 2 desc;

-- 3. Who gets cited: the sites the assistants read. This is your submission priority list.
select split_part(replace(url, 'https://', ''), '/', 1) as domain, count(*) as citations
from citations
group by 1
order by 2 desc
limit 15;
