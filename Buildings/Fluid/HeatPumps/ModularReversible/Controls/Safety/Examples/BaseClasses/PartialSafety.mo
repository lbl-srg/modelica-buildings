within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Examples.BaseClasses;
partial model PartialSafety

  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus sigBus
    "Bus-connector for the heat pump"
    annotation (Placement(transformation(extent={{-70,-70},{-30,-30}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    pre_y_start=false,
    uHigh=0.01,
    uLow=0.01/2) "Check if onOffMea in heat pump model would be true"
                 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={10,-50})));
  Modelica.Blocks.Interfaces.RealOutput ySet
    "Relative speed of compressor from 0 to 1"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput yOut
    "Relative speed of compressor applied after safety control"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
equation
  connect(hys.y, sigBus.onOffMea) annotation (Line(points={{-1,-50},{-50,-50}},
                           color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Partial example providing interfaces to
  show usage of safety control models.
</p>
</html>"));
end PartialSafety;
