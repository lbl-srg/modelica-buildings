within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.Validation;
model VAVSupply_u "Validation model for control input"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.VAVSupply setPoiVAV(
    yHeaMax=0.7,
    yMin=0.3,
    TMax=303.15,
    TMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(
    k=273.15 + 23) "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-22},{-60,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(
    k=273.15 + 21) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-62},{-60,-40}})));

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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetZon(
    k=273.15 + 22) "Average zone set point"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
equation
  connect(TZon.y, setPoiVAV.TZon) annotation (Line(points={{-59,-11},{-31.5,-11},
          {-31.5,-4},{-2,-4}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-59,-51},{-24,-51},{
          -24,-8},{-2,-8}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-59,80},{-12,80},{
          -12,8},{-2,8}},
                      color={0,0,127}));
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-59,50},{-59,50},{
          -16,50},{-16,4},{-2,4}},
                               color={0,0,127}));
  connect(TSetZon.y, setPoiVAV.TSetZon) annotation (Line(points={{-59,20},{-20,
          20},{-20,0},{-2,0}}, color={0,0,127}));
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
</p>
</html>", revisions="<html>
<ul>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVSupply_u;
