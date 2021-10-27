within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation;
model RotationController
  "Validation model for RotationController sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.RotationController
    rotCon(
    final lag=true,
    final minLim=false)
    "Scenario-1: Only lead device being enabled and disabled"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.RotationController
    rotCon1(
    final lag=true,
    final minLim=false)
    "Scenario-2: Lead device continuously enabled, lag device enabled and disabled"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel[2](final delayTime=fill(
        15, 2))
    "Delay representing component being enabled"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[2]
    "Logical Pre block"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Constant Boolean source"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=120,
    final shift=5)
    "Boolean pulse generator"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1[2](final delayTime=fill(
        15, 2))
    "Delay representing component being enabled"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2]
    "Logical Pre block"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=120,
    final shift=5)
    "Boolean pulse generator"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final period=1200,
    final shift=3)
    "Boolean pulse generator"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

equation
  connect(rotCon.yDevStaSet, truDel.u) annotation (Line(points={{-18,55},{-14,55},
          {-14,50},{-2,50}}, color={255,0,255}));
  connect(truDel.y, pre.u)
    annotation (Line(points={{22,50},{38,50}}, color={255,0,255}));
  connect(pre.y, rotCon.uDevSta) annotation (Line(points={{62,50},{70,50},{70,20},
          {-60,20},{-60,45},{-42,45}}, color={255,0,255}));
  connect(rotCon1.yDevStaSet, truDel1.u) annotation (Line(points={{-18,-25},{-14,
          -25},{-14,-30},{-2,-30}}, color={255,0,255}));
  connect(truDel1.y, pre1.u)
    annotation (Line(points={{22,-30},{38,-30}}, color={255,0,255}));
  connect(pre1.y, rotCon1.uDevSta) annotation (Line(points={{62,-30},{70,-30},{70,
          -60},{-60,-60},{-60,-35},{-42,-35}}, color={255,0,255}));
  connect(booPul1.y, rotCon1.uDevStaSet[2]) annotation (Line(points={{-68,-50},{
          -64,-50},{-64,-25},{-42,-25}}, color={255,0,255}));
  connect(booPul.y, rotCon.uDevStaSet[1]) annotation (Line(points={{-68,30},{-64,
          30},{-64,55},{-42,55}}, color={255,0,255}));
  connect(con.y, rotCon.uDevStaSet[2]) annotation (Line(points={{-68,60},{-60,60},
          {-60,55},{-42,55}}, color={255,0,255}));
  connect(booPul2.y, rotCon1.uDevStaSet[1]) annotation (Line(points={{-68,-20},{
          -50,-20},{-50,-25},{-42,-25}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
      graphics={Ellipse(
                  lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-100,-100},{100,100}}),
                Polygon(
                  lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(
      preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=600,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/Validation/RotationController.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.RotationController\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.RotationController</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      April 12, 2021, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end RotationController;
