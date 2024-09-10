within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model PartialHeatExchanger "Partial model for heat exchangers "

  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=(dp1_nominal > Modelica.Constants.eps),
    final computeFlowResistance2=(dp2_nominal > Modelica.Constants.eps));
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics,
    final mSenFac=1,
    redeclare final package Medium=Medium2);
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.ThreeWayValveParameters;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.Units.SI.Efficiency eta(
    min=0,
    max=1,
    start=0.8) "constant effectiveness";

   // Filter opening
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=activate_ThrWayVal));
  parameter Modelica.Units.SI.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=(activate_ThrWayVal and use_inputFilter)));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
      enable=(activate_ThrWayVal and use_inputFilter)));
  parameter Real yThrWayVal_start=1
    "Initial value of output from the filter in the bypass valve"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
      enable=(activate_ThrWayVal and use_inputFilter)));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa",
    min=0,
    fixed=true) = 6000 "Nominal pressure drop of fully open valve"
    annotation (Dialog(group="Three-way Valve", enable=activate_ThrWayVal));

 // Time constant
  parameter Modelica.Units.SI.Time tauThrWayVal=10
    "Time constant at nominal flow for dynamic energy and momentum balance of the three-way valve"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=(activate_ThrWayVal and not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  // Advanced
  parameter Modelica.Units.SI.Density rhoStd=Medium2.density_pTX(
      101325,
      273.15 + 4,
      Medium2.X_default)
    "Inlet density for which valve coefficients are defined" annotation (Dialog(
      group="Nominal condition",
      tab="Advanced",
      enable=activate_ThrWayVal));

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear thrWayVal(
    redeclare package Medium = Medium2,
    final from_dp=from_dp2,
    final linearized={linearizeFlowResistance2,linearizeFlowResistance2},
    final rhoStd=rhoStd,
    final homotopyInitialization=homotopyInitialization,
    final use_strokeTime=use_inputFilter,
    final strokeTime=riseTime,
    final init=init,
    final R=R,
    final delta0=delta0,
    final fraK=fraK_ThrWayVal,
    final dpFixed_nominal={dp2_nominal,0},
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final X_start=X_start,
    final y_start=yThrWayVal_start,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final l=l_ThrWayVal,
    final dpValve_nominal=dpValve_nominal,
    final deltaM=deltaM2,
    final m_flow_nominal=m2_flow_nominal,
    final portFlowDirection_1=portFlowDirection_1,
    final portFlowDirection_2=portFlowDirection_2,
    final portFlowDirection_3=portFlowDirection_3,
    final tau=tauThrWayVal) if activate_ThrWayVal
    "Three-way valve used to control the outlet temperature "
    annotation (Placement(transformation(extent={{-40,-40},{-60,-20}})));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final from_dp1=from_dp1,
    final dp1_nominal=dp1_nominal,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final eps=eta,
    final homotopyInitialization=homotopyInitialization,
    final dp2_nominal=if activate_ThrWayVal then 0 else dp2_nominal)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(port_a1, hex.port_a1)
    annotation (Line(points={{-100,60},{-100,60},{-40,60},{-40,6},{-10,6}},
      color={0,127,255}));
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{10,6},{40,6},{40,60},{100,60}},
      color={0,127,255}));
  connect(hex.port_a2, port_a2)
    annotation (Line(points={{10,-6},{40,-6},{40,-60},{100,-60}},
      color={0,127,255}));
  if activate_ThrWayVal then
    connect(hex.port_b2, thrWayVal.port_1) annotation (Line(points={{-10,-6},{-28,
            -6},{-28,-30},{-40,-30}}, color={0,127,255}));
    connect(port_a2, thrWayVal.port_3) annotation (Line(points={{100,-60},{-50,-60},
            {-50,-40}}, color={0,127,255}));
    connect(thrWayVal.port_2, port_b2) annotation (Line(points={{-60,-30},{-60,-30},
            {-80,-30},{-80,-60},{-100,-60}}, color={0,127,255}));
  else
    connect(port_b2, hex.port_b2)
      annotation (Line(points={{-100,-60},{-80,-60},{-80,-6},{-10,-6}},
                            color={0,127,255}));
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
              extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-92,66},{92,54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,70},{66,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-52},{100,-66}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{66,70},{72,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,80},{40,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,80},{20,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,80},{0,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-20,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,80},{-40,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-66,70},{-60,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,70},{-66,50}},
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
          extent={{40,80},{60,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    __Dymola_Commands,
    Documentation(info="<html>
<p>
This module simulates a heat exchanger with a three-way bypass used to modulate water flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
November 16, 2022, by Michael Wetter:<br/>
Changed <code>riseTime</code> of valve to be <i>30</i> seconds to make it the same as the rise time of pumps.
</li>
<li>
April 9, 2021, by Kathryn Hinkelman:<br/>
Added <code>dpValve_nominal</code> to avoid redundant declaration of <code>dp2_nominal</code>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">Buildings, #1341</a>.
</li>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialHeatExchanger;
