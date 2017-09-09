within Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.Validation;
model VAVSingleZoneTSupSet_T
  "Validation model for outdoor minus room air temperature"
  extends Modelica.Icons.Example;

  VAVSingleZoneTSupSet setPoiVAV(
    yHeaMax=0.7,
    yMin=0.3,
    TMax=303.15,
    TMin=289.15,
    yCooMax=0.9)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  CDL.Continuous.Sources.Constant uHea(k=0) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  CDL.Continuous.Sources.Constant uCoo(k=0.6) "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  CDL.Continuous.Sources.Ramp TOut(
    duration=1,
    height=18,
    offset=273.15 + 10) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  CDL.Continuous.Sources.Constant TZon(k=273.15 + 22) "Zone temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Add dT(k2=-1) "Difference zone minus outdoor temperature"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  CDL.Continuous.Sources.Constant TSetZon(k=273.15 + 22) "Average zone set point"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
equation
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-59,50},{-31.5,50},
          {-31.5,4},{-2,4}},color={0,0,127}));
  connect(TZon.y, setPoiVAV.TZon) annotation (Line(points={{-59,-10},{-32,-10},{
          -32,-4},{-2,-4}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-59,-50},{-28,-50},{
          -28,-8},{-2,-8}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-59,80},{-59,80},{
          -20,80},{-20,8},{-2,8}},
                               color={0,0,127}));
  connect(dT.u1, TZon.y) annotation (Line(points={{-2,-34},{-32,-34},{-32,-10},{
          -59,-10}}, color={0,0,127}));
  connect(dT.u2, TOut.y) annotation (Line(points={{-2,-46},{-28,-46},{-28,-50},{
          -59,-50}}, color={0,0,127}));
  connect(TSetZon.y, setPoiVAV.TSetZon) annotation (Line(points={{-59,20},{-40,
          20},{-40,0},{-2,0}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHU/SetPoints/Validation/VAVSingleZoneTSupSet_T.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.VAVSingleZoneTSupSet\">
Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.VAVSingleZoneTSupSet</a>
for a change in temperature difference between zone air and outdoor air.
Hence, this model validates whether the adjustment of the fan speed for medium
cooling load is correct implemented.
</p>
</html>", revisions="<html>
<ul>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVSingleZoneTSupSet_T;
