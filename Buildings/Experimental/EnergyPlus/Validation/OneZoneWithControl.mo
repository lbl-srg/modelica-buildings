within Buildings.Experimental.EnergyPlus.Validation;
model OneZoneWithControl "Validation model for one zone"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";

  parameter Modelica.SIunits.Volume AFlo = 149.657+2*(113.45+67.3) "Floor area of the whole floor of the building";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = AFlo*2.7*3*1.2/3600
    "Nominal mass flow rate";

  ThermalZone zon(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Core_ZN",
    nPorts = 2) "South zone"
    annotation (Placement(transformation(extent={{20,20},{60,60}})));
  Fluid.FixedResistances.PressureDrop duc(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=m_flow_nominal)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));
  Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal,
    use_T_in=true)
              "Boundary condition"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Fluid.Sources.Boundary_pT freshAir(
    redeclare package Medium = Medium,
    nPorts=1)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  Controls.OBC.CDL.Continuous.Sources.Pulse TSet(
    amplitude=6,
    period=86400,
    offset=273.15 + 16,
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
    u_m(unit="K", displayUnit="degC"))
            annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Fluid.HeatExchangers.Heater_T hea(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0,
    tau=0,
    show_T=true) "Ideal heater"
    annotation (Placement(transformation(extent={{18,-50},{38,-30}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar(p=273.15 + 18, k=12)
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
    annotation (Line(points={{-58,-70},{-52,-70}},color={0,0,127}));
  connect(conPID.u_m, zon.TAir) annotation (Line(points={{-40,-82},{-40,-92},{90,
          -92},{90,53.8},{61,53.8}}, color={0,0,127}));
  connect(bou.ports[1],hea. port_a)
    annotation (Line(points={{-40,-40},{18,-40}}, color={0,127,255}));
  connect(freshAir.ports[1], duc.port_b)
    annotation (Line(points={{-50,-10},{-40,-10}}, color={0,127,255}));
  connect(duc.port_a, zon.ports[1]) annotation (Line(points={{-20,-10},{38,-10},
          {38,20.8}}, color={0,127,255}));
  connect(hea.port_b, zon.ports[2])
    annotation (Line(points={{38,-40},{42,-40},{42,20.8}}, color={0,127,255}));
  connect(conPID.y, addPar.u)
    annotation (Line(points={{-28,-70},{-22,-70}}, color={0,0,127}));
  connect(addPar.y,hea. TSet) annotation (Line(points={{2,-70},{10,-70},{10,-32},
          {16,-32}}, color={0,0,127}));
  connect(gai.u[1],nPer. y)
    annotation (Line(points={{-42,50},{-59,50}},         color={0,0,127}));
  connect(zon.qGai_flow, gai.y)
    annotation (Line(points={{18,50},{-19,50}}, color={0,0,127}));
  connect(zon.TAir, bou.T_in) annotation (Line(points={{61,53.8},{90,53.8},{90,
          -92},{-90,-92},{-90,-36},{-62,-36}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Simple test case for one building with one thermal zone
in which the room air temperature is controlled with a PI controller.
The control output is used to compute the set point for the supply air
temperature, which is met by the heating coil.
The setpoint for the room air temperature changes between day and night.
</p>
</html>", revisions="<html>
<ul><li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Validation/OneZoneWithControl.mos"
        "Simulate and plot"),
experiment(
      StopTime=86400,
      Tolerance=1e-06));
end OneZoneWithControl;
