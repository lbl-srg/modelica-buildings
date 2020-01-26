within Buildings.Applications.DHC.EnergyTransferStations.Control;
model SubstationMainController "Main controller of the 5thG substation"
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
    annotation (Placement(transformation(extent={{-260,
            -60},{-220,-20}}),
                     iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanCooTop(final unit="K",displayUnit="degC")
    "Top temperature of cooling buffer tank"
    annotation (Placement(transformation(extent={{-260,-100},{-220,-60}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanCooBot(final unit="K",displayUnit="degC")
    "Bottom temperature of cooling buffer tank"
    annotation (Placement(transformation(extent={{-260,-130},{-220,-90}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanHeaTop(final unit="K",displayUnit="degC")
    "Top temperature of heating buffer tank"
    annotation (Placement(transformation(extent={{-260,80},{-220,120}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanHeaBot(final unit="K",displayUnit="degC")
    "Bottom temperature of heating buffer tank"
    annotation (Placement(transformation(extent={{-260,50},{-220,90}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHea(final unit="K", displayUnit="degC")
    "Setpoint for heating water temperature"
    annotation (Placement(transformation(extent={{-260,
            110},{-220,150}}),
                    iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput valHeaPos
   "Hot side valve status(1:On, 0:Off)"
    annotation (
      Placement(transformation(extent={{220,30},{240,50}}),   iconTransformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput valCooPos
    "Cold side valve status(1:On, 0:Off)"
    annotation (
      Placement(transformation(extent={{220,-110},{240,-90}}),  iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reqHea
    "True: heating is required, false otherwise"
    annotation (Placement(transformation(extent={{220,110},
            {240,130}}),      iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reqCoo
    "True: cooling is required, false otherwise"
    annotation (Placement(transformation(extent={{220,-50},
            {240,-30}}),        iconTransformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput rejColFulLoa
    "True: reject full surplus cooling load using the district heat exchanger and/or borefield systems."
    annotation (Placement(transformation(extent={{220,-70},{240,-50}}),
      iconTransformation(extent={{100,-82},{120,-62}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput rejHeaFulLoa
    "True: reject full surplus heating load using the district heat exchanger and/or borefield systems."
    annotation (Placement(transformation(extent={{220,92},{240,112}}),
      iconTransformation(extent={{100,-62},{120,-42}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput valHea
    "Hot side valve status, true when rejection of part or full heating load is required"
    annotation (Placement(
        transformation(extent={{220,60},{240,80}}),   iconTransformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput valCoo
    "Cold side valve status, true when rejection of part or full cooling load is required"
    annotation (Placement(
        transformation(extent={{220,-90},{240,-70}}),   iconTransformation(extent={{100,40},{120,60}})));

  HotSideController conHotSid(THys=THys)
    "Hot side controller"
    annotation (Placement(transformation(extent={{-160,86},{-140,106}})));
  ColdSideController conColSid(THys=THys)
    "Cold side controller"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));

equation
  connect(TTanHeaTop, conHotSid.TTop) annotation (Line(points={{-240,100},{-200,
          100},{-200,101},{-161,101}}, color={0,0,127}));
  connect(TTanHeaBot, conHotSid.TBot) annotation (Line(points={{-240,70},{-180,70},
          {-180,91},{-161,91}},        color={0,0,127}));
  connect(TTanCooTop, conColSid.TTop) annotation (Line(points={{-240,-80},{-200,
          -80},{-200,-95},{-161,-95}},    color={0,0,127}));
  connect(TTanCooBot, conColSid.TBot) annotation (Line(points={{-240,-110},{-192,
          -110},{-192,-105},{-161,-105}}, color={0,0,127}));
  connect(conHotSid.reqHea, reqHea) annotation (Line(points={{-139,105},{50,105},{50,120},{230,120}}, color={255,0,255}));
  connect(conColSid.reqCoo, reqCoo) annotation (Line(points={{-139,-91},{-130,-91},
          {-130,-80},{20,-80},{20,-40},{230,-40}},
                       color={255,0,255}));
  connect(conColSid.rejFulLoa, rejColFulLoa) annotation (Line(points={{-139,-94},
          {40,-94},{40,-60},{230,-60}},    color={255,0,255}));
  connect(conHotSid.rejFulLoa, rejHeaFulLoa)  annotation (Line(points={{-139,102},{230,102}}, color={255,0,255}));
  connect(valHea, conHotSid.valSta) annotation (Line(points={{230,70},{148,70},{148,96},{-139,96}},     color={255,0,255}));
  connect(conColSid.valSta,valCoo) annotation (Line(points={{-139,-100},{100,-100},{100,-80},{230,-80}},   color={255,0,255}));
  connect(TSetCoo, conColSid.TSet) annotation (Line(points={{-240,-40},{-174,-40},
          {-174,-91},{-161,-91}},         color={0,0,127}));
  connect(TSetHea, conHotSid.TSet) annotation (Line(points={{-240,130},{-202,130},
          {-202,105},{-161,105}},      color={0,0,127}));
  connect(conHotSid.yVal,valHeaPos)  annotation (Line(points={{-139,90},{118,90},
          {118,40},{230,40}},   color={0,0,127}));
  connect(conColSid.yVal,valCooPos)  annotation (Line(points={{-139,-106},{120,-106},
          {120,-100},{230,-100}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-220},{220,220}})),
        defaultComponentName="ETSCon",
        Documentation(info="<html>
<p>
The block combines the generated control signals of the ETS chilled and hot water circuits respectively
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController</a> and
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController</a>.
</p>
</html>", revisions="<html>
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
end SubstationMainController;
