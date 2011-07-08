from multiprocessing import Pool
import buildingspy.simulate.Simulator as si 

# Function to set common parameters and to run the simulation
def simulateCase(s):
    s.setStopTime(86400)
    s.setTimeOut(60) # Kill the process if it does not finish in 1 minute
    s.showProgressBar(False)
    s.printModelAndTime()
    s.simulate()

# Main function
if __name__ == '__main__':

    # Build list of cases to run
    li = []
    # First model
    model = 'Buildings.Controls.Continuous.Examples.PIDHysteresis'
    s = si.Simulator(model, 'dymola', 'case1')
    s.addParameters({'con.eOn': 0.1})
    li.append(s)
    # second model
    s = si.Simulator(model, 'dymola', 'case2')
    s.addParameters({'con.eOn': 1})
    li.append(s)

    # Run all cases in parallel
    po = Pool()
    po.map(simulateCase, li)
