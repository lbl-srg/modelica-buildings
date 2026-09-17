within Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.Validation;
model ControlledFan "Validation of the controlled fan model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Air medium";

  parameter Modelica.Units.SI.Power PFan_nominal = 400
    "Fan nominal power";

  parameter Modelica.Units.SI.Temperature T_start = 293.15
    "Inlet air temperature (20 degC)";

  parameter Modelica.Units.SI.Temperature TAirOutSet = T_start + 10
    "Controller set point, inlet temperature plus 10 K";

  Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.ControlledFan fan(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    PFan_nominal=PFan_nominal,
    TAirOutSet=TAirOutSet)
    "Controlled fan"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    "Flow resistance"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=0.2,
    nPorts=2,
    T_start=T_start,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    prescribedHeatFlowRate=true)
    "Mixing volume representing rack air"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senT(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=false,
    tau=0)
    "Outlet air temperature sensor"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=T_start,
    nPorts=2)
    "Pressure and temperature boundary"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,0})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Modelica.Blocks.Sources.Ramp ram(
    height=Q_flow_nominal,
    duration=1800,
    startTime=300)
    "Heat flow ramp from 0 to Q_flow_nominal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

protected
  parameter Modelica.Units.SI.Density rho_default = Medium.density(
    Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Default air density";

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default =
    Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
        p=Medium.p_default,
        T=Medium.T_default,
        X=Medium.X_default))
    "Specific heat capacity at default conditions";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 2 * rho_default
    "Nominal mass flow rate (1 m/s across 2 m2 face area)";

  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal = 2
    "Nominal volumetric flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") =
    PFan_nominal * fan.eta_nominal / V_flow_nominal
    "Fan pressure rise at nominal conditions";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = m_flow_nominal * cp_default * 10
    "Heat at full load giving a temperature rise of 10 K";

equation
  connect(sou.ports[1], fan.port_a)
    annotation (Line(points={{-80,2},{-70,2},{-70,0},{-60,0}},
      color={0,127,255}));
  connect(fan.port_b, res.port_a)
    annotation (Line(points={{-40,0},{-20,0}}, color={0,127,255}));
  connect(res.port_b, vol.ports[1])
    annotation (Line(points={{0,0},{40,0}}, color={0,127,255}));
  connect(vol.ports[2], senT.port_a)
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(senT.port_b, sou.ports[2])
    annotation (Line(points={{80,0},{90,0},{90,-30},{-80,-30},{-80,-2}},
      color={0,127,255}));
  connect(senT.T, fan.TAirOut)
    annotation (Line(points={{70,11},{70,60},{-72,60},{-72,6},{-61,6}},
      color={0,0,127}));
  connect(ram.y, preHea.Q_flow)
    annotation (Line(points={{-19,40},{0,40}}, color={0,0,127}));
  connect(preHea.port, vol.heatPort)
    annotation (Line(points={{20,40},{30,40},{30,10}}, color={191,0,0}));

  annotation (
    experiment(
      StopTime=2400,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/BaseClasses/Validation/ControlledFan.mos"
          "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation model for
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.ControlledFan\">
Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.ControlledFan</a>.
</p>
<p>
Air at 20&deg;C is driven by the fan through a pressure drop element and a mixing volume.
The mixing volume receives a heat input that ramps from zero to
<code>Q_flow_nominal</code>, which corresponds to a temperature rise of 10 K
at the nominal mass flow rate
<code>m_flow_nominal = 2 * rho_default</code>,
corresponding to a face velocity of 1 m/s across a 2 m<sup>2</sup> surface.
</p>
<p>
When the heat input reaches its maximum value,
the fan should run at full speed (<code>y = 1</code>)
and consume <code>PFan_nominal</code> of electrical power.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 15, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlledFan;
