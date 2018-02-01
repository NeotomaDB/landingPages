SELECT DISTINCT contactname AS creatorname, 
           address AS affiliation, 
           contributortype
FROM (
  SELECT contactid, 
        'Researcher' AS contributorType
  FROM (
    (SELECT d.collectionunitid 
     FROM ndb.datasets AS d 
     WHERE d.datasetid = ?ds_id) AS sds
  INNER JOIN 
    ndb.chronologies AS chron ON sds.collectionunitid = chron.collectionunitid
       )
  UNION ALL 
    SELECT contactid, 'DataCollector' AS contributortype 
    FROM (
      (SELECT d.collectionunitid 
       FROM ndb.datasets AS d
       WHERE d.datasetid = ?ds_id) AS sds INNER JOIN
      ndb.collectors AS coll ON sds.collectionunitid = coll.collectionunitid)
UNION ALL
  SELECT contactid, 
         'ProjectLeader' AS contributortype
  FROM ndb.datasetpis WHERE datasetpis.datasetid = ?ds_id
UNION ALL SELECT contactid, 'DataCurator' AS contributortype
FROM ndb.datasetsubmissions WHERE datasetsubmissions.datasetid = ?ds_id
UNION ALL SELECT contactid, 'Researcher' AS contributortype
FROM ((SELECT d.publicationid FROM ndb.datasetpublications AS d
WHERE d.datasetid = ?ds_id) AS sds
INNER JOIN ndb.publicationauthors AS paut ON sds.publicationid = paut.publicationid)
UNION ALL SELECT DISTINCT contactid, 'DataCollector' AS contributortype
FROM ((SELECT samp.sampleid FROM ndb.samples AS samp
WHERE samp.datasetid = ?ds_id) AS sas INNER JOIN ndb.sampleanalysts AS sana ON sas.sampleid = sana.sampleid)) AS cids
INNER JOIN ndb.contacts ON cids.contactid = contacts.contactid