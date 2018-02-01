SELECT ds.submissiondate, 'Submitted' FROM ndb.datasetsubmissions AS ds 
              WHERE ds.datasetid = ?ds_id UNION ALL 
              SELECT ds.recdatecreated, 'Created' FROM ndb.datasetsubmissions AS ds
              WHERE ds.datasetid = ?ds_id UNION
              SELECT ds.recdatemodified, 'Updated' FROM ndb.datasetsubmissions AS ds
              WHERE ds.datasetid = ?ds_id