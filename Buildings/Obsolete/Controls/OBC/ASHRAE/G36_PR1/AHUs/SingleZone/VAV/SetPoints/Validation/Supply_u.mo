within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Validation;
model Supply_u "Validation model for temperature and fan speed"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV(
    yHeaMax=0.7,
    yMin=0.3,
    TSupSetMax=303.15,
    TSupSetMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV1(
    yHeaMax=0.7,
    yMin=0.3,
    TSupSetMax=303.15,
    TSupSetMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV2(
    yHeaMax=0.7,
    yMin=0.3,
    TSupSetMax=303.15,
    TSupSetMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon(k=273.15 + 28)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(k=273.15 + 22)
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uHea(
    duration=0.25,
    height=-1,
    offset=1) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uCoo(
    duration=0.25,
    startTime=0.75)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonSet(k=273.15 + 23)
    "Average zone set point"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon1(k=273.15 + 23)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(k=true)
    "Fan is on"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
equation
  connect(TZon.y, setPoiVAV.TZon) annotation (Line(
      points={{-58,-10},{-31.5,-10},{-31.5,48.3333},{-2,48.3333}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-58,-40},{-24,-40},{
          -24,45},{-2,45}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-58,80},{-12,80},{
          -12,58.3333},{-2,58.3333}},
                        color={0,0,127}));
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-58,50},{-16,50},{-16,
          55},{-2,55}}, color={0,0,127}));
  connect(TZonSet.y,setPoiVAV.TZonSet)  annotation (Line(points={{-58,20},{-10,
          20},{-10,51.6667},{-2,51.6667}},
                             color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TOut) annotation (Line(points={{-58,-40},{-24,-40},
          {-24,5},{-2,5}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV1.uHea) annotation (Line(points={{-58,80},{-12,80},{
          -12,18.3333},{-2,18.3333}},
                        color={0,0,127}));
  connect(uCoo.y, setPoiVAV1.uCoo) annotation (Line(points={{-58,50},{-16,50},{-16,
          15},{-2,15}}, color={0,0,127}));
  connect(TZonSet.y,setPoiVAV1.TZonSet)  annotation (Line(points={{-58,20},{-10,
          20},{-10,11.6667},{-2,11.6667}},
                                 color={0,0,127}));
  connect(TOut.y, setPoiVAV2.TOut)
    annotation (Line(points={{-58,-40},{-24,-40},{-24,-35},{-2,-35}},
                                                  color={0,0,127}));
  connect(uHea.y, setPoiVAV2.uHea) annotation (Line(points={{-58,80},{-12,80},{
          -12,-21.6667},{-2,-21.6667}},
                          color={0,0,127}));
  connect(uCoo.y, setPoiVAV2.uCoo) annotation (Line(points={{-58,50},{-16,50},{-16,
          -25},{-2,-25}}, color={0,0,127}));
  connect(TZonSet.y,setPoiVAV2.TZonSet)  annotation (Line(points={{-58,20},{-10,
          20},{-10,-28.3333},{-2,-28.3333}},
                                   color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TZon) annotation (Line(
      points={{-58,-40},{-24,-40},{-24,8.33333},{-2,8.33333}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TZon1.y, setPoiVAV2.TZon) annotation (Line(
      points={{-58,-70},{-20,-70},{-20,-31.6667},{-2,-31.6667}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(fanSta.y, setPoiVAV.uFan) annotation (Line(points={{-58,-100},{-6,
          -100},{-6,41.6667},{-2,41.6667}},
                            color={255,0,255}));
  connect(setPoiVAV1.uFan, setPoiVAV.uFan) annotation (Line(points={{-2,1.66667},
          {-6,1.66667},{-6,41.6667},{-2,41.6667}},
                               color={255,0,255}));
  connect(setPoiVAV2.uFan, setPoiVAV.uFan) annotation (Line(points={{-2,
          -38.3333},{-6,-38.3333},{-6,41.6667},{-2,41.6667}},
                                    color={255,0,255}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/Validation/Supply_u.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for different control signals.
Each controller is configured identical, but the input signal for <code>TZon</code> differs
in order to validate that the fan speed is increased correctly.
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2018, by Michael Wetter:<br/>
Updated test to verify fan speed calculation.
</li>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-120},{100,100}}),
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
    Diagram(coordinateSystem(extent={{-100,-120},{100,100}})));
end Supply_u;
