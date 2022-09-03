x=7;
if x==7:
    print("lucky")
    print("ㅋㅋ")
    
""" 
조건문 if(분기, 중첩)
"""    
# 중첩
x = 15
if x>= 10:
    if x%2 == 1:
        print("10이상의 홀수")

x = 9
if x>0:
    if x<10:
        print("x는 10보다 작은 자연수")

x=7
if x>0 and x<10:
    print("10보다 작은 자연수")

# 분기
x=10
if x>0:
    print("양수")
else:
    print("음수")

x=93
if x>=90:
    print('A')
elif x>=80:
    print('B')
elif X>=70:
    print("C")
else:
    print("F")
