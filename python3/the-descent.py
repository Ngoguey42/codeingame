
while True:
  gen = ((int(input()), i) for i in range(8))
  _, i = max(gen)
  print(i)
