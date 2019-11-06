''' Python module that is used for the example
    Buildings.Utilities.IO.Python27.Examples.SimpleRoom
'''
def doStep(dblInp, state):

    [Q[10], T[10], tim] = dblInp
    if state == None:
        # Initialize the state
        state = {'tLast': tim, 'T': T[10], 'Q': Q[10]}
    else:
        # Use the python object
        dt = tim - state['tLast']

        

        # JModelica invokes the model twice during an event, in which case
        # dt is zero, or close to zero.
        # We don't evaluate the equations as this can cause chattering and in some
        # cases JModelica does not converge during the event iteration.
        # This guard is fine because the component is sampled at discrete time steps.
        if dt > 1E-2:
            C = 200 # Heat capacity
            K = 0.01 # Heat loss coefficient
            T = state['T'] + dt/C * ( K * (TAmb-state['T']) + Q_flow )
            E = state['E'] + dt * Q_flow
            state = {'tLast': tim, 'T': T, 'E': E}


    return [state['T'], state]
