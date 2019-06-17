```{.python} 

sc.version

import xml.etree.ElementTree as ElementTree

def getActivation(s):
    filetree = ElementTree.fromstring(s)
    return filetree.getiterator('activation')

def getModel(activation):
    return activation.find('model').text

def getAccount(activation):
    return activation.find('account-number').text
    
myrdd1 = sc.wholeTextFiles("hdfs://localhost/loudacre/activations/") \
.flatMap(lambda (fname,s): getActivation(s))

myrdd1.take(5)

for record in myrdd1.take(5):
    print(getModel(record))
    
for record in myrdd1.take(5):
    print(getAccount(record))
    
myrdd2 = sc.wholeTextFiles("hdfs://localhost/loudacre/activations/") \
.flatMap(lambda (fname,s): getActivation(s)) \
.map(lambda act:getAccount(act)+":"+getModel(act))

myrdd2.take(5)

myrdd2.saveAsTextFile("/loudacre/account-models")

```
