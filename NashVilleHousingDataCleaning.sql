
Project Dataset: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx
/*

Cleaning Data in SQL Queries

*/


Select *
From NashvilleHousing.dbo.Sheet1$

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDate, CONVERT(Date, SaleDate)
From NashvilleHousing.dbo.Sheet1$


 ALTER TABLE NashvilleHousing.dbo.Sheet1$ ALTER COLUMN SaleDate DATE 

 
 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


Select *
From NashvilleHousing.dbo.Sheet1$
Where PropertyAddress is null
order by ParcelID



Select a.PropertyAddress, a.ParcelID, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing.dbo.Sheet1$  a 
Join NashvilleHousing.dbo.Sheet1$  b
      On a.ParcelID = b.ParcelID
	  and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing.dbo.Sheet1$  a 
Join NashvilleHousing.dbo.Sheet1$  b
      On a.ParcelID = b.ParcelID
	  and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From NashvilleHousing.dbo.Sheet1$ 


Select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From NashvilleHousing.dbo.Sheet1$ 



ALTER TABLE NashvilleHousing.dbo.Sheet1$ 
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing.dbo.Sheet1$ 
SET PropertySplitAddress =SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing.dbo.Sheet1$ 
Add PropertySplitCity Nvarchar(255);


Update NashvilleHousing.dbo.Sheet1$ 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



Select *
From NashvilleHousing.dbo.Sheet1$



Select OwnerAddress
From NashvilleHousing.dbo.Sheet1$



Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

From NashvilleHousing.dbo.Sheet1$


Alter Table  NashvilleHousing.dbo.Sheet1$
Add OwnerSplitAddress Nvarchar(255);

Update  NashvilleHousing.dbo.Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


Alter Table  NashvilleHousing.dbo.Sheet1$
Add OwnerSplitCity Nvarchar(255);

Update  NashvilleHousing.dbo.Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


Alter Table  NashvilleHousing.dbo.Sheet1$
Add OwnerSplitState Nvarchar(255);

Update  NashvilleHousing.dbo.Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)




Select *
From NashvilleHousing.dbo.Sheet1$


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing.dbo.Sheet1$
Group by (SoldAsVacant)
order by 2




Select SoldAsVacant
, Case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From NashvilleHousing.dbo.Sheet1$



Update NashvilleHousing.dbo.Sheet1$
SET SoldAsVacant =  Case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End

	   



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

With RowNumCTE as (
Select *,
       ROW_NUMBER() OVER (
       PARTITION BY ParcelID,
	                       PropertyAddress,
						   SalePrice,
						   SaleDate,
						   LegalReference
						   ORDER BY
						          UniqueID
								  )row_num

From NashvilleHousing.dbo.Sheet1$
)
Select * 
From RowNumCTE
where row_num >1
--order by PropertyAddress




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From NashvilleHousing.dbo.Sheet1$


Alter Table NashvilleHousing.dbo.Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
