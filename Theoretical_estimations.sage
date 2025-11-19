def expect(s,t,N):
    A = 1 - (2*t**2 + 7*t + 6) / (6*N)
    B = (t + 1) - (t*(t + 2)*(3*t + 5)) / (24*N)
    return (A^s-1)/(A-1) *B




### Required number of repetition in the Online Phase in the general preprocessing-with-random-walks framework
def repetition_of_online_phase(s,t,N):
    q=(1-expect(s,t,N)/N)^(t+1)
    for j in range(1,t+1):
        q*=(1-expect(s,t-j,N)/N)
    p=1-q
    return round(1/p,10)

### Required number of repetition in Parallel-Online_GA
def repetition_of_parallel_online_GA(s,t,N1,N2,Delta):
    q=(1-expect(s,t,N2)/N2)^(t+1)
    for j in range(1,t+1):
        q*=(1-expect(s,t-j,N2)/N2)
    p1=1-q
    p2=0
    m=ceil(N1/Delta)
    for gam in range(1,min(Delta,m)+1):
        p3= binomial(m,gam)*binomial(N1-m, Delta-gam)/ binomial(N1,Delta)
        p4= 1-(1-p1)^gam
        p2+=p3*p4
    print(round(1/p2,10))