select *
from [SQL Portfolio Project]..HousingData

--Change Date Time

Select SaleDateConverted, convert (Date, SaleDate)
from [SQL Portfolio Project]..HousingData

Alter Table HousingData
Add SaleDateConverted Date; 

Update HousingData
Set SaleDateConverted = Convert(Date,SaleDate)

--Populate Property Address Data

Select *
from [SQL Portfolio Project]..HousingData
--where propertyaddress is null
order by parcelID
--ParcelID = Property Address. Back Populate ParcelIDs to fill in addresses

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [SQL Portfolio Project]..HousingData a
JOIN [SQL Portfolio Project]..HousingData b
	on a.parcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [SQL Portfolio Project]..HousingData a
JOIN [SQL Portfolio Project]..HousingData b
	on a.parcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null

	--Breaking Out Address into Individual Columns (Address, City, State)
Select PropertyAddress
from [SQL Portfolio Project]..HousingData
--where propertyaddress is null
--order by parcelID

SELECT
SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from [SQL Portfolio Project]..HousingData

Alter Table HousingData
Add PropertySplitAddress Nvarchar(255); 

Update HousingData
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) -1)

Alter Table HousingData
Add PropertySplitCity NVarchar(255); 

Update HousingData
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

Select * 
from [SQL Portfolio Project]..HousingData

--Look at the Owner Address and do simliar to above

Select OwnerAddress
from [SQL Portfolio Project]..HousingData

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [SQL Portfolio Project]..HousingData

Alter Table HousingData
Add OwnerSplitAddress Nvarchar(255); 

Update HousingData
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table HousingData
Add OwnerSplitCity NVarchar(255); 

Update HousingData
Set OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table HousingData
Add OwnerSplitState NVarchar(255); 

Update HousingData
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select * 
from [SQL Portfolio Project]..HousingData

--Change Y and N to Yes and No in "Sold As Vacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [SQL Portfolio Project]..HousingData
group by SoldAsVacant
order by 2

select SoldasVacant
,CASE when SoldasVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
from [SQL Portfolio Project]..HousingData

Update HousingData
SET SoldAsVacant = 
CASE when SoldasVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End

--Remove Dulpicates 
WITH RowNumCTE AS (
Select * ,
ROW_NUMBER() Over (
	Partition By ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
				) row_num
from [SQL Portfolio Project]..HousingData
)
Delete
from RowNumCTE
Where row_num > 1 

WITH RowNumCTE AS (
Select * ,
ROW_NUMBER() Over (
	Partition By ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
				) row_num
from [SQL Portfolio Project]..HousingData
)
select *
from RowNumCTE
Where row_num > 1 


--Removed Unused Columns

Select *
From [SQL Portfolio Project]..HousingData

ALTER TABLE [SQL Portfolio Project]..HousingData
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [SQL Portfolio Project]..HousingData
Drop Column SaleDate