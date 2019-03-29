within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Validation;
model ModeAndSetPoints
  "Validation models of reseting zone setpoint temperature"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints
    setPoi(
    final numZon=2,
    final cooAdj=true,
    final heaAdj=true)
    "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{28,-50},{48,-30}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints
    setPoi1(
    final numZon=2,
    final have_occSen=true,
    final have_winSen=true)
    "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{28,-80},{48,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine  heaSetAdj[2](
    each final freqHz=1/28800,
    each final amplitude=0.5)
    "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-38,-110},{-18,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine cooSetAdj[2](
    each final freqHz=1/28800)
    "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-38,-70},{-18,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon1(
    final amplitude=5,
    final offset=18 + 273.15,
    final freqHz=1/86400) "Zone 1 temperature"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon2(
    final offset=18 + 273.15,
    final freqHz=1/86400,
    final amplitude=7.5) "Zone 2 temperature"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta1(final k=false)
    "Window status"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta2(final k=true)
    "Window status"
    annotation (Placement(transformation(extent={{-38,-190},{-18,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen1(final k=false)
    "Occupancy sensor"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen2(final k=true)
    "Occupancy sensor"
    annotation (Placement(transformation(extent={{-38,-150},{-18,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable occTim(
    final table=[0,0;occSta,1; occEnd,0; 24*3600,0],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=24*3600) "One day in second"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div
    "Output first input divided by second input"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Round rou(final n=0)
    "Round real number to 0 digit"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(final k=24*3600)
    "Begin time of each day"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu
    "Check if it is beginning of next day"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-1, final k=1) "Add parameter"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(
    final k=24*3600) "Begin of day"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Beginning of current day"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Add curTim(final k2=-1) "Current time "
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k2=-1)
    "Left time to beginning of current day occupancy "
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occStaTim(
    final k=occSta) "Occupancy start"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    "Left time to the end of current day"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=occSta, final k=1)
    "Left time to next occupancy"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu1
    "Check if current time has already passed occupancy start time"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Time to next occupancy"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=0.5)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

protected
  final parameter Modelica.SIunits.Time occSta = 7*3600 "Occupancy start time";
  final parameter Modelica.SIunits.Time occEnd = 19*3600 "Occupancy end time";

equation
  connect(TZon1.y, setPoi.TZon[1])
    annotation (Line(points={{-59,-60},{-48,-60},{-48,-35.5},{27,-35.5}},
      color={0,0,127}));
  connect(TZon2.y, setPoi.TZon[2])
    annotation (Line(points={{-59,-100},{-48,-100},{-48,-34.5},{27,-34.5}},
      color={0,0,127}));
  connect(cooSetAdj.y, setPoi.setAdj)
    annotation (Line(points={{-17,-60},{-12,-60},{-12,-38},{27,-38}},
      color={0,0,127}));
  connect(heaSetAdj.y, setPoi.heaSetAdj)
    annotation (Line(points={{-17,-100},{-8,-100},{-8,-41},{27,-41}},
      color={0,0,127}));
  connect(TZon1.y, setPoi1.TZon[1])
    annotation (Line(points={{-59,-60},{-48,-60},{-48,-78},{-4,-78},{-4,-65.5},
      {27,-65.5}}, color={0,0,127}));
  connect(TZon2.y, setPoi1.TZon[2])
    annotation (Line(points={{-59,-100},{-48,-100},{-48,-78},{-4,-78},
      {-4,-64.5},{27,-64.5}}, color={0,0,127}));
  connect(occSen1.y, setPoi1.uOccSen[1])
    annotation (Line(points={{-59,-140},{-52,-140},{-52,-122},{4,-122},{4,-77.5},
      {27,-77.5}}, color={255,0,255}));
  connect(occSen2.y, setPoi1.uOccSen[2])
    annotation (Line(points={{-17,-140},{4,-140},{4,-76.5},{27,-76.5}},
      color={255,0,255}));
  connect(winSta1.y, setPoi1.uWinSta[1])
    annotation (Line(points={{-59,-180},{-52,-180},{-52,-158},{8,-158},{8,-79.5},
      {27,-79.5}}, color={255,0,255}));
  connect(winSta2.y, setPoi1.uWinSta[2])
    annotation (Line(points={{-17,-180},{-12,-180},{-12,-158},{8,-158},{8,-78.5},
      {27,-78.5}}, color={255,0,255}));
  connect(modTim.y,div. u1)
    annotation (Line(points={{-119,200},{-110,200},{-110,186},{-102,186}}, color={0,0,127}));
  connect(con.y,div. u2)
    annotation (Line(points={{-119,100},{-110,100},{-110,174},{-102,174}}, color={0,0,127}));
  connect(div.y,rou. u)
    annotation (Line(points={{-79,180},{-62,180}}, color={0,0,127}));
  connect(rou.y,gai. u)
    annotation (Line(points={{-39,180},{-22,180}}, color={0,0,127}));
  connect(gai.y,lesEqu. u1)
    annotation (Line(points={{1,180},{18,180}},   color={0,0,127}));
  connect(modTim.y,lesEqu. u2)
    annotation (Line(points={{-119,200},{10,200},{10,172},{18,172}}, color={0,0,127}));
  connect(rou.y,addPar1. u)
    annotation (Line(points={{-39,180},{-30,180},{-30,150},{-22,150}}, color={0,0,127}));
  connect(addPar1.y,gai1. u)
    annotation (Line(points={{1,150},{18,150}},   color={0,0,127}));
  connect(lesEqu.y,swi. u2)
    annotation (Line(points={{41,180},{58,180}}, color={255,0,255}));
  connect(gai.y,swi. u1)
    annotation (Line(points={{1,180},{6,180},{6,210},{50,210},{50,188},{58,188}},
      color={0,0,127}));
  connect(gai1.y,swi. u3)
    annotation (Line(points={{41,150},{50,150},{50,172},{58,172}}, color={0,0,127}));
  connect(modTim.y,curTim. u1)
    annotation (Line(points={{-119,200},{10,200},{10,206},{98,206}}, color={0,0,127}));
  connect(swi.y,curTim. u2)
    annotation (Line(points={{81,180},{90,180},{90,194},{98,194}}, color={0,0,127}));
  connect(occStaTim.y,add2. u1)
    annotation (Line(points={{-99,60},{-80,60},{-80,126},{98,126}}, color={0,0,127}));
  connect(con.y,add1. u1)
    annotation (Line(points={{-119,100},{-110,100},{-110,106},{18,106}},color={0,0,127}));
  connect(add1.y,addPar2. u)
    annotation (Line(points={{41,100},{58,100}}, color={0,0,127}));
  connect(occStaTim.y,lesEqu1. u2)
    annotation (Line(points={{-99,60},{-80,60},{-80,52},{18,52}}, color={0,0,127}));
  connect(curTim.y,lesEqu1. u1)
    annotation (Line(points={{121,200},{160,200},{160,80},{0,80},{0,60},{18,60}},
      color={0,0,127}));
  connect(lesEqu1.y,swi1. u2)
    annotation (Line(points={{41,60},{138,60}}, color={255,0,255}));
  connect(add2.y,swi1. u1)
    annotation (Line(points={{121,120},{130,120},{130,68},{138,68}},color={0,0,127}));
  connect(addPar2.y,swi1. u3)
    annotation (Line(points={{81,100},{120,100},{120,52},{138,52}}, color={0,0,127}));
  connect(occTim.y[1],greEquThr. u)
    annotation (Line(points={{-99,20},{-82,20}}, color={0,0,127}));
  connect(curTim.y,add2. u2)
    annotation (Line(points={{121,200},{160,200},{160,140},{80,140},{80,114},
      {98,114}}, color={0,0,127}));
  connect(curTim.y,add1. u2)
    annotation (Line(points={{121,200},{160,200},{160,80},{0,80},{0,94},{18,94}},
      color={0,0,127}));
  connect(greEquThr.y, setPoi.uOcc)
    annotation (Line(points={{-59,20},{0,20},{0,-43.975},{27,-43.975}}, color={255,0,255}));
  connect(greEquThr.y, setPoi1.uOcc)
    annotation (Line(points={{-59,20},{0,20},{0,-73.975},{27,-73.975}}, color={255,0,255}));
  connect(swi1.y, setPoi.tNexOcc)
    annotation (Line(points={{161,60},{170,60},{170,20},{20,20},{20,-32},
      {27,-32}}, color={0,0,127}));
  connect(swi1.y, setPoi1.tNexOcc)
    annotation (Line(points={{161,60},{170,60},{170,20},{20,20},{20,-62},
      {27,-62}}, color={0,0,127}));

annotation (experiment(StopTime=86400.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Validation/ModeAndSetPoints.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2019, by Jianjun Hu:<br/>
Reimplemented occupancy schedule block to avoid use block that is not in CDL. 
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1389\">issue 1389</a>.
</li>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-200},{180,220}}),
                                                     graphics={Text(
          extent={{58,-24},{134,-34}},
          lineColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No window status sensor
No occupancy sensor"), Text(
          extent={{56,-66},{110,-74}},
          lineColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No local setpoint adjustment")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end ModeAndSetPoints;
