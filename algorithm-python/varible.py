print("[1] 변수 값 할당")
a = 1
b = 2
c = 3
print(a, b, c)

print("\n[2] 변수 값 동시 할당")
d, e, f = 4, 5, 6
print(d, e, f)

print("\n[3] 변수 값 교환")
swap_a, swap_b = 10, 20
print(swap_a, swap_b)
swap_a, swap_b = swap_b, swap_a
print(swap_a, swap_b)

print("\n[4]변수 타입")
a = 12345
print(type(a))
a = 12.235345345345345
print(type(a))
a = 'student'
print(type(a))

print("\n[5]출력방식")
print("number")
a, b, c = 1, 2, 3
print(a, b, c)
print("number:", a, b, c)

print("\n[6]출력방식 - 구분자적용")
print(a, b, c, sep=", ")
print(a, b, c, sep="")

print("\n[7]출력방식 - 문장 끝 적용")
print(a,b,c, sep=", ", end=".")