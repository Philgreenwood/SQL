SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON


DECLARE @TMK as INT
DECLARE @PreviousMonth as INT
DECLARE @StartTime INT
DECLARE @EndTime INT
DECLARE @Currentyear INT
DECLARE @13monthStartTime INT
DECLARE @Lastyear INT



SET @TMK = (SELECT max(CONVERT(varchar(6),getdate(),112)))
SET @PreviousMonth = (SELECT CONVERT(varchar(6),dateadd(m,-1,getdate()),112))
SET @StartTime = (SELECT convert(varchar(6),dateadd(month, -6,max(DATEADD(month, DATEDIFF(month, 0, getdate()), 0) )),112) )  
SET @EndTime = (SELECT convert(varchar(6),max(dateadd(s,-1,(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) ))),112) ) 
SET @Currentyear = (SELECT CONVERT(varchar(4),getdate(),112))
SET @Lastyear = (SELECT CONVERT(varchar(4),dateadd(year,-1,getdate()),112))

SET @13monthStartTime = (SELECT convert(varchar(6),dateadd(month, -13,max(DATEADD(month, DATEDIFF(month, 0, getdate()), 0) )),112) )  






SELECT DISTINCT 

  CONVERT(varchar(6),[Date_Full_Date],112) as TMK
 ,[Date_Month_Abbr]+ '-'+ RIGHT(cast([Date_Year_Number] as varchar (10)),2)  as [Month_Desc]
 ,min([Date_Full_Date]) as [Date_Full_Date]
 
 
 INTO #DATE
 FROM [xxxxx].[Support_DMART].[DIM].[Date]

 where CONVERT(varchar(6),[Date_Full_Date],112) >= 201501 
 and CONVERT(varchar(6),[Date_Full_Date],112) < CONVERT(varchar(6),dateadd(month,12,getdate()),112)

 GROUP BY    CONVERT(varchar(6),[Date_Full_Date],112) 
,[Date_Month_Abbr]+ '-'+ RIGHT(cast([Date_Year_Number] as varchar (10)),2)

 ORDER BY CONVERT(varchar(6),[Date_Full_Date],112)

 
 --------------------------------------------------------------------------------------------

SELECT 
 
  TMK
 ,[Month_Desc]
 ,[Date_Full_Date]
 ,CASE WHEN TMK <@TMK 
       THEN 1
    ELSE 0
    END AS [Historic_Flag]
 ,CASE WHEN TMK = @TMK 
       THEN 1
    ELSE 0
    END AS [Current_Month_Flag]
 ,CASE WHEN TMK >= @TMK 
       THEN 1
    ELSE 0
    END AS [Current_And_Future_Month_Flag]
 ,CASE WHEN TMK <= @TMK 
       THEN 1
    ELSE 0
    END AS [Current_And_Historic_Month_Flag]
 ,CASE WHEN TMK = @PreviousMonth
       THEN 1
    ELSE 0
    END AS [Previous_Month_Flag]
,CASE WHEN TMK >= @StartTime and TMK <= @EndTime 
   THEN 1
      ELSE 0
   END AS [6_Month_Rolling_Flag]
,CASE WHEN TMK >= @StartTime and TMK <= @TMK
   THEN 1
      ELSE 0
   END AS [6_Month_Rolling_and_Current]


,CASE WHEN TMK >= @13monthStartTime and TMK <= @EndTime 
   THEN 1
      ELSE 0
   END AS [13_Month_Rolling_Flag]
,CASE WHEN TMK >= @13monthStartTime and TMK <= @TMK
   THEN 1
      ELSE 0
   END AS [13_Month_Rolling_and_Current]


,CASE WHEN CONVERT(varchar(4),TMK,112) = @Currentyear
   THEN 1
      ELSE 0
   END AS [Current_Year]

,CASE WHEN CONVERT(varchar(4),TMK,112) = @Lastyear
   THEN 1
      ELSE 0
   END AS [Last_Year]

,CASE WHEN CONVERT(varchar(4),TMK,112) = @Currentyear or CONVERT(varchar(4),TMK,112) = @Lastyear
   THEN 1
      ELSE 0
   END AS [Current_Last_Year]

 FROM #DATE

 DROP TABLE #DATE