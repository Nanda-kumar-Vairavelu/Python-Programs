SELECT
        M.MBR_HCID AS "Member ID",
        M.MBR_FRST_NM AS "FIRST NAME",
        M.MBR_LST_NM AS "LAST NAME",
        M.MBR_ADDR_LINE_11 AS "ADDRESS STREET 1",
        '' AS "ADDRESS STREET 2",
        M.MBR_CITY AS "City",
        M.MBR_STATE AS "State",
        LPAD(SUBSTRING(M.MBR_ZIP_CODE, 1, 5), 5, '0') AS "ZIP Code",
        M.MBR_EMAIL AS "Email Address",
        M.PHONE AS "Phone Number",
        TO_CHAR(TO_DATE(M.MBR_DOB, 'YYYYMMDD'), 'MM/DD/YYYY') AS "Birth Date",
        M.GNDR_CD AS "GENDER",
        CASE
            WHEN (
                M.MBR_STS_CD = '0'
                AND TO_DATE(M.MBR_CURR_BGN_DT, 'YYYYMMDD') <= CURRENT_DATE
            )
            OR (
                M.MBR_STS_CD > '0'
                AND TO_DATE(M.MBR_CURR_BGN_DT, 'YYYYMMDD') <= CURRENT_DATE
                AND TO_DATE(M.MBR_CAN_EFF_DT, 'YYYYMMDD') > CURRENT_DATE
            ) THEN CAST(M.NUM_OF_MBRS AS integer) 
            ELSE CAST(M.NUM_OF_MBRS AS integer)
        END AS "Number of Members",
        M.ST_CD AS "Plan State",
        M.SPOKEN_LANGUAGE AS "Spoken Language"
    FROM
        MODMBR.MOD_POC_DATA_LD M
    WHERE
        (
            M.MBR_STS_CD = '0'
            OR (
                M.MBR_STS_CD > '0'
                AND TO_DATE(M.CNTRCT_CNCL_ORG_EFF_DT, 'YYYYMMDD') > CURRENT_DATE
            )
        )
        AND M.MBR_CD IN ('10', '20')
        AND M.PROD_TYP LIKE '2%'
        AND M.ST_CD IN (
            'FL', 'GA', 'IN', 'MD', 'MO', 'NH', 'TX', 'VA', 'WI'
        )
        AND M.PROD_TYP_NM = 'MED'
        AND (
            (
                M.MBR_STS_CD = '0'
                AND TO_DATE(M.MBR_CURR_BGN_DT, 'YYYYMMDD') <= CURRENT_DATE
            )
            OR (
                M.MBR_STS_CD > '0'
                AND TO_DATE(M.MBR_CURR_BGN_DT, 'YYYYMMDD') <= CURRENT_DATE
                AND TO_DATE(M.CNTRCT_CNCL_ORG_EFF_DT, 'YYYYMMDD') > CURRENT_DATE
            )
        )
        AND M.EXCHG_IND IN ('PB', 'OF')
        AND TO_DATE(M.MBR_CURR_BGN_DT, 'YYYYMMDD') >= '2023-01-01'
        AND (CURRENT_DATE - TO_DATE(M.MBR_CURR_BGN_DT, 'YYYYMMDD')) >= 46
        AND FLOOR(EXTRACT(YEAR FROM AGE(CURRENT_DATE, TO_DATE(M.MBR_DOB, 'YYYYMMDD')))) >= 18