within Buildings.Fluid.Boilers.BaseClasses;
model Combustion "Empirical model for combustion process"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(allowFlowReversal=false);

  parameter Buildings.Fluid.Types.EfficiencyCurves fluGasTCurve=Buildings.Fluid.Types.EfficiencyCurves.Polynomial
    "Curve used to compute the leaving flue gas temperature (K) as a function of part load ratio, y";
  parameter Real a[:] = {452.5,17,43} "Coefficients for leaving temperature curve";

  parameter Modelica.SIunits.Temperature TIn_nominal = Medium.T_default
    "Nominal inlet temperature";

  Modelica.SIunits.Temperature TFluGas=
    if fluGasTCurve ==Buildings.Fluid.Types.EfficiencyCurves.Constant then
      a[1]
    elseif fluGasTCurve ==Buildings.Fluid.Types.EfficiencyCurves.Polynomial then
      Buildings.Utilities.Math.Functions.polynomial(a=a, x=y)
   elseif fluGasTCurve ==Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
      Buildings.Utilities.Math.Functions.quadraticLinear(a=aQuaLin, x1=y, x2=TIn)
   else
      0
  "Flue gas leaving temperature";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

protected
  parameter Real TFluGas_nominal(fixed=false) "Leaving flue gas temperature at nominal condition";
  parameter Real aQuaLin[6] = if size(a, 1) == 6 then a else fill(0, 6)
  "Auxiliary variable for efficiency curve because quadraticLinear requires exactly 6 elements";

  Modelica.SIunits.Temperature TIn "Incoming fluid temperature";
  Modelica.SIunits.SpecificEnthalpy hIn "Incoming fluid specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy hFluGas "Flue gas specific enthalpy";

initial equation

  if  fluGasTCurve == Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
    assert(size(a, 1) == 6,
    "The combustion model has the leaving flue gas temperature curve set to 
    'Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear', and hence the 
    parameter 'a' must have exactly 6 elements.
    However, only " + String(size(a, 1)) + " elements were provided.");
  end if;

  if fluGasTCurve ==Buildings.Fluid.Types.EfficiencyCurves.Constant then
    TFluGas_nominal = a[1];
  elseif fluGasTCurve ==Buildings.Fluid.Types.EfficiencyCurves.Polynomial then
    TFluGas_nominal = Buildings.Utilities.Math.Functions.polynomial(a=a, x=1);
  elseif fluGasTCurve ==Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
    // For this efficiency curve, a must have 6 elements.
    TFluGas_nominal = Buildings.Utilities.Math.Functions.quadraticLinear(a=aQuaLin, x1=1, x2=TIn_nominal);
  else
     TFluGas_nominal = 0;
  end if;

equation

  assert(TFluGas > 0, "Temperature curve is wrong.");

  // Pressure
  port_b.p = port_a.p;

  // Transport of substances
  port_a.Xi_outflow = Medium.X_default[1:Medium.nXi];
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  // Conservaton of mass
  port_a.m_flow + port_b.m_flow = 0;

  // Temperature
  TIn= Medium.temperature(
    state=Medium.setState_phX(
      p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow)));

  // Enthalpy
  hFluGas = Medium.specificEnthalpy(Medium.setState_pTX(
      p=port_b.p, T=TFluGas, X=port_b.Xi_outflow));
  port_b.h_outflow = hFluGas;
  inStream(port_a.h_outflow) = hIn;
  port_a.h_outflow = Medium.h_default;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,4},{100,-4}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,4},{100,-4}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-60},{80,60}},
          lineColor={244,125,35},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-147,-114},{153,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-30,-30},{30,30}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Sphere)}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Combustion;
