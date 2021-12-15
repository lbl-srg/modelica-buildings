within Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses;
block FanOnOffWithDP
  "Controller for fan on/off and to provide prescribed dP"
  import Buildings.Examples.VAVReheat.BaseClasses.Controls.OperationModes;
  parameter Modelica.Units.SI.PressureDifference preRis=850
    "Prescribed pressure difference";
  Modelica.Blocks.Interfaces.RealOutput y(unit="Pa")
    "Supply fan requested pressure rise, or zero if fan should be off"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Examples.VAVReheat.BaseClasses.Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Modelica.Blocks.Routing.Extractor extractor(
    nin=6,
    index(start=1, fixed=true)) "Extractor for control signal"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.Constant on(k=preRis) "On signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(off.y, extractor.u[Integer(OperationModes.unoccupiedOff)])
    annotation (Line(points={{-19,-40},{0,-40},{0,0},{18,0}},
      color={0,0,127},smooth=Smooth.None));
  connect(off.y, extractor.u[Integer(OperationModes.safety)])
    annotation (Line(points={{-19,-40},{0,-40},{0,0},{18,0}},
      color={0,0,127},smooth=Smooth.None));
  connect(on.y, extractor.u[Integer(OperationModes.unoccupiedNightSetBack)])
    annotation (Line(points={{-19,0},{18,0}},
      color={0,0,127},smooth=Smooth.None));
  connect(on.y, extractor.u[Integer(OperationModes.occupied)])
    annotation (Line(points={{-19,0},{18,0}},
      color={0,0,127},smooth=Smooth.None));
  connect(on.y, extractor.u[Integer(OperationModes.unoccupiedWarmUp)])
    annotation (Line(points={{-19,0},{18,0}},
      color={0,0,127},smooth=Smooth.None));
  connect(on.y, extractor.u[Integer(OperationModes.unoccupiedPreCool)])
    annotation (Line(points={{-19,0},{18,0}},
      color={0,0,127},smooth=Smooth.None));
  connect(controlBus.controlMode, extractor.index)
    annotation (Line(points={{-60,80},{-60,-20},{30,-20},{30,-12}},
      color={255,204,51},thickness=0.5,smooth=Smooth.None),
      Text(textString="%first",index=-1,extent={{-6,3},{-6,3}}));
  connect(extractor.y, y)
    annotation (Line(points={{41,0},{41,0},{60,0},{110,0}},color={0,0,127}));
  annotation (
  defaultComponentName="fanOnOffDp",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,-50},{96,-96}},
          textColor={0,0,255},
          textString="prescribed_dP=%dP_pre"),
        Text(
        extent={{-120,140},{120,104}},
        textString="%name",
        textColor={0,0,255})}),
Documentation(info="<html>
<p>This model outputs <code>ON/OFF</code> signal to control fan operation.
When the system is in mode like <code>unoccupiedOff, safety</code>, it outputs
<code>false</code> so that fan should be <code>OFF</code> and provide 0 pressure rise;
When the system is in mode like <code>unoccupiedNightSetBack,occupied,unoccupiedWarmUp,
unoccupiedPreCool</code>, it outputs <code>true</code> so that fan should be
<code>ON</code> and provide <code>preRis</code> pressure rise.
</p></html>", revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.<br/>
</li>
</ul>
</html>"));
end FanOnOffWithDP;
