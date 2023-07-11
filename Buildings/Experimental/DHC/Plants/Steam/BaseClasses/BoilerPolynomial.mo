within Buildings.Experimental.DHC.Plants.Steam.BaseClasses;
model BoilerPolynomial
  "A equilibrium boiler with water phase change from liquid to vapor, discharging
  saturated steam vapor, with the efficiency curve described by a polynomial."
  extends Buildings.BaseClasses.BaseIconLow;
  extends Buildings.Experimental.DHC.BaseClasses.Steam.PartialTwoPortTwoMedium(
    redeclare final package Medium_a=MediumWat,
    redeclare final package Medium_b=MediumSte,
    final T_start=MediumSte.saturationTemperature(p_start));

  // Medium declarations
  replaceable package MediumWat =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - port_a (inlet)";
  replaceable package MediumSte = Buildings.Media.Steam
     "Steam medium - port_b (oulet)";
  // Initialization
  parameter Boolean fixed_p_start=false
    "Set to true if p_start is to be used as an explicit initial equation, 
    not an initial guess"
    annotation(Dialog(tab = "Initialization"));
  // Nominal conditions
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.Power Q_flow_nominal "Nominal heating power";
  parameter Modelica.Units.SI.Temperature T_nominal = 373.15
    "Temperature used to compute nominal efficiency 
    (only used if efficiency curve depends on temperature)";

  // Efficiency, fuel, and boiler properties
  parameter Buildings.Fluid.Types.EfficiencyCurves effCur=
    Buildings.Fluid.Types.EfficiencyCurves.Constant
    "Curve used to compute the efficiency";
  parameter Real a[:] = {0.9} "Coefficients for efficiency curve";
  parameter Buildings.Fluid.Data.Fuels.Generic fue "Fuel type"
   annotation (choicesAllMatching = true);
  parameter Modelica.Units.SI.ThermalConductance UA=0.05*Q_flow_nominal/30
    "Overall UA value";
  parameter Modelica.Units.SI.Volume V = 1.5E-6*Q_flow_nominal
    "Total internal volume of boiler"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.Units.SI.Mass mDry = 1.5E-3*Q_flow_nominal
    "Mass of boiler that will be lumped to water heat capacity"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));

  // Variables
  Modelica.Units.SI.Efficiency eta=
    if effCur == Buildings.Fluid.Types.EfficiencyCurves.Constant then
      a[1]
    elseif effCur == Buildings.Fluid.Types.EfficiencyCurves.Polynomial then
      Buildings.Utilities.Math.Functions.polynomial(a=a, x=y_internal)
    elseif effCur == Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
      Buildings.Utilities.Math.Functions.quadraticLinear(
        a=aQuaLin,
        x1=y_internal,
        x2=MediumSte.saturationTemperature(port_a.p))
    else 0
    "Boiler efficiency";
  Modelica.Units.SI.Power QFue_flow = y_internal * Q_flow_nominal/eta_nominal
    "Heat released by fuel";
  Modelica.Units.SI.Power QWat_flow = eta * QFue_flow
    "Heat transfer from gas into water";
  Modelica.Units.SI.MassFlowRate mFue_flow = QFue_flow/fue.h
    "Fuel mass flow rate";
  Modelica.Units.SI.VolumeFlowRate VFue_flow = mFue_flow/fue.d
    "Fuel volume flow rate";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) if not steadyDynamics
    "Part load ratio"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput VLiq(
    final quantity="Volume",
    final unit="m3",
    min=0) "Output liquid water volume"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if not steadyDynamics
    "Heat port, can be used to connect to ambient"
    annotation (Placement(transformation(extent={{-10,62}, {10,82}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapDry(
    C=500*mDry,
    T(start=T_start)) if not steadyDynamics
    "Heat capacity of boiler metal"
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
  Buildings.Experimental.DHC.Plants.Steam.BaseClasses.ControlVolumeEvaporation vol(
    redeclare final package MediumSte = MediumSte,
    redeclare final package MediumWat = MediumWat,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final V=V,
    final fixed_p_start=fixed_p_start)
    "Steam/water control volume"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumWat,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final dp_nominal=dp_nominal)
    "Flow resistance"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Modelica.Blocks.Interfaces.RealOutput QFueFlo(
    final quantity="HeatFlowRate",
    final unit="W",
    min=0) "Heat flow rate of the fuel"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));

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
  "Prescribed heat flow (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-49,-40},{-29,-20}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_in(y=QWat_flow)
    if not steadyDynamics
    "Heat transfer from gas into water (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAOve(G=UA) if not steadyDynamics
    "Overall thermal conductance (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-48,10},{-28,30}})));

  Modelica.Blocks.Sources.RealExpression QFue_flow_out(y=QFue_flow)
    "Heat flow rate of the fuel"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
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
  connect(vol.VLiq,VLiq)  annotation (Line(points={{21,7},{80,7},{80,60},{110,
          60}},
        color={0,0,127}));
  connect(QFue_flow_out.y, QFueFlo)
    annotation (Line(points={{81,90},{110,90}}, color={0,0,127}));
  annotation (
    defaultComponentName="boi",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
        smooth=Smooth.Bezier),
      Line(
        points={{-2,18},{-22,8},{-2,-12},{-22,-22}},
        color={0,0,0},
        smooth=Smooth.Bezier)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model represents a steam boiler that discharges saturated 
steam and has an efficiency curve defined by a polynomial.
The efficiency in this model represents the fuel-to-water 
efficiency (e.g., thermal efficiency).
This model is similar to the 
<a href=\"modelica://Buildings.Fluid.Boilers.BoilerPolynomial\"> 
Buildings.Fluid.Boilers.BoilerPolynomial</a> for the efficiency 
and fuel mass flow rate computation with the following exceptions:
</p>
<ul>
<li>
Water enters <code>port_a</code> in liquid state and exits 
<code>port_b</code> in vapor state.
</li> 
<li>
The liquid and vapor phases are at equilibrium; thus, the steam
boiler is constrained to saturated states only with the volume
containing a wet steam mixture. 
</li>
<li>
If the boiler is configured in steady state, several blocks involving
the heat flow rate are conditionally removed to avoid overconstraining
the model. This is because the discharging fluid is constrained at 
a saturated state. The blocks that are conditionally removed as a 
result are within the green region in the below figure:
</li>
</ul>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Plants/Steam/BaseClasses/BoilerPolynomial.png\" border=\"1\"
alt=\"Boiler polynomial steam with blocks in green conditionally removed if steady state\"/>
</p>
<h4>Implementation</h4>
<p>
In order to improve the numerical efficiency, this model follows 
the split-medium approach using the
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium\">
Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium</a> interface model.
The saturated mixing volume for an evaporation process 
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Steam.BaseClasses.ControlVolumeEvaporation\">
Buildings.Experimental.DHC.Plants.Steam.BaseClasses.ControlVolumeEvaporation</a> 
represents the phase change process of water from liquid 
to vapor at equilibrium.
</p>
<h4>Reference</h4>
<p>
Hinkelman, Kathryn, Saranya Anbarasu, Michael Wetter, 
Antoine Gautier, and Wangda Zuo. 2022. “A Fast and Accurate Modeling 
Approach for Water and Steam Thermodynamics with Practical 
Applications in District Heating System Simulation.” Preprint. February 24. 
<a href=\"http://dx.doi.org/10.13140/RG.2.2.20710.29762\">doi:10.13140/RG.2.2.20710.29762</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2022 by Kathryn Hinkelman:<br/>
Refactored base classes for improved extensibility and relocated models into Steam subpackages.
</li>
<li>
July 22, 2021 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerPolynomial;
