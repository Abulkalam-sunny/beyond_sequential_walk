def vk_sequence_exact(N: float, t: int, s: int, V0: float = 0.0) -> float:
    """
    Computes V_s(N,t) using the exact recurrence
        V_{k+1} = V_k + φ(V_k),
    with initial value V_0 = V0.
    """

    def phi_exact(t: int, N: float, Vk: float) -> float:
        """
        Computes the increment φ(V_k).
        """
        running_prod = 1.0
        weighted_sum = 0.0

        for j in range(t + 1):
            running_prod *= (1.0 - (Vk + j) / N)
            weighted_sum += (j + 1) * running_prod

        return t / 2.0 + weighted_sum / (t + 1)

    V = V0
    for _ in range(s):
        V += phi_exact(t, N, V)

    return V


def success_probability(N: float, t: int, s: int, V0: float = 0.0) -> float:
    """
    Computes the success probability of the Online Phase.
    """

    q = (1.0 - vk_sequence_exact(N, t, s, V0) / N) ** (t + 1)

    for i in range(1, t + 1):
        q *= (1.0 - vk_sequence_exact(N, t - i, s, V0) / N)

    return 1.0 - q


from math import ceil, comb


def success_of_parallel_online_GA(s: int, t: int, N1: int, N2: int, Delta: int) -> float:
    """
    Computes the success probability of the Parallel-GA online phase.

    Parameters
    ----------
    s : int
        Number of preprocessing tables.
    t : int
        Length of each random walk.
    N1, N2 : int
        Order of the direct-summand subgroups.
    Delta : int
        Number of processing cores.

    Returns
    -------
    float
        Success probability of the Parallel-GA online phase.
    """

    p1 = success_probability(N2, t, s)

    if N1 <= Delta:
        return p1

    m = ceil(N1 / Delta)

    p2 = 0.0
    for nu in range(1, min(m, Delta) + 1):
        probability = (
            comb(m, nu)
            * comb(N1 - m, Delta - nu)
            / comb(N1, Delta)
        )

        p2 += probability * (1.0 - (1.0 - p1) ** nu)

    return p2
