within Buildings.DHC.ETS.Combined.Subsystems;
model SwitchBox
  "Model for mass flow rate redirection with three-port two-position directional valves"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    min=0,
    displayUnit="Pa") = 5000 "Valve pressure drop at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Real trueHoldDuration(
    final unit="s") = 60
    "true hold duration";
  parameter Real falseHoldDuration(
    final unit="s") = trueHoldDuration
    "false hold duration";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance (except for the pump always modeled in steady state)"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));
  // IO CONECTORS
  Modelica.Fluid.Interfaces.FluidPort_b port_bSup(
    redeclare package Medium = Medium)
    "Supply line outlet port"
    annotation (Placement(transformation(
      extent={{-30,90},{-10,110}}),
      iconTransformation(extent={{-70,90},{-50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bRet(
    redeclare final package Medium = Medium)
    "Return line outlet port"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}}),
      iconTransformation(extent={{50,-110},{70,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSup(
    redeclare final package Medium = Medium)
    "Supply line inlet port"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}}),
      iconTransformation(extent={{-70,-110},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
    redeclare final package Medium = Medium)
    "Return line inlet port"
    annotation (Placement(transformation(extent={{10,90},{30,110}}),
      iconTransformation(extent={{50,90},{70,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mRev_flow(final unit="kg/s")
    "Service water mass flow rate in reverse direction"
    annotation (Placement(
      transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mPos_flow(final unit="kg/s")
    "Service water mass flow rate in positive direction"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
    iconTransformation(extent=
           {{-140,20},{-100,60}})));
  // COMPONENTS
  Buildings.DHC.ETS.BaseClasses.Junction splSup(
    redeclare final package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal)
    "Flow splitter"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-20,40})));
  Buildings.DHC.ETS.BaseClasses.Junction splRet(
    redeclare final package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal)
    "Flow splitter"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={20,0})));
  Buildings.DHC.ETS.Combined.Controls.SwitchBox con(
    final m_flow_nominal=m_flow_nominal,
    final trueHoldDuration=trueHoldDuration,
    final falseHoldDuration=falseHoldDuration)
    "Switch box controller"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valSup(
    redeclare package Medium = Medium,
    dpValve_nominal=dpValve_nominal,
    use_strokeTime=false,
    m_flow_nominal=m_flow_nominal,
    linearized={true,true},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Directional valve" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        origin={-20,0},
        rotation=-90)));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valRet(
    redeclare package Medium = Medium,
    dpValve_nominal=dpValve_nominal,
    use_strokeTime=false,
    m_flow_nominal=m_flow_nominal,
    linearized={true,true},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Directional valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={20,-40},
        rotation=-90)));
equation
  connect(port_bSup, splSup.port_2)
    annotation (Line(points={{-20,100},{-20,50}}, color={0,127,255}));
  connect(mRev_flow, con.mRev_flow) annotation (Line(points={{-120,-40},{-80,-40},
          {-80,-8},{-72,-8}}, color={0,0,127}));
  connect(splRet.port_1, port_aRet)
    annotation (Line(points={{20,10},{20,100}}, color={0,127,255}));
  connect(valSup.port_1, splSup.port_1)
    annotation (Line(points={{-20,10},{-20,30}}, color={0,127,255}));
  connect(valSup.port_3, splRet.port_3)
    annotation (Line(points={{-10,0},{10,0}}, color={0,127,255}));
  connect(splRet.port_2, valRet.port_1)
    annotation (Line(points={{20,-10},{20,-30}}, color={0,127,255}));
  connect(splSup.port_3, valRet.port_3) annotation (Line(points={{-10,40},{0,40},
          {0,-40},{10,-40}}, color={0,127,255}));
  connect(valRet.port_2, port_bRet)
    annotation (Line(points={{20,-50},{20,-100}}, color={0,127,255}));
  connect(valSup.port_2, port_aSup) annotation (Line(points={{-20,-10},{-20,-100}},
                      color={0,127,255}));
  connect(con.y, valRet.y) annotation (Line(points={{-48,0},{-40,0},{-40,-20},{60,
          -20},{60,-40},{32,-40}},
                     color={0,0,127}));
  connect(mPos_flow, con.mPos_flow) annotation (Line(points={{-120,40},{-80,40},
          {-80,8},{-72,8}}, color={0,0,127}));
  connect(con.y, valSup.y)
    annotation (Line(points={{-48,0},{-32,0}}, color={0,0,127}));
  annotation (
  defaultComponentName="swiFlo",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
    {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
    lineColor={0,0,127}, fillColor={255,255,255},
  fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-35,1},{35,-1}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-61,55},
          rotation=90),
        Polygon(
          points={{-10,-10},{-10,10},{10,0},{-10,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-60,-10},
          rotation=90),
        Polygon(
          points={{-10,-10},{-10,10},{10,0},{-10,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-60,10},
          rotation=-90),
        Polygon(
          points={{-40,-10},{-40,10},{-60,0},{-40,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{38,-48},{38,-28},{58,-38},{38,-48}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,-10},{-10,10},{10,0},{-10,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={58,-28},
          rotation=-90),
        Polygon(
          points={{-10,-10},{-10,10},{10,0},{-10,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={58,-48},
          rotation=90),
        Rectangle(
          extent={{-54,1},{54,-1}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={59,36},
          rotation=90),
        Rectangle(
          extent={{-16,1},{16,-1}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={59,-74},
          rotation=90),
        Rectangle(
          extent={{-35,1},{35,-1}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-61,-55},
          rotation=90),
        Rectangle(
          extent={{-1,50},{1,-50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={10,1},
          rotation=90),
        Rectangle(
          extent={{-1,29},{1,-29}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-31,61},
          rotation=90),
        Rectangle(
          extent={{-1,21},{1,-21}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={17,-39},
          rotation=90),
        Rectangle(
          extent={{-50,1},{50,-1}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-3,12},
          rotation=90),
        Line(
          points={{-90,66},{-52,64}},
          color={0,0,127},
          pattern=LinePattern.None),
        Line(points={{-72,0},{-72,-70},{82,-70},{82,-34},{58,-34}}, color={0,0,127}),
        Rectangle(
          extent={{-96,10},{-76,-10}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-76,0},{-60,0}}, color={0,0,127}),
        Line(points={{-100,40},{-86,40},{-86,10}}, color={0,0,127}),
        Line(points={{-100,-40},{-86,-40}}, color={0,0,127}),
        Line(points={{-86,-40},{-86,-10}}, color={0,0,127})}),Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This model represents a hydronic arrangement avoid flow reversal in the service line,
for instance when connecting an energy transfer station such as the one modeled in
<a href=\"modelica://Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger\">
Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger</a>.
For that intent, two three-port two-position directional valves are used. The valves are
actuated based on the logic described in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Controls.SwitchBox\">
Buildings.DHC.ETS.Combined.Controls.SwitchBox</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 27, 2024, by David Blum:<br/>
Update icon.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3606\">issue #3606</a>.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
Refactored with three-way valves instead of pumps.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1769\">
issue 1769</a>.
</li>
<li>
January 16, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end SwitchBox;
