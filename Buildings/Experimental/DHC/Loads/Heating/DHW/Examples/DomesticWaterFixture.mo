within Buildings.Experimental.DHC.Loads.Heating.DHW.Examples;
model DomesticWaterFixture
  "Thermostatic mixing valve and hot water fixture with representative annual load profile"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium model for water";
  parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal
    "Design domestic hot water supply flow rate of system";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Pressure difference";
  parameter Modelica.Units.SI.Temperature TDhwSet=273.15 + 40
    "Temperature setpoint of tempered doemstic hot water outlet";
  parameter Real k(min=0) = 2 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  Modelica.Fluid.Interfaces.FluidPort_a port_dhw(redeclare package Medium =
        Medium) "Domestic hot water supply port" annotation (
      Placement(transformation(extent={{-210,30},{-190,50}}),
        iconTransformation(extent={{-210,30},{-190,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T sinDhw(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for domestic hot water supply"
    annotation (Placement(transformation(extent={{-30,-30},{-50,-10}})));
  Modelica.Blocks.Math.Gain gaiDhw(k=-mDhw_flow_nominal) "Gain for multiplying domestic hot water schedule"
    annotation (Placement(transformation(extent={{72,10},{52,30}})));
  Modelica.Blocks.Sources.CombiTimeTable schDhw(tableOnFile=true,
  table=[0,0.1; 3600*1,1e-5; 3600*2,1e-5; 3600*3,1e-5; 3600*4,1e-5; 3600*5,0.3;
        3600*6,0.9; 3600*7,1; 3600*8,1; 3600*9,0.8; 3600*10,0.8; 3600*11,0.6;
        3600*12,0.5; 3600*13,0.5; 3600*14,0.4; 3600*15,0.5; 3600*16,0.6; 3600*
        17,0.7; 3600*18,0.9; 3600*19,0.8; 3600*20,0.8; 3600*21,0.6; 3600*22,0.5;
        3600*23,0.3; 3600*24,0.1],
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Heating/DHW/DHW_SingleApartment.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Domestic hot water fraction schedule"
    annotation (Placement(transformation(extent={{130,10},{110,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_dcw(redeclare package Medium =
        Medium) "Domestic cold water supply port" annotation (
      Placement(transformation(extent={{-210,-50},{-190,-30}}),
        iconTransformation(extent={{-210,-50},{-190,-30}})));
  BaseClasses.DomesticWaterMixer tmv(
    redeclare package Medium = Medium,
    TSet=TDhwSet,
    mDhw_flow_nominal=mDhw_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    k=k,
    Ti=Ti) "Ideal thermostatic mixing valve"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Continuous.Integrator watCon(k=-1)
                                               "Integrated hot water consumption"
    annotation (Placement(transformation(extent={{84,-50},{104,-30}})));
  Modelica.Blocks.Interfaces.RealOutput TTw "Temperature of the outlet tempered water"
    annotation (Placement(transformation(extent={{180,20},{220,60}})));
  Modelica.Blocks.Interfaces.RealOutput mDhw "Total hot water consumption"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
        iconTransformation(extent={{180,-60},{220,-20}})));
equation
  connect(gaiDhw.y, sinDhw.m_flow_in) annotation (Line(points={{51,20},{0,20},{0,
          -12},{-28,-12}},       color={0,0,127}));
  connect(schDhw.y[1], gaiDhw.u)
    annotation (Line(points={{109,20},{74,20}},    color={0,0,127}));
  connect(tmv.port_tw, sinDhw.ports[1])
    annotation (Line(points={{-90,0},{-70,0},{-70,-20},{-50,-20}},
                                                      color={0,127,255}));
  connect(tmv.port_hw, port_dhw) annotation (Line(points={{-110,6},{-150,6},{-150,
          40},{-200,40}},           color={0,127,255}));
  connect(tmv.port_cw, port_dcw) annotation (Line(points={{-110,-6},{-150,-6},{-150,
          -40},{-200,-40}},         color={0,127,255}));
  connect(tmv.TTw, TTw) annotation (Line(points={{-89,8},{-70,8},{-70,40},{200,40}},
        color={0,0,127}));
  connect(watCon.y, mDhw)
    annotation (Line(points={{105,-40},{200,-40}}, color={0,0,127}));
  connect(watCon.u, gaiDhw.y) annotation (Line(points={{82,-40},{0,-40},{
          0,20},{51,20}}, color={0,0,127}));
annotation (Documentation(info="<html>
<p>
This is a single zone model based on the envelope of the BESTEST Case 600
building, though it has some modifications.  Supply and return air ports are
included for simulation with air-based HVAC systems.  Heating and cooling
setpoints and internal loads are time-varying according to an assumed
occupancy schedule.
</p>
<p>
This zone model utilizes schedules and constructions from
the <code>Schedules</code> and <code>Constructions</code> packages.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-200,-200},{200,200}})),
    Icon(coordinateSystem(extent={{-200,-200},{200,200}})));
end DomesticWaterFixture;
