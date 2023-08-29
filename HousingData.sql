SELECT * FROM HousingData
ORDER BY ParcelID

SELECT * FROM HousingData 
WHERE PropertyAddress IS NULL

SELECT a.UniqueID, a.ParcelID, a.PropertyAddress, b.UniqueID, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM HousingData a INNER JOIN HousingData b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
	FROM HousingData a INNER JOIN HousingData b
	ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS PropertySplitAddress, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS PropertySplitCity
FROM HousingData

ALTER TABLE HousingData ADD PropertySplitAddress nvarchar(255)
ALTER TABLE HousingData ADD PropertySplitCity nvarchar(255)

UPDATE HousingData 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE HousingData 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT OwnerAddress, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM HousingData

ALTER TABLE HousingData ADD OwnerSplitAddress nvarchar(255)
ALTER TABLE HousingData ADD OwnerSplitCity nvarchar(255)
ALTER TABLE HousingData ADD OwnerSplitState nvarchar(255)

UPDATE HousingData 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE HousingData 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE HousingData 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT SoldAsVacant, COUNT(SoldAsVacant) 
FROM HousingData 
GROUP BY SoldAsVacant
ORDER BY 2

UPDATE HousingData
SET SoldAsVacant = 
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END 


WITH cte 
AS 
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY ParcelID, SaleDate, SalePrice, LegalReference ORDER BY UniqueID) 
AS RowNumber
FROM HousingData
)
SELECT * FROM cte 
WHERE RowNumber > 1
ORDER BY ParcelID

SELECT * FROM HousingData
