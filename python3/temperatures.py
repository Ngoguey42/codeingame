
n = int(input())
if n > 0:
  it = (int(s) for s in input().split())
  key = lambda a: a << 1 if a > 0 else (-a) << 1 + 1
  print(min(it, key = key))
else:
  print('0')
