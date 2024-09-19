within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model SignalFilter  "Partial model that implements the filtered opening for valves and dampers"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.SignalFilterParameters;
protected
  Modelica.Blocks.Interfaces.RealOutput[numAct] y_actual "Actual valve position"
    annotation (Placement(transformation(extent={{-28,66},{-12,82}})));

  Modelica.Blocks.Nonlinear.SlewRateLimiter[numAct] actPos(
    each Rising=1/strokeTime,
    each Falling=-1/strokeTime,
    each Td=10/strokeTime,
    each initType=initValve,
    each y_start=yValve_start,
    each strict=true)
    if use_strokeTime
      "Actuator position"
    annotation (Placement(transformation(extent={{-48,80},{-40,88}})));

  Modelica.Blocks.Interfaces.RealOutput[numAct] y_filtered if use_strokeTime
    "Filtered valve positions in the range 0..1"
    annotation (Placement(transformation(extent={{-28,76},{-12,92}}),
        iconTransformation(extent={{60,50},{80,70}})));
equation
 connect(actPos.y,y_filtered)
   annotation (Line(points={{-39.6,84},{-20,84}},
      color={0,0,127}));
  if use_strokeTime then
   connect(actPos.y, y_actual)
     annotation (Line(points={{-39.6,84},{-32,84},{-32,74},{-20,74}},
       color={0,0,127}));
 end if;
  annotation (    Documentation(revisions="<html>
<ul>
<li>
September 19, 2024, by Michael Wetter:<br/>
Corrected dimension of instance <code>actPos</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4004\">Buildings, #4004</a>.
<li>
August 26, 2024, by Michael Wetter:<br/>
Implemented linear actuator travel dynamics.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3965\">Buildings, #3965</a>.
</li>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Partial model that implements the filters that are used to approximate the travel time of the actuators.
The signal <code>y_actual</code> is used to obtain the current position of the actuators.
</p>
</html>"));
end SignalFilter;
