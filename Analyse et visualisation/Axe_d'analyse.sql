#calculer la population modiale
SELECT year_code,SUM(Total_value) FROM population;

#calculer la proportion des céréales pour l’alimentation animale
SELECT count(*) FROM product_information pi
	INNER JOIN product p ON p.Product_code=pi.Product_code
    INNER JOIN category c ON p.Category_code=c.Category_code
    WHERE c.Sub_category LIKE 'Cereal'
    AND pi.Information_code IN (SELECT Information_code FROM information WHERE Information LIKE '%Feed%');

#calculer pour chaque pays et pour chaque produit, la disponibilité alimentaire en Kcal et en Kg de proétines
SELECT DISTINCT pi.Year_code,c.Area,p.Product,i.Information,pi.Total_value FROM product_information pi, product p, country c,information i
		WHERE pi.Information_code=i.Information_code
        AND pi.Product_code=p.Product_code
        AND pi.Area_code=c.Area_code
        AND (i.Information LIKE 'Protein%' OR i.Information LIKE '%kcal%');

#calculez pour chaque produit le ratio "énergie/poids", que vous donnerez en kcal ?
#Indication : Vous pouvez vérifier la cohérence de votre calcul en comparant ce ratio aux données
#disponibles sur internet, par exemple en cherchant la valeur calorique d'un oeuf.
SELECT A.Product_code,ROUND(A.val1/B.val2,2) AS Ratio FROM (SELECT pi.Product_code,SUM(pi.Total_value*365) AS val1 FROM product_information pi, product p, country c,information i
		WHERE pi.Information_code=i.Information_code
        AND pi.Product_code=p.Product_code
        AND pi.Area_code=c.Area_code
        AND i.Information LIKE '%Kcal%'
        GROUP BY pi.Product_code) AS A
        JOIN
		(SELECT pi.Product_code,SUM(pi.Total_value) AS val2 FROM product_information pi, product p, country c,information i
		WHERE pi.Information_code=i.Information_code
        AND pi.Product_code=p.Product_code
        AND pi.Area_code=c.Area_code
        AND i.Information LIKE '%kg%'
        GROUP BY pi.Product_code) AS B
        ON A.Product_code=B.Product_code;
        
SELECT ca.*,co.*,p.*,y.*,pi.Total_value FROM category ca,country co,information i,product p,product_information pi,years y
	WHERE pi.Product_code=p.Product_code
    AND pi.Information_code=i.Information_code
    AND pi.Area_Code=co.Area_code
    AND pi.Year_code=y.Year_code;

SELECT product_information.* FROM information  
	INNER JOIN product_information  USING (Information_code)
    INNER JOIN years  USING (Year_code);
    
SELECT pi.Year_code,pi.Years,c.*,p.*,ca.Category,pi.Information_code,pi.Information,pi.Total_value FROM category ca
	INNER JOIN product p USING (Category_code)
	INNER JOIN (SELECT product_information.*,years.Years,information.Information FROM information  
				INNER JOIN product_information  USING (Information_code)
				INNER JOIN years  USING (Year_code)) pi USING (Product_code)
	INNER JOIN country c USING (Area_code);
