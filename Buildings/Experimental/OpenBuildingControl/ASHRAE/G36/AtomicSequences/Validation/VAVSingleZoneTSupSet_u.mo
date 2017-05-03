within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model VAVSingleZoneTSupSet_u "Validation model for control input"
  extends Modelica.Icons.Example;

  AtomicSequences.VAVSingleZoneTSupSet setPoiVAV(
    yHeaMax=0.7,
    yMin=0.3,
    TMax=303.15,
    TMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  CDL.Continuous.Constant TZon(k=273.15 + 23) "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));

  CDL.Continuous.Constant TOut(k=273.15 + 21) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-62},{-60,-40}})));

  Modelica.Blocks.Sources.Ramp uHea(
    duration=0.25,
    height=-1,
    offset=1) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Modelica.Blocks.Sources.Ramp uCoo(duration=0.25, startTime=0.75)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,38},{-60,58}})));

  CDL.Continuous.Constant TSetZon(k=273.15 + 22) "Average zone set point"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
equation
  connect(TZon.y, setPoiVAV.TZon) annotation (Line(points={{-59,-16},{-31.5,-16},
          {-31.5,-4},{-2,-4}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-59,-51},{-24,-51},{
          -24,-8},{-2,-8}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-59,80},{-12,80},{
          -12,8},{-2,8}},
                      color={0,0,127}));
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-59,48},{-59,50},{
          -16,50},{-16,4},{-2,4}},
                               color={0,0,127}));
  connect(TSetZon.y, setPoiVAV.TSetZon) annotation (Line(points={{-59,16},{-20,
          16},{-20,0},{-2,0}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/VAVSingleZoneTSupSet_u.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.VAVSingleZoneTSupSet\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.VAVSingleZoneTSupSet</a>
for different control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVSingleZoneTSupSet_u;
