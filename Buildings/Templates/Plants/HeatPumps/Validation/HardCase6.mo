within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase6 "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversibleHeatRecovery(
    pla(
      linearized=false,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      have_pumPriDedComHp_select=true,
      ctl(have_senDpHeaWatRemWir=false),
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversibleHeatRecovery))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase6
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51811.04378980346
  Tag: simulation.nonlinear[1]

  Common causes:
   * The system of equations has no solution - the residual will be above zero.
     - In some cases the event-logic can cause this.
   * Starting values are too far from the solution.
     - In rare cases this could occur at events.
   * The equations are too discontinuous for the nonlinear solver - the residual will have knees.
     - Likely caused by over-using noEvent.

  To get more information consider the options:
   * Simulation/Setup/Translation/Generate listing of translated Modelica code in dsmodel.mof
   * Simulation/Setup/Translation/List non-linear iteration variables
   * The options under the group Simulation/Setup/Debug/Nonlinear solver diagnostics

  Jacobian inverse norm estimate: 5.31117e+09
  Condition number estimate: 4.79991e+09
  1-norm of the residual = 5.3312
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.port_aChiWat.m_flow = 57.3286
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 262304
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 262300
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 351366
    pla.valIso.port_bHeaWat.m_flow = -1.03834
    VHeaWat_flow.port_a.m_flow = 0.0158157
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 489721
    pla.valIso.valChiWatUniInlIso[2].lin.dp = 1440.34
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 489754
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 351470
    pla.valIso.port_aChiWat.m_flow = 57.3299
  Last value of the residual:
    { 0.778818, -0.0268768, -0.0661052, 0.77988, -0.0353083,
      -0.00272434, -3.56637, 0.0353108, 0.0383828, -0.00128814,
      -0.000135441 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84477.63089134346
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 5.74146e+12
  Condition number estimate: 5.63061e+12
  1-norm of the residual = 0.342904
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.port_aChiWat.m_flow = 1.29942E-09
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 351325
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 351330
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 351330
    pla.valIso.port_bHeaWat.m_flow = -0.217675
    VHeaWat_flow.port_a.m_flow = 0.000995527
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 351330
    pla.valIso.valChiWatUniInlIso[2].lin.dp = 6.05658
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 351340
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 351330
    pla.valIso.port_aChiWat.m_flow = 1.32019E-07
  Last value of the residual:
    { 0.0432888, 0.169903, -3.50318E-10, 0.000154175, 0.0431346,
      -0.0431346, -0.0432888, 1.27413E-11, 2.95169E-09, -1.11123E-11,
      5.17299E-07 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.821 seconds
   CPU-time for initialization               : 0.334574 seconds
   Number of result points                   : 1689
   Number of grid points                     : 501
   Number of accepted steps                  : 15741
   Number of rejected steps                  : 564
   Number of f-evaluations (dynamics)        : 24180
   Number of non-linear iteration            : 22893
   Number of non-linear convergence failures : 885
   Number of Jacobian-evaluations            : 1382
   Number of crossing function evaluations   : 18685
   Number of model time events               : 422
   Number of state events                    : 174
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase6

----------------- OCT

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

CVodeError: 'The rootfinding function failed in an unrecoverable manner. At time 20151.735489.'


"),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={244,125,35},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase6;
