within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.Validation;
model ControllerTwo_MinimumLeadRuntime
  "Validates lead/lag and lead/standby equipment rotation controller for two devices or groups of devices"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo
    leaLag(
    final lag=true,
    minLim=true,
    final minLeaRuntime=43200) "Lead/lag rotation"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo
    leaLag1(
    final lag=true,
    minLim=true,
    final minLeaRuntime=54000) "Lead/lag rotation"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo
    leaSta(
    final lag=false,
    minLim=true,
    final minLeaRuntime=43200) "Lead/standby rotation"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel[2](
    final delayTime={600,600},
    final delayOnInit={true,true}) "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2] "Boolean pre"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad(
    final width=0.8,
    final period=7200) "Lead device ON/OFF status"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad(
    final width=0.2,
    final period=3600) "Lag device ON/OFF status"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad1(
    final width=0.2,
    final period=5400) "Lag device ON/OFF status"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

equation
  connect(leadLoad.y, leaLag.uLeaStaSet) annotation (Line(points={{-78,50},{-50,
          50},{-50,56},{-22,56}}, color={255,0,255}));
  connect(lagLoad.y, leaLag.uLagStaSet) annotation (Line(points={{-78,10},{-40,10},
          {-40,50},{-22,50}}, color={255,0,255}));
  connect(leadLoad.y, leaSta.uLeaStaSet) annotation (Line(points={{-78,50},{-70,
          50},{-70,-24},{-22,-24}},
                                  color={255,0,255}));
  connect(lagLoad1.y, leaLag1.uLagStaSet) annotation (Line(points={{-78,-30},{-32,
          -30},{-32,10},{-22,10}}, color={255,0,255}));
  connect(leadLoad.y, leaLag1.uLeaStaSet) annotation (Line(points={{-78,50},{-50,
          50},{-50,16},{-22,16}}, color={255,0,255}));
  connect(leaSta.yDevStaSet, truDel.u) annotation (Line(points={{2,-24},{10,-24},
          {10,-30},{18,-30}}, color={255,0,255}));
  connect(leaLag.yDevStaSet, leaLag.uDevSta) annotation (Line(points={{2,56},{20,
          56},{20,30},{-30,30},{-30,44},{-22,44}},    color={255,0,255}));
  connect(leaLag1.yDevStaSet, leaLag1.uDevSta) annotation (Line(points={{2,16},{
          20,16},{20,-8},{-28,-8},{-28,4},{-22,4}},    color={255,0,255}));
  connect(truDel.y, pre1.u)
    annotation (Line(points={{42,-30},{58,-30}}, color={255,0,255}));
  connect(pre1.y, leaSta.uDevSta) annotation (Line(points={{82,-30},{90,-30},{90,
          -50},{-28,-50},{-28,-36},{-22,-36}},    color={255,0,255}));
          annotation (
   experiment(StopTime=100000.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/EquipmentRotation/Validation/ControllerTwo_MinimumLeadRuntime.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-80},{120,80}})));
end ControllerTwo_MinimumLeadRuntime;
