within Buildings.Applications.DataCenters.ChillerCooled.Equipment;
model WatersideEconomizer "Waterside economizer"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialPlantParallel(
    final num=1,
    val2(each final dpFixed_nominal=dp2_nominal),
    val1(each final dpFixed_nominal=dp1_nominal),
    final yValve_start={yValWSE_start});
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics,
    final mSenFac=1,
    redeclare final package Medium=Medium2);
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.ThreeWayValveParameters(
    final activate_ThrWayVal=use_controller);
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialControllerInterface;

  // Filter opening
  parameter Real yThrWayVal_start=1
   "Initial value of output from the filter in the bypass valve"
    annotation(Dialog(tab="Dynamics",group="Time needed to open or close valve",enable=use_controller and use_strokeTime));
  parameter Real yValWSE_start=1
    "Initial value of output from the filter in the shutoff valve"
    annotation(Dialog(tab="Dynamics",group="Time needed to open or close valve",enable=use_strokeTime));

 // Heat exchanger
  parameter Modelica.Units.SI.Efficiency eta(start=0.8)
    "constant effectiveness";

 // Bypass valve parameters
  parameter Modelica.Units.SI.Time tauThrWayVal=10
    "Time constant at nominal flow for dynamic energy and momentum balance of the three-way valve"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=use_controller and not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  Modelica.Blocks.Interfaces.RealInput TSet(
    unit="K",
    displayUnit="degC") if use_controller
    "Set point for leaving water temperature"
    annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.HeatExchanger_TSet
    heaExc(
    redeclare final replaceable package Medium1 = Medium1,
    redeclare final replaceable package Medium2 = Medium2,
    final dpThrWayVal_nominal=dpThrWayVal_nominal,
    final use_controller=use_controller,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
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
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=initValve,
    final yThrWayVal_start=yThrWayVal_start,
    final eta=eta,
    final fraK_ThrWayVal=fraK_ThrWayVal,
    final l_ThrWayVal=l_ThrWayVal,
    final R=R,
    final delta0=delta0,
    final tauThrWayVal=tauThrWayVal,
    final portFlowDirection_1=portFlowDirection_1,
    final portFlowDirection_2=portFlowDirection_2,
    final portFlowDirection_3=portFlowDirection_3,
    final rhoStd=rhoStd[2],
    final reverseActing=reverseActing) "Water-to-water heat exchanger"
    annotation (Placement(transformation(extent={{-10,-12},{10,4}})));

equation
  connect(port_a1, heaExc.port_a1)
    annotation (Line(points={{-100,60},{-40,60},
            {-40,2},{-10,2}},color={0,127,255}));
  connect(heaExc.port_a2, port_a2)
    annotation (Line(points={{10,-10},{40,-10},
            {40,-60},{100,-60}},color={0,127,255}));
  connect(TSet, heaExc.TSet)
    annotation (Line(points={{-120,0},{-12,0}},color={0,0,127}));
  connect(y_reset_in, heaExc.y_reset_in)
    annotation (Line(points={{-90,-100},{-90,
          -100},{-90,-80},{-10,-80},{-10,-14}},color={0,0,127}));
  connect(trigger, heaExc.trigger)
    annotation (Line(points={{-60,-100},{-60,-80},
          {-6,-80},{-6,-14}}, color={255,0,255}));
  connect(heaExc.port_b1, val1[1].port_a)
    annotation (Line(points={{10,2},{40,2},{40,22}}, color={0,127,255}));
  connect(val2[1].port_a, heaExc.port_b2)
    annotation (Line(points={{-40,-22},{-40,
          -22},{-40,-10},{-10,-10}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This module impliments a waterside economizer model that consists of a
<a href=\"Modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment.HeatExchanger_TSet\">heat exchanger</a> and a shutoff valve on each medium side.
This waterside economizer model can be used in two different control scenarios:
</p>
<ol>
<li>The temperature at <code>port_b2</code> is controlled by a built-in PID controller and a three-way valve
by setting the parameter <code>use_controller</code> as <code>true</code>.
</li>
<li>The temperature at <code>port_b2</code> is NOT controlled by a built-in controller
by setting the parameter <code>use_controller</code> as <code>false</code>.
Hence, an outside controller can be used to control the temperature. For example, in the free-cooling mode,
the speed of variable-speed cooling tower fans can be adjusted to maintain the supply chilled water temperature
around the setpoint.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
April 9, 2021, by Kathryn Hinkelman:<br/>
Moved nominal pressure differences to <code>dpFixed_nominal</code> at isolation valves
to avoid redundant declarations and algebraic loops.
</li>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-94,-52},{100,-66}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,66},{92,54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,70},{-66,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-66,70},{-60,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,80},{-40,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-20,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,80},{0,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,80},{20,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,80},{40,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,80},{60,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,70},{66,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{66,70},{72,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{66,-50},{72,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,-50},{66,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-66,-50},{-60,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,-50},{-66,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end WatersideEconomizer;
