/*
Cleaning Data in SQL Queries
*/

select * from [housing-data].dbo.Housingdata


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDateConverted, convert(Date, SaleDate)
from [housing-data].dbo.Housingdata

Update Housingdata
SET SaleDate = convert(Date, SaleDate)

Alter table Housingdata
add SaleDateConverted Date;

Update Housingdata
SET SaleDateConverted = convert(Date, SaleDate)




 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select *
from [housing-data].dbo.Housingdata
where PropertyAddress is null
order by ParcelID



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from [housing-data].dbo.Housingdata a
join [housing-data].dbo.Housingdata b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from [housing-data].dbo.Housingdata a
join [housing-data].dbo.Housingdata b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null






--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from [housing-data].dbo.Housingdata

--Where PropertyAddress is null
--order by ParcelID


select 
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
substring(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress)) as Address

from [housing-data].dbo.Housingdata

alter table Housingdata
add PropertySplitAddress Nvarchar(255);

Update dbo.Housingdata
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

Alter table Housingdata
add PropertySplitCity Nvarchar(255);

Update Housingdata
SET PropertySplitCity = substring(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress))


select * 
from [housing-data].dbo.Housingdata





select OwnerAddress 
from [housing-data].dbo.Housingdata


select 
PARSENAME(replace(OwnerAddress,',','.') , 3),
PARSENAME(replace(OwnerAddress,',','.') , 2),
PARSENAME(replace(OwnerAddress,',','.') , 1)
from [housing-data].dbo.Housingdata



alter table Housingdata
add OwnerSplitAddress Nvarchar(255);

Update dbo.Housingdata
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.') , 3)

Alter table Housingdata
add OwnerSplitCity Nvarchar(255);

Update Housingdata
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.') , 2)


alter table Housingdata
add OwnerSplitState Nvarchar(255);

Update dbo.Housingdata
SET OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.') , 1)

select * 
from dbo.Housingdata






--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from dbo.Housingdata
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from dbo.Housingdata

Update dbo.Housingdata
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

with RowNumCTE as(
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
				) row_num


from [housing-data].dbo.Housingdata
---order by ParcelID
)

select *
from RowNumCTE
where row_num > 1
order by PropertyAddress





--order by ParcelID









---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


select *
from [housing-data].dbo.Housingdata

alter table [housing-data].dbo.Housingdata
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table [housing-data].dbo.Housingdata
drop column SaleDate
















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


















