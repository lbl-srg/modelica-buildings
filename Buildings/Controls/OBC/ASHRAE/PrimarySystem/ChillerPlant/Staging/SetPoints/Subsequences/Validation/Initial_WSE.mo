within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model Initial_WSE "Validate initial stage sequence for a plant with WSE"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial iniStaCol(
    final have_WSE=true) "Initial stage is the WSE only stage"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial iniStaHot(
    final have_WSE=true)
    "Initial stage is the lowest available chiller stage"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant lowAvaSta(
    final k=1)
    "Lowest chiller stage that is available "
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin outTemHot(
    final amplitude=8,
    final freqHz=1/(24*3600),
    final phase=-1.5707963267949,
    final offset=298.15)
    "Measured outdoor air wet bulb temperature on a hot day"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin outTemCol(
    final amplitude=8,
    final freqHz=1/(24*3600),
    final phase=-1.5707963267949,
    final offset=278.15)
    "Measured outdoor air wet bulb temperature on a cold day"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant tunPar(
    final k=0.06)
    "Assume a constant tuning parameter"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    final k=285.15)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaSta(
    final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=600,
    final delayOnInit=true) "True delay"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

equation
  connect(lowAvaSta.y,iniStaCol. uUp) annotation (Line(points={{-18,-50},{-10,-50},
          {-10,0},{-2,0}}, color={255,127,0}));
  connect(TChiWatSupSet.y,iniStaCol. TChiWatSupSet) annotation (Line(points={{-18,
          50},{-10,50},{-10,3},{-2,3}}, color={0,0,127}));
  connect(TChiWatSupSet.y, iniStaHot.TChiWatSupSet) annotation (Line(points={{-18,
          50},{-10,50},{-10,20},{50,20},{50,3},{58,3}}, color={0,0,127}));
  connect(tunPar.y,iniStaCol. uTunPar) annotation (Line(points={{-58,50},{-50,50},
          {-50,6},{-2,6}}, color={0,0,127}));
  connect(tunPar.y, iniStaHot.uTunPar) annotation (Line(points={{-58,50},{-50,50},
          {-50,16},{46,16},{46,6},{58,6}}, color={0,0,127}));
  connect(outTemHot.y, iniStaHot.TOutWet)
    annotation (Line(points={{42,50},{54,50},{54,9},{58,9}}, color={0,0,127}));
  connect(outTemCol.y, iniStaCol.TOutWet) annotation (Line(points={{-58,-10},{-30,
          -10},{-30,9},{-2,9}}, color={0,0,127}));
  connect(lowAvaSta.y, iniStaHot.uUp) annotation (Line(points={{-18,-50},{50,-50},
          {50,0},{58,0}}, color={255,127,0}));
  connect(plaSta.y, truDel.u)
    annotation (Line(points={{-98,-50},{-82,-50}}, color={255,0,255}));
  connect(truDel.y, iniStaCol.uPla) annotation (Line(points={{-58,-50},{-50,-50},
          {-50,-20},{-20,-20},{-20,-6},{-2,-6}}, color={255,0,255}));
  connect(truDel.y, iniStaHot.uPla) annotation (Line(points={{-58,-50},{-50,-50},
          {-50,-20},{40,-20},{40,-6},{58,-6}}, color={255,0,255}));

annotation (
 experiment(StopTime=86400.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/Initial_WSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial</a>
for chiller plants with WSE.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2020, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-80},{140,80}})));
end Initial_WSE;
