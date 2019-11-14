within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Validation;
model ControllerTwo "Validates lead/lag and lead/standby equipment rotation controller for two devices or groups of devices"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo
    leaLag(
    final lag=true,
    final stagingRuntime=43200) "Lead/lag rotation"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo
    leaLag1(
    final lag=true,
    final stagingRuntime=54000) "Lead/lag rotation"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo
    leaSta(
    final lag=false,
    final stagingRuntime=43200) "Lead/standby rotation"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo
    conLea(
    final lag=false,
    final continuous=true,
    final weeInt=false,
    final houOfDay=2,
    final weeCou=1,
    final weekday=6,
    final dayCou=3) "Lead/standby rotation for continuously operating devices"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1[2](
    final delayTime={600,600},
    final delayOnInit={true,true})
    "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel[2](
    final delayTime={600,600},
    final delayOnInit={true,true}) "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[2] "Boolean pre"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2] "Boolean pre"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad(
    final width=0.8,
    final period=7200) "Lead device ON/OFF status"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad(
    final width=0.2,
    final period=3600) "Lag device ON/OFF status"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad1(
    final width=0.2,
    final period=5400) "Lag device ON/OFF status"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

equation
  connect(conLea.yDevStaSet,truDel1. u) annotation (Line(points={{1,-54},{10,
          -54},{10,-60},{18,-60}}, color={255,0,255}));
  connect(leadLoad.y, leaLag.uLeaStaSet) annotation (Line(points={{-78,70},{-50,
          70},{-50,76},{-22,76}}, color={255,0,255}));
  connect(lagLoad.y, leaLag.uLagStaSet) annotation (Line(points={{-78,30},{-40,30},
          {-40,70},{-22,70}}, color={255,0,255}));
  connect(leadLoad.y, leaSta.uLeaStaSet) annotation (Line(points={{-78,70},{-70,
          70},{-70,-4},{-22,-4}}, color={255,0,255}));
  connect(lagLoad1.y, leaLag1.uLagStaSet) annotation (Line(points={{-78,-10},{-32,
          -10},{-32,30},{-22,30}}, color={255,0,255}));
  connect(leadLoad.y, leaLag1.uLeaStaSet) annotation (Line(points={{-78,70},{-50,
          70},{-50,36},{-22,36}}, color={255,0,255}));
  connect(leaSta.yDevStaSet, truDel.u) annotation (Line(points={{1,-4},{10,-4},
          {10,-10},{18,-10}}, color={255,0,255}));
  connect(leaLag.yDevStaSet, leaLag.uDevSta) annotation (Line(points={{1,76},{
          20,76},{20,50},{-30,50},{-30,64},{-22,64}}, color={255,0,255}));
  connect(leaLag1.yDevStaSet, leaLag1.uDevSta) annotation (Line(points={{1,36},
          {20,36},{20,12},{-28,12},{-28,24},{-22,24}}, color={255,0,255}));
  connect(truDel1.y, pre.u)
    annotation (Line(points={{42,-60},{58,-60}}, color={255,0,255}));
  connect(pre.y, conLea.uDevSta) annotation (Line(points={{82,-60},{90,-60},{90,
          -80},{-30,-80},{-30,-66},{-22,-66}}, color={255,0,255}));
  connect(truDel.y, pre1.u)
    annotation (Line(points={{42,-10},{58,-10}}, color={255,0,255}));
  connect(pre1.y, leaSta.uDevSta) annotation (Line(points={{82,-10},{90,-10},{
          90,-30},{-28,-30},{-28,-16},{-22,-16}}, color={255,0,255}));
          annotation (
   experiment(StopTime=1000000.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/EquipmentRotation/Validation/ControllerTwo.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})));
end ControllerTwo;
