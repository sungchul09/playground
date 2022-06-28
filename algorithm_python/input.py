print("\n[1]변수입력")

a = input("숫자를 입력하세요: ")
print(a)

print("\n[2]숫자입력 두개")
a, b = input("숫자를 입력하세요: ").split()
print(a, b, sep=", ")

print("\n[4] 형 변환")
a, b = input("숫자를 입력하세요: ").split()
a = int(a)
b = int(b)
print(type(a), type(b))
print(a, b)

print("\n[5] map 사용")
a, b = map(int, input("숫자를 입력하세요: ").split())
print(a, b)
