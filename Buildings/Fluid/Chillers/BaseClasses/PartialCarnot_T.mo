within Buildings.Fluid.Chillers.BaseClasses;
partial model PartialCarnot_T
  "Partial model for chiller with performance curve adjusted based on Carnot efficiency"
 extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
   m1_flow_nominal = QCon_flow_nominal/cp1_default/dTCon_nominal,
   m2_flow_nominal = QEva_flow_nominal/cp2_default/dTEva_nominal);

  parameter Buildings.Fluid.Types.EfficiencyInput effInpEva
    "Temperatures of evaporator fluid used to compute Carnot efficiency"
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));
  parameter Buildings.Fluid.Types.EfficiencyInput effInpCon
    "Temperatures of condenser fluid used to compute Carnot efficiency"
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));
  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)
    "Nominal cooling heat flow rate (QEva_flow_nominal < 0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal(min=0)
    "Nominal heating flow rate";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal(max=0) = -10
    "Temperature difference evaporator outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal(min=0) = 10
    "Temperature difference condenser outlet-inlet"
    annotation (Dialog(group="Nominal condition"));

  // Efficiency
  parameter Boolean use_eta_Carnot = true
    "Set to true to use Carnot efficiency"
    annotation(Dialog(group="Efficiency"));
  parameter Real etaCar(unit="1", fixed=use_eta_Carnot)
    "Carnot effectiveness (=COP/COP_Carnot)"
    annotation (Dialog(group="Efficiency", enable=use_eta_Carnot));
  parameter Real COPc_nominal(unit="1") "Coefficient of performance"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));
  parameter Modelica.SIunits.Temperature TCon_nominal "Condenser temperature"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));
  parameter Modelica.SIunits.Temperature TEva_nominal "Evaporator temperature"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));

  parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, yPL=1)=1)"
    annotation (Dialog(group="Efficiency"));

  parameter Modelica.SIunits.Pressure dp1_nominal
    "Pressure difference over condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp2_nominal
    "Pressure difference over evaporator"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean homotopyInitialization=true "= true, use homotopy method"
    annotation (Dialog(tab="Advanced"));

  parameter Boolean from_dp1=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean from_dp2=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Boolean linearizeFlowResistance1=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean linearizeFlowResistance2=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Real deltaM1(final unit="1")=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Real deltaM2(final unit="1")=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Modelica.SIunits.Time tau1=60
    "Time constant at nominal flow rate (used if energyDynamics1 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.SIunits.Time tau2=60
    "Time constant at nominal flow rate (used if energyDynamics2 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Modelica.SIunits.Temperature T1_start=Medium1.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.SIunits.Temperature T2_start=Medium2.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics1=Modelica.Fluid.Types.Dynamics.SteadyState
    "Formulation of energy balance"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics2=Modelica.Fluid.Types.Dynamics.SteadyState
    "Formulation of energy balance"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  input Real yPL(final unit="1") "Part load ratio";
  Real etaPL(final unit = "1") =
    Buildings.Utilities.Math.Functions.polynomial(
      a=a,
      x=yPL)
    "Efficiency due to part load of compressor (etaPL(yPL=1)=1)";
  Real COPc(min=0) = etaCar * COPcCar * etaPL "Coefficient of performance";
  Real COPcCar(min=0)=
    TEva /
    Buildings.Utilities.Math.Functions.smoothMax(
      x1=1,
      x2=TCon-TEva,
      deltaX=0.25)
    "Carnot efficiency";

