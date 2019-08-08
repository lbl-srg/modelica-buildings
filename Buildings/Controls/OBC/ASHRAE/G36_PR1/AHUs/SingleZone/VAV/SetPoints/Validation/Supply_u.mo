within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Validation;
model Supply_u "Validation model for control input"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV(
    yHeaMax=0.7,
    yMin=0.3,
    TSupSetMax=303.15,
    TSupSetMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV1(
    yHeaMax=0.7,
    yMin=0.3,
    TSupSetMax=303.15,
    TSupSetMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV2(
    yHeaMax=0.7,
    yMin=0.3,
    TSupSetMax=303.15,
    TSupSetMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(k=273.15 + 28)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(k=273.15 + 22)
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uHea(
    duration=0.25,
    height=-1,
    offset=1) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    duration=0.25,
    startTime=0.75)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonSet(k=273.15 + 23)
    "Average zone set point"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  CDL.Continuous.Sources.Constant TZon1(k=273.15 + 23)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Logical.Sources.Constant fanSta(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
equation
  connect(TZon.y, setPoiVAV.TZon) annotation (Line(
      points={{-59,-10},{-31.5,-10},{-31.5,48},{-2,48}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-59,-40},{-24,-40},
          {-24,44},{-2,44}},color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-59,80},{-12,80},{
          -12,60},{-2,60}},
                        color={0,0,127}));
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-59,50},{-16,50},{
          -16,56},{-2,56}},
                        color={0,0,127}));
  connect(TZonSet.y,setPoiVAV.TZonSet)  annotation (Line(points={{-59,20},{-10,
          20},{-10,52},{-2,52}},
                             color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TOut) annotation (Line(points={{-59,-40},{-24,-40},
          {-24,4},{-2,4}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV1.uHea) annotation (Line(points={{-59,80},{-12,80},{
          -12,20},{-2,20}},
                        color={0,0,127}));
  connect(uCoo.y, setPoiVAV1.uCoo) annotation (Line(points={{-59,50},{-16,50},{
          -16,16},{-2,16}},
                        color={0,0,127}));
  connect(TZonSet.y,setPoiVAV1.TZonSet)  annotation (Line(points={{-59,20},{-10,
          20},{-10,12},{-2,12}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV2.TOut)
    annotation (Line(points={{-59,-40},{-24,-40},{-24,-36},{-2,-36}},
                                                  color={0,0,127}));
  connect(uHea.y, setPoiVAV2.uHea) annotation (Line(points={{-59,80},{-12,80},{
          -12,-20},{-2,-20}},
                          color={0,0,127}));
  connect(uCoo.y, setPoiVAV2.uCoo) annotation (Line(points={{-59,50},{-16,50},{
          -16,-24},{-2,-24}},
                          color={0,0,127}));
  connect(TZonSet.y,setPoiVAV2.TZonSet)  annotation (Line(points={{-59,20},{-10,
          20},{-10,-28},{-2,-28}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TZon) annotation (Line(
      points={{-59,-40},{-24,-40},{-24,8},{-2,8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TZon1.y, setPoiVAV2.TZon) annotation (Line(
      points={{-59,-70},{-20,-70},{-20,-32},{-2,-32}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(fanSta.y, setPoiVAV.uFan) annotation (Line(points={{-59,-100},{-6,-100},
          {-6,40},{-2,40}}, color={255,0,255}));
  connect(setPoiVAV1.uFan, setPoiVAV.uFan) annotation (Line(points={{-2,0},{-6,
          0},{-6,40},{-2,40}}, color={255,0,255}));
  connect(setPoiVAV2.uFan, setPoiVAV.uFan) annotation (Line(points={{-2,-40},{
          -6,-40},{-6,40},{-2,40}}, color={255,0,255}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/Validation/Supply_u.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply</a>
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
