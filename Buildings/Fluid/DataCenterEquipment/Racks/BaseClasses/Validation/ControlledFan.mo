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
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    "Flow resistance"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=0.2,
    nPorts=2,
    T_start=T_start,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    prescribedHeatFlowRate=true)
    "Mixing volume representing rack air"
    annotation (Placement(transformation(extent={{50,0},{70,20}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senT(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=false,
    tau=0)
    "Outlet air temperature sensor"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=T_start,
    nPorts=2)
    "Pressure and temperature boundary"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-110,0})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Modelica.Blocks.Sources.Ramp ram(
    height=Q_flow_nominal,
    duration=1800,
    startTime=300)
    "Heat flow ramp from 0 to Q_flow_nominal"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

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

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = V_flow_nominal * rho_default
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal = 0.2 * 2
    "Nominal volumetric flow rate (0.2 m/s across 2 m2 face area)";

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") =
    PFan_nominal * fan.eta_nominal / V_flow_nominal
    "Fan pressure rise at nominal conditions";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = m_flow_nominal * cp_default * 10
    "Heat at full load giving a temperature rise of 10 K";
  Controls.OBC.CDL.Reals.Sources.Constant           TOutSet(final k=TAirOutSet)
    "Temperature set point"
    annotation (Placement(transformation(
      origin={0,90},
      extent={{-80,-80},{-60,-60}})));

equation
  connect(sou.ports[1], fan.port_a)
    annotation (Line(points={{-100,1},{-50,1},{-50,0},{-40,0}},
      color={0,127,255}));
  connect(fan.port_b, res.port_a)
    annotation (Line(points={{-20,0},{0,0}},   color={0,127,255}));
  connect(res.port_b, vol.ports[1])
    annotation (Line(points={{20,0},{59,0}},color={0,127,255}));
  connect(vol.ports[2], senT.port_a)
    annotation (Line(points={{61,0},{80,0}}, color={0,127,255}));
  connect(senT.port_b, sou.ports[2])
    annotation (Line(points={{100,0},{110,0},{110,-30},{-90,-30},{-90,0},{-100,
          0},{-100,-1}},
      color={0,127,255}));
  connect(senT.T, fan.TMea) annotation (Line(points={{90,11},{90,56},{-86,56},{
          -86,4},{-42,4}}, color={0,0,127}));
  connect(ram.y, preHea.Q_flow)
    annotation (Line(points={{1,40},{20,40}},  color={0,0,127}));
  connect(preHea.port, vol.heatPort)
    annotation (Line(points={{40,40},{50,40},{50,10}}, color={191,0,0}));

  connect(TOutSet.y, fan.TSet) annotation (Line(points={{-58,20},{-50,20},{-50,
          8},{-41,8}}, color={0,0,127}));
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
Air at <i>20&deg;</i>C is driven by the fan through a pressure drop element and a mixing volume.
The mixing volume receives a heat input that ramps from zero to
<code>Q_flow_nominal</code>, which corresponds to a temperature rise of <i>10</i> K
at the nominal mass flow rate,
corresponding to a face velocity of <i>0.2</i> m/s across a 2 m<sup>2</sup> surface.
</p>
<p>
When the heat input reaches its maximum value,
the fan runs at full speed (<code>y = 1</code>)
and consume <code>PFan_nominal</code> of electrical power.
Note that the leaving fluid temperature is slightly above its set point because
the heat of the fan is added to the air flow rate, and hence the
<i>20&deg;</i>C is not quite sufficient to provide the cooling required to meet the set point
temperature.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 15, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-140,-100},{140,100}})));
end ControlledFan;
