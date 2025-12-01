-- Create a CTE
-- to join all relevant tables and prepare enriched downtime data
WITH dt_set AS (
  SELECT 
    d.event_id, -- Unique ID of the downtime event
    d.equipment_id, -- ID of equipment where downtime occurred
    d.start_time, -- Start timestamp of the downtime
    d.end_time, -- End timestamp of the downtime
    -- Calculate duration of downtime in minutes
    TIMESTAMP_DIFF(d.end_time, d.start_time, MINUTE) AS downtime_duration_minutes,
    d.responsible_team, -- Team responsible for the equipment at that moment
    d.resolved_by, -- Person or team who resolved the issue
    d.reason_id, -- ID of the reason for the downtime
    
    -- Determine the reason name, handling missing or custom cases
    CASE
      WHEN r.reason_name IS NOT NULL THEN r.reason_name
      WHEN d.reason_id = 'R07' THEN 'Environmental conditions'
      ELSE 'The reason is not stated'
    END AS reason_name,
    
    -- Determine the category of the reason
    CASE
      WHEN r.reason_category IS NOT NULL THEN r.reason_category
      WHEN d.reason_id = 'R07' THEN 'Infrastructure'
      ELSE 'Category not assigned'
    END AS reason_category,

    -- Determine whether the reason is critical
    CASE
      WHEN r.critical IS NOT NULL THEN r.critical
      WHEN d.reason_id = 'R07' THEN TRUE
      ELSE FALSE
    END AS critical,

    -- Add equipment metadata
    e.equipment_name,
    e.manufacturer,
    e.installation_date,

    -- Spatial info from location table
    loc.farm,
    loc.zone,
    loc.building,
    loc.floor,

    -- Add optional debug/alias fields if needed later
    e.equipment_id AS eq, -- Redundant alias of equipment_id (optional)
    r.reason_id AS r_id, -- Redundant alias of reason_id (optional)
    loc.equipment_id AS leid -- Equipment ID from location table (for validation)

  FROM `Downtime_set.downtime_events` d

  -- Join with reason catalog to get reason details
  LEFT JOIN `Downtime_set.reason_catalog` r ON d.reason_id = r.reason_id

  -- Join with equipment inventory to enrich with equipment info
  LEFT JOIN `Downtime_set.equipment_inventory` e ON d.equipment_id = e.equipment_id

  -- Join with equipment location table for spatial context
  LEFT JOIN `Downtime_set.equipment_location` loc ON d.equipment_id = loc.equipment_id
)

-- Final select from the CTE with calculated and enriched fields
SELECT 
  event_id,
  equipment_id,
  start_time,
  end_time,
  -- Extract and format datetime fields for time-based analytics
  FORMAT_TIMESTAMP('%Y-%m-%d', start_time) AS date,
  EXTRACT(HOUR FROM start_time) AS hour_of_start_day,
  EXTRACT(DAYOFWEEK FROM start_time) AS start_weekday, -- 1=Sunday, 7=Saturday
  FORMAT_TIMESTAMP('%Y-%m', start_time) AS start_year_month,

  -- Downtime metrics
  downtime_duration_minutes,
  responsible_team,
  resolved_by,

  -- Reason and category
  reason_id,
  reason_name,
  reason_category,
  critical,

  -- Equipment info
  equipment_name,
  manufacturer,
  installation_date,

  -- Spatial info
  farm,
  zone,
  building,
  floor

FROM dt_set;