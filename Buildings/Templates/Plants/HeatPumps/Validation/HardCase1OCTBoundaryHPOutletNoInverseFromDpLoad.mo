within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1OCTBoundaryHPOutletNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTNoInverseFromDpLoad(
    pla(locBou=Buildings.Templates.Plants.HeatPumps.Types.LocationBoundary.HeatPumpOutlet))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTBoundaryHPOutletNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36509.93179015279
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

  Jacobian inverse norm estimate: 7.98537e+11
  Condition number estimate: 2.38488e+10
  1-norm of the residual = 25.4699
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = 13038.6
    loaCoo.con.val.valEqu.dp = 42515.7
    pla.valIso.port_aChiWat.m_flow = 55.0244
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 140328
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 410453
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 641225
    loaHea.con.val.valEqu.dp = 20912.8
    pla.valIso.port_bHeaWat.m_flow = -21.6267
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 586306
    loaHea.port_a.p = 441670
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 441704
  Last value of the residual:
    { -1.18308, 0.230232, 20.7408, -0.687469, 0.655902,
      0.165397, -0.690413, 0.460597, 0.655901, -4.42497E-06,
      2.84412E-05 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36509.81510184393
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.0442e+12
  Condition number estimate: 1.09425e+11
  1-norm of the residual = 26.1046
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = 13308.7
    loaCoo.con.val.valEqu.dp = 42769.3
    pla.valIso.port_aChiWat.m_flow = 55.1922
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 139155
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 411040
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 639725
    loaHea.con.val.valEqu.dp = 20107.7
    pla.valIso.port_bHeaWat.m_flow = -21.1976
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 585697
    loaHea.port_a.p = 441067
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 441216
  Last value of the residual:
    { -0.554593, 0.0135515, 15.5593, -1.52145, 1.60619,
      -1.43706, -1.52164, 2.28462, 1.60619, 6.08107E-06,
      -6.17035E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36509.9884367305
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 9.16265e+11
  Condition number estimate: 2.49349e+10
  1-norm of the residual = 29.0507
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = 13178
    loaCoo.con.val.valEqu.dp = 42604.5
    pla.valIso.port_aChiWat.m_flow = 55.0799
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 139394
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 411192
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 642572
    loaHea.con.val.valEqu.dp = 19752
    pla.valIso.port_bHeaWat.m_flow = -21.0344
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 585574
    loaHea.port_a.p = 440706
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 440752
  Last value of the residual:
    { -1.1759, 0.19646, 19.3256, -1.25826, 1.43155,
      -1.36719, -1.25878, 1.60544, 1.43155, -1.04808E-05,
      9.61401E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36510.41677996768
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.14731e+12
  Condition number estimate: 3.1721e+10
  1-norm of the residual = 24.1969
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = 13325.9
    loaCoo.con.val.valEqu.dp = 42822.5
    pla.valIso.port_aChiWat.m_flow = 55.2059
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 139112
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 412045
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 640040
    loaHea.con.val.valEqu.dp = 18806.9
    pla.valIso.port_bHeaWat.m_flow = -20.5894
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 585730
    loaHea.port_a.p = 440209
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 440216
  Last value of the residual:
    { -0.341091, 0.0541205, 14.8123, -1.34697, 1.39823,
      -1.45239, -1.34696, 2.0466, 1.39823, -1.99474E-05,
      -2.8095E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 41260.30852798118
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 8.38019e+11
  Condition number estimate: 3.41563e+10
  1-norm of the residual = 19.4434
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = 9938.5
    loaCoo.con.val.valEqu.dp = 50002.9
    pla.valIso.port_aChiWat.m_flow = 47.6888
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 103864
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 396721
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 629818
    loaHea.con.val.valEqu.dp = 35399.4
    pla.valIso.port_bHeaWat.m_flow = -20.6966
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 545297
    loaHea.port_a.p = 436511
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 436617
  Last value of the residual:
    { -0.82007, -0.0053221, 3.07301, -2.32263, 2.44767,
      -2.42349, -2.32266, 3.58083, 2.44767, -8.33638E-06,
      -2.74359E-05 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 54027.20957392058
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.02612e+08
  Condition number estimate: 4.83973e+07
  1-norm of the residual = 49.482
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = 9090
    loaCoo.con.val.valEqu.dp = 17450.1
    pla.valIso.port_aChiWat.m_flow = 52.1375
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 39598.5
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 351449
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 393071
    loaHea.con.val.valEqu.dp = 0.0261055
    pla.valIso.port_bHeaWat.m_flow = -0.000875578
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 435646
    loaHea.port_a.p = 393069
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 427000
  Last value of the residual:
    { -15.1282, 0.12826, 1.34524E-07, -1.19818, 7.20207E-05,
      -0.000915255, 0.392155, 32.1778, -0.456289, -4.14735E-05,
      2.08872E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 60210.90723270157
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.89156e+08
  Condition number estimate: 2.31874e+08
  1-norm of the residual = 0.510754
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = -1696.39
    loaCoo.con.val.valEqu.dp = 0.777996
    pla.valIso.port_aChiWat.m_flow = 0.347313
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 22.0689
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 351325
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 351426
    loaHea.con.val.valEqu.dp = 6.58482E-05
    pla.valIso.port_bHeaWat.m_flow = -2.12392E-06
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 351366
    loaHea.port_a.p = 351426
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 351344
  Last value of the residual:
    { -0.254921, 0.000671731, 1.97191E-09, -0.0925819, 3.63012E-06,
      -3.89953E-05, -0.0644867, 0.091756, -0.00627016, 2.39304E-05,
      8.9898E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 66809.30355994531
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.64891e+07
  Condition number estimate: 1.24947e+07
  1-norm of the residual = 87.4908
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = -23806.4
    loaCoo.con.val.valEqu.dp = 15130.7
    pla.valIso.port_aChiWat.m_flow = 32.5648
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 17772.9
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 350963
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 392308
    loaHea.con.val.valEqu.dp = 0.0248152
    pla.valIso.port_bHeaWat.m_flow = -0.000864303
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 393669
    loaHea.port_a.p = 392307
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 470639
  Last value of the residual:
    { 54.8717, -0.159008, -3.30205E-07, 10.2454, 2.76565E-05,
      -0.000368282, 10.1532, -10.1949, 1.86545, -0.000753591,
      6.27711E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84072.16330360489
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.17705e+11
  Condition number estimate: 8.90187e+09
  1-norm of the residual = 0.421745
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = 819.809
    loaCoo.con.val.valEqu.dp = 12.5745
    pla.valIso.port_aChiWat.m_flow = 0.458125
    pla.valIso.valChiWatUniOutIso[1].lin.dp = -16153.1
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 304138
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 345226
    loaHea.con.val.valEqu.dp = 39767.2
    pla.valIso.port_bHeaWat.m_flow = -14.2774
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 352487
    loaHea.port_a.p = 345221
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 466594
  Last value of the residual:
    { 6.11642E-08, 0.00065064, 0.0342239, 0.0367566, -0.0353953,
      0.0266604, 0.0353951, 0.217203, -0.0353953, 6.4211E-05,
      3.1105E-07 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 5.17503 seconds
   CPU-time for initialization               : 0.338568 seconds
   Number of result points                   : 1977
   Number of grid points                     : 501
   Number of accepted steps                  : 20411
   Number of rejected steps                  : 843
   Number of f-evaluations (dynamics)        : 31293
   Number of non-linear iteration            : 29511
   Number of non-linear convergence failures : 907
   Number of Jacobian-evaluations            : 1545
   Number of crossing function evaluations   : 24838
   Number of model time events               : 446
   Number of state events                    : 294
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTBoundaryHPOutletNoInverseFromDpLoad

-------------------- OCT 

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

CVodeError: 'The rootfinding function failed in an unrecoverable manner. At time 41261.147339.'"),
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
end HardCase1OCTBoundaryHPOutletNoInverseFromDpLoad;
