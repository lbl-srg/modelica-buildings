within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Validation;
model ZoneQualification "Zone qualification"

  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneQualification
    zonQua(
    dTSheThr=0.5,
    dTSheHys=0.5,
    PBuiHys=50,
    TResInt=0.5,
    airConMod=true,
    use_demCon=true,
    nZon=5) annotation (Placement(transformation(extent={{20,-18},{40,18}})));
  CDL.Logical.Sources.Constant                        con3[4](k=fill(false, 4))
    "A vector of four false boolean constants"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  CDL.Logical.Sources.Pulse                        booPul(period=172800)
    "True for half a second, false for the other half second"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Reals.Sources.Constant con(k=500)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Reals.Sources.Sin sin(
    amplitude=100,
    freqHz=1/86400,
    offset=500)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  CDL.Reals.Sources.Constant                        con2[5](k={273.15 + 17,
        273.15 + 23,273.15 + 15,273.15 + 12,273.15 + 13})
    "A vector of four real constants"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  CDL.Reals.Sources.Constant                        con1[5](k=fill(273.15 + 20,
        5))
    "A vector of four real constants"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Reals.Sources.Constant con4[5](k=fill(273.15 + 21.5, 5))
    annotation (Placement(transformation(extent={{-74,-56},{-54,-36}})));
  CDL.Reals.Sources.Constant con5[5](k=fill(273.15 + 16, 5))
    annotation (Placement(transformation(extent={{-42,-74},{-22,-54}})));
  CDL.Reals.Sources.Constant con6[5](k=fill(273.15 + 20, 5))
    annotation (Placement(transformation(extent={{-16,-98},{4,-78}})));
  CDL.Integers.Sources.TimeTable                        tabDemFleMod(
    table=[0,1; 14,0; 16,2; 21,3; 23,1; 24,1],
    timeScale=3600,
    period=86400)
    "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-48,-38},{-28,-18}})));
equation
  connect(con3.y, zonQua.rouZonFla[1:4]) annotation (Line(points={{-18,90},{0,
          90},{0,16.4},{18,16.4}},
                               color={255,0,255}));
  connect(booPul.y, zonQua.rouZonFla[5]) annotation (Line(points={{-58,70},{0,
          70},{0,16.8},{18,16.8}},   color={255,0,255}));
  connect(con.y, zonQua.PBuiThr)
    annotation (Line(points={{-58,30},{0,30},{0,8},{18,8}}, color={0,0,127}));
  connect(sin.y, zonQua.PBui) annotation (Line(points={{-18,50},{-10,50},{-10,
          12},{18,12}}, color={0,0,127}));
  connect(con2.y, zonQua.TZon)
    annotation (Line(points={{-18,10},{0,10},{0,4},{18,4}}, color={0,0,127}));
  connect(con1.y, zonQua.TZonSet) annotation (Line(points={{-58,-10},{-10,-10},
          {-10,0},{18,0}}, color={0,0,127}));
  connect(con4.y, zonQua.TPreTarSet) annotation (Line(points={{-52,-46},{-18,
          -46},{-18,-8},{18,-8}}, color={0,0,127}));
  connect(con5.y, zonQua.TSheTarSet) annotation (Line(points={{-20,-64},{-2,-64},
          {-2,-12},{18,-12}}, color={0,0,127}));
  connect(con6.y, zonQua.TDefSet) annotation (Line(points={{6,-88},{14,-88},{14,
          -16},{18,-16}}, color={0,0,127}));
  connect(tabDemFleMod.y[1], zonQua.demFleMod) annotation (Line(points={{-26,
          -28},{-4,-28},{-4,-4},{18,-4}}, color={255,127,0}));
annotation (experiment(StopTime=172800, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SetpointResolution.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution</a>.
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
      extent={{-100,-100},{100,100}})));
end ZoneQualification;
