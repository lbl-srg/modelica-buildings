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
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanCooTop(final unit="K",displayUnit="degC")
    "Top temperature of cooling buffer tank"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanCooBot(final unit="K",displayUnit="degC")
    "Bottom temperature of cooling buffer tank"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanHeaTop(final unit="K",displayUnit="degC")
    "Top temperature of heating buffer tank"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanHeaBot(final unit="K",displayUnit="degC")
    "Bottom temperature of heating buffer tank"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHea(final unit="K", displayUnit="degC")
    "Setpoint for heating water temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValCon
    "Condenser loop directional valve position" annotation (Placement(
        transformation(extent={{100,-60},{140,-20}}), iconTransformation(extent=
           {{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEva
    "Evaporator loop directional valve position" annotation (Placement(
        transformation(extent={{100,-100},{140,-60}}), iconTransformation(
          extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reqHea
    "True: heating is required, false otherwise"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
                   iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reqCoo
    "True: cooling is required, false otherwise"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
                   iconTransformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput rejColFulLoa
    "True: reject full surplus cooling load using the district heat exchanger and/or borefield systems"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,-82},{120,-62}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput rejHeaFulLoa
    "True: reject full surplus heating load using the district heat exchanger and/or borefield systems"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,-62},{120,-42}})));
  HotSide conHotSid(THys=THys) "Hot side controller"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  ColdSide conColSid(THys=THys) "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-84},{10,-64}})));
equation
  connect(TTanHeaTop, conHotSid.TTop) annotation (Line(points={{-120,50},{-80,
          50},{-80,55},{-11,55}},      color={0,0,127}));
  connect(TTanHeaBot, conHotSid.TBot) annotation (Line(points={{-120,20},{-62,
          20},{-62,45},{-11,45}},
                                color={0,0,127}));
  connect(TTanCooTop, conColSid.TTop) annotation (Line(points={{-120,-50},{-78,
          -50},{-78,-69},{-11,-69}},   color={0,0,127}));
  connect(TTanCooBot, conColSid.TBot) annotation (Line(points={{-120,-80},{-70,
          -80},{-70,-79},{-11,-79}},      color={0,0,127}));
  connect(conHotSid.reqHea, reqHea) annotation (Line(points={{11,59},{16,59},{
          16,60},{20,60},{20,80},{120,80}},                                                           color={255,0,255}));
  connect(conColSid.reqCoo, reqCoo) annotation (Line(points={{11,-65},{36,-65},
          {36,-52},{60,-52},{60,40},{120,40}},     color={255,0,255}));
  connect(conColSid.rejFulLoa, rejColFulLoa) annotation (Line(points={{11,-68},
          {80,-68},{80,20},{120,20}},   color={255,0,255}));
  connect(conHotSid.rejFulLoa, rejHeaFulLoa)  annotation (Line(points={{11,56},
          {40,56},{40,60},{120,60}},                                                          color={255,0,255}));
  connect(TSetCoo, conColSid.TSet) annotation (Line(points={{-120,-20},{-52,-20},
          {-52,-65},{-11,-65}},   color={0,0,127}));
  connect(TSetHea, conHotSid.TSet) annotation (Line(points={{-120,80},{-76,80},
          {-76,59},{-11,59}},     color={0,0,127}));
  connect(conHotSid.yVal, yValCon) annotation (Line(points={{11,44},{20,44},{20,
          -40},{120,-40}}, color={0,0,127}));
  connect(conColSid.yVal, yValEva)
    annotation (Line(points={{11,-80},{120,-80}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        defaultComponentName="conETS",
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
