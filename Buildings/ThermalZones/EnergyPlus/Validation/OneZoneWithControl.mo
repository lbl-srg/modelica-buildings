within Buildings.ThermalZones.EnergyPlus.Validation;
model OneZoneWithControl "Validation model for one zone"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter String idfName = "aaa.fmu" "Name of the FMU file that contains this zone";
  parameter Modelica.SIunits.Volume AFlo = 30 "Room volume";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = AFlo*2.7*6*1.2/3600
    "Nominal mass flow rate";

  ThermalZone zon(
    redeclare package Medium = Medium,
    idfName="bld.fmu",
    zoneName="Zone 1",
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
              "Thermal zone"
    annotation (Placement(transformation(extent={{20,20},{60,60}})));
  Fluid.FixedResistances.PressureDrop duc(
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));
  Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal,
    T=303.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-68,-50},{-48,-30}})));
  Fluid.Sources.Boundary_pT freshAir(
    redeclare package Medium = Medium,
    nPorts=1)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  Controls.OBC.CDL.Continuous.Sources.Pulse TSet(
    amplitude=-4,
    period=86400,
    offset=273.15 + 28,
    startTime=6*3600,
    y(unit="K", displayUnit="degC"))
    "Setpoint for room air"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Controls.OBC.CDL.Continuous.LimPID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=900,
    yMax=1,
    yMin=0,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"),
    reverseAction=true)
            annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Fluid.HeatExchangers.SensibleCooler_T coo(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0,
    tau=0,
    show_T=true)
           "Ideal cooler"
    annotation (Placement(transformation(extent={{18,-50},{38,-30}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar(p=273.15 + 24, k=-8)
    "Compute the leaving water setpoint temperature"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Math.MatrixGain gai(K=120/AFlo*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Pulse nPer(
    period(displayUnit="d") = 86400,
    startTime(displayUnit="h") = 25200,
    amplitude=2) "Number of persons"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(TSet.y, conPID.u_s)
    annotation (Line(points={{-59,-70},{-52,-70}},color={0,0,127}));
  connect(conPID.u_m, zon.TAir) annotation (Line(points={{-40,-82},{-40,-92},{90,
          -92},{90,53.8},{61,53.8}}, color={0,0,127}));
  connect(bou.ports[1], coo.port_a)
    annotation (Line(points={{-48,-40},{18,-40}}, color={0,127,255}));
  connect(freshAir.ports[1], duc.port_b)
    annotation (Line(points={{-50,-10},{-40,-10}}, color={0,127,255}));
  connect(duc.port_a, zon.ports[1]) annotation (Line(points={{-20,-10},{38,-10},
          {38,20.8}}, color={0,127,255}));
  connect(coo.port_b, zon.ports[2])
    annotation (Line(points={{38,-40},{42,-40},{42,20.8}}, color={0,127,255}));
  connect(conPID.y, addPar.u)
    annotation (Line(points={{-29,-70},{-22,-70}}, color={0,0,127}));
  connect(addPar.y, coo.TSet) annotation (Line(points={{1,-70},{10,-70},{10,-32},
          {16,-32}}, color={0,0,127}));
  connect(gai.u[1],nPer. y)
    annotation (Line(points={{-42,50},{-59,50}},         color={0,0,127}));
  connect(zon.qGai_flow, gai.y)
    annotation (Line(points={{18,50},{-19,50}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Simple test case for one buildings with one thermal zone.
</p>
</html>", revisions="<html>
<ul><li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/OneZoneWithControl.mos"
        "Simulate and plot"),
experiment(
      StopTime=86400,
      Tolerance=1e-06));
end OneZoneWithControl;
