# LX: the X position of the light of power
# LY: the Y position of the light of power
# TX: Thor's starting X position
# TY: Thor's starting Y position
LX, LY, TX, TY = [int(i) for i in input().split()]

def gen_dx(dx):
  if dx > 0:
    yield from ('E' for _ in range(dx))
  elif dx < 0:
    yield from ('W' for _ in range(-dx))
  while True:
    yield ''

def gen_dy(dy):
  if dy > 0:
    yield from ('S' for _ in range(dy))
  elif dy < 0:
    yield from ('N' for _ in range(-dy))
  while True:
    yield ''

for dx, dy in zip(gen_dy(LY - TY), gen_dx(LX - TX)):
  print("%s%s" % (dx, dy))
