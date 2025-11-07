-- •	See all the data imported --
SELECT * from [BlinkIT Grocery Data];

-- Count rows --
SELECT COUNT(*) FROM [BlinkIT Grocery Data];

SELECT DISTINCT Item_Fat_Content
FROM [BlinkIT Grocery Data]

-- Data Cleaning --
UPDATE [BlinkIT Grocery Data]
SET Item_Fat_Content =
CASE
	WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
	WHEN Item_Fat_Content = 'reg' THEN 'Low Fat'
	ELSE Item_Fat_Content
END;

-- KPI Requirements (Total Sales) --
SELECT CAST(SUM(Total_Sales) / 1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions
FROM [BlinkIT Grocery Data];

-- KPI Requirements (Average Sales) --
SELECT CAST(AVG(Total_Sales)AS DECIMAL(10,0)) AS Average_Sales
FROM [BlinkIT Grocery Data]

-- KPI Requirements (Number of Items)
SELECT COUNT(*) AS No_Of_Items
FROM [BlinkIT Grocery Data]

-- KPI Requirements (Number of Items) --
SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM [BlinkIT Grocery Data] 

-----------------------------------------------------------------

-- Granular Requirements (Total Sales by Fat Content) --
SELECT 
	Item_Fat_Content, 
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST(AVG(Total_Sales) AS DECIMAL (10,2)) AS Average_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM [BlinkIT Grocery Data]
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC;

-- Granular Requirements (Total Sales by Item Type) --
SELECT
	Item_Type,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST(AVG(Total_Sales) AS DECIMAL (10,2)) AS Average_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM [BlinkIT Grocery Data]
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- Granular Requirements (Fat Content by Outlet for Total Sales) --
SELECT
	Outlet_Location_Type,
	ISNULL([Low Fat],0) AS Low_fat,
	ISNULL([Regular],0) AS Regular
FROM
(
	SELECT
		Outlet_Location_Type, 
		Item_Fat_Content,
		CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
	FROM [BlinkIT Grocery Data]
	GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT
(
	SUM(Total_Sales)
	FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS Pivot_Table
ORDER BY Outlet_Location_Type;

-- Granular Requirements (Fat Content by Outlet for Total Sales) --
SELECT
	Outlet_Establishment_Year,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM [BlinkIT Grocery Data]
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC;

-- Granular Requirements (Percentage of Sales by Outlet Size) --
SELECT
	Outlet_Size,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST(SUM(Total_Sales) * 100 / SUM(SUM(Total_Sales)) OVER() AS DECIMAL(10,2)) AS Percentage_of_Sales
FROM [BlinkIT Grocery Data]
GROUP BY Outlet_Size
ORDER BY Percentage_of_Sales DESC;

-- Granular Requirements (Sales by Outlet Location) --
SELECT
	Outlet_Location_Type,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM [BlinkIT Grocery Data]
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- Granular Requirements (All Metrics by Outlet Type) --
SELECT 
	Outlet_Type, 
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST(AVG(Total_Sales) AS DECIMAL (10,2)) AS Average_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating,
	CAST(AVG(Item_Visibility) AS DECIMAL(10,1)) AS Avg_Item_Visibility
FROM [BlinkIT Grocery Data]
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;