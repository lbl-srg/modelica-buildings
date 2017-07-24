within Buildings.ChillerWSE;
model WatersideEconomizer "Waterside economizer"
  extends Buildings.ChillerWSE.BaseClasses.PartialPlantParallel(
    final n=1,
    final nVal=2,
    final m_flow_nominal={m1_flow_nominal,m2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)},
    val2(each final dpFixed_nominal=0),
    val1(each final dpFixed_nominal=dp1_nominal),
    kFixed={m1_flow_nominal/sqrt(dp1_nominal),0},
    final yValve_start={yValWSE_start});
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final mSenFac=1,
    redeclare package Medium=Medium2);

  extends Buildings.ChillerWSE.BaseClasses.ThreeWayValveParameters;
  extends Buildings.ChillerWSE.BaseClasses.PartialControllerInterface;

  // Filter opening
  parameter Real yBypVal_start=1 if use_Controller
   "Initial value of output from the filter in the bypass valve"
    annotation(Dialog(tab="Dynamics",group="Filtered opening",enable=use_Controller and use_inputFilter));

  parameter Real yValWSE_start=1 "Initial value of output from the filter in the shutoff valve"
    annotation(Dialog(tab="Dynamics",group="Filtered opening",enable=use_inputFilter));

 // Heat exchanger
  parameter Modelica.SIunits.Efficiency eta(start=0.8) "constant effectiveness";

 // Bypass valve parameters
  parameter Modelica.SIunits.Time tau_ThrWayVal=10 if use_Controller
    "Time constant at nominal flow for dynamic energy and momentum balance of the three-way valve"
    annotation(Dialog(tab="Dynamics", group="Nominal condition",
               enable=use_Controller and not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  Buildings.ChillerWSE.HeatExchanger heaExc(
    redeclare final replaceable package Medium1 = Medium1,
    redeclare final replaceable package Medium2 = Medium2,
    final use_Controller=use_Controller,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final wp=wp,
    final wd=wd,
    final Ni=Ni,
    final Nd=Nd,
    final initType=initType,
    final xi_start=xi_start,
    final xd_start=xd_start,
    final yCon_start=yCon_start,
    final reset=reset,
    final y_reset=y_reset,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final from_dp1=from_dp1,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final homotopyInitialization=homotopyInitialization,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTimeValve,
    final init=initValve,
    final yBypVal_start=yBypVal_start,
    final eta=eta,
    final fraK_ThrWayVal=fraK_ThrWayVal,
    each final l_ThrWayVal=l_ThrWayVal,
    final R=R,
    final delta0=delta0,
    final tau_ThrWayVal=tau_ThrWayVal,
    final portFlowDirection_1=portFlowDirection_1,
    final portFlowDirection_2=portFlowDirection_2,
    final portFlowDirection_3=portFlowDirection_3,
    final rhoStd=rhoStd[2],
    final reverseAction=reverseAction) "Water-to-water heat exchanger"
    annotation (Placement(transformation(extent={{-10,-12},{10,4}})));
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC") if use_Controller
    "Set point for leaving water temperature" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
equation
  connect(port_a1, heaExc.port_a1) annotation (Line(points={{-100,60},{-40,60},
            {-40,2},{-10,2}},
                            color={0,127,255}));
  connect(heaExc.port_a2, port_a2) annotation (Line(points={{10,-10},{40,-10},
            {40,-60},{100,-60}},
                              color={0,127,255}));
  connect(TSet, heaExc.TSet) annotation (Line(points={{-120,0},{-12,0}},
                       color={0,0,127}));

  connect(y_reset_in, heaExc.y_reset_in) annotation (Line(points={{-90,-100},{-90,
          -100},{-90,-80},{-10,-80},{-10,-14}},
                                   color={0,0,127}));
  connect(trigger, heaExc.trigger) annotation (Line(points={{-60,-100},{-60,-80},
          {-6,-80},{-6,-14}}, color={255,0,255}));
  connect(heaExc.port_b1, val1[1].port_a)
    annotation (Line(points={{10,2},{40,2},{40,22}}, color={0,127,255}));
  connect(val2[1].port_a, heaExc.port_b2) annotation (Line(points={{-40,-22},{-40,
          -22},{-40,-10},{-10,-10}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This module impliments a waterside economizer model that consists of a 
<a href=\"Modelica://Buildings.ChillerWSE.HeatExchanger\">heat exchanger</a> and a shutoff valve on each medium side. 
This waterside economizer model can be used in two different control scenarios:
</p>
<ol>
<li>The temperature at <code>port_b2</code> is controlled by a built-in PID controller and a three-way valve 
by setting the parameter <code>use_Controller</code> as <code>true</code>.
</li>
<li>The temperature at <code>port_b2</code> is NOT controlled by a built-in controller 
by setting the parameter <code>use_Controller</code> as <code>false</code>. 
Hence, an outside controller can be used to control the temperature. For example, in the free-cooling mode,
the speed of variable-speed cooling tower fans can be adjusted to maintain the supply chilled water temperature 
around the setpoint.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end WatersideEconomizer;
