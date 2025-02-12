within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses;
model BoundaryMap
  "Block that checks if the inputs are within the characteristic map"
  parameter Real tab[:,2]
    "Table for boundary with second column as useful temperature side";
  parameter Modelica.Units.SI.TemperatureDifference dT
    "Delta value used to avoid state events when used as a safety control";
  parameter Boolean isUppBou "=true if it is an upper boundary, false for lower";
  Modelica.Blocks.Interfaces.BooleanOutput noErr
    "=false when an error occurs"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TAmbSid(unit="K", displayUnit="degC")
    "Temperature at ambient side"
    annotation (Placement(transformation(extent={{-130,-54},{-102,-26}})));

  Modelica.Blocks.Tables.CombiTable1Ds tabBou(
    final table=tab,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    final tableOnFile=false) "Table with envelope data"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.MathBoolean.Nor nor(nu=3)
    "=true if the operational envelope is not violated"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Logical.Hysteresis hysLef(
    final uLow=-0.05,
    final uHigh=0,
    pre_y_start=false) "Hysteresis for left side of envelope"
  annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Logical.Hysteresis hysRig(
    final uLow=-0.05,
    final uHigh=0,
    pre_y_start=false) "Hysteresis for right side of envelope"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Sources.Constant conTAmbSidMin(k=TAmbSidMin)
    "Constant minimal temperature of ambient temperature side"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.Constant conTAmbSidMax(k=TAmbSidMax)
    "Constant maximal temperature of ambient temperature side"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Modelica.Blocks.Math.Add subMax(final k1=+1, final k2=-1)
    "Actual minus maximal ambient side temperature"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Math.Add sub(final k1=-1, final k2=+1)
    "Minimal minus current ambient side temperature"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Interfaces.RealInput TUseSid(unit="K", displayUnit="degC")
    "Useful temperature side "
    annotation (Placement(transformation(extent={{-128,26},{-100,54}})));
  Modelica.Blocks.Math.Add subBou(final k1=if isUppBou then 1 else -1, final k2=
       if isUppBou then -1 else 1)
    "Subtract boundary from current value depending on lower or upper boundary"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Logical.Hysteresis hysBou(
    final uLow=-dT,
    final uHigh=0,
    pre_y_start=false) "Hysteresis for temperature limit"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
protected
  parameter Real icoMin=-70
    "Used to set the frame where the icon should appear";
  parameter Real icoMax=70 "Used to set the frame where the icon should appear";
  final parameter Modelica.Units.SI.Temperature TAmbSidMax=tab[end, 1]
    "Maximal value of ambient side";
  final parameter Modelica.Units.SI.Temperature TAmbSidMin=tab[1, 1]
    "Minimal temperature at ambient side";
  final parameter Modelica.Units.SI.Temperature TUseSidMax=max(tab[:, 2])
    "Maximal temperature of useful side";
  final parameter Modelica.Units.SI.Temperature TUseSidMin=0
    "Minimal value of useful side";
  final parameter Real poi[size(scaTAmbSid, 1),2]=transpose({scaTAmbSidToPoi,
      scaTUseSidToPoi}) "Points for dynamic annotation"
    annotation (Hide=false, HideResult=false);
  final parameter Modelica.Units.SI.Temperature scaTAmbSid[:]=tab[:, 1]
    "Helper array with only not ambient side temperature values";
  final parameter Modelica.Units.SI.Temperature scaTUseSid[:]=tab[:, 2]
    "Helper array with only useful side temperature values";
  final parameter Real scaTAmbSidToPoi[size(scaTAmbSid, 1)](
    each min=-100,
    each max=100) = (scaTAmbSid - fill(TAmbSidMin, size(scaTAmbSid, 1)))*(icoMax -
    icoMin)/(TAmbSidMax - TAmbSidMin) + fill(icoMin, size(scaTAmbSid, 1))
    "Scale ambient side to icon size";
  final parameter Real scaTUseSidToPoi[size(scaTAmbSid, 1)](
    each min=-100,
    each max=100) = (scaTUseSid - fill(TUseSidMin, size(scaTUseSid, 1)))*(icoMax -
    icoMin)/(TUseSidMax - TUseSidMin) + fill(icoMin, size(scaTUseSid, 1))
    "Scale useful side to icon size";

