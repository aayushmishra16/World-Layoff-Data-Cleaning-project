-- Data Cleaning Project
-- steps
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or blank values
-- 4. Remove any columns

Select *
from layoffs;

Create table layoff_staging
like layoffs;

Insert layoff_staging
select *
from layoffs;

Select *
from layoff_staging;

-- Removing Duplicates

with duplicates as(
Select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_staging
)

select *
from duplicates
where row_num > 1;

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Insert into layoff_staging2
Select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_staging;

Select *
from layoff_staging2;

Delete
from layoff_staging2
where row_num > 1;

select *
from layoff_staging2
where row_num > 1;

-- Standardize the data

select company, trim(company)
from layoff_staging2;

update layoff_staging2
set company = trim(company);

Select distinct industry
from layoff_staging2;

update layoff_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

Select distinct industry
from layoff_staging2
order by 1;

Select distinct country, trim(trailing '.' from country)
from layoff_staging2
order by 1; 

update layoff_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

Select distinct country
from layoff_staging2
order by 1;

Select `date`, str_to_date(`date`, '%m/%d/%y')
from layoff_staging2;

update layoff_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

select `date`
from layoff_staging2;

Alter table layoff_staging2
modify column `date` date;

Select *
from layoff_staging2;

-- Null Values and Blank Values

Select *
from layoff_staging2
Where industry = ' ';

update layoff_staging2
set industry = null
where industry = '';

select *
from layoff_staging2
where industry is null;

select *
from layoff_staging2
where company = 'Airbnb';

update layoff_staging2
set industry = 'Travel'
where company = 'Airbnb';

Select *
from layoff_staging2 t1
join layoff_staging2 t2
	on t1.company = t2.company
    where t1.industry is NULL and t2.industry is not NULL;
    
update layoff_staging2 t1
join layoff_staging2 t2
	on t1.company = t2.company
    set t1.industry = t2.industry
    where t1.industry is Null and t2.industry is not null;
    
Select *
from layoff_staging2
where total_laid_off is Null and percentage_laid_off is null;

delete
from layoff_staging2
where total_laid_off is null and percentage_laid_off is null;

-- Remove any columns

alter table layoff_staging2
drop column row_num;

Select *
from layoff_staging2;