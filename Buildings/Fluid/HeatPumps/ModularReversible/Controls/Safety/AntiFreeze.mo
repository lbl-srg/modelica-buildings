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
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Modelica.Blocks.Math.Min min
    "Minimum of evaporator outlet and condenser inlet temperatures"
   annotation (Placement(transformation(extent={{-58,10},{-38,30}})));

equation
  connect(ySet,swiErr.u1)  annotation (Line(points={{-136,0},{-100,0},{-100,52},
          {70,52},{70,8},{78,8}},
                  color={0,0,127}));
  connect(min.y, hys.u)
    annotation (Line(points={{-37,20},{-22,20}},   color={0,0,127}));
  connect(sigBus.TConInMea, min.u1) annotation (Line(
      points={{-119,-61},{-119,-60},{-92,-60},{-92,26},{-60,26}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus.TEvaOutMea, min.u2) annotation (Line(
      points={{-119,-61},{-119,-60},{-92,-60},{-92,14},{-60,14}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(hys.y, booPasThr.u) annotation (Line(
      points={{1,20},{20,20},{20,0},{38,0}},
      color={255,0,255}));
  annotation (Documentation(revisions="<html><ul>
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
