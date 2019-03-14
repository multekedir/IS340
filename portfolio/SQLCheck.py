import mysql.connector
mydb = mysql.connector.connect(
  host="ec2-3-17-148-134.us-east-2.compute.amazonaws.com",
  user="ubuntu"
)
mycursor = mydb.cursor()
mycursor.execute("USE Rideshare")
mycursor.execute("show tables")
tables = mycursor.fetchall()

def dataOut():
    for table in tables:
        print ('*'*15, table[0], '*'*15)
        mycursor.execute("SELECT * FROM {}".format(table[0]))
        [print((fields[0]), end='\t') for fields in mycursor.description]
        print('')
        data = mycursor.fetchall()
        for i in data:
            for value in i:
                print((value), end='\t')
            print ("")
        print ('~'*50)

def showData(pram):
     mycursor.execute("SELECT * FROM {}".format(pram))
     data = mycursor.fetchall()
     [print((fields[0]), end='\t') for fields in mycursor.description]
     print('')
     for i in data:
         for value in i:
             print((value), end='\t')
         print()
def getData(pram, args):
    print(args)
    mycursor.execute("SELECT {} FROM {}".format(args, pram))
    data = mycursor.fetchall()
    return data
    
#dataOut();
#showData('Address')

print()
st = ""
for i in getData('Person', 'phone'):
    size = len(i[0])
    st = i[0]
    old = i[0]
    if (size> 10):
        st = st[:-(size-10)]
    print(st)
    sql = "UPDATE Person SET phone = {} WHERE phone = {}".format(st,old)
    mycursor.execute(sql)
    mydb.commit()

print(mycursor.rowcount, "record(s) affected")

