within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Validation;
model ZoneQualification "Zone qualification"

  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneQualification zonQua(
    dTSheThr=0.5,
    dTSheHys=0.5,
    PBuiHys=50,
    TResInt=0.5,
    airConMod=true,
    use_demCon=true,
    nZon=5)
    "Zone qualification block"
    annotation (Placement(transformation(extent={{60,-18},{80,18}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant rouZonFla1234[4](
    k=fill(false, 4))
    "Rogue zone flags for Zone 1 through 4"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse rouZonFla5(
    period=172800)
    "Rogue zone flag for Zone 5"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant PBuiThrVal(
    k=500)
    "Threshold value for the electricity demand of the building"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin PBuiVal(
    amplitude=100,
    freqHz=1/86400,
    offset=500) "Value for the electricity demand of the building"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonVal[5](
    k={273.15 + 17,273.15 + 23,273.15 + 15,273.15 + 12,273.15 + 13})
    "Zone temperature values for Zone 1 through 5"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonSetVal[5](
    k=fill(273.15 + 20, 5))
    "Zone temperature setpoint values for Zone 1 through 5"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TPreTarSetVal[5](
    k=fill(273.15 + 21.5, 5))
    "Pre-heat target temperature setpoint value"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSheTarSetVal[5](
    k=fill(273.15 + 16, 5))
    "Load-shed target temperature setpoint value"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDefSetVal[5](
    k=fill(273.15 + 20, 5))
    "Default temperature setpoint value"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable tabDemFleMod(
    table=[0,1; 14,0; 16,2; 21,3; 23,1; 24,1],
    timeScale=3600,
    period=86400)
    "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(rouZonFla1234.y, zonQua.rouZonFla[1:4])
    annotation (Line(points={{-58,190},{40,190},{40,16.4},{58,16.4}},
      color={255,0,255}));
  connect(rouZonFla5.y, zonQua.rouZonFla[5])
    annotation (Line(points={{-58,150},{40,150},{40,16.8},{58,16.8}},
      color={255,0,255}));
  connect(PBuiThrVal.y, zonQua.PBuiThr)
    annotation (Line(points={{-58,70},{0,70},{0,8},{58,8}}, color={0,0,127}));
  connect(PBuiVal.y, zonQua.PBui)
    annotation (Line(points={{-58,110},{20,110},{20,12},{58,12}}, color={0,0,127}));
  connect(TZonVal.y, zonQua.TZon)
    annotation (Line(points={{-58,30},{-20,30},{-20,4},{58,4}}, color={0,0,127}));
  connect(TZonSetVal.y, zonQua.TZonSet)
    annotation (Line(points={{-58,-10},{-40,-10},{-40,0},{58,0}}, color={0,0,127}));
  connect(TPreTarSetVal.y, zonQua.TPreTarSet)
    annotation (Line(points={{-58,-90},{0,-90},{0,-8},{58,-8}}, color={0,0,127}));
  connect(TSheTarSetVal.y, zonQua.TSheTarSet)
    annotation (Line(points={{-58,-130},{20,-130},{20,-12},{58,-12}},
      color={0,0,127}));
  connect(TDefSetVal.y, zonQua.TDefSet)
    annotation (Line(points={{-58,-170},{40,-170},{40,-16},{58,-16}},
      color={0,0,127}));
  connect(tabDemFleMod.y[1], zonQua.demFleMod)
    annotation (Line(points={{-58,-50},{-20,-50},{-20,-4},{58,-4}},
      color={255,127,0}));
annotation (experiment(StopTime=172800, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SetpointResolution.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneQualification\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneQualification</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-220},{100,220}})));
end ZoneQualification;
