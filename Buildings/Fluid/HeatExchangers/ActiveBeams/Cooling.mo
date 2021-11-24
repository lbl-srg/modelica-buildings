within Buildings.Fluid.HeatExchangers.ActiveBeams;
model Cooling "Active beam unit for cooling"

  replaceable package MediumWat =
    Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water")));
  replaceable package MediumAir =
    Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  replaceable parameter Data.Generic perCoo "Performance data for cooling"
    annotation (
      Dialog(group="Nominal condition"),
      choicesAllMatching=true,
      Placement(transformation(extent={{102,-98},{118,-82}})));

  parameter Integer nBeams(min=1)=1 "Number of beams in parallel";

  parameter Boolean allowFlowReversalWat=true
    "= true to allow flow reversal in water circuit, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalAir=true
    "= true to allow flow reversal in air circuit, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // Flow resistance
  parameter Boolean from_dpWat = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = perCoo.dpAir_nominal > 0,
                tab="Flow resistance"));
  parameter Boolean linearizeFlowResistanceWat = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Flow resistance"));
  parameter Real deltaMWat = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(tab="Flow resistance"));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter MediumWat.AbsolutePressure pWatCoo_start = MediumWat.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Cooling"));
  parameter MediumWat.Temperature TWatCoo_start = MediumWat.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Cooling"));

  parameter MediumWat.MassFlowRate mWat_flow_small(min=0) = 1E-4*abs(perCoo.mWat_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter MediumAir.MassFlowRate mAir_flow_small(min=0) = 1E-4*abs(perCoo.mAir_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  // Ports
  Modelica.Fluid.Interfaces.FluidPort_a watCoo_a(
    redeclare final package Medium = MediumWat,
    m_flow(min=if allowFlowReversalWat then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumWat.h_default))
    "Fluid connector watCoo_a (positive design flow direction is from watCoo_a to watCoo_b)"
    annotation (Placement(transformation(extent={{-150,50},{-130,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b watCoo_b(
    redeclare final package Medium = MediumWat,
    m_flow(max=if allowFlowReversalWat then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumWat.h_default))
    "Fluid connector watCoo_b (positive design flow direction is from watCoo_a to watCoo_b)"
    annotation (Placement(transformation(extent={{150,50},{130,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a air_a(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversalAir then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default))
    "Fluid connector air_a (positive design flow direction is from air_a to air_b)"
    annotation (Placement(transformation(extent={{130,-70},{150,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b air_b(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversalAir then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default))
    "Fluid connector air_b (positive design flow direction is from air_a to air_b)"
    annotation (Placement(transformation(extent={{-130,-70},{-150,-50}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPor
    "Heat port, to be connected to room air"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));

  MediumWat.ThermodynamicState staWatCoo_a=
      MediumWat.setState_phX(watCoo_a.p,
                           noEvent(actualStream(watCoo_a.h_outflow)),
                           noEvent(actualStream(watCoo_a.Xi_outflow))) if
         show_T "Medium properties in port watCoo_a";
  MediumWat.ThermodynamicState staWatCoo_b=
      MediumWat.setState_phX(watCoo_b.p,
                           noEvent(actualStream(watCoo_b.h_outflow)),
                           noEvent(actualStream(watCoo_b.Xi_outflow))) if
         show_T "Medium properties in port watCoo_b";
  MediumAir.ThermodynamicState staAir_a=
      MediumAir.setState_phX(air_a.p,
                           noEvent(actualStream(air_a.h_outflow)),
                           noEvent(actualStream(air_a.Xi_outflow))) if
         show_T "Medium properties in port air_a";
  MediumAir.ThermodynamicState staAir_b=
      MediumAir.setState_phX(air_b.p,
                           noEvent(actualStream(air_b.h_outflow)),
                           noEvent(actualStream(air_b.Xi_outflow))) if
         show_T "Medium properties in port air_b";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaToRoo(
    final alpha=0)
    "Heat tranferred to the room (in addition to heat from supply air)" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-36})));

  // Pressure drop
  Modelica.SIunits.PressureDifference dpWatCoo(displayUnit="Pa") = watCoo_a.p - watCoo_b.p
    "Pressure difference watCoo_a minus watCoo_b";

  Modelica.SIunits.PressureDifference dpAir(displayUnit="Pa") = air_a.p - air_b.p
    "Pressure difference air_a minus air_b";

  FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=perCoo.mAir_flow_nominal*nBeams,
    final dp_nominal=perCoo.dpAir_nominal)
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));

protected
  BaseClasses.Convector conCoo(
    redeclare final package Medium = MediumWat,
    final per=perCoo,
    final allowFlowReversal=allowFlowReversalWat,
    final m_flow_small=mWat_flow_small,
    final show_T=false,
    final homotopyInitialization=homotopyInitialization,
    final from_dp=from_dpWat,
    final linearizeFlowResistance=linearizeFlowResistanceWat,
    final deltaM=deltaMWat,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=pWatCoo_start,
    final T_start=TWatCoo_start,
    final nBeams=nBeams) "Cooling beam"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Modelica.Blocks.Math.Sum sum "Connector for heating and cooling mode"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Modelica.Blocks.Math.Gain gaiSig(
    final k=-1,
    u(final unit="W"),
    y(final unit="W")) "Gain to reverse the sign" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,-20})));

  Sensors.MassFlowRate senFloAir(
    redeclare final package Medium = MediumAir) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-80,-70},{-100,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRooAir
    "Temperature sensor for room air"
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));

initial equation
  assert(perCoo.primaryAir.r_V[1]<=0.000001 and perCoo.primaryAir.f[1]<=0.00001,
    "Performance curve perCoo.primaryAir must pass through (0,0).");
  assert(perCoo.water.r_V[1]<=0.000001      and perCoo.water.f[1]<=0.00001,
    "Performance curve perCoo.water must pass through (0,0).");
  assert(perCoo.dT.r_dT[1]<=0.000001      and perCoo.dT.f[1]<=0.00001,
    "Performance curve perCoo.dT must pass through (0,0).");
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(heaToRoo.port, heaPor)
    annotation (Line(points={{0,-46},{0,-120}}, color={191,0,0}));
  connect(sum.y, gaiSig.u) annotation (Line(points={{61,30},{66,30},{70,30},{70,
          -20},{62,-20}}, color={0,0,127}));
  connect(gaiSig.y, heaToRoo.Q_flow)
    annotation (Line(points={{39,-20},{0,-20},{0,-26}}, color={0,0,127}));
  connect(senTemRooAir.port, heaPor) annotation (Line(points={{-20,-40},{-14,-40},
          {-14,-52},{0,-52},{0,-120}}, color={191,0,0}));
  connect(air_b, senFloAir.port_b)
    annotation (Line(points={{-140,-60},{-100,-60}}, color={0,127,255}));
  connect(conCoo.port_b, watCoo_b)
    annotation (Line(points={{10,60},{140,60}}, color={0,127,255}));
  connect(conCoo.Q_flow, sum.u[1]) annotation (Line(points={{11,67},{20,67},{20,
          30},{38,30}}, color={0,0,127}));
  connect(senTemRooAir.T, conCoo.TRoo) annotation (Line(points={{-40,-40},{-50,-40},
          {-50,54},{-12,54}}, color={0,0,127}));

  connect(air_a, res.port_a)
    annotation (Line(points={{140,-60},{90,-60},{40,-60}}, color={0,127,255}));
  connect(senFloAir.port_a, res.port_b) annotation (Line(points={{-80,-60},{-30,
          -60},{20,-60}}, color={0,127,255}));
  connect(watCoo_a, conCoo.port_a)
    annotation (Line(points={{-140,60},{-76,60},{-10,60}}, color={0,127,255}));
  connect(senFloAir.m_flow, conCoo.mAir_flow) annotation (Line(points={{-90,-49},
          {-90,-49},{-90,64},{-12,64}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,  extent={{-140,
            -120},{140,120}}), graphics={Rectangle(
          extent={{-120,100},{120,-100}},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          pattern=LinePattern.None,
          lineColor={0,0,0}),       Ellipse(
          extent={{48,78},{-48,-18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,-34},{42,-80}},
          fillColor={0,128,255},
          fillPattern=FillPattern.VerticalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-120,66},{-132,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{132,66},{120,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-120,-54},{-134,-66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{134,-54},{120,-66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,141},{151,101}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Line(points={{-114,60},{-68,60},{-84,70}}, color={0,0,255}),
        Line(points={{-68,60},{-84,52}}, color={0,0,255}),
        Line(points={{114,-60},{70,-60},{84,-52}}, color={0,127,127}),
        Line(points={{70,-60},{82,-68}}, color={0,127,127})}),
defaultComponentName="actBea",
Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
Documentation(info="<html>
<p>
Model of an active beam, based on the EnergyPlus beam model  <code>AirTerminal:SingleDuct:ConstantVolume:FourPipeBeam</code>.
</p>
<p>
This model operates only in cooling mode. For a model that operates in both heating and cooling mode,
use <a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating\">
Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating</a>.
</p>
<p>
For a description of the equations, see the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.UsersGuide\">
User's Guide</a>.
</p>
<p>
Performance data are available from
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Data\">
Buildings.Fluid.HeatExchangers.ActiveBeams.Data</a>.
</p>
<h4>References</h4>
<ul>
<li>
DOE(2015) EnergyPlus documentation v8.4.0 - Engineering Reference.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 30, 2021, by Michael Wetter:<br/>
Added annotation <code>HideResult=true</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1459\">IBPSA, #1459</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
November 3, 2016, by Michael Wetter:<br/>
Set <code>final alpha=0</code> for prescribed heat flow rate.
</li>
<li>
September 17, 2016, by Michael Wetter:<br/>
Corrected wrong annotation to avoid an error in the pedantic model check
in Dymola 2017 FD01 beta2.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/557\">issue 557</a>.
</li>
<li>
June 14, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Cooling;
