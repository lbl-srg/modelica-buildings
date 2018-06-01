within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.Validation;
model VAVSupply_u "Validation model for control input"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.VAVSupply setPoiVAV(
    yHeaMax=0.7,
    yMin=0.3,
    TMax=303.15,
    TMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.VAVSupply setPoiVAV1(
    yHeaMax=0.7,
    yMin=0.3,
    TMax=303.15,
    TMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.VAVSupply setPoiVAV2(
    yHeaMax=0.7,
    yMin=0.3,
    TMax=303.15,
    TMin=289.15)
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetZon(k=273.15 + 23)
    "Average zone set point"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  CDL.Continuous.Sources.Constant TZon1(k=273.15 + 23)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(TZon.y, setPoiVAV.TZon) annotation (Line(
      points={{-59,-10},{-31.5,-10},{-31.5,46},{-2,46}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-59,-40},{-24,-40},
          {-24,42},{-2,42}},color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-59,80},{-12,80},{
          -12,58},{-2,58}},
                        color={0,0,127}));
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-59,50},{-16,50},{
          -16,54},{-2,54}},
                        color={0,0,127}));
  connect(TSetZon.y, setPoiVAV.TSetZon) annotation (Line(points={{-59,20},{-10,
          20},{-10,50},{-2,50}},
                             color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TOut) annotation (Line(points={{-59,-40},{-24,-40},
          {-24,2},{-2,2}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV1.uHea) annotation (Line(points={{-59,80},{-12,80},{
          -12,18},{-2,18}},
                        color={0,0,127}));
  connect(uCoo.y, setPoiVAV1.uCoo) annotation (Line(points={{-59,50},{-16,50},{
          -16,14},{-2,14}},
                        color={0,0,127}));
  connect(TSetZon.y, setPoiVAV1.TSetZon) annotation (Line(points={{-59,20},{-10,
          20},{-10,10},{-2,10}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV2.TOut)
    annotation (Line(points={{-59,-40},{-24,-40},{-24,-38},{-2,-38}},
                                                  color={0,0,127}));
  connect(uHea.y, setPoiVAV2.uHea) annotation (Line(points={{-59,80},{-12,80},{
          -12,-22},{-2,-22}},
                          color={0,0,127}));
  connect(uCoo.y, setPoiVAV2.uCoo) annotation (Line(points={{-59,50},{-16,50},{
          -16,-26},{-2,-26}},
                          color={0,0,127}));
  connect(TSetZon.y, setPoiVAV2.TSetZon) annotation (Line(points={{-59,20},{-10,
          20},{-10,-30},{-2,-30}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TZon) annotation (Line(
      points={{-59,-40},{-24,-40},{-24,6},{-2,6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TZon1.y, setPoiVAV2.TZon) annotation (Line(
      points={{-59,-70},{-20,-70},{-20,-34},{-2,-34}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/SetPoints/Validation/VAVSupply_u.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.VAVSupply\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.VAVSupply</a>
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
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end VAVSupply_u;
