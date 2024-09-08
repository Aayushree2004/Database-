SQL> SELECT customerId, customerName, customerAddress
  2  FROM Customers
  3  WHERE customerCategory = 'STAFF';

CUSTOMERID CUSTOMERNAME         CUSTOMERADDRESS                                 
---------- -------------------- --------------------                            
c1         Appu Gurung          Dhaka                                           
c2         Alli Baba            UK                                              
c3         Pushpa Giri          Pokhara                                         

SQL> SELECT o.orderId, o.orderDate, o.totalAmount, p.productId, p.productName
  2  FROM Orders o
  3  JOIN ProductsCustomersOrders pco ON o.orderId = pco.orderId
  4  JOIN Products p ON pco.productId = p.productId
  5  WHERE o.orderDate BETWEEN TO_DATE('2023-05-01', 'YYYY-MM-DD') AND TO_DATE('2023-05-28', 'YYYY-MM-DD');

ORDER ORDERDATE    TOTALAMOUNT PRODU PRODUCTNAME                                
----- ------------ ----------- ----- ---------------                            
o5    08-MAY-23           4000 p4    Apple Watch                                
o4    07-MAY-23           2000 p4    Apple Watch                                
o1    15-MAY-23          20000 p4    Apple Watch                                

SQL> SELECT c.customerId, c.customerName, c.customerAddress, o.orderId, o.orderDate, o.totalAmount
  2  FROM Customers c
  3  LEFT JOIN ProductsCustomersOrders pco ON c.customerId = pco.customerId
  4  LEFT JOIN Orders o ON pco.orderId = o.orderId;

CUSTOMERID CUSTOMERNAME         CUSTOMERADDRESS      ORDER ORDERDATE            
---------- -------------------- -------------------- ----- ------------         
TOTALAMOUNT                                                                     
-----------                                                                     
c1         Appu Gurung          Dhaka                o1    15-MAY-23            
      20000                                                                     
                                                                                
c2         Alli Baba            UK                   o2    22-AUG-24            
      50000                                                                     
                                                                                
c3         Pushpa Giri          Pokhara              o3    20-MAY-24            
      80000                                                                     
                                                                                

CUSTOMERID CUSTOMERNAME         CUSTOMERADDRESS      ORDER ORDERDATE            
---------- -------------------- -------------------- ----- ------------         
TOTALAMOUNT                                                                     
-----------                                                                     
c7         Kai Cenat            Sweden               o4    07-MAY-23            
       2000                                                                     
                                                                                
c5         Vinsmoke Sanji       Japan                o5    08-MAY-23            
       4000                                                                     
                                                                                
c6         Jeon Jungkook        Korea                o6    08-SEP-25            
      30000                                                                     
                                                                                

CUSTOMERID CUSTOMERNAME         CUSTOMERADDRESS      ORDER ORDERDATE            
---------- -------------------- -------------------- ----- ------------         
TOTALAMOUNT                                                                     
-----------                                                                     
c7         Kai Cenat            Sweden               o7    10-JUL-24            
      68000                                                                     
                                                                                
c8         Ishowspeed           America              o8    07-MAR-24            
      50000                                                                     
                                                                                
c9         Light Yagami         Ktm                  o9    10-AUG-23            
      50000                                                                     
                                                                                

CUSTOMERID CUSTOMERNAME         CUSTOMERADDRESS      ORDER ORDERDATE            
---------- -------------------- -------------------- ----- ------------         
TOTALAMOUNT                                                                     
-----------                                                                     
c4         Charles Smith        UAE                                             
                                                                                
                                                                                

10 rows selected.

SQL> SELECT productId, productName, productDescription, productPrice, productStock
  2  FROM Products
  3  WHERE productName LIKE '_a%' AND productStock > 50;

PRODU PRODUCTNAME     PRODUCTDESCRIPTION        PRODUCTPRICE PRODUCTSTOCK       
----- --------------- ------------------------- ------------ ------------       
p1    Mac Book        multitasking                  80000.00           70       

SQL> SELECT c.customerId, c.customerName, c.customerAddress, o.orderId, o.orderDate
  2  FROM Orders o
  3  JOIN ProductsCustomersOrders pco ON o.orderId = pco.orderId
  4  JOIN Customers c ON pco.customerId = c.customerId
  5  WHERE o.orderDate = (SELECT MAX(orderDate) FROM Orders);

CUSTOMERID CUSTOMERNAME         CUSTOMERADDRESS      ORDER ORDERDATE            
---------- -------------------- -------------------- ----- ------------         
c6         Jeon Jungkook        Korea                o6    08-SEP-25            

SQL> SELECT TO_CHAR(orderDate, 'YYYY-MM') AS Month, SUM(totalAmount) AS TotalRevenue
  2  FROM Orders
  3  GROUP BY TO_CHAR(orderDate, 'YYYY-MM');

MONTH   TOTALREVENUE                                                            
------- ------------                                                            
2023-05        26000                                                            
2024-07        68000                                                            
2025-09        30000                                                            
2024-03        50000                                                            
2024-05        80000                                                            
2024-08        50000                                                            
2023-08        50000                                                            

7 rows selected.

SQL> SELECT orderId, orderDate, totalAmount
  2  FROM Orders
  3  WHERE totalAmount >= (SELECT AVG(totalAmount) FROM Orders);

ORDER ORDERDATE    TOTALAMOUNT                                                  
----- ------------ -----------                                                  
o2    22-AUG-24          50000                                                  
o3    20-MAY-24          80000                                                  
o7    10-JUL-24          68000                                                  
o8    07-MAR-24          50000                                                  
o9    10-AUG-23          50000                                                  

SQL> SELECT v.vendorId, v.vendorName, COUNT(p.productId) AS ProductCount
  2  FROM Vendor v
  3  JOIN Products p ON v.vendorId = p.vendorId
  4  GROUP BY v.vendorId, v.vendorName
  5  HAVING COUNT(p.productId) > 3;

VENDO VENDORNAME           PRODUCTCOUNT                                         
----- -------------------- ------------                                         
v2    Nico Robin                      4                                         

SQL> SELECT * FROM (
  2      SELECT p.productId, p.productName, SUM(pco.quantity) AS TotalQuantity
  3      FROM Products p
  4      JOIN ProductsCustomersOrders pco ON p.productId = pco.productId
  5      GROUP BY p.productId, p.productName
  6      ORDER BY SUM(pco.quantity) DESC
  7  )
  8  WHERE ROWNUM <= 3;

PRODU PRODUCTNAME     TOTALQUANTITY                                             
----- --------------- -------------                                             
p1    Mac Book                   13                                             
p3    L.G                         5                                             
p4    Apple Watch                 5                                             

SQL> SELECT *
  2  FROM (
  3      SELECT c.customerId, c.customerName, SUM(o.totalAmount) AS totalSpending
  4      FROM Orders o
  5      JOIN ProductsCustomersOrders pco ON o.orderId = pco.orderId
  6      JOIN Customers c ON pco.customerId = c.customerId
  7      WHERE TO_CHAR(o.orderDate, 'MM') = '08'
  8      AND TO_CHAR(o.orderDate, 'YYYY') = '2024'
  9      GROUP BY c.customerId, c.customerName
 10      ORDER BY totalSpending DESC
 11  )
 12  WHERE ROWNUM = 1;

CUSTOMERID CUSTOMERNAME         TOTALSPENDING                                   
---------- -------------------- -------------                                   
c2         Alli Baba                    50000                                   

SQL> spool off