equation
  connect(nor.y, noErr)
    annotation (Line(points={{81.5,0},{110,0}}, color={255,0,255}));
  connect(hysLef.y, nor.u[1]) annotation (Line(points={{41,-30},{50,-30},{50,-2.33333},
          {60,-2.33333}}, color={255,0,255}));
  connect(hysRig.y, nor.u[2]) annotation (Line(points={{41,-70},{50,-70},{50,-5.55112e-16},
          {60,-5.55112e-16}}, color={255,0,255}));
  connect(subMax.u2,conTAmbSidMax.y)  annotation (Line(points={{-22,-76},{-32,-76},
          {-32,-80},{-39,-80}}, color={0,0,127}));
  connect(sub.u2,conTAmbSidMin.y)  annotation (Line(points={{-22,-36},{-32,-36},{
          -32,-40},{-39,-40}},  color={0,0,127}));
  connect(subMax.y, hysRig.u)
    annotation (Line(points={{1,-70},{18,-70}}, color={0,0,127}));
  connect(sub.y, hysLef.u)
    annotation (Line(points={{1,-30},{18,-30}}, color={0,0,127}));
  connect(hysBou.u, subBou.y)
    annotation (Line(points={{18,10},{6,10},{6,70},{1,70}}, color={0,0,127}));
  connect(hysBou.y, nor.u[3]) annotation (Line(points={{41,10},{50,10},{50,2.33333},
          {60,2.33333}}, color={255,0,255}));
  connect(tabBou.y[1], subBou.u2) annotation (Line(points={{-39,50},{-30,50},{-30,
          64},{-22,64}}, color={0,0,127}));
  connect(subBou.u1, TUseSid) annotation (Line(points={{-22,76},{-96,76},{-96,40},
          {-114,40}}, color={0,0,127}));
  connect(TAmbSid, tabBou.u) annotation (Line(points={{-116,-40},{-80,-40},{-80,50},
          {-62,50}}, color={0,0,127}));
  connect(TAmbSid, sub.u1) annotation (Line(points={{-116,-40},{-80,-40},{-80,-24},
          {-22,-24}}, color={0,0,127}));
  connect(TAmbSid, subMax.u1) annotation (Line(points={{-116,-40},{-80,-40},{-80,
          -64},{-22,-64}},                color={0,0,127}));
  annotation (Icon(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                    Line(points=DynamicSelect(
      {{-66,-66},{-66,50},{-44,66}, {68,66},{68,-66},{-66,-66}},poi),
      color={238,46,47},
      thickness=0.5),
  Polygon(
    points={{icoMin-20,icoMax},{icoMin-20,icoMax},
            {icoMin-10,icoMax},{icoMin-15,icoMax+20}},
    lineColor={95,95,95},
    fillColor={95,95,95},
    fillPattern=FillPattern.Solid),
  Polygon(
    points={{icoMax+20,icoMin-10},{icoMax,icoMin-4},
            {icoMax,icoMin-16},{icoMax+20,icoMin-10}},
    lineColor={95,95,95},
    fillColor={95,95,95},
    fillPattern=FillPattern.Solid),
  Line(points={{icoMin-15,icoMax},
              {icoMin-15,icoMin-15}}, color={95,95,95}),
  Line(points={{icoMin-20,icoMin-10},
              {icoMax+10,icoMin-10}}, color={95,95,95}),
        Text(
          extent={{-149,135},{151,95}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
  Documentation(info="<html>
<p>
  Given an input of <code>TCon</code> and <code>TEva</code>,
  the model returns false if the given
  point is outside of the given operational envelope.
</p>
<p>
  The maximal and minimal <code>TCon</code> depend on
  <code>TEva</code> and are defined by the
  upper and lower boundaries in form of 1Ds-Tables.</p>
<p>
  The maximal and minimal <code>TEva</code> values are obtained
  trough the table and are constant.
</p>
<p>
  For the boundaries of the <code>TCon</code> input value, a
  dynamic hysteresis is used to ensure a used device will
  stay off a certain time after shutdown.
</p>
<p>
  This is similar to the hysteresis in a pressure-based safety control,
  which prevents operation outside this envelope in real devices.
</p>
</html>",
        revisions="<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on IPBSA guidelines <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>November 26, 2018;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue
    <a href=\"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end BoundaryMap;
