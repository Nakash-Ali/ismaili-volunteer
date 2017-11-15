#!/usr/bin/env python3.6

import random
import string

chars = [*string.ascii_letters, *string.digits, *string.punctuation]
secure_random = random.SystemRandom()
result = ''.join(secure_random.choice(chars) for i in range(64))

print(result)
