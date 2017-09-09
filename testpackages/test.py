from testpackages import customer
from testpackages import order
myCustomer = customer('thomas',45)
myOrder = order()
cname = myCustomer.getname()
print cname
cbal = myCustomer.getbalance()
print cbal
