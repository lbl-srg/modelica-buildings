within IceStorage.Examples;
model IceTank "Example that test the IceTank model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=293.15,
    X_a=0.30);
  parameter Real coeCha[6] = {1.99930278E-2,0,0,0,0,0} "Coefficient for charging curve";
  parameter Real coeDisCha[6] = {5.54E-05,-0.000145679,9.28E-05,0.001126122,
      -0.0011012,0.000300544} "Coefficient for discharging curve";
  parameter Real dt = 10 "Time step used in the samples for curve fitting";
  parameter Modelica.SIunits.Mass mIce_max=2846.35
    "Nominal mass of ice in the tank";
  parameter Modelica.SIunits.Mass mIce_start=2846.35/10
    "Start value of ice mass in the tank";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal=100000
    "Pressure difference";

  IceStorage.IceTank iceTan(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    mIce_max=mIce_max,
    mIce_start=mIce_start,
    coeCha=coeCha,
    dtCha=dt,
    coeDisCha=coeDisCha,
    dtDisCha=dt)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{86,-10},{66,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500)
    annotation (Placement(transformation(extent={{34,-10},{54,10}})));
  Modelica.Blocks.Sources.IntegerTable mod(table=[0,Integer(IceStorage.Types.IceThermalStorageMode.Charging);
        3600*10,Integer(IceStorage.Types.IceThermalStorageMode.Dormant); 3600*11,
        Integer(IceStorage.Types.IceThermalStorageMode.Discharging); 3600*18,
        Integer(IceStorage.Types.IceThermalStorageMode.Charging)])
                  "Mode"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 6) "Setpoint temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Modelica.Blocks.Sources.CombiTimeTable
                                       TSou(table=[0,273.15 - 5; 3600*10,273.15 -
        5; 3600*10,273.15 + 10; 3600*11,273.15 + 10; 3600*18,273.15 + 10; 3600*18,
        273.15 - 5]) "Source temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  connect(sou.ports[1], iceTan.port_a)
    annotation (Line(points={{-46,0},{0,0}},   color={0,127,255}));
  connect(iceTan.port_b, res.port_a)
    annotation (Line(points={{20,0},{34,0}}, color={0,127,255}));
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{54,0},{66,0}}, color={0,127,255}));
  connect(mod.y, iceTan.u) annotation (Line(points={{-79,40},{-26,40},{-26,8},{-2,
          8}},     color={255,127,0}));
  connect(TSet.y, iceTan.TOutSet) annotation (Line(points={{-79,-30},{-26,-30},{
          -26,3},{-2,3}},   color={0,0,127}));
  connect(TSou.y[1], sou.T_in) annotation (Line(points={{-79,0},{-74,0},{-74,4},
          {-68,4}}, color={0,0,127}));
  annotation (
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://IceStorage/Resources/Scripts/Dymola/Examples/IceTank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to verify the ice tank model <a href=\"\"><>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IceTank;
