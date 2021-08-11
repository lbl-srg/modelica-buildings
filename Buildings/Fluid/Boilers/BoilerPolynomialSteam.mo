within Buildings.Fluid.Boilers;
model BoilerPolynomialSteam "Steam boiler"
  extends Buildings.Fluid.Interfaces.PartialWaterPhaseChange;
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare final package Medium_a=MediumWat,
    redeclare final package Medium_b=MediumSte);

  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Power Q_flow_nominal "Nominal heating power";
  parameter Modelica.SIunits.Temperature T_nominal = 353.15
    "Temperature used to compute nominal efficiency (only used if efficiency curve depends on temperature)";
  // Assumptions
  parameter Buildings.Fluid.Types.EfficiencyCurves effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant
    "Curve used to compute the efficiency";
  parameter Real a[:] = {0.9} "Coefficients for efficiency curve";

  parameter Buildings.Fluid.Data.Fuels.Generic fue "Fuel type"
   annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.ThermalConductance UA=0.05*Q_flow_nominal/30
    "Overall UA value";
  parameter Modelica.SIunits.Volume V = 1.5E-6*Q_flow_nominal
    "Total internal volume of boiler"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Mass mDry =   1.5E-3*Q_flow_nominal
    "Mass of boiler that will be lumped to water heat capacity"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));

  Modelica.SIunits.Efficiency eta=if effCur == Buildings.Fluid.Types.EfficiencyCurves.Constant
       then a[1] elseif effCur == Buildings.Fluid.Types.EfficiencyCurves.Polynomial
       then Buildings.Utilities.Math.Functions.polynomial(a=a, x=y_internal) elseif
      effCur == Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
      Buildings.Utilities.Math.Functions.quadraticLinear(
      a=aQuaLin,
      x1=y_internal,
      x2=MediumSte.saturationTemperature(port_a.p)) else 0 "Boiler efficiency";
  Modelica.SIunits.Power QFue_flow = y_internal * Q_flow_nominal/eta_nominal
    "Heat released by fuel";
  Modelica.SIunits.Power QWat_flow = eta * QFue_flow
    "Heat transfer from gas into water";
  Modelica.SIunits.MassFlowRate mFue_flow = QFue_flow/fue.h
    "Fuel mass flow rate";
  Modelica.SIunits.VolumeFlowRate VFue_flow = mFue_flow/fue.d
    "Fuel volume flow rate";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) if not steadyDynamics
    "Part load ratio"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealOutput VLiq(
    final quantity="Volume",
    final unit="m3",
    min=0) "Output liquid water volume"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if not steadyDynamics
    "Heat port, can be used to connect to ambient"
    annotation (Placement(transformation(extent={{-10,62}, {10,82}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapDry(
    C=500*mDry,
    T(start=T_start)) if not steadyDynamics
    "heat capacity of boiler metal"
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));

  Buildings.Fluid.MixingVolumes.MixingVolumeEvaporation vol(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    V=V)
    "Steam water mixing volume"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = MediumWat,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

protected
  final parameter Boolean steadyDynamics=
    if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then true
    else false
    "= true, if steady state formulation";
  parameter Real eta_nominal(fixed=false) "Boiler efficiency at nominal condition";
  parameter Real aQuaLin[6] = if size(a, 1) == 6 then a else fill(0, 6)
  "Auxiliary variable for efficiency curve because quadraticLinear requires exactly 6 elements";

  Modelica.Blocks.Interfaces.RealInput y_internal(min=0, max=1)
    "Internal block needed for conditional input part load ratio";

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo if not steadyDynamics
    annotation (Placement(transformation(extent={{-49,-40},{-29,-20}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_in(y=QWat_flow) if not steadyDynamics
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAOve(G=UA) if not steadyDynamics
    "Overall thermal conductance (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-48,10},{-28,30}})));

initial equation
  if  effCur == Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
    assert(size(a, 1) == 6,
    "The boiler has the efficiency curve set to 'Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear',
    and hence the parameter 'a' must have exactly 6 elements.
    However, only " + String(size(a, 1)) + " elements were provided.");
  end if;

  if effCur == Buildings.Fluid.Types.EfficiencyCurves.Constant then
    eta_nominal = a[1];
  elseif effCur == Buildings.Fluid.Types.EfficiencyCurves.Polynomial then
    eta_nominal = Buildings.Utilities.Math.Functions.polynomial(
      a=a, x=1);
  elseif effCur == Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
    // For this efficiency curve, a must have 6 elements.
    eta_nominal = Buildings.Utilities.Math.Functions.quadraticLinear(
      a=aQuaLin, x1=1, x2=T_nominal);
  else
     eta_nominal = 999;
  end if;

equation
  assert(eta > 0.001, "Efficiency curve is wrong.");

  connect(y,y_internal);

  if steadyDynamics then
    -QWat_flow = port_a.m_flow*actualStream(port_a.h_outflow) +
      port_b.m_flow*actualStream(port_b.h_outflow);
  end if;

  connect(UAOve.port_a, heatPort) annotation (Line(
      points={{-48,20},{-52,20},{-52,60},{0,60},{0,72}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Q_flow_in.y,preHeaFlo. Q_flow) annotation (Line(
      points={{-59,-30},{-49,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCapDry.port, UAOve.port_b) annotation (Line(points={{-70,12},{-70,6},
          {-20,6},{-20,20},{-28,20}}, color={191,0,0}));
  connect(preHeaFlo.port, UAOve.port_b) annotation (Line(points={{-29,-30},{-20,
          -30},{-20,20},{-28,20}}, color={191,0,0}));
  connect(vol.heatPort, UAOve.port_b) annotation (Line(points={{10,-10},{10,-20},
          {-20,-20},{-20,20},{-28,20}}, color={191,0,0}));
  connect(vol.port_b, port_b)
    annotation (Line(points={{20,0},{100,0}}, color={0,127,255}));
  connect(port_a, res.port_a)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
  connect(res.port_b, vol.port_a)
    annotation (Line(points={{-40,0},{0,0}}, color={0,127,255}));
  connect(vol.VLiq,VLiq)  annotation (Line(points={{21,7},{80,7},{80,80},{110,80}},
        color={0,0,127}));
  annotation (
    defaultComponentName="boi",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-149,-124},{151,-164}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,40},{40,-40}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Line(
        points={{20,18},{0,8},{20,-12},{0,-22}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{-2,18},{-22,8},{-2,-12},{-22,-22}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}})}), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
A simple two-port steam boiler model.
</p>
</html>"));
end BoilerPolynomialSteam;
