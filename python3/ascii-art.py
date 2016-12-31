

w = int(input())
h = int(input())

fallback_char = chr(ord('Z') + 1)
cleanchar_of_char = lambda c: c.upper() if c.isalpha() else fallback_char

text = map(cleanchar_of_char, input())
indices = list(map(lambda c: ord(c) - ord('A'), text))

for _ in range(h):
  symbols = input()
  for i in indices:
    print(symbols[i*w : (i+1)*w], end='')
  print()
