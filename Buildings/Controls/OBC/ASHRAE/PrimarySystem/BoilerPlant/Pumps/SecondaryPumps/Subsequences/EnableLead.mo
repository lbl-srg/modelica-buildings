within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences;
block EnableLead
    "Sequence to enable or disable the lead secondary pump of boiler plants"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPlaEna
    "Primary pump status signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput supResReq
    "Hot water supply reset requests"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea
    "Lead pump status"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr
    "Check if any hot water requests are being generated"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical And"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  connect(supResReq, intGreThr.u)
    annotation (Line(points={{-120,-40},{-82,-40}}, color={255,127,0}));

  connect(intGreThr.y, and2.u2) annotation (Line(points={{-58,-40},{-40,-40},{-40,
          -8},{-22,-8}}, color={255,0,255}));

  connect(and2.y, yLea)
    annotation (Line(points={{2,0},{120,0}}, color={255,0,255}));

  connect(uPlaEna, and2.u1) annotation (Line(points={{-120,40},{-40,40},{-40,0},
          {-22,0}}, color={255,0,255}));

annotation (
  defaultComponentName="enaLeaSecPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
  <p>
  Block that enables and disables lead secondary hot water pump, for plants
  with variable-speed hot water pumps, according to ASHRAE RP-1711, March 2020 draft, 
  section 5.3.7.2.
  </p>
  <ul>
  <li>
  The lead secondary hot water pump shall be enabled <code>yLea = true</code> when
  boiler plant is enabled <code>uPlaEna = true</code> and hot water reset requests 
  are being received from the loads, ie, <code>supResReq &gt; 0</code> and shall 
  be disabled otherwise.
  </li>
  </ul>
  </html>", revisions="<html>
  <ul>
  <li>
  August 25, 2020, by Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end EnableLead;
