within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase3ComplianceNoBoundary
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase3(
    pla(use_cpl=true, use_bouChiWat=false, use_bouHeaWat=false))
    annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase3ComplianceNoBoundary
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.50708593048
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

  Jacobian inverse norm estimate: 52985.9
  Condition number estimate: 7927.29
  1-norm of the residual = 99.2836

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 628.643
    pla.valIso.port_aHeaWat.m_flow = 0.41142
    pla.valHeaWatMinByp.lin.dp = 45.196
  Last value of the residual:
    { 98.1799, 1.10365, -2.34293E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.62301680492
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.36895e+06
  Condition number estimate: 237594
  1-norm of the residual = 107.625

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 543.898
    pla.valIso.port_aHeaWat.m_flow = 0.273635
    pla.valHeaWatMinByp.lin.dp = 20.8182
  Last value of the residual:
    { 106.969, 0.656172, -7.17016E-05 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.62148994949
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 3.46377e+06
  Condition number estimate: 690246
  1-norm of the residual = 17.2427

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 483.553
    pla.valIso.port_aHeaWat.m_flow = 0.195852
    pla.valHeaWatMinByp.lin.dp = 13.1695
  Last value of the residual:
    { 16.4795, 0.763163, 1.58069E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.72480807377
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 93472.9
  Condition number estimate: 20052.9
  1-norm of the residual = 4.08725

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 454.104
    pla.valIso.port_aHeaWat.m_flow = 0.163679
    pla.valHeaWatMinByp.lin.dp = 10.6589
  Last value of the residual:
    { 3.05585, 1.0314, -1.20877E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.57112946791
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.96401e+06
  Condition number estimate: 611880
  1-norm of the residual = 10.6219

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 475.818
    pla.valIso.port_aHeaWat.m_flow = 0.187052
    pla.valHeaWatMinByp.lin.dp = 12.4776
  Last value of the residual:
    { 10.4914, 0.130502, -5.41912E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.69505009332
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.13969e+06
  Condition number estimate: 965268
  1-norm of the residual = 34.7096

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 422.05
    pla.valIso.port_aHeaWat.m_flow = 0.132705
    pla.valHeaWatMinByp.lin.dp = 8.52873
  Last value of the residual:
    { 34.5768, 0.132841, 7.26571E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.77433112708
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 6887.68
  Condition number estimate: 3255.38
  1-norm of the residual = 24.568

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 365.394
    pla.valIso.port_aHeaWat.m_flow = 0.0876241
    pla.valHeaWatMinByp.lin.dp = 5.50921
  Last value of the residual:
    { 24.5132, 0.0547734, 4.38852E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.87576262523
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 13089.3
  Condition number estimate: 4839.69
  1-norm of the residual = 95.6219

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 373.851
    pla.valIso.port_aHeaWat.m_flow = 0.0936074
    pla.valHeaWatMinByp.lin.dp = 5.99273
  Last value of the residual:
    { 95.5617, -0.06014, 2.77275E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.18454392065
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.8566e+06
  Condition number estimate: 1.50997e+06
  1-norm of the residual = 43.5664
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 309.191
    pla.valIso.port_aHeaWat.m_flow = 0.0540164
    pla.valHeaWatMinByp.lin.dp = 3.37316
  Last value of the residual:
    { 42.455, 1.11143, 2.40495E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.88483654249
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.91102e+06
  Condition number estimate: 1.50567e+06
  1-norm of the residual = 29.9986
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 315.295
    pla.valIso.port_aHeaWat.m_flow = 0.0571715
    pla.valHeaWatMinByp.lin.dp = 3.57508
  Last value of the residual:
    { 29.7462, 0.252455, 5.42068E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.06365478403
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.10581e+06
  Condition number estimate: 1.34311e+06
  1-norm of the residual = 98.292
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 289.095
    pla.valIso.port_aHeaWat.m_flow = 0.044429
    pla.valHeaWatMinByp.lin.dp = 2.87212
  Last value of the residual:
    { 98.2767, 0.0152741, 1.8631E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51173.8920776806
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 37625.4
  Condition number estimate: 12641.7
  1-norm of the residual = 19.1418

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 296.794
    pla.valIso.port_aHeaWat.m_flow = 0.0479596
    pla.valHeaWatMinByp.lin.dp = 2.984
  Last value of the residual:
    { 19.0695, 0.0723464, 3.11574E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.00646241623
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 212261
  Condition number estimate: 70994.8
  1-norm of the residual = 62.7212

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 279.914
    pla.valIso.port_aHeaWat.m_flow = 0.0404446
    pla.valHeaWatMinByp.lin.dp = 2.57617
  Last value of the residual:
    { 62.6988, -0.0223543, 1.06916E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.24432181577
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.57218e+06
  Condition number estimate: 1.69843e+06
  1-norm of the residual = 115.308
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 234.724
    pla.valIso.port_aHeaWat.m_flow = 0.0241902
    pla.valHeaWatMinByp.lin.dp = 1.644
  Last value of the residual:
    { 115.289, 0.0193869, 2.17097E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.01230942129
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 21081.7
  Condition number estimate: 7923.92
  1-norm of the residual = 23.1622

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 241.332
    pla.valIso.port_aHeaWat.m_flow = 0.0262359
    pla.valHeaWatMinByp.lin.dp = 1.64153
  Last value of the residual:
    { 23.0884, 0.0737796, 4.2257E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.16698435095
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.20108e+06
  Condition number estimate: 1.60785e+06
  1-norm of the residual = 70.3841
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 221.419
    pla.valIso.port_aHeaWat.m_flow = 0.0203927
    pla.valHeaWatMinByp.lin.dp = 1.34807
  Last value of the residual:
    { 70.2862, 0.097844, 1.16299E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.0219766044
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.35527e+06
  Condition number estimate: 511731
  1-norm of the residual = 13.8687

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 228.258
    pla.valIso.port_aHeaWat.m_flow = 0.0222921
    pla.valHeaWatMinByp.lin.dp = 1.38525
  Last value of the residual:
    { 13.7765, 0.0921972, 1.32289E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.11864843543
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 27086.6
  Condition number estimate: 10792.6
  1-norm of the residual = 4.44133

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 204.041
    pla.valIso.port_aHeaWat.m_flow = 0.0160492
    pla.valHeaWatMinByp.lin.dp = 0.985681
  Last value of the residual:
    { 3.90673, 0.534598, -3.37185E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.36032801302
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.65319e+06
  Condition number estimate: 1.94729e+06
  1-norm of the residual = 92.9881
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 177.053
    pla.valIso.port_aHeaWat.m_flow = 0.0105826
    pla.valHeaWatMinByp.lin.dp = 0.778923
  Last value of the residual:
    { 92.909, 0.0790749, 1.6928E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.13375340903
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 28099.8
  Condition number estimate: 11647.2
  1-norm of the residual = 19.1261

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 184.359
    pla.valIso.port_aHeaWat.m_flow = 0.0119173
    pla.valHeaWatMinByp.lin.dp = 0.755361
  Last value of the residual:
    { 19.0413, 0.0847112, 3.2013E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.28480314503
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 452592
  Condition number estimate: 193178
  1-norm of the residual = 55.8933

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 166.815
    pla.valIso.port_aHeaWat.m_flow = 0.00888329
    pla.valHeaWatMinByp.lin.dp = 0.622137
  Last value of the residual:
    { 55.7128, 0.180529, 9.35555E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.55784603991
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.64641e+06
  Condition number estimate: 2.12872e+06
  1-norm of the residual = 84.6719
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 121.976
    pla.valIso.port_aHeaWat.m_flow = 0.00353605
    pla.valHeaWatMinByp.lin.dp = 0.337272
  Last value of the residual:
    { 84.553, 0.118935, 1.4923E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.28225930501
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 8524.46
  Condition number estimate: 3968
  1-norm of the residual = 21.0085

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 130.519
    pla.valIso.port_aHeaWat.m_flow = 0.00431585
    pla.valHeaWatMinByp.lin.dp = 0.2932
  Last value of the residual:
    { 20.9339, 0.0745462, 2.71926E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.44533299049
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.88134e+06
  Condition number estimate: 2.27932e+06
  1-norm of the residual = 46.3756
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 107.612
    pla.valIso.port_aHeaWat.m_flow = 0.00244568
    pla.valHeaWatMinByp.lin.dp = 0.216029
  Last value of the residual:
    { 46.308, 0.0675046, 7.52232E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.57645099176
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 7474.1
  Condition number estimate: 3647.17
  1-norm of the residual = 40.8603

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 73.4611
    pla.valIso.port_aHeaWat.m_flow = 0.000797958
    pla.valHeaWatMinByp.lin.dp = 0.107836
  Last value of the residual:
    { 40.8035, 0.0567775, 6.5308E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 51174.78151653225
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 6175.07
  Condition number estimate: 3063.1
  1-norm of the residual = 33.0415

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 39.5563
    pla.valIso.port_aHeaWat.m_flow = 0.000134579
    pla.valHeaWatMinByp.lin.dp = 0.056074
  Last value of the residual:
    { 32.9786, 0.062873, 5.03138E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84964.7237991818
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.50232e+06
  Condition number estimate: 367857
  1-norm of the residual = 7.21304

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 400.936
    pla.valIso.port_aHeaWat.m_flow = 0.114509
    pla.valHeaWatMinByp.lin.dp = 5.21679
  Last value of the residual:
    { 5.35618, 1.85686, -1.36736E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84964.02918235345
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.58129e+06
  Condition number estimate: 391093
  1-norm of the residual = 56.0524

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 399.042
    pla.valIso.port_aHeaWat.m_flow = 0.112958
    pla.valHeaWatMinByp.lin.dp = 5.39529
  Last value of the residual:
    { 56.0036, -0.048855, 1.75539E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84963.91341288206
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 387494
  Condition number estimate: 86648.4
  1-norm of the residual = 8.48419

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 437.85
    pla.valIso.port_aHeaWat.m_flow = 0.147459
    pla.valHeaWatMinByp.lin.dp = 6.95892
  Last value of the residual:
    { 8.03193, 0.452259, -5.93273E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84964.16562755578
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 5090.18
  Condition number estimate: 4013.38
  1-norm of the residual = 69.7314

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 337.987
    pla.valIso.port_aHeaWat.m_flow = 0.0699347
    pla.valHeaWatMinByp.lin.dp = 3.3948
  Last value of the residual:
    { 69.6759, -0.0554784, 1.34853E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84964.23808402891
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.2206e+06
  Condition number estimate: 710579
  1-norm of the residual = 55.9295

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 297.803
    pla.valIso.port_aHeaWat.m_flow = 0.0484351
    pla.valHeaWatMinByp.lin.dp = 2.35932
  Last value of the residual:
    { 55.6376, 0.291874, 1.3741E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84964.34667894317
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.74808e+06
  Condition number estimate: 624657
  1-norm of the residual = 3.91817

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 251.678
    pla.valIso.port_aHeaWat.m_flow = 0.0296599
    pla.valHeaWatMinByp.lin.dp = 1.33506
  Last value of the residual:
    { 3.14057, 0.777602, -8.0102E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84964.54683626852
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.80381e+06
  Condition number estimate: 745546
  1-norm of the residual = 3.74129

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 183.319
    pla.valIso.port_aHeaWat.m_flow = 0.011721
    pla.valHeaWatMinByp.lin.dp = 0.530276
  Last value of the residual:
    { 2.92892, 0.812366, -6.71166E-08 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84964.70672496122
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 6046.36
  Condition number estimate: 2889.13
  1-norm of the residual = 70.9853

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 132.663
    pla.valIso.port_aHeaWat.m_flow = 0.00452766
    pla.valHeaWatMinByp.lin.dp = 0.433033
  Last value of the residual:
    { 70.9217, 0.0635506, 2.06474E-07 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84964.88033675517
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 37569.2
  Condition number estimate: 18104.9
  1-norm of the residual = 51.1837

  Last value of the solution:
    pla.pumHeaWatPri.valChe[2].dp = 79.1653
    pla.valIso.port_aHeaWat.m_flow = 0.000992967
    pla.valHeaWatMinByp.lin.dp = 0.211047
  Last value of the residual:
    { 51.0372, 0.146485, 1.43123E-07 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.34703 seconds
   CPU-time for initialization               : 0.352849 seconds
   Number of result points                   : 2253
   Number of grid points                     : 501
   Number of accepted steps                  : 21124
   Number of rejected steps                  : 885
   Number of f-evaluations (dynamics)        : 32557
   Number of non-linear iteration            : 30468
   Number of non-linear convergence failures : 956
   Number of Jacobian-evaluations            : 1674
   Number of crossing function evaluations   : 25316
   Number of model time events               : 473
   Number of state events                    : 405
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase3ComplianceNoBoundary

--------------- OCT 8 NonlinearBlockConvergenceError

Final Run Statistics: --- e+04

 Number of steps                                 : 22448
 Number of function evaluations                  : 36466
 Number of Jacobian evaluations                  : 1937
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 1041
 Number of nonlinear iterations                  : 32685
 Number of nonlinear convergence failures        : 472
 Number of state function evaluations            : 27365
 Number of state events                          : 467
 Number of time events                           : 475

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-06 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04
 3.e-04 3.e-04 1.e-06 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 3.e-04 3.e-04
 1.e-06 1.e-06 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-01 1.e-01 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01
 1.e-01 3.e-04 1.e-01 3.e-04 1.e-06 1.e-01 3.e-04 1.e-01 1.e-01 1.e-06
 1.e-01 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 1.e-06 1.e-01 3.e-04
 1.e-01 1.e-01 1.e-01 1.e-01 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06
 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04
 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 41.94706298500023 seconds."),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={244,125,35},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase3ComplianceNoBoundary;
