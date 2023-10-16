within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences;
block BypassValve
  "Valves control when chilled water flow through economizer is controlled using bypass valve"

  parameter Real dpDes(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=0)=6000
    "Design pressure difference across the chilled water side economizer";
  parameter CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Valve controller"));
  parameter Real k=0.1
    "Gain of controller"
    annotation (Dialog(group="Valve controller"));
  parameter Real Ti(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Valve controller",
                       enable=controllerType == CDL.Types.SimpleController.PI or controllerType == CDL.Types.SimpleController.PID));
  parameter Real Td(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Valve controller",
                       enable=controllerType == CDL.Types.SimpleController.PD or controllerType == CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "True: waterside economizer is enabled"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat(
    final unit="Pa",
    final quantity="PressureDifference")
    "Differential static pressure across economizer in the chilled water side"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatIsoVal(
    final min=0,
    final max=1,
    final unit="1")
    "Economizer condensing water isolation valve position"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetVal(
    final min=0,
    final max=1,
    final unit="1")
    "WSE in-line CHW return line valve position"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final reverseActing=false,
    final y_reset=1) "Chilled water return line valve controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=dpDes)
    "Design static pressure difference across waterside economizer in chilled water side"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    annotation (Placement(transformation(extent={{-40,-56},{-20,-36}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Waterside economizer commanded on"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(dpChiWat, div1.u1)
    annotation (Line(points={{-120,-40},{-42,-40}}, color={0,0,127}));
  connect(con1.y, div1.u2) annotation (Line(points={{-58,-80},{-50,-80},{-50,-52},
          {-42,-52}}, color={0,0,127}));
  connect(con.y, conPID.u_s)
    annotation (Line(points={{-58,0},{-12,0}},   color={0,0,127}));
  connect(div1.y, conPID.u_m)
    annotation (Line(points={{-18,-46},{0,-46},{0,-12}}, color={0,0,127}));
  connect(conPID.y, swi.u1) annotation (Line(points={{12,0},{20,0},{20,-12},{58,
          -12}},color={0,0,127}));
  connect(con.y, swi.u3) annotation (Line(points={{-58,0},{-50,0},{-50,-28},{58,
          -28}},color={0,0,127}));
  connect(swi.y, yRetVal) annotation (Line(points={{82,-20},{120,-20}},
                color={0,0,127}));
  connect(booToRea.y, yConWatIsoVal)
    annotation (Line(points={{82,40},{120,40}}, color={0,0,127}));
  connect(uWSE, and1.u1)
    annotation (Line(points={{-120,40},{-82,40}}, color={255,0,255}));
  connect(uPla, and1.u2) annotation (Line(points={{-120,80},{-90,80},{-90,32},{-82,
          32}}, color={255,0,255}));
  connect(and1.y, booToRea.u)
    annotation (Line(points={{-58,40},{58,40}}, color={255,0,255}));
  connect(and1.y, conPID.trigger) annotation (Line(points={{-58,40},{-40,40},{-40,
          -20},{-6,-20},{-6,-12}}, color={255,0,255}));
  connect(and1.y, swi.u2) annotation (Line(points={{-58,40},{-40,40},{-40,-20},{
          58,-20}}, color={255,0,255}));
annotation (defaultComponentName = "wseVal",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Waterside economizer valves control when the chilled water flow through the economizer
is controlled using a modulating heat exchanger bypass valve. It is implemented
according to ASHRAE RP-1711, March 2020, section 5.2.3.4-6. 
</p>
<p>
When economizer is enabled, start next condenser pump and (or) adjust the pump
speed (see <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller</a>),
open the condenser water isolation valve to the heat exchanger (<code>yConWatIsoVal=1</code>),
and enable the economizer in-line chilled water return line valve (<code>yRetVal=1</code>).
</p>
<p>
When the in-line valve is enabled, it shall be modulated by a direct-acting PID
loop to maintain the static pressure difference across the chilled water side
of the heat exchanger at the design value (<code>dpDes</code>). Map the loop output from 0% open
at 0% output to 100% open at 100% output. Bias the loop to launce from 100%
output. The valve shall be fully open when the loop is disabled.
</p>
<p>
When the economizer is disabled, the economizer in-line chilled water return line
valve shall be disabled (fully open), the heat exchanger condensing water isolation
valve fully closed (<code>yConWatIsoVal=0</code>), and the last lag condenser water
pump disabled and (or) change the pump speed 
(see <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller</a>).
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end BypassValve;
