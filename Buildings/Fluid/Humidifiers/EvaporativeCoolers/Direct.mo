within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model Direct
  "Direct Evaporative cooler"

  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal air mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Pressure drop at nominal mass flow rate";

  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";

  parameter Modelica.Units.SI.Length dep
    "Depth of the rigid media evaporative pad";

  parameter Real effCoe[11]={0.792714, 0.958569, -0.25193, -1.03215, 0.0262659,
                             0.914869, -1.48241, -0.018992, 1.13137, 0.0327622,
                             -0.145384}
    "Coefficients for evaporative medium efficiency calculation";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow rate (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dmWat_flow(
    final unit="kg/s",
    displayUnit="kg/s",
    final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet"
    annotation (Placement(transformation(origin={120,80}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={90,40}, extent={{-20,-20},{20,20}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final T_start=298.15)
    "Dry bulb temperature sensor"
    annotation (Placement(transformation(origin={-70,0}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senTemWetBul(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final TWetBul_start=296.15)
    "Wet bulb temperature sensor"
    annotation (Placement(transformation(origin={-40,0}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare final package Medium =  Medium,
    final m_flow_nominal=m_flow_nominal)
    "Volume flow rate sensor"
    annotation (Placement(transformation(origin={-10,0}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = Medium,
    final dp_nominal=dp_nominal,
    final m_flow_nominal = m_flow_nominal)
    "Pressure drop"
    annotation (Placement(transformation(origin={30,0}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    redeclare final package Medium = Medium,
    final m_flow_nominal = m_flow_nominal,
    final V=m_flow_nominal*tau/rho_default,
    final nPorts = 2)
    "Moist air mixing volume"
    annotation (Placement(transformation(origin={80,20}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations dirEvaCoo(
    redeclare final package Medium = Medium,
    final dep=dep,
    final padAre=padAre,
    final effCoe=effCoe)
    "Direct evaporative cooling calculator"
    annotation (Placement(transformation(origin={30,60}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.Pressure senPre(
    redeclare final package Medium = Medium)
    "Pressure"
    annotation (Placement(transformation(origin={-90,54}, extent={{-10,-10},{10,10}})));

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default, p=Medium.p_default, X=Medium.X_default)
    "Default state of medium";
  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";

equation
  connect(senVolFlo.V_flow, dirEvaCoo.V_flow) annotation (Line(points={{-10,11},
          {-10,58},{18,58}}, color={0,0,127}));
  connect(senTemWetBul.T, dirEvaCoo.TWetBulIn)
    annotation (Line(points={{-40,11},{-40,66},{18,66}}, color={0,0,127}));
  connect(senTem.T, dirEvaCoo.TDryBulIn)
    annotation (Line(points={{-70,11},{-70,62},{18,62}}, color={0,0,127}));
  connect(senTem.port_b, senTemWetBul.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(senTemWetBul.port_b,senVolFlo. port_a)
    annotation (Line(points={{-30,0},{-20,0}}));
  connect(res.port_b, vol.ports[1])
    annotation (Line(points={{40,0},{79,0},{79,10}}, color = {0, 127, 255}));
  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-80,0}}));
  connect(vol.ports[2], port_b)
    annotation (Line(points={{81,10},{81,0},{100,0}}, color = {0, 127, 255}));
  connect(senTem.port_a, senPre.port)
    annotation (Line(points={{-80,0},{-90,0},{-90,44}}, color={0,127,255}));
  connect(senPre.p, dirEvaCoo.p)
    annotation (Line(points={{-79,54},{18,54}}, color={0,0,127}));
  connect(dirEvaCoo.dmWat_flow, vol.mWat_flow)
    annotation (Line(points={{42,60},{60,60},{60,28},{68,28}}, color={0,0,127}));
  connect(senVolFlo.port_b, res.port_a)
    annotation (Line(points={{0,0},{20,0}}, color={0,127,255}));
  connect(dirEvaCoo.dmWat_flow, dmWat_flow)
    annotation (Line(points={{42,60},{60,60},{60,80},{120,80}}, color={0,0,127}));

annotation (Icon(graphics={
  Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent = {{-70, 60}, {70, -60}}),
  Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =  FillPattern.Solid, extent = {{-101, 5}, {100, -4}}),
  Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 0, 0}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent = {{0, -4}, {100, 5}}),
  Text(textColor = {0, 0, 127}, extent = {{-52, -60}, {58, -120}}, textString = "m=%m_flow_nominal"),
  Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent = {{-100, 5}, {101, -5}}),
  Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 62, 0}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent = {{-70, 60}, {70, -60}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern = FillPattern.Solid,
            points = {{42, 42}, {54, 34}, {54, 34}, {42, 28}, {42, 30}, {50, 34}, {50, 34}, {42, 40}, {42, 42}}),
  Rectangle(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern = FillPattern.Solid, extent = {{58, -54}, {54, 52}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points = {{42, 10}, {54, 2}, {54, 2}, {42, -4}, {42, -2}, {50, 2}, {50, 2}, {42, 8}, {42, 10}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points = {{42, -26}, {54, -34}, {54, -34}, {42, -40}, {42, -38}, {50, -34}, {50, -34}, {42, -28}, {42, -26}})},
  coordinateSystem(extent = {{-100, -100}, {100, 100}})),
Documentation(defaultComponentName="dirEvaCoo",
info="<html>
<p>
Model for a direct evaporative cooler.
</p>
<p>
This model cools the airstream down by adiabatically increasing the humidity 
mass fraction of the air. The mass of water vapour added to the air is reported by the 
output signal <code>dmWat_flow</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(graphics={Line(origin = {28, 62}, points = {{0, 0}})}));
end Direct;
