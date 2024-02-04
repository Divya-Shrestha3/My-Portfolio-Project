use nashville;
select * from nashvillehousing;

--Standarizing data format

select SaleDate, CONVERT(Date,SaleDate)
from nashvillehousing;
;

ALTER Table NashVilleHousing
Add SaleDateConverted Date;

UPDATE NashVilleHousing 
SET SaleDateConverted= CONVERT(Date,SaleDate);

SELECT SaleDateConverted,SaleDate
from NashVilleHousing;


--Breaking out address from individual columns(Address,city,state)
select propertyaddress
from NashVilleHousing
;

select
substring(propertyaddress,1,charindex(',',propertyaddress)-1) as address,
substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as address 
from NashvilleHousing
;

ALTER Table Nashvillehousing
add PropertyStreet VARCHAR(25),PropertyCity VARCHAR(255)
;


UPDATE NashvilleHousing
SET PropertyStreet=substring(propertyaddress,1,charindex(',',propertyaddress)-1)
;

UPDATE NashvilleHousing
SET PropertyCity=substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))
;

SELECT * FROM NashvilleHousing;



--owner's address(same way)
select owneraddress from nashvillehousing;

select owneraddress
,substring(owneraddress,1,charindex(',',owneraddress))
,substring(owneraddress,charindex(',',owneraddress)+1,len(owneraddress))
from nashvillehousing;

--owner's address by parsename
select 
parsename(replace(owneraddress,',','.'),3)
,parsename(replace(owneraddress,',','.'),2)
,parsename(replace(owneraddress,',','.'),1)
from NashvilleHousing
;

ALTER TABLE NASHVILLEHOUSING
ADD OwnerAddressStreet  VARCHAR(255),OwnerAddressCity VARCHAR(255),OwnerAddressState VARCHAR(255)
;

SELECT * FROM NashvilleHousing;

UPDATE NashvilleHousing
SET OwnerAddressStreet=parsename(replace(owneraddress,',','.'),3),
OwnerAddressCity=parsename(replace(owneraddress,',','.'),2),
OwnerAddressState=parsename(replace(owneraddress,',','.'),1)
FROM NASHVILLEHOUSING;

--change y and n to Yes  and No in  'Sold & Vacant' field
select Distinct(SoldAsVacant),Count(SoldAsVacant)
from NashvilleHousing
Group by SoldAsVacant;

select SoldAsVacant
,
CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
Else SoldAsVacant
END as Updated
from NashvilleHousing
;

UPDATE NashVilleHousing
Set SoldAsVacant=
CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
Else SoldAsVacant
END
from NashvilleHousing
;

--Remove 
with rownumcte as(
select *,
row_number() over(
	partition by parcelid,
		propertyaddress,
		saleprice,
		saledate,
		legalreference
		order by 
			uniqueid
		) row_num
from NashvilleHousing
)
select *
from rownumcte
where row_num>1
order by propertyaddress;

--Populate property address
Select *
from NashVillehousing
where propertyaddress is null
;

select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress,ISNULL(a.propertyaddress,b.propertyaddress)
from NashVilleHousing a
Join NashVilleHousing b
ON a.parcelid=b.parcelid
and a.[uniqueid] != b.[uniqueid]
where a.propertyaddress is null
;

UPDATE a
SET propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
from NashVilleHousing a
Join NashVilleHousing b
ON a.parcelid=b.parcelid
and a.[uniqueid] != b.[uniqueid]
where a.propertyaddress is null
;


