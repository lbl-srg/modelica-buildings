within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model CoolingDirectControlledReturn
  "Example model for direct cooling energy transfer station with in-building pump and controlled district return temperature"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 0.5
    "Nominal mass flow rate of district cooling supply";

  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal = 0.5
    "Nominal mass flow rate of building chilled water supply";

  Buildings.Applications.DHC.EnergyTransferStations.CoolingDirectControlledReturn
    coo(
    redeclare package Medium = Medium,
    mDis_flow_nominal=mDis_flow_nominal,
    mBui_flow_nominal=mBui_flow_nominal,
    mByp_flow_nominal=0.01,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yCon_start=0)
        annotation (Placement(transformation(extent={{-12,-12},{8,8}})));
  Fluid.Sensors.TemperatureTwoPort           TDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal,
    T_start=280.15)
    "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Fluid.Sensors.TemperatureTwoPort           TBuiSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    T_start=280.15)
    "Building-side (secondary) supply temperature sensor"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Fluid.Sensors.TemperatureTwoPort           TBuiRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    T_start=287.15)
    "Building-side (secondary) return temperature sensor"
    annotation (Placement(transformation(extent={{50,-60},{30,-40}})));
  Fluid.Sensors.TemperatureTwoPort           TDisRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal)
    "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 16)
    "Setpoint temperature for district return"
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  Fluid.Sources.Boundary_pT sinDis(redeclare package Medium = Medium, nPorts=1)
    "District sink"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Fluid.Sources.MassFlowSource_T souDis(
    redeclare package Medium = Medium,
    m_flow=mDis_flow_nominal,
    T=280.15,
    nPorts=1) "District source"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Fluid.Sources.Boundary_pT retBui(
    redeclare package Medium = Medium,
    T=287.15,
    nPorts=1) "Building return"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Fluid.Sources.MassFlowSource_T supBui_pulling(
    redeclare package Medium = Medium,
    m_flow=-mBui_flow_nominal,
    nPorts=1) "Building supply"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
equation
  connect(TSet.y, coo.TSetDisRet)
    annotation (Line(points={{-59,-12},{-14,-12}}, color={0,0,127}));
  connect(souDis.ports[1], TDisSup.port_a)
    annotation (Line(points={{-60,50},{-50,50}}, color={0,127,255}));
  connect(TDisSup.port_b, coo.port_a1) annotation (Line(points={{-30,50},{-22,50},
          {-22,4},{-12,4}}, color={0,127,255}));
  connect(coo.port_b1, TBuiSup.port_a) annotation (Line(points={{8,4},{20,4},{
          20,50},{30,50}}, color={0,127,255}));
  connect(TBuiSup.port_b, supBui_pulling.ports[1])
    annotation (Line(points={{50,50},{60,50}}, color={0,127,255}));
  connect(retBui.ports[1], TBuiRet.port_a) annotation (Line(points={{60,-50},{
          56,-50},{56,-50},{50,-50}}, color={0,127,255}));
  connect(TBuiRet.port_b, coo.port_a2) annotation (Line(points={{30,-50},{20,
          -50},{20,-8},{8,-8}}, color={0,127,255}));
  connect(coo.port_b2, TDisRet.port_b) annotation (Line(points={{-12,-8},{-22,
          -8},{-22,-50},{-30,-50}}, color={0,127,255}));
  connect(TDisRet.port_a, sinDis.ports[1])
    annotation (Line(points={{-50,-50},{-60,-50}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingDirectControlledReturn.mos"
    "Simulate and plot"),
  experiment(
    StartTime=0,
    StopTime=86400,
    Tolerance=1e-06),
    Documentation(info="<html>
<p>This model provides an example for the direct cooling energy transfer station model, which
contains in-building pumping and controls the district return temperature. The control valve is 
modulated proportionally to the instantaneous cooling load with respect to the maxiumum load.
</p>
</html>", revisions="<html>
<ul>
<li>November 13, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end CoolingDirectControlledReturn;
