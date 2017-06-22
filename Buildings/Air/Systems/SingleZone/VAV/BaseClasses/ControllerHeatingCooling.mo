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
    annotation (Placement(transformation(rotation=0, extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput yHea(unit="1")
    "Control signal for heating coil"
    annotation (Placement(transformation(rotation=0, extent={{100,-50},{120,-30}})));
  Controls.Continuous.LimPID conHeaCoi(
      k=kPHea,
      controllerType=Modelica.Blocks.Types.SimpleController.P)
      "Controller for heating coil"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Controls.Continuous.LimPID conFan(
    k=kPFan,
    yMax=1,
    yMin=minAirFlo,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    reverseAction=true)
    "Controller for fan"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

equation
  connect(TSetRooHea, conHeaCoi.u_s)
    annotation (Line(points={{-110,60},{-60,60},{-60,-40},{-12,-40}},
                                                     color={0,0,127}));
  connect(TRoo, conHeaCoi.u_m) annotation (Line(points={{-110,-60},{-80,-60},{
          -80,-60},{0,-60},{0,-52}},   color={0,0,127}));
  connect(conHeaCoi.y, yHea)
    annotation (Line(points={{11,-40},{60,-40},{110,-40}},
                                                 color={0,0,127}));
  connect(conFan.u_s, TSetRooCoo) annotation (Line(points={{18,40},{18,40},{-48,
          40},{-48,40},{-80,40},{-80,0},{-110,0}},
                                                 color={0,0,127}));
  connect(TRoo, conFan.u_m) annotation (Line(points={{-110,-60},{-110,-60},{30,
          -60},{30,28}},                        color={0,0,127}));

  connect(conFan.y, yFan)
    annotation (Line(points={{41,40},{41,40},{110,40}},
                                                   color={0,0,127}));
  annotation (
  defaultComponentName="conHeaFan",
  Documentation(info="<html>
<p>
Controller for heating coil and fan speed.
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
</html>"));
end ControllerHeatingCooling;
