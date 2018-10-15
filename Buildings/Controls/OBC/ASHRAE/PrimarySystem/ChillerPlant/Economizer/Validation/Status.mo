within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Validation;
model Status
  "Validates the water side economizer enable/disable sequence"

  parameter Modelica.SIunits.Temperature TOutWetBul = 285.15
  "Average outdoor air wet bulb temperature";

  parameter Modelica.SIunits.Temperature TChiWatRet = 292.15
  "Chilled water retun temperature upstream of the WSE";

  parameter Modelica.SIunits.Temperature TWseOut = 290.15
  "Chilled water retun temperature downstream of the WSE";

  parameter Real VChiWat_flow(quantity="VolumeFlowRate", unit="m3/s") = 0.01
  "Measured chilled water return temperature";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Status
    wseSta "Water side economizer enable status sequence"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  CDL.Continuous.Sources.Constant
                              chiWatFlow(k=VChiWat_flow)
                            "Chilled water flow"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  CDL.Continuous.Sources.Constant
                              TOutWetSig(k=TOutWetBul)
                       "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Continuous.Sources.Constant constTowFanSig(k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Continuous.Sources.Constant
                              TChiWatRetSig(k=TChiWatRet)
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Continuous.Sources.Constant TChiWatRetDow(k=TWseOut)
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation

  connect(constTowFanSig.y, wseSta.uTowFanSpe) annotation (Line(points={{-59,-70},
          {-20,-70},{-20,2},{-2,2}}, color={0,0,127}));
  connect(TOutWetSig.y, wseSta.TOutWet) annotation (Line(points={{-59,70},{-20,70},
          {-20,18},{-2,18}}, color={0,0,127}));
  connect(TChiWatRetSig.y, wseSta.TChiWatRet) annotation (Line(points={{-59,40},
          {-40,40},{-40,14},{-2,14}}, color={0,0,127}));
  connect(chiWatFlow.y, wseSta.VChiWat_flow) annotation (Line(points={{-59,-30},
          {-30,-30},{-30,6},{-2,6}}, color={0,0,127}));
  connect(TChiWatRetDow.y, wseSta.TChiWatWseDow)
    annotation (Line(points={{-59,10},{-2,10}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Economizer/Validation/Status.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Status\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Status</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2018, by Milica Grahovac:<br/>
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
end Status;
