from multiprocessing import Pool
from itertools import product
import random, hashlib
import random
import time as time

Delta=24  #Number of available cores
base=16   # order of the generators


G= AbelianGroup([base]*6, names=('g1', 'g2', 'g3', 'g4', 'g5', 'g6'))
g1, g2, g3, g4, g5, g6 =G.gens() 
V=list(product(range(g1.order()), range(g2.order()), range(g3.order()), range(g4.order())))

N=G.order()
N1=g5.order() * g6.order()
N2=int(N/N1)
t =  floor(1/2*N2^(1/3))
s =  floor(1/2*N2^(1/3))
print('N=',N,'N1=',N1,'N2=',N2)

def g_1(v):
    return g5^v[0]*g6^v[1]

def g_2(v):
    return g1^v[0]*g2^v[1]*g3^v[2]*g4^v[3]




def step(x):
    # hash x with SHA3-256 and map back to [0, N1-1]
    h = hashlib.sha3_256(str(x).encode()).digest()
    return int.from_bytes(h, 'big') % N2

def h(x):
    z=step(x)
    a=[floor(z/base^i)%(base) for i in range(4)]
    return a

def plus(a,b):
    return [(a[i]+b[i])%(g1.order()) for i in range(4)]

def walk(w_alpha):
    w,alpha=w_alpha
    x0=g_1(alpha)*g_2(w)*X
    y=x0
    wt=w
    for j in range(1,t+1):
        flag=h(y)
        y=g_2(flag)*y
        wt= plus(wt,flag)
    return (y,wt)

def precompute(alpha_lst):
    alpha,lst=alpha_lst
    NL=[]
    for elt in lst:
        y,wt = walk((elt,alpha))
        NL.append((y,wt,alpha))
    return NL

def online(beta_wt):
    beta,wt=beta_wt
    x0 = g_1(beta) * g_2(wt) * Y
    y = x0
    for j in range(1,2*t+1):
        wt1 = h(y)
        y=g_2(wt1)*y
        wt=plus(wt,wt1)
        if y in Hint1:
            i=Hint1.index(y)
            minus_wt =[-a for a in wt]
            tao = plus(Hint[i][1],minus_wt)
            alpha=Hint[i][2]
            return g_2(tao)*g5^(alpha[0]-beta[0])*g6^(alpha[1]-beta[1])
    return 0
    
    



total_repetition=0

for iteration in range(1,1001):
    print('iteration: ',iteration)
    X=G.random_element()
    Y=G.random_element()
    print('x=',X,'y=',Y)
    
    
    
    
    
    
    
    print('Solution should be: ', Y/X)
    
    
    
    A=list(random.sample(list(product(range(g5.order()), range(g6.order()))),floor(N1/Delta)))
    
    lst=[random.sample(V,s) for _ in range(len(A))]
    
    with Pool() as pool:
        results = pool.map(precompute, [(A[i],lst[i]) for i in range(len(A))])
    
    Hint=[]
    for a in results:
        Hint+=a
    Hint1=[a for (a,b,c) in Hint]
    
    
    
    
    
    flag=0
    iter=1
    while flag==0:
        B=list(random.sample(list(product(range(g5.order()),range(g6.order()))),Delta))
        lst = random.sample(V,Delta)
        with Pool() as pool:
            results = pool.map(online, [(B[i], lst[i]) for i in range(Delta)])
        if results == [0 for _ in range(Delta)]:
            iter+=1
        else:
            flag=1


    for a in results:
        if a!=0:
            print('solution found:',a)
            break
    print('total number of repition needed for success:',iter)
    total_repetition+=iter
    for _ in range(5):
        print(' ')
print('Average number of repetition needed for success',float(total_repetition/iteration))