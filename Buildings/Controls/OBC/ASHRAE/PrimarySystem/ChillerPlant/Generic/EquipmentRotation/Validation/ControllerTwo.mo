within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Validation;
model ControllerTwo "Validate lead/lag and lead/standby switching"

  parameter Boolean initRoles[2] = {true, false}
    "Sets initial roles: true = lead, false = lag or standby";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo
    leaLag(lag=true) "Lead/lag rotation"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo
    leaSta(lag=false) "Lead/standby rotation"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo
    conLea(lag=false, continuous=true)
    "Lead/standby rotation for continuously operating devices"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo
    leaLag1(lag=true) "Lead/lag rotation"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Logical.TrueDelay truDel[2](delayTime={900,900}, delayOnInit={true,true})
    "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  CDL.Logical.TrueDelay truDel1[2](delayTime={900,900}, delayOnInit={true,true})
    "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Logical.TrueDelay truDel2[2](delayTime={900,900}, delayOnInit={true,true})
    "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  CDL.Logical.TrueDelay truDel3[2](delayTime={900,900}, delayOnInit={true,true})
    "Emulates device start-up time"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  CDL.Logical.Pre pre[2](pre_u_start={false,false}) "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  CDL.Logical.Pre pre1[2](pre_u_start={false,false}) "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  CDL.Logical.Pre pre2[2](pre_u_start={false,false}) "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  CDL.Logical.Pre pre3[2](pre_u_start={false,false}) "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad(
    final width=0.8,
    final period=2*60*60) "Lead device on/off status"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad(
    final width=0.2,
    final period=1*60*60)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad1(final width=0.2,
      final period=1.5*60*60)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
equation
  connect(truDel.y, pre.u)
    annotation (Line(points={{42,70},{58,70}}, color={255,0,255}));
  connect(truDel1.y, pre1.u)
    annotation (Line(points={{42,30},{58,30}}, color={255,0,255}));
  connect(truDel2.y, pre2.u)
    annotation (Line(points={{42,-10},{58,-10}}, color={255,0,255}));
  connect(truDel3.y, pre3.u)
    annotation (Line(points={{42,-50},{58,-50},{58,-50}}, color={255,0,255}));
  connect(leaLag.yDevStaSet, truDel.u) annotation (Line(points={{1,76},{10,76},{
          10,70},{18,70}}, color={255,0,255}));
  connect(leaLag1.yDevStaSet, truDel1.u) annotation (Line(points={{1,36},{10,36},
          {10,30},{18,30}}, color={255,0,255}));
  connect(leaSta.yDevStaSet, truDel2.u) annotation (Line(points={{1,-4},{12,-4},
          {12,-10},{18,-10}}, color={255,0,255}));
  connect(conLea.yDevStaSet, truDel3.u) annotation (Line(points={{1,-44},{10,-44},
          {10,-50},{18,-50}}, color={255,0,255}));
  connect(pre.y, leaLag.uDevSta) annotation (Line(points={{82,70},{92,70},{92,54},
          {-30,54},{-30,64},{-22,64}}, color={255,0,255}));
  connect(leadLoad.y, leaLag.uLeaStaSet) annotation (Line(points={{-78,70},{-50,
          70},{-50,76},{-22,76}}, color={255,0,255}));
  connect(lagLoad.y, leaLag.uLagStaSet) annotation (Line(points={{-78,30},{-40,30},
          {-40,70},{-22,70}}, color={255,0,255}));
  connect(pre1.y, leaLag1.uDevSta) annotation (Line(points={{82,30},{90,30},{90,
          12},{-30,12},{-30,24},{-22,24}}, color={255,0,255}));
  connect(pre2.y, leaSta.uDevSta) annotation (Line(points={{82,-10},{90,-10},{90,
          -30},{-30,-30},{-30,-16},{-22,-16}}, color={255,0,255}));
  connect(pre3.y, conLea.uDevSta) annotation (Line(points={{82,-50},{90,-50},{90,
          -70},{-30,-70},{-30,-56},{-22,-56}}, color={255,0,255}));
  connect(leadLoad.y, leaSta.uLeaStaSet) annotation (Line(points={{-78,70},{-70,
          70},{-70,-4},{-22,-4}}, color={255,0,255}));
  connect(lagLoad1.y, leaLag1.uLagStaSet) annotation (Line(points={{-78,-10},{-32,
          -10},{-32,30},{-22,30}}, color={255,0,255}));
  connect(leadLoad.y, leaLag1.uLeaStaSet) annotation (Line(points={{-78,70},{-50,
          70},{-50,36},{-22,36}}, color={255,0,255}));
          annotation (
   experiment(StopTime=1000000.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/EquipmentRotation/Subsequences/Validation/ControllerTwo.mos"
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
