within Buildings.Fluid.Chillers;
model Carnot
  "Chiller with performance curve adjusted based on Carnot efficiency"
 extends Interfaces.FourPortHeatMassExchanger(vol1(
      prescribedHeatFlowRate = true),
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      prescribedHeatFlowRate = true));

  parameter Buildings.Fluid.Types.EfficiencyInput effInpEva=
    Buildings.Fluid.Types.EfficiencyInput.volume
    "Temperatures of evaporator fluid used to compute Carnot efficiency"
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));
  parameter Buildings.Fluid.Types.EfficiencyInput effInpCon=
    Buildings.Fluid.Types.EfficiencyInput.port_a
    "Temperatures of condenser fluid used to compute Carnot efficiency"
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));
  parameter Modelica.SIunits.Power P_nominal
    "Nominal compressor power (at y=1)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal = 10
    "Temperature difference evaporator inlet-outlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal = 10
    "Temperature difference condenser outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  // Efficiency
  parameter Boolean use_eta_Carnot = true
    "Set to true to use Carnot efficiency"
    annotation(Dialog(group="Efficiency"));
  parameter Real etaCar(fixed=use_eta_Carnot)
    "Carnot effectiveness (=COP/COP_Carnot)"
    annotation (Dialog(group="Efficiency", enable=use_eta_Carnot));
  parameter Real COP_nominal(fixed=not use_eta_Carnot)
    "Coefficient of performance"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));
  parameter Modelica.SIunits.Temperature TCon_nominal = 303.15
    "Condenser temperature"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));
  parameter Modelica.SIunits.Temperature TEva_nominal = 278.15
    "Evaporator temperature"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));

  parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, y=1)=1)"
    annotation (Dialog(group="Efficiency"));

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Real etaPL "Efficiency due to part load of compressor (etaPL(y=1)=1";
  Real COP(min=0) "Coefficient of performance";
  Real COPCar(min=0) "Carnot efficiency";
  Modelica.SIunits.HeatFlowRate QCon_flow "Condenser heat input";
  Modelica.SIunits.HeatFlowRate QEva_flow "Evaporator heat input";
  Modelica.Blocks.Interfaces.RealOutput P(final quantity="Power", unit="W")
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Medium1.Temperature TCon "Condenser temperature used to compute efficiency";
  Medium2.Temperature TEva "Evaporator temperature used to compute efficiency";
protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,-50},{-19,-30}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,30},{-19,50}})));
  Modelica.Blocks.Sources.RealExpression QEva_flow_in(y=QEva_flow)
    "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression QCon_flow_in(y=QCon_flow)
    "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Medium1.ThermodynamicState staA1 "Medium properties in port_a1";
  Medium1.ThermodynamicState staB1 "Medium properties in port_b1";
  Medium2.ThermodynamicState staA2 "Medium properties in port_a2";
  Medium2.ThermodynamicState staB2 "Medium properties in port_b2";

initial equation
  assert(dTEva_nominal>0, "Parameter dTEva_nominal must be positive.");
  assert(dTCon_nominal>0, "Parameter dTCon_nominal must be positive.");
  if use_eta_Carnot then
    COP_nominal = etaCar * TEva_nominal/(TCon_nominal-TEva_nominal);
  else
    etaCar = COP_nominal / (TEva_nominal/(TCon_nominal-TEva_nominal));
  end if;
  assert(abs(Buildings.Utilities.Math.Functions.polynomial(
         a=a, x=y)-1) < 0.01, "Efficiency curve is wrong. Need etaPL(y=1)=1.");
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
    TCon = vol1.heatPort.T;
  elseif effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TCon = Medium1.temperature(staA1);
  elseif effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_b then
    TCon = Medium1.temperature(staB1);
  else
    TCon = 0.5 * (Medium1.temperature(staA1)+Medium1.temperature(staB1));
  end if;

  if effInpEva == Buildings.Fluid.Types.EfficiencyInput.volume then
    TEva = vol2.heatPort.T;
  elseif effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TEva = Medium2.temperature(staA2);
  elseif effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_b then
    TEva = Medium2.temperature(staB2);
  else
    TEva = 0.5 * (Medium2.temperature(staA2)+Medium2.temperature(staB2));
  end if;

  etaPL  = Buildings.Utilities.Math.Functions.polynomial(a=a, x=y);
  P = y * P_nominal;
  COPCar = TEva / Buildings.Utilities.Math.Functions.smoothMax(x1=1, x2=TCon-TEva, deltaX=0.25);
  COP = etaCar * COPCar * etaPL;
  -QEva_flow = COP * P;
  QCon_flow = P - QEva_flow;

  connect(QCon_flow_in.y, preHeaFloCon.Q_flow) annotation (Line(
      points={{-59,40},{-39,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFloCon.port, vol1.heatPort) annotation (Line(
      points={{-19,40},{-10,40},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QEva_flow_in.y, preHeaFloEva.Q_flow) annotation (Line(
      points={{-59,-40},{-39,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFloEva.port, vol2.heatPort) annotation (Line(
      points={{-19,-40},{12,-40},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
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
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-144,146},{-88,104}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Text(extent={{64,96},{114,82}},   textString="P",
          lineColor={0,0,127})}),
defaultComponentName="chi",
Documentation(info="<html>
<p>
This is model of a chiller whose coefficient of performance (COP) changes
with temperatures in the same way as the Carnot efficiency changes.
The COP at the nominal conditions can be specified by a parameter, or
it can be computed by the model based on the Carnot effectiveness, in which
case
</p>
<p align=\"center\" style=\"font-style:italic;\">
  COP<sub>0</sub> = &eta;<sub>car</sub> COP<sub>car</sub>
= &eta;<sub>car</sub> T<sub>eva</sub> &frasl; (T<sub>con</sub>-T<sub>eva</sub>),
</p>
<p>
where <i>T<sub>eva</sub></i> is the evaporator temperature
and <i>T<sub>con</sub></i> is the condenser temperature.
On the <code>Advanced</code> tab, a user can specify the temperature that
will be used as the evaporator (or condenser) temperature. The options
are the temperature of the fluid volume, of <code>port_a</code>, of
<code>port_b</code>, or the average temperature of <code>port_a</code> and
<code>port_b</code>.
</p>
<p>
The chiller COP is computed as the product
</p>
<p align=\"center\" style=\"font-style:italic;\">
  COP = &eta;<sub>car</sub> COP<sub>car</sub> &eta;<sub>PL</sub>,
</p>
<p>
where <i>&eta;<sub>car</sub></i> is the Carnot effectiveness,
<i>COP<sub>car</sub></i> is the Carnot efficiency and
<i>&eta;<sub>PL</sub></i> is a polynomial in the control signal <i>y</i>
that can be used to take into account a change in <i>COP</i> at part load
conditions.
</p>
<p>
On the <code>Dynamics</code> tag, the model can be parametrized to compute a transient
or steady-state response.
The transient response of the model is computed using a first
order differential equation for the evaporator and condenser fluid volumes.
The chiller outlet temperatures are equal to the temperatures of these lumped volumes.
</p>
</html>",
revisions="<html>
<ul>
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
</html>"));
end Carnot;
