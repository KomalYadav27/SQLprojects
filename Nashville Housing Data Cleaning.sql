--- selecting entire data

select *
from NashvilleHousing;

-- changing SalesDate format to date

select saledate, convert(date,saledate)
from NashvilleHousing

Alter Table nashvillehousing
Add SaleDate1 Date;

Update NashvilleHousing
set SaleDate1 = convert(date,saledate)

select saledate1
from NashvilleHousing

--- Populating property address

select *
from NashvilleHousing
where PropertyAddress is null;

select nh.ParcelID,nh.PropertyAddress,nh1.ParcelID,nh1.PropertyAddress, ISNULL(nh.propertyaddress,nh1.PropertyAddress)
from NashvilleHousing nh
join NashvilleHousing nh1
on nh1.ParcelID = nh.ParcelID 
AND nh1.[UniqueID ]<>nh.[UniqueID ]
where nh.PropertyAddress is NULL;

UPDATE nh
set nh.propertyaddress = ISNULL(nh.propertyaddress,nh1.PropertyAddress)
from NashvilleHousing nh
join NashvilleHousing nh1
on nh1.ParcelID = nh.ParcelID 
AND nh1.[UniqueID ]<>nh.[UniqueID ]
where nh.PropertyAddress is NULL;

--- spliting property address into address and city

select PropertyAddress
from NashvilleHousing;

select propertyaddress, SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address, SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress)) as  city
from NashvilleHousing

Alter Table nashvillehousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

Alter Table nashvillehousing
Add PropertyCity nvarchar(255);

Update NashvilleHousing
set PropertyCity = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress));

--- spliting owneraddress

select OwnerAddress
from NashvilleHousing;

select PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from NashvilleHousing;


Alter Table nashvillehousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(owneraddress,',','.'),3)

Alter Table nashvillehousing
Add OwnerCity nvarchar(255);

Update NashvilleHousing
set OwnerCity = PARSENAME(replace(owneraddress,',','.'),2)

Alter Table nashvillehousing
Add OwnerState nvarchar(255);

Update NashvilleHousing
set OwnerState = PARSENAME(replace(owneraddress,',','.'),1)

--- change y and n to yes and no in soldasvacant

select distinct(soldasvacant), count(soldasvacant)
from NashvilleHousing
group by SoldAsVacant;

select soldasvacant,
case when soldasvacant ='y' then 'yes'
when soldasvacant ='n' then 'no'
else SoldAsVacant
end
from NashvilleHousing;

update NashvilleHousing
set SoldAsVacant = case when soldasvacant ='y' then 'yes'
when soldasvacant ='n' then 'no'
else SoldAsVacant
end

--- Removing duplicate entries

With rownum as (
select *, ROW_NUMBER() Over (Partition by ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, Soldasvacant, Ownername, owneraddress order by uniqueID) row_num
from NashvilleHousing
)
select * 
from rownum
where row_num >1;

With rownum as (
select *, ROW_NUMBER() Over (Partition by ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, Soldasvacant, Ownername, owneraddress order by uniqueID) row_num
from NashvilleHousing
)
delete  
from rownum
where row_num >1;

--- deleting not useful columns

alter table nashvillehousing
drop column propertyaddress, saledate, owneraddress