protected
  final parameter Modelica.SIunits.SpecificHeatCapacity cp1_default=
    Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
      p = Medium1.p_default,
      T = Medium1.T_default,
      X = Medium1.X_default))
    "Specific heat capacity of medium 1 at default medium state";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp2_default=
    Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
      p = Medium2.p_default,
      T = Medium2.T_default,
      X = Medium2.X_default))
    "Specific heat capacity of medium 2 at default medium state";

  Medium1.ThermodynamicState staA1 "Medium properties in port_a1";
  Medium1.ThermodynamicState staB1 "Medium properties in port_b1";
  Medium2.ThermodynamicState staA2 "Medium properties in port_a2";
  Medium2.ThermodynamicState staB2 "Medium properties in port_b2";

  Medium1.Temperature TCon "Condenser temperature used to compute efficiency";
  Medium2.Temperature TEva "Evaporator temperature used to compute efficiency";

  Modelica.Blocks.Sources.RealExpression PEle "Electrical power consumption"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

    replaceable Interfaces.PartialTwoPortInterface con
      constrainedby Interfaces.PartialTwoPortInterface(
        redeclare final package Medium = Medium1,
        final allowFlowReversal=allowFlowReversal1,
        final m_flow_nominal=m1_flow_nominal,
        final m_flow_small=m1_flow_small,
        final show_T=false) "Condenser"
      annotation (Placement(transformation(extent={{-10,50},{10,70}})));

    replaceable Interfaces.PartialTwoPortInterface eva
      constrainedby Interfaces.PartialTwoPortInterface(
        redeclare final package Medium = Medium2,
        final allowFlowReversal=allowFlowReversal2,
        final m_flow_nominal=m2_flow_nominal,
        final m_flow_small=m2_flow_small,
        final show_T=false) "Evaporator"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));

initial equation
  assert(dTEva_nominal < 0, "Parameter dTEva_nominal must be negative.");
  assert(dTCon_nominal > 0, "Parameter dTCon_nominal must be positive.");

  assert(abs(Buildings.Utilities.Math.Functions.polynomial(
         a=a, x=1)-1) < 0.01, "Efficiency curve is wrong. Need etaPL(y=1)=1.");
  assert(etaCar > 0.1, "Parameters lead to etaCar < 0.1. Check parameters.");
  assert(etaCar < 1,   "Parameters lead to etaCar > 1. Check parameters.");

