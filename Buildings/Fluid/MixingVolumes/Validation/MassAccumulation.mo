within Buildings.Fluid.MixingVolumes.Validation;
model MassAccumulation "Validation model for conservation equation"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}) "Air media";
  parameter Modelica.Units.SI.MassFraction X_w = 0.01 "Water mass fraction";
  parameter Real C = 1e-3 "Trace substance";
  parameter Modelica.Units.SI.MassFlowRate m_flow = 0.01
    "Mass flow rate";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow,
    V=1,
    simplify_mWat_flow=true,
    X_start={X_w,1 - X_w},
    T_start=293.15,
    C_start={C},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=1)
    "Fluid volume"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

    Buildings.Fluid.Sources.MassFlowSource_T sou(
      redeclare package Medium = Medium,
      m_flow=m_flow,
      X={X_w, 1-X_w},
      C={C},
      T=293.15,
     nPorts=1)
      "Inflow with the same composition as the volume"
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Units.SI.Mass mWat = vol.mXi[1] "Water mass in volume";
  Modelica.Units.SI.Mass mAir = vol.mXi[1]/vol.Xi[1] "Air mass in volume";
  Modelica.Units.SI.Mass mWatExp = vol.V*1.2*X_w + m_flow*X_w*time "Water that entered";
equation
  connect(sou.ports[1], vol.ports[1])
    annotation (Line(points={{-20,0},{30,0},{30,20}}, color={0,127,255}));
  annotation (experiment(
    StopTime=120,
    Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MassAccumulation.mos"
      "Simulate and plot"),
Documentation(info="<html>
<p>
Validation model that injects a constant mass flow rate of air into a control volume.
</p>
<p>
The model also computes the solution using a variable assignment to <code>mWatExp</code>
which can be compared to the actual water mass <code>mWat</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 9, 2026, by Michael Wetter:<br/>
First implementation, for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2186\">IBPSA, #2186</a>.
</li>
</ul>
</html>"));
end MassAccumulation;
