within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.Validation;
model ControllerTwo
  "Validates lead/lag and lead/standby equipment rotation controller for two devices or groups of devices"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo
    leaLag(
    final lag=true,
    final minLim=false)
    "Lead/lag rotation"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo
    leaLag1(
    final lag=true,
    final minLim=false)
    "Lead/lag rotation"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo
    leaSta(
    final lag=false,
    final minLim=false)
    "Lead/lag rotation"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo
    conLeaSimSta(
    final lag=false,
    final continuous=true,
    final weeInt=false,
    final rotationPeriod=1800,
    final houOfDay=2,
    final weeCou=1,
    final weekday=6,
    final dayCou=3)
    "Lead/standby rotation for continuously operating device. Rotation time is measured from simulation start"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo
    conLeaSch(
    final lag=false,
    final continuous=true,
    final minLim=false,
    final simTimSta=false,
    final weeInt=false,
    final zerTim=Buildings.Controls.OBC.CDL.Types.ZeroTime.Custom,
    final yearRef=2020,
    final houOfDay=2,
    final weekday=3,
    final dayCou=1)
    "Lead/standby rotation for continuous operation"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1[2](
    final delayTime={300,400},
    final delayOnInit={true,true})
    "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel[2](
    final delayTime={600,600},
    final delayOnInit={true,true})
    "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[2]
    "Boolean pre"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2]
    "Boolean pre"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad(
    final width=0.8,
    final period(displayUnit="s") = 7200)
    "Lead device ON/OFF status"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad(
    final width=0.2,
    final period=3600)
    "Lag device ON/OFF status"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad1(
    final width=0.2,
    final period=5400)
    "Lag device ON/OFF status"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2[2](
    final delayTime={600,600},
    final delayOnInit={true,true})
    "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2]
    "Boolean pre"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

equation
  connect(conLeaSimSta.yDevStaSet, truDel1.u) annotation (Line(points={{2,-24},{
          10,-24},{10,-30},{18,-30}}, color={255,0,255}));
  connect(leadLoad.y, leaLag.uLeaStaSet) annotation (Line(points={{-78,90},{-50,
          90},{-50,96},{-22,96}}, color={255,0,255}));
  connect(lagLoad.y, leaLag.uLagStaSet) annotation (Line(points={{-78,50},{-40,50},
          {-40,90},{-22,90}}, color={255,0,255}));
  connect(leadLoad.y, leaSta.uLeaStaSet) annotation (Line(points={{-78,90},{-70,
          90},{-70,16},{-22,16}}, color={255,0,255}));
  connect(lagLoad1.y, leaLag1.uLagStaSet) annotation (Line(points={{-78,10},{-32,
          10},{-32,50},{-22,50}},  color={255,0,255}));
  connect(leadLoad.y, leaLag1.uLeaStaSet) annotation (Line(points={{-78,90},{-50,
          90},{-50,56},{-22,56}}, color={255,0,255}));
  connect(leaSta.yDevStaSet, truDel.u) annotation (Line(points={{2,16},{10,16},{
          10,10},{18,10}},    color={255,0,255}));
  connect(leaLag.yDevStaSet, leaLag.uDevSta) annotation (Line(points={{2,96},{20,
          96},{20,70},{-30,70},{-30,84},{-22,84}},    color={255,0,255}));
  connect(leaLag1.yDevStaSet, leaLag1.uDevSta) annotation (Line(points={{2,56},{
          20,56},{20,32},{-28,32},{-28,44},{-22,44}},  color={255,0,255}));
  connect(truDel1.y, pre.u)
    annotation (Line(points={{42,-30},{58,-30}}, color={255,0,255}));
  connect(pre.y, conLeaSimSta.uDevSta) annotation (Line(points={{82,-30},{90,-30},
          {90,-50},{-30,-50},{-30,-36},{-22,-36}}, color={255,0,255}));
  connect(truDel.y, pre1.u)
    annotation (Line(points={{42,10},{58,10}},   color={255,0,255}));
  connect(pre1.y, leaSta.uDevSta) annotation (Line(points={{82,10},{90,10},{90,-10},
          {-28,-10},{-28,4},{-22,4}},             color={255,0,255}));
  connect(conLeaSch.yDevStaSet, truDel2.u) annotation (Line(points={{2,-64},{10,
          -64},{10,-70},{18,-70}}, color={255,0,255}));
  connect(truDel2.y, pre2.u)
    annotation (Line(points={{42,-70},{58,-70}}, color={255,0,255}));
  connect(pre2.y, conLeaSch.uDevSta) annotation (Line(points={{82,-70},{90,-70},
          {90,-90},{-30,-90},{-30,-76},{-22,-76}}, color={255,0,255}));
          annotation (
   experiment(StopTime=100000.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/EquipmentRotation/Validation/ControllerTwo.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end ControllerTwo;
