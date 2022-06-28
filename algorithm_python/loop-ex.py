'''
반복문을 이용한 문제풀이
1) 1~n까지 홀수 출력
2) 1~n까지 합
3) n의 약수 출력
'''

n = int(input("n을 입력하세요:"))
for i in range(1, n+1):
    if i % 2 == 1:
        print(i)

sum = 0
for i in range(1, n+1):
    sum += i
print("sum:", sum)


for i in range(1, n+1):
    if n%i == 0:
        print(i)