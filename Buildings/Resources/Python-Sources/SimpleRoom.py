''' Python module that is used for the example
    Buildings.Utilities.IO.Python36.Examples.SimpleRoom
'''
def doStep(dblInp, state):
    # Function with a state, that computes a response
    # for the simple first order room model
    # T(0) = T0
    # dT/dt = 1/C * ( K * (TAmb-T) + Q_flow )
    [T0, TAmb, Q_flow, tim] = dblInp
    if state == None:
        # Initialize the state
        state = {'tLast': tim, 'T': T0, 'E': 0.0}
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
    # Return the temperature, the accumulated energy, and also the
    # state. The object 'state' is not accessible in Modelica, but it
    # will be passed to this function so it can be used in the next invocation.
    return [[state['T'], state['E']], state]
