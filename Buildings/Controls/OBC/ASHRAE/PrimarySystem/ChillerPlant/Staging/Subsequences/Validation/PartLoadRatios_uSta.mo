within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model PartLoadRatios_uSta
  "Validates the operating and stage part load ratios calculation"

//protected
  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Real aveVChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") = 0.05
    "Average measured chilled water flow rate";

  PartLoadRatios staChaPosDis(chiStaTyp={2,2})
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Capacities staCap(
    numSta=2,
    staNomCap={10,30},
    minStaUnlCap={2,6})
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  CDL.Integers.Sources.Constant staSig1(k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Continuous.Sources.Constant capReq(k=5) "Capacity requirement"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation

  connect(staSig1.y, staChaPosDis.uSta) annotation (Line(points={{-59,70},{-30,
          70},{-30,79},{19,79}}, color={255,127,0}));
  connect(capReq.y, staChaPosDis.uCapReq) annotation (Line(points={{-19,40},{
          -10,40},{-10,77},{19,77}}, color={0,0,127}));
  connect(staCap.yStaNom, staChaPosDis.uStaCapNom) annotation (Line(points={{
          -19,7},{-8,7},{-8,75},{19,75}}, color={0,0,127}));
  connect(staCap.yStaUpNom, staChaPosDis.uStaUpCapNom) annotation (Line(points=
          {{-19,3},{-6,3},{-6,73},{19,73}}, color={0,0,127}));
  connect(staCap.yStaDowNom, staChaPosDis.uStaDowCapNom) annotation (Line(
        points={{-19,-1},{-4,-1},{-4,71},{19,71}}, color={0,0,127}));
  connect(staCap.yStaUpMin, staChaPosDis.uStaUpCapMin) annotation (Line(points=
          {{-19,-6},{-2,-6},{-2,69},{19,69}}, color={0,0,127}));
  connect(staCap.yStaMin, staChaPosDis.uStaCapMin) annotation (Line(points={{
          -19,-8},{0,-8},{0,67},{19,67}}, color={0,0,127}));
  connect(staSig1.y, staCap.uSta) annotation (Line(points={{-59,70},{-50,70},{
          -50,0},{-42,0}}, color={255,127,0}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/CapacityRequirement.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false)));
end PartLoadRatios_uSta;
