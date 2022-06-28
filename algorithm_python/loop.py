# range() 순차적인 정수 리스트를 만드는 함수
a = range(10)
print(list(a))

a = range(3, 10)
print(list(a))

# range를 사용한 for
for i in range(10):
    print(i, ": hello")

for i in range(3, 10):
    print(i, ": bye")

# range를 사용한 for (감소형태)
for i in range(10, 0, -1):
    print(i)

for i in range(10, 0, -2):
    print("range:", i)

i = 1
while i < 10:
    print("while:", i)
    i = i+1

i = 1
while True:
    print("wilhe:", i)
    if i == 10:
        break
    i += 1


for i in range(1, 11):
    if i%2==0:
        continue
    print(i)
    
# for - else 구문 
# - 정상 종료시 else를 타지 않는다.  
# - break를 타서 종료시 else를 탄다.a
for i in range(1, 11):
    print(i)
    if i>15:
        break
else:
    print(11)
    
    
    
# 이중포문
for i in range(5):
    for j in range(5):
        print(j, end=" ")
    print()