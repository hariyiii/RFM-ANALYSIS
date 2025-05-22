
SELECT 
    cs.CustomerID,
    cs.R_Score,
    cs.F_Score,
    cs.M_Score,
    
    
    CASE 
        WHEN cs.R_Score = 1 AND cs.F_Score = 1 THEN 'High'
        WHEN cs.R_Score = 2 AND cs.F_Score = 2 THEN 'Medium'
        WHEN cs.R_Score >= 3 AND cs.F_Score >= 3 THEN 'Low'
        ELSE 'Others'
    END AS Churn_Risk,

 
    CASE 
        WHEN cs.R_Score = 5 AND cs.F_Score = 5 AND cs.M_Score = 5 THEN 'VIP'
        WHEN cs.R_Score >= 3 AND cs.F_Score >= 3 THEN 'Loyal'
        WHEN cs.R_Score = 2 AND cs.F_Score = 2 THEN 'Casual'
        WHEN cs.R_Score = 1 AND cs.F_Score = 1 THEN 'Lost'
        ELSE 'Others'
    END AS Customer_Category,

    
    ROUND(((cs.R_Score + cs.F_Score + cs.M_Score) / 15.0) * 100, 2) AS Retention_Score

FROM customer_seg cs;