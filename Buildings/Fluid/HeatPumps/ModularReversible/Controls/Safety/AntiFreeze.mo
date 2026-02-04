within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety;
model AntiFreeze "Model to prevent source from freezing"
  extends BaseClasses.PartialSafetyWithCounter;

  parameter Modelica.Units.SI.ThermodynamicTemperature TAntFre=276.15
    "Limit temperature for anti freeze control";
  parameter Real dTHys=2
    "Hysteresis interval width";
  Modelica.Blocks.Logical.Hysteresis hys(
    final uLow=TAntFre,
    final pre_y_start=true,
    final uHigh=TAntFre + dTHys) "Hysteresis to indicate if freezing occurs"
    annotation (Placement(transformation(extent={{-6,-10},{14,10}})));

  Modelica.Blocks.Math.Min min
    "Minimum of evaporator outlet and condenser inlet temperatures"
   annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));

equation
  connect(min.y, hys.u)
    annotation (Line(points={{-23,0},{-8,0}},      color={0,0,127}));
  connect(sigBus.TConInMea, min.u1) annotation (Line(
      points={{-119,-61},{-64,-61},{-64,6},{-46,6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus.TEvaOutMea, min.u2) annotation (Line(
      points={{-119,-61},{-64,-61},{-64,-6},{-46,-6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(hys.y, booPasThr.u) annotation (Line(
      points={{15,0},{78,0}},
      color={255,0,255}));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>May 27, 2025</i> by Fabian Wuellhorst:<br/>
    Make safety checks parallel (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/2015\">IBPSA #2015</a>)
  </li>
  <li>
    <i>May 26, 2025</i> by Fabian Wuellhorst and Michael Wetter:<br/>
    Increase error counter only when device should turn on (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/2011\">IBPSA #2011</a>)
  </li>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adapted based on Buildings implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model is used to prevent freezing of
  the condenser or evaporator side.
  A real device would shut off as well.
</p>
<p>
  This models takes the minimum of the two temperatures evaporator
  outlet and condenser inlet. If this minimal temperature falls below
  the given lower boundary, the hystereses will trigger an error and cause
  the device to switch off.
</p>
<h4>Assumptions</h4>
  This block does not check the evaporator inlet or condenser outlet temperatures
  because they are assumed to be always higher than the other side.
</html>"));
end AntiFreeze;
