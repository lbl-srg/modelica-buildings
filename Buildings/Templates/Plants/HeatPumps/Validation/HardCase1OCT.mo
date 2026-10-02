within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1OCT
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversiblePolyvalent(
    pla(
      linearized=false,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      have_pumPriDedComHp_select=true,
      ctl(have_senTLooRet_select=true, have_senDpHeaWatRemWir=true)))
    annotation(IconMap(primitivesVisible=false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
  Documentation(
    info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCT
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36510.15424323957
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

  Jacobian inverse norm estimate: 2.756e+12
  Condition number estimate: 9.45544e+10
  1-norm of the residual = 27.6899
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 578617
    VHeaWat_flow.port_a.m_flow = 13.7838
    pla.valIso.port_bHeaWat.m_flow = -20.7233
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 351296
    pla.valIso.valChiWatUniInlIso[1].lin.dp = 1323.41
    pla.pumPri.pumChiWat.valChe[1].dp = 13367.6
    pla.valIso.port_bChiWat.m_flow = -55.1273
    pla.port_aChiWat.m_flow = 51.1973
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 379930
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 291258
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 524140
  Last value of the residual:
    { 14.8945, 0.0523608, 4.63466, -1.7032E-05, 2.04758,
      -1.96585, 1.49788E-05, -2.04733, 2.04758, 3.40541E-06,
      -1.15815E-05 }


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.71656 seconds
   CPU-time for initialization               : 0.320885 seconds
   Number of result points                   : 1983
   Number of grid points                     : 501
   Number of accepted steps                  : 20130
   Number of rejected steps                  : 836
   Number of f-evaluations (dynamics)        : 30960
   Number of non-linear iteration            : 29178
   Number of non-linear convergence failures : 898
   Number of Jacobian-evaluations            : 1532
   Number of crossing function evaluations   : 24669
   Number of model time events               : 446
   Number of state events                    : 297
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCT


-------------- OCT

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

CVodeError: 'The right-hand side function had repeated recoverable errors. At time 20157.555473.'"),
  Icon(graphics={Polygon(lineColor={0,0,255},
    fillColor={0,140,72},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    points={{-80,100},{20,40},{-80,-20},{-80,100}}),
  Polygon(lineColor={0,0,255},
    fillColor={238,46,47},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase1OCT;
