within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1BoundaryHPOutlet "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1(pla(locBou=
    Buildings.Templates.Plants.HeatPumps.Types.LocationBoundary.HeatPumpOutlet))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Sizes after manipulation of the nonlinear systems: {9, 1, 1, 1, 1, 1}
Number of numerical Jacobians: 2

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 3.86927 seconds
   CPU-time for initialization               : 0.336529 seconds
   Number of result points                   : 1617
   Number of grid points                     : 501
   Number of accepted steps                  : 16089
   Number of rejected steps                  : 559
   Number of f-evaluations (dynamics)        : 24455
   Number of non-linear iteration            : 23269
   Number of non-linear convergence failures : 875
   Number of Jacobian-evaluations            : 1350
   Number of crossing function evaluations   : 18891
   Number of model time events               : 419
   Number of state events                    : 141
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1BoundaryHPOutlet


[CVode Warning] b'Internal t = 21159.8 and h = 8.83044e-13 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'Internal t = 21159.8 and h = 2.20761e-13 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'Internal t = 21159.8 and h = 2.20761e-13 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'Internal t = 21159.8 and h = 1.37976e-13 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'Internal t = 21159.8 and h = 1.37976e-13 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'Internal t = 21159.8 and h = 2.15587e-14 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'Internal t = 21159.8 and h = 1.34742e-15 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'Internal t = 21159.8 and h = 1.34742e-15 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'Internal t = 21159.8 and h = 1.34742e-14 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'Internal t = 21159.8 and h = 2.10534e-15 are such that t + h = t on the next step. The solver will continue anyway.'
[CVode Warning] b'The above warning has been issued mxhnil times and will not be issued again for this problem.'
---------------------------------------------------------------------------
CVodeError                                Traceback (most recent call last)
File /mnt/home/reituag/gitrepo/docker-ubuntu-optimica/jmodelica.py:113
    109     mod.set('_log_level', 4)
    111 ######################################################################
    112 # Simulate
--> 113 res = mod.simulate(options=opts)
    114 #        logging.error(traceback.format_exc())
    116 if generate_plot:

File src/pyfmi/fmi2.pyx:4809, in pyfmi.fmi2.FMUModelME2.simulate()

File src/pyfmi/fmi_base.pyx:214, in pyfmi.fmi_base.ModelBase._exec_simulate_algorithm()

File /opt/OCT/P538-OCT/../install/Python/pyfmi/fmi_algorithm_drivers.py:672, in solve(self)

File assimulo/ode.pyx:192, in assimulo.ode.ODE.simulate()

File assimulo/ode.pyx:312, in assimulo.ode.ODE.simulate()

File assimulo/explicit_ode.pyx:137, in assimulo.explicit_ode.Explicit_ODE._simulate()

File assimulo/explicit_ode.pyx:222, in assimulo.explicit_ode.Explicit_ODE._simulate()

File assimulo/solvers/sundials.pyx:2112, in assimulo.solvers.sundials.CVode.integrate()

File assimulo/solvers/sundials.pyx:2147, in assimulo.solvers.sundials.CVode.integrate()

CVodeError: 'The right-hand side function had repeated recoverable errors. At time 21159.802454.'",
        revisions=""),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-102},{100,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,18},{100,-42},{0,-102},{0,18}})}));
end HardCase1BoundaryHPOutlet;
