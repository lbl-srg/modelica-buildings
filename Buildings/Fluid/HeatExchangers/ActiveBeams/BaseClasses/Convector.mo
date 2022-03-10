within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses;
model Convector "Heat exchanger for the water stream"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal = per.mWat_flow_nominal*nBeams);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=true,
    final dp_nominal = per.dpWat_nominal "Don't multiply with nBeams, as the beams are in parallel");

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Data.Generic per "Performance data"
    annotation (choicesAllMatching = true,
    Placement(transformation(extent={{60,-80},{80,-60}})));

  parameter Integer nBeams(min=1) "Number of beams in parallel";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  Modelica.Blocks.Interfaces.RealInput mAir_flow(
    final unit="kg/s") "Air mass flow rate of a single beam"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC") "Room air temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W")
    "Actual capacity of a single beam"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

protected
  HeaterCooler_u hex(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final show_T=false,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final tau=tau,
    final homotopyInitialization=homotopyInitialization,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final Q_flow_nominal=-nBeams * per.Q_flow_nominal)
    "Heat exchanger for the water stream"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  ModificationFactor mod(
    final nBeams=nBeams,
    final per=per) "Performance modification for part load"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Modelica.Blocks.Sources.RealExpression senTem(final y=Medium.temperature(port_a_inflow))
    "Actual water temperature entering the beam"
    annotation (Placement(transformation(extent={{-60,18},{-40,38}})));

  Medium.ThermodynamicState port_a_inflow=
    Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow))
    "state for medium inflowing through port_a";

  Sensors.MassFlowRate senFloWatCoo(
    redeclare final package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(hex.Q_flow, Q_flow) annotation (Line(points={{61,6},{70,6},{70,70},{
          110,70}},
                color={0,0,127}));
  connect(hex.port_b, port_b)
    annotation (Line(points={{60,0},{82,0},{100,0}},
                                              color={0,127,255}));
  connect(mod.y, hex.u)
    annotation (Line(points={{11,60},{20,60},{20,6},{38,6}}, color={0,0,127}));
  connect(senTem.y, mod.TWat) annotation (Line(points={{-39,28},{-28,28},{-28,57},
          {-12,57}}, color={0,0,127}));
  connect(TRoo, mod.TRoo) annotation (Line(points={{-120,-60},{-20,-60},{-20,51.2},
          {-12,51.2}}, color={0,0,127}));
  connect(mAir_flow, mod.mAir_flow) annotation (Line(points={{-120,40},{-120,40},
          {-34,40},{-34,63},{-12,63}}, color={0,0,127}));
  connect(senFloWatCoo.port_a, port_a)
    annotation (Line(points={{-80,0},{-100,0}},          color={0,127,255}));
  connect(senFloWatCoo.port_b, hex.port_a)
    annotation (Line(points={{-60,0},{40,0}}, color={0,127,255}));
  connect(senFloWatCoo.m_flow, mod.mWat_flow)
    annotation (Line(points={{-70,11},{-70,69},{-12,69}}, color={0,0,127}));
  annotation ( Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,100},{-50,-100}},
          lineColor={95,95,95},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-10,100},{10,-100}},
          lineColor={95,95,95},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={95,95,95}),
        Rectangle(
          extent={{50,100},{70,-100}},
          lineColor={95,95,95},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={95,95,95})}), defaultComponentName="con",
           Documentation(info="<html>
<p>
In cooling mode, this model adds heat to the water stream. The heat added is equal to:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Beam</sub> = Q<sub>rated</sub> f<sub><code>&#916;</code>T</sub> f<sub>SA</sub> f<sub>W</sub>
</p>
<p>
In heating mode, the heat is removed from the water stream.
</p>
</html>", revisions="<html>
<ul>
<li>
March 3, 2022, by Michael Wetter:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
November 2, 2016, by Michael Wetter:<br/>
Made assignment of <code>senTem.y</code> final.
</li>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Convector;
