import random, hashlib
from math import ceil

N = 2**20

s = floor(1/2* N ** (1/3))
t = floor(1/2* N ** (1/3))

print('s=',s,', t=', t)


def step(x):
    # hash x with SHA3-256 and map back to [0, N-1]
    h = hashlib.sha3_256(str(x).encode()).digest()
    return int.from_bytes(h, 'big') % N
    
   

num = 0


Array = []
for i in range(10000):

 visited = set()
 visited_all = set()
 for it in range(s):
    x = random.randrange(N)      # random seed in [0, N-1]
    visited_all.add(x)
    for _ in range(t):
        x = step(x)
        visited_all.add(x)
    visited.add(x)
  
 Array.append(len(visited_all))



 while(1):
   visited_new = set()
   x = random.randrange(N)  

   visited_new.add(x)# count the seed as covered
   for _ in range(2*t):
        x = step(x)
        visited_new.add(x)
        
   hit_set = visited & visited_new

   num = num + 1
   if(len(hit_set)>0):
      break





import numpy as np
mu = np.mean(Array)



print('Average number of repetitions needed for success:',round(num/(i+1),10))
print('Average number of distinct elements visited in Precompute Phase:',mu)
