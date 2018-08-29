''' Python module that is used for the example
    Buildings.Utilities.IO.Python27.Examples.Kalman
'''
def random(seed):
    ''' Return a random floating point number in the range [0.0, 1.0)
        for the given seed.
    '''
    import random
    r = random.Random()
    r.seed(int(seed*1e5))
    y = r.random()
    return y-0.5


def filter(u):
    ''' Kalman filter, based on http://www.scipy.org/Cookbook/KalmanFiltering
    '''
# Kalman filter example demo in Python

    # A Python implementation of the example given in pages 11-15 of "An
    # Introduction to the Kalman Filter" by Greg Welch and Gary Bishop,
    # University of North Carolina at Chapel Hill, Department of Computer
    # Science, TR 95-041,
    # http://www.cs.unc.edu/~welch/kalman/kalmanIntro.html
    # by Andrew D. Straw
    import os
    import pickle

    temporaryFile = "tmp-kalman.pkl"

    # Read past observations from file, if the file exists
    # Otherwise, create a new array
    if os.path.exists( temporaryFile ):
        pkl_file = open(temporaryFile, 'rb')
        d = pickle.load(pkl_file)
        pkl_file.close()
        xhat = d['xhat']
        P    = d['P']
    else:
        # initial guesses
        xhat = 0.0
        P    = 1.0

    Q = 1e-5 # process variance

    R = 0.01 # estimate of measurement variance, change to see effect

    xhatminus = xhat
    Pminus = P+Q
    # measurement update
    K = Pminus/( Pminus+R )
    xhat = xhatminus+K*(u-xhatminus)
    P = (1-K)*Pminus

    # Store observations to file for use in next iteration
    d = {'xhat': xhat, 'P': P}
    pkl_file = open(temporaryFile, 'wb')
    pickle.dump(d, pkl_file)
    pkl_file.close()

    return xhat
