SELECT
    ct.model,
    timeuse.id AS tu_id,
    timeuse.study_id AS tu_sid,
    timeuse.props AS tu_props,
    timeuse.status_id AS tu_status,
    timeuse.created_at AS tu_cat,
    timeuse.updated_at AS tu_uat,
    survey.id AS sur_id,
    survey.study_id AS sur_sid,
    survey.status_id AS sur_status,
    survey.props AS sur_props,
    survey.created_at AS sur_cat,
    survey.updated_at AS sur_uat
FROM
    activity_activity AS timeuse
    LEFT JOIN django_content_type AS ct ON ct.id = timeuse.polymorphic_ctype_id
    LEFT JOIN activity_activity AS survey ON survey.id =(timeuse.props -> 'survey_id')::int
WHERE
    ct.model = 'timeuse'
    AND (NOT (survey.props @> '{"type_id":1}')
        OR (survey.status_id != timeuse.status_id));

SELECT
    survey.id AS sur_id,
    survey.study_id AS sur_sid,
    survey.status_id AS sur_status,
    survey.props AS sur_props,
    survey.created_at AS sur_cat,
    survey.updated_at AS sur_uat
FROM
    activity_activity AS survey
    FULL OUTER JOIN activity_activity AS timeuse ON survey.id =(timeuse.props -> 'survey_id')::int
WHERE
    timeuse.id IS NULL
    AND survey.props @> '{"type_id":1}';