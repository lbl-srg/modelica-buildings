within Buildings.Applications.DHC.EnergyTransferStations.Controls;
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput valHeaPos
   "Hot side valve status(1:On, 0:Off)"
    annotation (Placement(transformation(extent={{220,30},{240,50}}),
      iconTransformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput valCooPos
    "Cold side valve status(1:On, 0:Off)"
    annotation (Placement(transformation(extent={{220,-110},{240,-90}}),
      iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reqHea
    "True: heating is required, false otherwise"
    annotation (Placement(transformation(extent={{220,110},
      {240,130}}), iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reqCoo
    "True: cooling is required, false otherwise"
    annotation (Placement(transformation(extent={{220,-50},
      {240,-30}}), iconTransformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput rejColFulLoa
    "True: reject full surplus cooling load using the district heat exchanger and/or borefield systems"
    annotation (Placement(transformation(extent={{220,-70},{240,-50}}),
      iconTransformation(extent={{100,-82},{120,-62}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput rejHeaFulLoa
    "True: reject full surplus heating load using the district heat exchanger and/or borefield systems"
    annotation (Placement(transformation(extent={{220,92},{240,112}}),
      iconTransformation(extent={{100,-62},{120,-42}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput valHea
    "Hot side valve status, true when rejection of part or full heating load is required"
    annotation (Placement( transformation(extent={{220,60},{240,80}}),
      iconTransformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput valCoo
    "Cold side valve status, true when rejection of part or full cooling load is required"
    annotation (Placement( transformation(extent={{220,-90},{240,-70}}),
      iconTransformation(extent={{100,40},{120,60}})));
  HotSide conHotSid(THys=THys) "Hot side controller"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  ColdSide conColSid(THys=THys) "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(TTanHeaTop, conHotSid.TTop) annotation (Line(points={{-120,50},{-80,
          50},{-80,55},{-11,55}},      color={0,0,127}));
  connect(TTanHeaBot, conHotSid.TBot) annotation (Line(points={{-120,20},{-62,
          20},{-62,45},{-11,45}},
                                color={0,0,127}));
  connect(TTanCooTop, conColSid.TTop) annotation (Line(points={{-120,-50},{-78,
          -50},{-78,-55},{-11,-55}},   color={0,0,127}));
  connect(TTanCooBot, conColSid.TBot) annotation (Line(points={{-120,-80},{-70,
          -80},{-70,-65},{-11,-65}},      color={0,0,127}));
  connect(conHotSid.reqHea, reqHea) annotation (Line(points={{11,59},{50,59},{
          50,120},{230,120}},                                                                         color={255,0,255}));
  connect(conColSid.reqCoo, reqCoo) annotation (Line(points={{11,-51},{-8,-51},
          {-8,-62},{142,-62},{142,-40},{230,-40}}, color={255,0,255}));
  connect(conColSid.rejFulLoa, rejColFulLoa) annotation (Line(points={{11,-54},
          {162,-54},{162,-60},{230,-60}},
                                        color={255,0,255}));
  connect(conHotSid.rejFulLoa, rejHeaFulLoa)  annotation (Line(points={{11,56},
          {52,56},{52,102},{230,102}},                                                        color={255,0,255}));
  connect(valHea, conHotSid.valSta) annotation (Line(points={{230,70},{148,70},
          {148,50},{11,50}},                                                                            color={255,0,255}));
  connect(conColSid.valSta,valCoo) annotation (Line(points={{11,-60},{222,-60},
          {222,-80},{230,-80}},                                                                            color={255,0,255}));
  connect(TSetCoo, conColSid.TSet) annotation (Line(points={{-120,-20},{-52,-20},
          {-52,-51},{-11,-51}},   color={0,0,127}));
  connect(TSetHea, conHotSid.TSet) annotation (Line(points={{-120,80},{-76,80},
          {-76,59},{-11,59}},     color={0,0,127}));
  connect(conHotSid.yVal,valHeaPos)  annotation (Line(points={{11,44},{118,44},
          {118,40},{230,40}},   color={0,0,127}));
  connect(conColSid.yVal,valCooPos)  annotation (Line(points={{11,-66},{242,-66},
          {242,-100},{230,-100}}, color={0,0,127}));

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
