within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls;
model Supervisory "Energy transfer station supervisory controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.TemperatureDifference THys(min=0.1)=THys
    "Temperature hysteresis";
  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k(final unit="1/K")=0.01
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.SIunits.Time Ti(min=0)=60
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PI
         or  controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PD
          or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMin = 0.01
    "Minimum control output"
    annotation (Dialog(group="PID controller"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCoo(final unit="K", displayUnit="degC")
    "Setpoint for cooling water temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanCooTop(final unit="K",displayUnit="degC")
    "Top temperature of cooling buffer tank"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanCooBot(final unit="K",displayUnit="degC")
    "Bottom temperature of cooling buffer tank"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanHeaTop(final unit="K",displayUnit="degC")
    "Top temperature of heating buffer tank"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanHeaBot(final unit="K",displayUnit="degC")
    "Bottom temperature of heating buffer tank"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHea(final unit="K", displayUnit="degC")
    "Setpoint for heating water temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoCon
    "Condenser to ambient loop isolation valve control signal"
                                                annotation (Placement(
        transformation(extent={{100,-60},{140,-20}}), iconTransformation(extent={{100,-60},
            {140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoEva
    "Evaporator to ambient loop isolation valve control signal"
                                                 annotation (Placement(
        transformation(extent={{100,-90},{140,-50}}),  iconTransformation(
          extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHea
    "Heating mode enabled signal" annotation (Placement(transformation(extent={
            {100,60},{140,100}}), iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCoo
    "Cooling mode enabled signal" annotation (Placement(transformation(extent={{100,30},
            {140,70}}),         iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yColRej
    "Control signal enabling full cold rejection to ambient loop" annotation (
      Placement(transformation(extent={{100,-30},{140,10}}), iconTransformation(
          extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaRej
    "Control signal enabling full heat rejection to ambient loop" annotation (
      Placement(transformation(extent={{100,0},{140,40}}),  iconTransformation(
          extent={{100,0},{140,40}})));
  HotSide conHotSid(THys=THys) "Hot side controller"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  ColdSide conColSid(THys=THys) "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));
equation
  connect(TTanHeaTop, conHotSid.TTop) annotation (Line(points={{-120,50},{-20,
          50},{-20,48},{-12,48}},      color={0,0,127}));
  connect(TTanHeaBot, conHotSid.TBot) annotation (Line(points={{-120,20},{-20,
          20},{-20,44},{-12,44}},
                                color={0,0,127}));
  connect(TTanCooTop, conColSid.TTop) annotation (Line(points={{-120,-40},{-24,
          -40},{-24,-78},{-12,-78}},   color={0,0,127}));
  connect(TTanCooBot, conColSid.TBot) annotation (Line(points={{-120,-70},{-28,
          -70},{-28,-82},{-12,-82}},      color={0,0,127}));
  connect(conHotSid.yHea, yHea) annotation (Line(points={{12,58},{20,58},{20,80},
          {120,80}}, color={255,0,255}));
  connect(conColSid.yCoo, yCoo) annotation (Line(points={{12,-68},{60,-68},{60,
          50},{120,50}},
                     color={255,0,255}));
  connect(conColSid.yRej, yColRej) annotation (Line(points={{12,-72},{80,-72},{80,
          -10},{120,-10}}, color={255,0,255}));
  connect(conHotSid.yRej, yHeaRej) annotation (Line(points={{12,54},{20,54},{20,
          20},{120,20}}, color={255,0,255}));
  connect(TSetCoo, conColSid.TSet) annotation (Line(points={{-120,-10},{-20,-10},
          {-20,-70},{-12,-70}},   color={0,0,127}));
  connect(TSetHea, conHotSid.TSet) annotation (Line(points={{-120,80},{-20,80},
          {-20,56},{-12,56}},     color={0,0,127}));
  connect(conHotSid.yIso,yIsoCon)  annotation (Line(points={{12,46},{14,46},{14,
          -40},{120,-40}}, color={0,0,127}));
  connect(conColSid.yIso,yIsoEva)
    annotation (Line(points={{12,-80},{90,-80},{90,-70},{120,-70}},
                                                  color={0,0,127}));

  connect(yHea, yHea)
    annotation (Line(points={{120,80},{120,80}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        defaultComponentName="conSup",
        Documentation(info="<html>
<p>
The block implements the control sequence for the ETS chilled water and 
heating water circuits.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 10, 2019, by Hagar Elarga:<br/>
Added the documentation. 
</li>
<li>
November 25, 2019, by Hagar Elarga:<br/>
Removed the tank minimum charging flow signal because the primary pumps are constant speed.
</li>
</ul>
</html>"));
end Supervisory;
