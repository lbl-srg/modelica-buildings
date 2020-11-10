within Buildings.Experimental.DHC.CentralPlants.Cooling.Subsystems;
model CoolingTowerParellel
  "Multiple identical cooling towers in parallel connection"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.SignalFilter(
    riseTimeValve=30,
    use_inputFilter=true,
    final numFil=num);
  parameter Integer num(
    final min=1)=2
    "Number of cooling towers";
  replaceable package Medium=Buildings.Media.Water
    "Condenser water medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Boolean show_T=true
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced",group="Diagnostics"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of condenser water in each tower"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp_nominal
    "Nominal pressure difference of the tower"
    annotation (Dialog(group="Nominal condition"));
  parameter Real ratWatAir_nominal(
    final min=0,
    final unit="1")=0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TAirInWB_nominal
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.SIunits.Temperature TWatIn_nominal
    "Nominal water inlet temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.SIunits.Power PFan_nominal
    "Fan power"
    annotation (Dialog(group="Fan"));
  Medium.ThermodynamicState sta_a=Medium.setState_phX(
    port_a.p,
    noEvent(
      actualStream(
        port_a.h_outflow)),
    noEvent(
      actualStream(
        port_a.Xi_outflow))) if show_T
    "Medium properties in port_a";
  Medium.ThermodynamicState sta_b=Medium.setState_phX(
    port_b.p,
    noEvent(
      actualStream(
        port_b.h_outflow)),
    noEvent(
      actualStream(
        port_b.Xi_outflow))) if show_T
    "Medium properties in port_b";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium=Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.BooleanInput on[num]
    "On signal for cooling towers"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput uFanSpe(
    final unit="1")
    "Fan speed control signal"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final unit="K",
    displayUnit="degC")
    "Entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput PFan[num](
    each final quantity="Power",
    each final unit="W")
    "Electric power consumed by fan"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput TLvg[num](
    each final unit="K",
    each displayUnit="degC")
    "Leaving water temperature"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  replaceable Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel cooTow[num](
    each final ratWatAir_nominal=ratWatAir_nominal,
    each final TAirInWB_nominal=TAirInWB_nominal,
    each final TWatIn_nominal=TWatIn_nominal,
    each final TWatOut_nominal=TWatIn_nominal-dT_nominal,
    each final PFan_nominal=PFan_nominal)
    constrainedby Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower(
      redeclare each final package Medium=Medium,
      each show_T=show_T,
      each final m_flow_nominal=m_flow_nominal,
      each final dp_nominal=dp_nominal,
      each final energyDynamics=energyDynamics)
    "Cooling tower type"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val[num](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=m_flow_nominal,
    each final dpValve_nominal=dp_nominal)
    "Cooling tower valves"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[num]
    "Boolean signal to real signal"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
initial equation
  Modelica.Utilities.Streams.print(
    "Warning:\n  In "+getInstanceName()+": This model is a beta version and is not fully validated yet.");
equation
  for i in 1:num loop
    connect(port_a,val[i].port_a)
      annotation (Line(points={{-100,0},{-60,0}},color={0,127,255}));
    connect(val[i].port_b,cooTow[i].port_a)
      annotation (Line(points={{-40,0},{-10,0}},color={0,127,255}));
    connect(cooTow[i].port_b,port_b)
      annotation (Line(points={{10,0},{100,0}},color={0,127,255}));
    connect(uFanSpe,cooTow[i].y)
      annotation (Line(points={{-120,20},{-20,20},{-20,8},{-12,8}},color={0,0,127}));
    connect(TWetBul,cooTow[i].TAir)
      annotation (Line(points={{-120,-60},{-20,-60},{-20,4},{-12,4}},color={0,0,127}));
    connect(cooTow[i].PFan,PFan[i])
      annotation (Line(points={{11,8},{20,8},{20,60},{110,60}},color={0,0,127}));
    connect(cooTow[i].TLvg,TLvg[i])
      annotation (Line(points={{11,-6},{26,-6},{26,30},{110,30}},color={0,0,127}));
  end for;
  if use_inputFilter then
    connect(booToRea.y,filter.u)
      annotation (Line(points={{-68,60},{-60,60},{-60,84},{-55.2,84}},color={0,0,127}));
  else
    connect(booToRea.y,y_actual)
      annotation (Line(points={{-68,60},{-60,60},{-60,74},{-20,74}},color={0,0,127}));
  end if;
  connect(y_actual,val.y)
    annotation (Line(points={{-20,74},{-14,74},{-14,60},{-50,60},{-50,12}},color={0,0,127}));
  connect(on,booToRea.u)
    annotation (Line(points={{-120,60},{-92,60}},color={255,0,255}));
  annotation (
    defaultComponentName="cooTowPar",
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-30,80},{30,6}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,74},{0,66}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,74},{22,66}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{16,56},{22,44}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,56},{6,44}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,56},{-6,44}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{16,56},{10,44}},
          color={255,0,0},
          thickness=0.5),
        Rectangle(
          extent={{-30,-6},{30,-80}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-22,-12},{0,-20}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,-12},{22,-20}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,-30},{-22,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-16,-30},{-10,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-30},{-6,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-30},{6,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{16,-30},{10,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{16,-30},{22,-42}},
          color={255,0,0},
          thickness=0.5),
        Rectangle(
          extent={{30,10},{60,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,-76},{60,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{62,2},{92,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,-80},{62,10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,2},{-60,-2}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,-30},{-60,60}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-26},{16,-30}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{16,56}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,56},{-22,44}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-16,56},{-10,44}},
          color={255,0,0},
          thickness=0.5)}),
    Documentation(
      revisions="<html>
<ul>
<li>
May 19, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>This model implements a parallel cooling tower system with <code>num</code> identical cooling towers. </p>
<p>The cooling tower type is replacable. <a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a> is currently used in this model. </p>
</html>"),
    __Dymola_Commands);
end CoolingTowerParellel;
