within Buildings.Fluid.ZoneEquipment.BaseClasses;
block SupplementalHeating "Supplemental heating controller"

  parameter Real TLocOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=273.15-8
    "Minimum outdoor dry-bulb temperature for compressor operation";

  parameter Real dTHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=-1
    "Constant value to reduce heating setpoint for supplementary heating"
    annotation(Dialog(group="Setpoint adjustment"));

  parameter Real dTHys(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=0.05
    "Small temperature difference used in comparison blocks"
    annotation(Dialog(tab="Advanced"));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of supplementary heating controller"
    annotation (Dialog(group="PI controller"));

  parameter Real k=1
    "Gain of supplementary heating controller"
    annotation (Dialog(group="PI controller"));

  parameter Modelica.Units.SI.Time Ti=120
    "Time constant of Integrator block for supplementary heating"
    annotation (Dialog(group="PI controller"));

  parameter Modelica.Units.SI.Time Td=0.1
    "Time constant of Derivative block for supplementary heating"
    annotation (Dialog(group="PI controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaMod
    "When heating mode is enabled"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaEna
    "DX heating coil enable signal"
    annotation (Placement(transformation(extent={{-200,-110},{-160,-70}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-200,50},{-160,90}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-200,10},{-160,50}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-200,-30},{-160,10}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaEna
    "DX heating coil enable signal"
    annotation (Placement(transformation(extent={{160,-70},{200,-30}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupHea(
    final min=0,
    final max=1,
    final unit="1")
    "Supplementary heating control signal"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
      iconTransformation(extent={{100,0},{140,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThrLocOut(
    final t=TLocOut,
    final h=dTHys)
    "Outdoor air lockout temperature for DX coil"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Logical.And andLocOut
    "Check for heating mode signal and outdoor air temperature lockout"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.Continuous.LimPID conPIHeaHig(
    final controllerType=controllerType,
    final k=k,
    final Td=Td,
    final yMax=1,
    final yMin=0,
    final Ti=Ti)
    "Regulate zone temperature at or above heating setpoint when load is unmet by DX heating"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Controls.OBC.CDL.Logical.Not notLocOut
    "Check if DX heating coil is not locked out"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Logical.And andHeaEna
    "Enable DX heating coil only if outdoor temperature is above lockout"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaSupHeaLocOut
    "Convert Boolean supplementary heating enable signal to real value"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulSupHeaEna
    "Enable supplementary heating if DX coil is unable to meet heating load"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addParHeaSet(
    final p=dTHeaSet)
    "Reduce heating setpoint by constant value"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.Continuous.LimPID conPIHeaLocOut(
    final controllerType=controllerType,
    final k=k,
    final Td=Td,
    final yMax=1,
    final yMin=0,
    final Ti=Ti)
    "Regulate zone temperature at or above heating setpoint"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulSupHeaEna1
    "Enable supplementary heating when DX coil is locked out"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaSupHeaHig
    "Convert Boolean supplementary heating enable signal to real value"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Max maxSupHea
    "Output higher of the two supplementary heating signals"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

equation
  connect(TOut, lesThrLocOut.u) annotation (Line(points={{-180,-10},{-142,-10}},
                             color={0,0,127}));
  connect(lesThrLocOut.y, andLocOut.u1)
    annotation (Line(points={{-118,-10},{-82,-10}}, color={255,0,255}));
  connect(TZon, conPIHeaHig.u_m)
    annotation (Line(points={{-180,30},{10,30},{10,58}}, color={0,0,127}));
  connect(uHeaMod, andLocOut.u2) annotation (Line(points={{-180,-50},{-100,-50},
          {-100,-18},{-82,-18}}, color={255,0,255}));
  connect(andLocOut.y, notLocOut.u) annotation (Line(points={{-58,-10},{-50,-10},
          {-50,-30},{-22,-30}}, color={255,0,255}));
  connect(andHeaEna.y, yHeaEna)
    annotation (Line(points={{62,-50},{180,-50}}, color={255,0,255}));
  connect(notLocOut.y, andHeaEna.u1) annotation (Line(points={{2,-30},{10,-30},{
          10,-50},{38,-50}}, color={255,0,255}));
  connect(uHeaEna, andHeaEna.u2) annotation (Line(points={{-180,-90},{10,-90},{10,
          -58},{38,-58}}, color={255,0,255}));
  connect(andLocOut.y, booToReaSupHeaLocOut.u) annotation (Line(points={{-58,-10},
          {-50,-10},{-50,100},{-42,100}}, color={255,0,255}));
  connect(THeaSet, addParHeaSet.u)
    annotation (Line(points={{-180,70},{-42,70}},  color={0,0,127}));
  connect(addParHeaSet.y, conPIHeaHig.u_s)
    annotation (Line(points={{-18,70},{-2,70}}, color={0,0,127}));
  connect(THeaSet, conPIHeaLocOut.u_s) annotation (Line(points={{-180,70},{-140,
          70},{-140,120},{-102,120}}, color={0,0,127}));
  connect(TZon, conPIHeaLocOut.u_m)
    annotation (Line(points={{-180,30},{-90,30},{-90,108}}, color={0,0,127}));
  connect(conPIHeaLocOut.y, mulSupHeaEna1.u1) annotation (Line(points={{-79,120},
          {-10,120},{-10,126},{-2,126}}, color={0,0,127}));
  connect(booToReaSupHeaLocOut.y, mulSupHeaEna1.u2) annotation (Line(points={{-18,
          100},{-10,100},{-10,114},{-2,114}}, color={0,0,127}));
  connect(uHeaMod, booToReaSupHeaHig.u) annotation (Line(points={{-180,-50},{-30,
          -50},{-30,10},{-2,10}}, color={255,0,255}));
  connect(booToReaSupHeaHig.y, mulSupHeaEna.u2) annotation (Line(points={{22,10},
          {28,10},{28,54},{38,54}}, color={0,0,127}));
  connect(conPIHeaHig.y, mulSupHeaEna.u1) annotation (Line(points={{21,70},{28,70},
          {28,66},{38,66}}, color={0,0,127}));
  connect(mulSupHeaEna1.y, maxSupHea.u1) annotation (Line(points={{22,120},{80,120},
          {80,106},{98,106}}, color={0,0,127}));
  connect(mulSupHeaEna.y, maxSupHea.u2) annotation (Line(points={{62,60},{80,60},
          {80,94},{98,94}}, color={0,0,127}));
  connect(maxSupHea.y, ySupHea) annotation (Line(points={{122,100},{140,100},{140,
          60},{180,60}}, color={0,0,127}));
annotation (defaultComponentName="conSupHea",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-100,160},{100,120}},
        textString="%name",
        textColor={0,0,255}),
        Text(
          extent={{-96,92},{-48,68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-96,48},{-64,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-96,8},{-64,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-94,-32},{-40,-48}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHeaMod"),
        Text(
          extent={{-94,-72},{-40,-88}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHeaEna"),
        Text(
          extent={{44,-12},{96,-28}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yHeaEna"),
        Text(
          extent={{42,34},{96,8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ySupHea")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-140},{160,140}})),
Documentation(info="<html>
<p>This is a control module for enabling/disabling supplemental heating. 
The components are operated as follows. </p>
<ul>
<li>
When <code>TOut</code> is below the minimum dry bulb temperature 
<code>TLocOut</code> and the system is in the heating mode (<code>uHeaMod = True</code>), 
the controller enables the supplemental heating that tracks the zone air temperature 
setpoint <code>THeaSet</code> and disables the DX heating coil (<code>yHeaEna = False</code>).
</li>
<li>
When <code>TOut</code> is above the minimum dry bulb temperature <code>TLocOut</code> 
and the system is in the heating mode (<code>uHeaMod = True</code>), 
the controller reduces the setpoint for the supplemental heating by 
<code>dTHeaSet</code>, thereby prioritizing the DX coil for heating use, and 
running the supplementary heating only when the DX coil is unable to meet the 
heating load. 
</li>
</ul>
</html>
", revisions="<html>
    <ul>
    <li>
    April 10, 2023, by Xing Lu and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end SupplementalHeating;
