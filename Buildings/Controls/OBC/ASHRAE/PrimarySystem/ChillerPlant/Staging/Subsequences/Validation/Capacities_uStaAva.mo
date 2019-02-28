within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Capacities_uStaAva
  "Validate stage capacities sequence for stage availability inputs"

  parameter Integer nSta = 3
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 5e5, 5e5}
    "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2], 0.2*staNomCap[2]}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Large number for numerical consistency";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap[nSta + 2](
      final k={small,5e5,5e5,1e6,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload[nSta + 2](
    final k= {0,1e5,1e5,2e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage3(k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  CDL.Logical.Sources.Constant con[nSta](k={true,false,true})
    "Stage availability array"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation

  connect(stage3.y, staCap.uSta)
    annotation (Line(points={{-59,40},{-42,40}}, color={255,127,0}));
  connect(staCap.yStaNom, absErrorSta[1].u1) annotation (Line(points={{-19,47},{
          40,47},{40,60},{58,60}}, color={0,0,127}));
  connect(staCap.yStaDowNom, absErrorSta[2].u1) annotation (Line(points={{-19,39},
          {40,39},{40,60},{58,60}}, color={0,0,127}));
  connect(staCap.yStaUpNom, absErrorSta[3].u1) annotation (Line(points={{-19,43},
          {40,43},{40,60},{58,60}}, color={0,0,127}));
  connect(staCap.yStaMin, absErrorSta[4].u1) annotation (Line(points={{-19,32},{
          40,32},{40,60},{58,60}}, color={0,0,127}));
  connect(staCap.yStaUpMin, absErrorSta[5].u1) annotation (Line(points={{-19,34},
          {40,34},{40,60},{58,60}}, color={0,0,127}));
  connect(con.y, staCap.uStaAva) annotation (Line(points={{-59,-30},{-50,-30},{-50,
          34},{-42,34}}, color={255,0,255}));
  connect(nomStaCap[4].y, absErrorSta[1].u2)
    annotation (Line(points={{21,10},{70,10},{70,48}}, color={0,0,127}));
  connect(nomStaCap[3].y, absErrorSta[2].u2) annotation (Line(points={{21,10},{
          68,10},{68,40},{70,40},{70,48}}, color={0,0,127}));
  connect(nomStaCap[5].y, absErrorSta[3].u2) annotation (Line(points={{21,10},{
          72,10},{72,40},{70,40},{70,48}}, color={0,0,127}));
  connect(minStaUnload[4].y, absErrorSta[4].u2) annotation (Line(points={{21,
          -50},{74,-50},{74,40},{70,40},{70,48}}, color={0,0,127}));
  connect(minStaUnload[5].y, absErrorSta[5].u2) annotation (Line(points={{21,
          -50},{76,-50},{76,40},{70,40},{70,48}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Capacities_uStaAva.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-80},{100,80}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})));
end Capacities_uStaAva;
