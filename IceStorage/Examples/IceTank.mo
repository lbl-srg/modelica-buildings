within IceStorage.Examples;
model IceTank "Example that test the IceTank model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=293.15,
    X_a=0.30);
  parameter Real coeCha[6] = {0, 0.09, -0.15, 0.612, -0.324, -0.216} "Coefficient for charging curve";
  parameter Real coeDisCha[6] = {0, 0.09, -0.15, 0.612, -0.324, -0.216} "Coefficient for discharging curve";
  parameter Real dt = 3600 "Time step used in the samples for curve fitting";

  IceStorage.IceTank iceTan(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    dp_nominal=100000,
    mIce_max=2846.35,
    mIce_start=2846.35/2,
    Hf=333550,
    coeCha=coeCha,
    dtCha=dt,
    coeDisCha=coeDisCha,
    dtDisCha=dt)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=1,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{86,-10},{66,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=500)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Modelica.Blocks.Sources.IntegerTable mod(table=[
        0,Integer(IceStorage.Types.IceThermalStorageMode.Dormant);
        3600,Integer(IceStorage.Types.IceThermalStorageMode.Charging);
        7200,Integer(IceStorage.Types.IceThermalStorageMode.Discharging)])
                  "Mode"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.Step temSou(
    height=10,
    offset=273.15 - 5,
    startTime=7200) "Source temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 0) "Setpoint temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
equation
  connect(sou.ports[1], iceTan.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(iceTan.port_b, res.port_a)
    annotation (Line(points={{10,0},{26,0}}, color={0,127,255}));
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{46,0},{66,0}}, color={0,127,255}));
  connect(mod.y, iceTan.u) annotation (Line(points={{-79,40},{-26,40},{-26,8},{
          -12,8}}, color={255,127,0}));
  connect(temSou.y, sou.T_in) annotation (Line(points={{-79,10},{-72,10},{-72,4},
          {-62,4}}, color={0,0,127}));
  connect(TSet.y, iceTan.TOutSet) annotation (Line(points={{-79,-30},{-26,-30},
          {-26,3},{-12,3}}, color={0,0,127}));
  annotation (
    experiment(
      StartTime=0,
      StopTime=14400,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://VirtualTestbed/Resources/Scripts/Dymola/NISTChillerTestbed/Component/Examples/IceTank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to validate the developed tank model against real measurement from NIST chiller tank testbed.</p>
</html>", revisions="<html>
<p>April 2021, Yangyang Fu First implementation </p>
</html>"));
end IceTank;
