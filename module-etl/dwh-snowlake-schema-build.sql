---------------------SNOWFLAKE SCHEMA---------------------

USE [DW]
GO

----Create year dimension
CREATE TABLE dbo.[Dim_Year](
	[YearKey] [nvarchar](4) NOT NULL,
	[Year] [int] NOT NULL,
 CONSTRAINT [PK_Dim_Year] PRIMARY KEY CLUSTERED 
(
	[YearKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

---- Create month dimension
CREATE TABLE dbo.[Dim_Month](
	[MonthKey] [nvarchar](6) NOT NULL,
	[YearKey] [nvarchar](4) NOT NULL,
	[Month] [int] NOT NULL,
 CONSTRAINT [PK_Dim_Month] PRIMARY KEY CLUSTERED 
(
	[MonthKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE dbo.[Dim_Month]  WITH CHECK ADD  CONSTRAINT [FK_Dim_Month_Dim_Year] FOREIGN KEY([YearKey])
REFERENCES dbo.[Dim_Year] ([YearKey])
GO

ALTER TABLE dbo.[Dim_Month] CHECK CONSTRAINT [FK_Dim_Month_Dim_Year]
GO