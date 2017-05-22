


--TMDK (Time Year month day key
CONVERT(varchar(8),[Created],112)

--TMK (year month key)
CONVERT(varchar(6),[Created],112)





--CONVERT YYYYMMDD to datetime

convert(datetime,convert(varchar(10),[Time_Key],120))






Time only from full date


SELECT convert(varchar(8), getdate(), 108)


----Create a datetime 10 mins after the start of the month from a TMK field. This is to be used where this is between 2 dates on a join.

  SELECT dateadd(minute, 10, convert(datetime,convert(varchar(10),(cast([Time_Month_Key] as varchar(6)) + '01'),120)))
  FROM [EMAIL-APPS].[Churn].[dbo].[Report_Churn_Base_Revenues]


