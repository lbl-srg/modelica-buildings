within IceStorage.BaseClasses.Examples;
model OutletTemperatureControl
  "Example that tests the outlet temperature control"
  import VirtualTestbed;
  extends Modelica.Icons.Example;

  VirtualTestbed.NISTChillerTestbed.Component.BaseClasses.TankTOutControl
    valOnOff annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerStep integerStep(offset=2, startTime=3600)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Step TOutSet(
    height=8,
    startTime=3600,
    offset=273.15 - 3)
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  Modelica.Blocks.Sources.TimeTable TOutMea(table=[0,271.15; 3600,273.15; 3600,
        273.15; 7200,278.15])
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
equation
  connect(integerStep.y, valOnOff.u) annotation (Line(points={{-39,50},{-26,50},
          {-26,0},{-12,0}}, color={255,127,0}));
  connect(TOutSet.y, valOnOff.TOutSet)
    annotation (Line(points={{-39,-4},{-12,-4}}, color={0,0,127}));
  connect(TOutMea.y, valOnOff.TOutMea) annotation (Line(points={{-39,-40},{-26,
          -40},{-26,-8},{-12,-8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<p>April 2021, Guowen Li First implementation.</p>
</html>", info="<html>
<p>This example is to validate the model that can control the outlet temperature of the ice tank.</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://VirtualTestbed/Resources/scripts/dymola/NISTChillerTestbed/Component/BaseClasses/Examples/TankTOutControl.mos"
        "Simulate and Plot"));
end OutletTemperatureControl;
