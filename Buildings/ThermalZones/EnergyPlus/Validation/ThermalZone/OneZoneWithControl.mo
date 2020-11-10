within Buildings.ThermalZones.EnergyPlus.Validation.ThermalZone;
model OneZoneWithControl
  "Validation model for one zone"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Air
    "Medium model";
  inner Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance.idf"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    showWeatherData=false)
    "Building model"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  parameter Modelica.SIunits.Volume AFlo=185
    "Floor area of the whole floor of the building";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=6*AFlo*2.7*1.2/3600
    "Nominal mass flow rate";
  Buildings.ThermalZones.EnergyPlus.ThermalZone zon(
    redeclare package Medium=Medium,
    zoneName="LIVING ZONE",
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{20,20},{60,60}})));
  Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true)
    "Fan"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Controls.OBC.CDL.Continuous.Sources.Pulse TSet(
    amplitude=6,
    period(
      displayUnit="d")=86400,
    offset=273.15+16,
    delay(
      displayUnit="h")=21600,
    y(
      unit="K",
      displayUnit="degC"))
    "Setpoint for room air"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Controls.OBC.CDL.Continuous.PID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=900,
    yMax=1,
    yMin=0,
    u_s(
      unit="K",
      displayUnit="degC"),
    u_m(
      unit="K",
      displayUnit="degC"))
    "Controller for heater"
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Fluid.HeatExchangers.Heater_T hea(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    tau=0,
    show_T=true)
    "Ideal heater"
    annotation (Placement(transformation(extent={{18,-50},{38,-30}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar(
    p=273.15+18,
    k=12)
    "Compute the leaving water setpoint temperature"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Math.MatrixGain gai(
    K=120/AFlo*[
      0.4;
      0.4;
      0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Controls.OBC.CDL.Continuous.Sources.Pulse nPer(
    period(
      displayUnit="d")=86400,
    delay(
      displayUnit="h")=25200,
    amplitude=2)
    "Number of persons"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(TSet.y,conPID.u_s)
    annotation (Line(points={{-58,-70},{-52,-70}},color={0,0,127}));
  connect(conPID.u_m,zon.TAir)
    annotation (Line(points={{-40,-82},{-40,-92},{90,-92},{90,58},{61,58}},color={0,0,127}));
  connect(conPID.y,addPar.u)
    annotation (Line(points={{-28,-70},{-22,-70}},color={0,0,127}));
  connect(addPar.y,hea.TSet)
    annotation (Line(points={{2,-70},{10,-70},{10,-32},{16,-32}},color={0,0,127}));
  connect(gai.u[1],nPer.y)
    annotation (Line(points={{-42,50},{-58,50}},color={0,0,127}));
  connect(zon.qGai_flow,gai.y)
    annotation (Line(points={{18,50},{-19,50}},color={0,0,127}));
  connect(fan.port_b,hea.port_a)
    annotation (Line(points={{-20,-40},{18,-40}},color={0,127,255}));
  connect(fan.port_a,zon.ports[1])
    annotation (Line(points={{-40,-40},{-50,-40},{-50,0},{38,0},{38,20.9}},color={0,127,255}));
  connect(hea.port_b,zon.ports[2])
    annotation (Line(points={{38,-40},{42,-40},{42,20.9}},color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
Simple test case for one building with one thermal zone
in which the room air temperature is controlled with a PI controller.
The control output is used to compute the set point for the supply air
temperature, which is met by the heating coil.
The setpoint for the room air temperature changes between day and night.
The fan operates continuously at constant speed.
</p>
</html>",
      revisions="<html>
<ul><li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/ThermalZone/OneZoneWithControl.mos" "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06));
end OneZoneWithControl;
