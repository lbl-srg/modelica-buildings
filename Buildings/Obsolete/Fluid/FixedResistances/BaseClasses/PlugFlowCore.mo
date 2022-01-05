within Buildings.Obsolete.Fluid.FixedResistances.BaseClasses;
model PlugFlowCore
  "Pipe model using spatialDistribution for temperature delay with modified delay tracker"
  extends Buildings.Obsolete.BaseClasses.ObsoleteModel;
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.Units.SI.Length dh
    "Hydraulic diameter (assuming a round cross section area)";

  parameter Modelica.Units.SI.Velocity v_nominal
    "Velocity at m_flow_nominal (used to compute default value for hydraulic diameter dh)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Length length(min=0) "Pipe length";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Geometry"));

  parameter Real R(unit="(m.K)/W")
    "Thermal resistance per unit length from fluid to boundary temperature";

  parameter Real C(unit="J/(K.m)")
    "Thermal capacity per unit length of pipe";

  parameter Real fac=1
    "Factor to take into account flow resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal";

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.Units.SI.Length thickness(min=0) "Pipe wall thickness";

  parameter Modelica.Units.SI.Temperature T_start_in=Medium.T_default
    "Initialization temperature at pipe inlet"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start_out=Medium.T_default
    "Initialization temperature at pipe outlet"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean initDelay=false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_start=0
    annotation (Dialog(tab="Initialization", enable=initDelay));

  parameter Real ReC=4000
    "Reynolds number where transition to turbulence starts";

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Buildings.Fluid.FixedResistances.HydraulicDiameter res(
    redeclare final package Medium = Medium,
    final dh=dh,
    final m_flow_nominal=m_flow_nominal,
    final from_dp=from_dp,
    final length=length,
    final roughness=roughness,
    final fac=fac,
    final ReC=ReC,
    final v_nominal=v_nominal,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearized,
    dp(nominal=fac*200*length))
                 "Pressure drop calculation for this pipe"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Fluid.FixedResistances.BaseClasses.PlugFlow del(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final dh=dh,
    final length=length,
    final allowFlowReversal=allowFlowReversal,
    final T_start_in=T_start_in,
    final T_start_out=T_start_out)
    "Model for temperature wave propagation"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowHeatLoss heaLos_a(
    redeclare final package Medium = Medium,
    final C=C,
    final R=R,
    final m_flow_small=m_flow_small,
    final T_start=T_start_in,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_start=m_flow_start,
    final show_T=false,
    final show_V_flow=false) "Heat loss for flow from port_b to port_a"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));

  Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowHeatLoss heaLos_b(
    redeclare final package Medium = Medium,
    final C=C,
    final R=R,
    final m_flow_small=m_flow_small,
    final T_start=T_start_out,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_start=m_flow_start,
    final show_T=false,
    final show_V_flow=false) "Heat loss for flow from port_a to port_b"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium) "Mass flow sensor"
    annotation (Placement(transformation(extent={{-50,10},{-30,-10}})));
  Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowTransportDelay timDel(
    final length=length,
    final dh=dh,
    final rho=rho_default,
    final initDelay=initDelay,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_start=m_flow_start) "Time delay"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port to connect environment (positive heat flow for heat loss to surroundings)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

protected
  parameter Modelica.Units.SI.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced"));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(senMasFlo.m_flow, timDel.m_flow) annotation (Line(
      points={{-40,-11},{-40,-40},{-12,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos_a.heatPort, heatPort) annotation (Line(points={{-70,10},{-70,40},
          {0,40},{0,100}}, color={191,0,0}));
  connect(heaLos_b.heatPort, heatPort) annotation (Line(points={{70,10},{70,40},
          {0,40},{0,100}}, color={191,0,0}));

  connect(timDel.tauRev, heaLos_a.tau) annotation (Line(points={{11,-36},{50,-36},
          {50,28},{-64,28},{-64,10}}, color={0,0,127}));
  connect(timDel.tau, heaLos_b.tau) annotation (Line(points={{11,-44},{54,-44},
          {54,28},{64,28},{64,10}}, color={0,0,127}));

  connect(port_a, heaLos_a.port_b)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(heaLos_a.port_a, senMasFlo.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(heaLos_b.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(del.port_a, res.port_b)
    annotation (Line(points={{20,0},{0,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, res.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(heaLos_b.port_a, del.port_b)
    annotation (Line(points={{60,0},{40,0}}, color={0,127,255}));
  annotation (
    Line(points={{70,20},{72,20},{72,0},{100,0}}, color={0,127,255}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,50},{100,40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-40},{100,-50}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{0,100},{40,62},{20,62},{20,38},{-20,38},{-20,62},{-40,62},{0,
              100}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,30},{28,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187})}),
    obsolete = "Obsolete model - use Buildings.Fluid.FixedResistances.PlugFlowPipe instead",
    Documentation(revisions="<html>
<ul>
<li>
July 12, 2021, by Baptiste Ravache:<br/>
This class is obsolete and replaced by
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Fluid.FixedResistances.PlugFlowPipe</a>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1494\">IBPSA, #1494</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
October 20, 2017, by Michael Wetter:<br/>
Replaced model that lumps flow resistance and transport delays
with two separate models, as these are physically distinct processes.
This also avoids one more layer of models.
<br/>
Revised variable names and documentation to follow guidelines.
</li>
<li>
July 4, 2016 by Bram van der Heijde:<br/>
Introduce <code>pipVol</code>.
</li>
<li>
October 10, 2015 by Marcus Fuchs:<br/>
Copy Icon from KUL implementation and rename model.
Replace resistance and temperature delay by an adiabatic pipe.
</li>
<li>
September, 2015 by Marcus Fuchs:<br/>First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Pipe with heat loss using the time delay based heat losses and plug flow
for the transport delay of the fluid.
</p>
<h4>Implementation</h4>
<p>
The
<code>spatialDistribution</code> operator is used for the temperature wave propagation
through the length of the pipe. This operator is contained in
<a href=\"modelica://Buildings.Fluid.FixedResistances.BaseClasses.PlugFlow\">BaseClasses.PlugFlow</a>.
</p>
<p>
This model does not include thermal inertia of the pipe wall.
The wall inertia is implemented in
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">PlugFlowPipe</a>, which uses this model.
<br/>
The removal of the thermal inertia with a mixing volume can be desirable in the
case where mixing volumes are added manually at the pipe junctions.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowHeatLoss\">
PlugFlowHeatLoss</a>
implements a heat loss in design direction, but leaves the enthalpy unchanged
in opposite flow direction. Therefore it is used in front of and behind the time delay.
</p>
<h4>References</h4>
<p>
Full details on the model implementation and experimental validation can be found
in:
</p>
<p>
van der Heijde, B., Fuchs, M., Ribas Tugores, C., Schweiger, G., Sartor, K., Basciotti, D., M&uuml;ller,
D., Nytsch-Geusen, C., Wetter, M. and Helsen, L. (2017).<br/>
Dynamic equation-based thermo-hydraulic pipe model for district heating and cooling systems.<br/>
<i>Energy Conversion and Management</i>, vol. 151, p. 158-169.
<a href=\"https://doi.org/10.1016/j.enconman.2017.08.072\">doi: 10.1016/j.enconman.2017.08.072</a>.</p>
</html>"));
end PlugFlowCore;
