Select *
from Project2.dbo.Nashvillehousing

--Changing the sale date
select saleDateConverted, CONVERT(DATE,saledate)
from Project2.dbo.Nashvillehousing

UPDATE Nashvillehousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashvillehousing
ADD SaleDateConverted Date;

UPDATE Nashvillehousing 
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Piopulate proterty address data

Select *
from Project2.dbo.Nashvillehousing
WHERE propertyaddress  IS NULL


--updatiing the table to upadte the property address from null
Select a.ParcelID, a.PropertyAddress, b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Project2.dbo.Nashvillehousing a 
JOIN Project2.dbo.Nashvillehousing b 
 ON a.parcelID = b.parcelID
 AND a.[UniqueID] <> b.[UniqueID]
WHERE a.Propertyaddress is NULL

UPDATE a
SET propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Project2.dbo.Nashvillehousing a 
JOIN Project2.dbo.Nashvillehousing b 
 ON a.parcelID = b.parcelID
 AND a.[UniqueID] <> b.[UniqueID]
WHERE a.Propertyaddress is NULL


--Breaking address into indivdiual columns i.e. adress , city ,state
Select PropertyAddress
From Project2.dbo.Nashvillehousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress ) -1 )as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress ) +1 , LEN(PropertyAddress))as Address
From Project2.dbo.Nashvillehousing

ALTER TABLE NashvilleHousing
ADD PropertySplitaddress Nvarchar(255);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);


Update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress ) -1 )

Update Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress ) +1 , LEN(PropertyAddress))

Select *
FROM Nashvillehousing

-- Using the easier method to divide the address
Select OwnerAddress
From Nashvillehousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From Nashvillehousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitaddress Nvarchar(255);

ALTER TABLE NashvilleHousing
ADD OnwerSplitCity Nvarchar(255);

ALTER TABLE NashvilleHousing
ADD OnwerSplitState Nvarchar(255);

Update Nashvillehousing
Set OwnerSplitaddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Update Nashvillehousing
SET OnwerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Update Nashvillehousing
SET OnwerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 

-- CHange the y and n to yes and no in "sold as vacant "fields
Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From Nashvillehousing
GROUP BY SoldAsVacant
Order by 2

select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Nashvillehousing

Update Nashvillehousing
Set soldasVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


--remove duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice, 
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					)row_num
From Nashvillehousing)

Select *
From RowNumCTE
Where row_num>1
ORDER BY PropertyAddress


Delete
From RowNumCTE
Where row_num>1

select *
from Nashvillehousing

Alter table Nashvillehousing
DROP Column PropertyAddress, owneraddress, taxdistrict, SaleDate 



