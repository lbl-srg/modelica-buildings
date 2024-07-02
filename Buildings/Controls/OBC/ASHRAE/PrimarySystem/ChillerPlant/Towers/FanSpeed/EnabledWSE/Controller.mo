within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE;
block Controller "Tower fan speed control when waterside economizer is enabled"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Real fanSpeMin=0.1 "Minimum tower fan speed";
  parameter Real fanSpeMax=1 "Maximum tower fan speed";
  parameter Real chiMinCap[nChi](
    each final unit="W",
    final quantity=fill("HeatFlowRate", nChi))={1e4,1e4}
    "Minimum cyclining load below which chiller will begin cycling"
    annotation (Dialog(tab="Integrated operation"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController intOpeCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Integrated operation", group="Controller"));
  parameter Real kIntOpe=1 "Gain of controller"
    annotation (Dialog(tab="Integrated operation", group="Controller"));
  parameter Real TiIntOpe(final quantity="Time", final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Integrated operation", group="Controller",
                       enable=intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                              intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdIntOpe(final quantity="Time", final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Integrated operation", group="Controller",
                       enable=intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real fanSpeChe=0.005 "Lower threshold value to check fan speed"
    annotation (Dialog(tab="WSE-only"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController chiWatCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="WSE-only", group="Controller"));
  parameter Real kWSE=1 "Gain of controller"
    annotation (Dialog(tab="WSE-only", group="Controller"));
  parameter Real TiWSE(final quantity="Time", final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="WSE-only", group="Controller",
                       enable=chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                              chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdWSE(final quantity="Time", final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="WSE-only", group="Controller",
                       enable=chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput chiLoa[nChi](
    final unit=fill("W", nChi),
    final quantity=fill("HeatFlowRate", nChi))
    "Current load of each chiller"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse
    "Waterside economizer enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
     final min=0,
     final max=1,
     final unit="1") "Measured tower fan speed"
     annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
       iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet(
    final min=0,
    final max=1,
    final unit="1")
    "Tower fan speed setpoint when WSE is enabled and there is any chiller running"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.IntegratedOperation
    intOpe(
    final nChi=nChi,
    final chiMinCap=chiMinCap,
    final fanSpeMin=fanSpeMin,
    final fanSpeMax=fanSpeMax,
    final conTyp=intOpeCon,
    final k=kIntOpe,
    final Ti=TiIntOpe,
    final Td=TdIntOpe)
    "Tower fan speed when the waterside economizer is enabled and the chillers are running"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.WSEOperation
    wseOpe(
    final fanSpeMin=fanSpeMin,
    final fanSpeMax=fanSpeMax,
    final fanSpeChe=fanSpeChe,
    final chiWatCon=chiWatCon,
    final k=kWSE,
    final Ti=TiWSE,
    final Td=TdWSE)
    "Tower fan speed when the waterside economizer is running alone"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nin=nChi) "Logical or"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

equation
  connect(intOpe.uChi, uChi)
    annotation (Line(points={{-42,88},{-80,88},{-80,40},{-120,40}}, color={255,0,255}));
  connect(intOpe.chiLoa, chiLoa)
    annotation (Line(points={{-42,80},{-120,80}}, color={0,0,127}));
  connect(wseOpe.uFanSpe,uFanSpe)
    annotation (Line(points={{-42,-52},{-60,-52},{-60,-30},{-120,-30}}, color={0,0,127}));
  connect(wseOpe.TChiWatSup, TChiWatSup)
    annotation (Line(points={{-42,-60},{-120,-60}}, color={0,0,127}));
  connect(wseOpe.TChiWatSupSet, TChiWatSupSet)
    annotation (Line(points={{-42,-68},{-60,-68},{-60,-90},{-120,-90}}, color={0,0,127}));
  connect(mulOr.y, swi.u2)
    annotation (Line(points={{-18,40},{-2,40}}, color={255,0,255}));
  connect(intOpe.ySpeSet, swi.u1)
    annotation (Line(points={{-18,80},{-10,80},{-10,48},{-2,48}}, color={0,0,127}));
  connect(wseOpe.ySpeSet, swi.u3)
    annotation (Line(points={{-18,-60},{-10,-60},{-10,32},{-2,32}}, color={0,0,127}));
  connect(uWse, swi1.u2)
    annotation (Line(points={{-120,0},{58,0}}, color={255,0,255}));
  connect(swi.y, swi1.u1)
    annotation (Line(points={{22,40},{40,40},{40,8},{58,8}}, color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{22,-30},{40,-30},{40,-8},{58,-8}}, color={0,0,127}));
  connect(swi1.y,ySpeSet)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(uChi, mulOr.u)
    annotation (Line(points={{-120,40},{-42,40}}, color={255,0,255}));
  connect(uWse, intOpe.uWse)
    annotation (Line(points={{-120,0},{-60,0},{-60,72},{-42,72}}, color={255,0,255}));

annotation (
  defaultComponentName="towFanSpeWse",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-20,80},{20,80},{0,10},{-20,80}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,10},{40,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-10},{-20,-80},{20,-80},{0,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-80},{76,-94}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{76,-78},{78,-96}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,-78},{80,-96}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-50,82}},
          textColor={0,0,127},
          textString="chiLoa"),
        Text(
          extent={{-100,70},{-64,54}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-96,30},{-66,12}},
          textColor={255,0,255},
          textString="uWse"),
        Text(
          extent={{-96,-10},{-52,-26}},
          textColor={0,0,127},
          textString="uFanSpe"),
        Text(
          extent={{-96,-52},{-40,-66}},
          textColor={0,0,127},
          textString="TChiWatSup"),
        Text(
          extent={{-96,-82},{-24,-98}},
          textColor={0,0,127},
          textString="TChiWatSupSet"),
        Text(
          extent={{54,12},{98,-6}},
          textColor={0,0,127},
          textString="ySpeSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that outputs cooling tower fan speed <code>ySpeSet</code> when waterside 
economizer is enabled. This is implemented according to ASHRAE Guideline36-2021,
section 5.20.12.2, item c. It includes two subsequences:
</p>
<ul>
<li>
When waterside economizer is enabled and chillers are running, see 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.IntegratedOperation\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.IntegratedOperation</a>
for a description.
</li>
<li>
When waterside economizer is running alone, see 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.WSEOperation\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.WSEOperation</a>
for a description.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 9, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