equation
  if allowFlowReversal1 then
    if homotopyInitialization then
      staA1=Medium1.setState_phX(port_a1.p,
                          homotopy(actual=actualStream(port_a1.h_outflow),
                                   simplified=inStream(port_a1.h_outflow)),
                          homotopy(actual=actualStream(port_a1.Xi_outflow),
                                   simplified=inStream(port_a1.Xi_outflow)));
      staB1=Medium1.setState_phX(port_b1.p,
                          homotopy(actual=actualStream(port_b1.h_outflow),
                                   simplified=port_b1.h_outflow),
                          homotopy(actual=actualStream(port_b1.Xi_outflow),
                            simplified=port_b1.Xi_outflow));

    else
      staA1=Medium1.setState_phX(port_a1.p,
                          actualStream(port_a1.h_outflow),
                          actualStream(port_a1.Xi_outflow));
      staB1=Medium1.setState_phX(port_b1.p,
                          actualStream(port_b1.h_outflow),
                          actualStream(port_b1.Xi_outflow));
    end if; // homotopyInitialization
  else // reverse flow not allowed
    staA1=Medium1.setState_phX(port_a1.p,
                             inStream(port_a1.h_outflow),
                             inStream(port_a1.Xi_outflow));
    staB1=Medium1.setState_phX(port_b1.p,
                             inStream(port_b1.h_outflow),
                             inStream(port_b1.Xi_outflow));
  end if;
  if allowFlowReversal2 then
    if homotopyInitialization then
      staA2=Medium2.setState_phX(port_a2.p,
                          homotopy(actual=actualStream(port_a2.h_outflow),
                                   simplified=inStream(port_a2.h_outflow)),
                          homotopy(actual=actualStream(port_a2.Xi_outflow),
                                   simplified=inStream(port_a2.Xi_outflow)));
      staB2=Medium2.setState_phX(port_b2.p,
                          homotopy(actual=actualStream(port_b2.h_outflow),
                                   simplified=port_b2.h_outflow),
                          homotopy(actual=actualStream(port_b2.Xi_outflow),
                            simplified=port_b2.Xi_outflow));

    else
      staA2=Medium2.setState_phX(port_a2.p,
                          actualStream(port_a2.h_outflow),
                          actualStream(port_a2.Xi_outflow));
      staB2=Medium2.setState_phX(port_b2.p,
                          actualStream(port_b2.h_outflow),
                          actualStream(port_b2.Xi_outflow));
    end if; // homotopyInitialization
  else // reverse flow not allowed
    staA2=Medium2.setState_phX(port_a2.p,
                             inStream(port_a2.h_outflow),
                             inStream(port_a2.Xi_outflow));
    staB2=Medium2.setState_phX(port_b2.p,
                             inStream(port_b2.h_outflow),
                             inStream(port_b2.Xi_outflow));
  end if;

  // Set temperatures that will be used to compute Carnot efficiency
  if effInpCon == Buildings.Fluid.Types.EfficiencyInput.volume then
    TCon = Medium1.temperature( Medium1.setState_phX(
      p=  con.port_b.p,
      h=  con.port_b.h_outflow,
      X=  cat(1, con.port_b.Xi_outflow, {1-sum({con.port_b.Xi_outflow})})));
  elseif effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TCon = Medium1.temperature(staA1);
  elseif effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_b then
    TCon = Medium1.temperature(staB1);
  else
    TCon = 0.5 * (Medium1.temperature(staA1)+Medium1.temperature(staB1));
  end if;

  if effInpEva == Buildings.Fluid.Types.EfficiencyInput.volume then
    TEva = Medium2.temperature( Medium2.setState_phX(
      p=  eva.port_b.p,
      h=  eva.port_b.h_outflow,
      X=  cat(1, eva.port_b.Xi_outflow, {1-sum({eva.port_b.Xi_outflow})})));
  elseif effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TEva = Medium2.temperature(staA2);
  elseif effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_b then
    TEva = Medium2.temperature(staB2);
  else
    TEva = 0.5 * (Medium2.temperature(staA2)+Medium2.temperature(staB2));
  end if;

  connect(PEle.y, P) annotation (Line(points={{81,0},{92,0},{110,0}},
        color={0,0,127}));
  connect(port_a2, eva.port_a)
    annotation (Line(points={{100,-60},{56,-60},{10,-60}}, color={0,127,255}));
  connect(eva.port_b, port_b2) annotation (Line(points={{-10,-60},{-100,-60}},
                 color={0,127,255}));
  connect(port_a1, con.port_a)
    annotation (Line(points={{-100,60},{-56,60},{-10,60}}, color={0,127,255}));
  connect(con.port_b, port_b1)
    annotation (Line(points={{10,60},{56,60},{100,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-72,80},{68,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18-QEva_flow/COPc,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(extent={{80,46},{130,32}},   textString="P",
          lineColor={0,0,127}),
        Line(points={{62,0},{100,0}},                 color={0,0,255}),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="chi",
Documentation(info="<html>
<p>
This is a partial model of a chiller whose coefficient of performance (COP) changes
with temperatures in the same way as the Carnot efficiency changes.
</p>
<h4>Implementation</h4>
<p>
This model uses the Carnot efficiency for cooling <code>COPc</code>.
This allows Carnot chillers and heat pumps to use this base class
and accordingly assign <code>COPc</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 3, 2015 by Michael Wetter:<br/>
Expanded documentation.
</li>
<li>
May 6, 2015 by Michael Wetter:<br/>
Added <code>prescribedHeatFlowRate=true</code> for <code>vol2</code>.
</li>
<li>
October 9, 2013 by Michael Wetter:<br/>
Reimplemented the computation of the port states to avoid using
the conditionally removed variables <code>sta_a1</code>,
<code>sta_a2</code>, <code>sta_b1</code> and <code>sta_b2</code>.
</li>
<li>
May 10, 2013 by Michael Wetter:<br/>
Added electric power <code>P</code> as an output signal.
</li>
<li>
October 11, 2010 by Michael Wetter:<br/>
Fixed bug in energy balance.
</li>
<li>
March 3, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end PartialCarnot_T;
