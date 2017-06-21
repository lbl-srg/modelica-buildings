within Buildings.Air.Systems.SingleZone.VAV.BaseClasses;
model ControllerHeatingCooling "Controller for heating and cooling"
  extends Modelica.Blocks.Icons.Block;

  parameter Real kPHea(min=Modelica.Constants.small) = 1
    "Proportional gain of heating controller"
    annotation(Dialog(group="Control gain"));
  parameter Real kPFan(min=Modelica.Constants.small) = 1
    "Gain of controller for fan"
    annotation(Dialog(group="Control gain"));

  parameter Real minAirFlo(
    min=0,
    max=1,
    unit="1")
    "Minimum airflow rate of system";

  Modelica.Blocks.Interfaces.RealInput TSetRooCoo "Zone cooling setpoint"
    annotation (Placement(transformation(rotation=0, extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TRoo
    "Zone temperature measurement"          annotation (Placement(
        transformation(rotation=0, extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput TSetRooHea "Zone heating setpoint"
    annotation (Placement(transformation(rotation=0, extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealOutput yFan(unit="1") "Control signal for fan"
    annotation (Placement(transformation(rotation=0, extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput yHea(unit="1") "Control signal for heating coil"
    annotation (Placement(transformation(rotation=0, extent={{100,50},{120,70}})));
  Controls.Continuous.LimPID conHeaCoi(
      k=kPHea, controllerType=Modelica.Blocks.Types.SimpleController.P)
               "Controller for heating coil"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Controls.Continuous.LimPID conFan(
      k=kPFan,
    yMax=1,
    yMin=minAirFlo,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    reverseAction=true)
               "Controller for fan"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

equation
  connect(TSetRooHea, conHeaCoi.u_s)
    annotation (Line(points={{-110,60},{-42,60}},    color={0,0,127}));
  connect(TRoo, conHeaCoi.u_m) annotation (Line(points={{-110,-60},{-72,-60},{-72,
          28},{-30,28},{-30,48}},      color={0,0,127}));
  connect(conHeaCoi.y, yHea)
    annotation (Line(points={{-19,60},{110,60}}, color={0,0,127}));
  connect(conFan.u_s, TSetRooCoo) annotation (Line(points={{-42,-60},{-60,-60},{
          -60,0},{-110,0}},                      color={0,0,127}));
  connect(TRoo, conFan.u_m) annotation (Line(points={{-110,-60},{-72,-60},{-72,-80},
          {-30,-80},{-30,-72}},                 color={0,0,127}));

  connect(conFan.y, yFan)
    annotation (Line(points={{-19,-60},{110,-60}}, color={0,0,127}));
end ControllerHeatingCooling;
