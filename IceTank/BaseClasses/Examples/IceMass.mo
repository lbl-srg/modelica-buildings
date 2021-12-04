within IceTank.BaseClasses.Examples;
model IceMass
  import VirtualTestbed;
  extends Modelica.Icons.Example;

  VirtualTestbed.NISTChillerTestbed.Component.BaseClasses.IceMass iceMas(
    mIce_max=2846.35,
    mIce_start=2846.35/2,
    Hf=333550)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Cosine q(
    freqHz=1/3600,
    amplitude=40000,
    offset=0)
    "Heat transfer rate: postive for charging, negative for discharging"
    annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
equation
  connect(q.y, iceMas.q)
    annotation (Line(points={{-33,0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "modelica://VirtualTestbed/Resources/scripts/dymola/NISTChillerTestbed/Component/BaseClasses/Examples/IceMass.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to validate the model that can output the ice mass.</p>
</html>", revisions="<html>
<p>April 2021, Yangyang Fu First implementation</p>
</html>"));
end IceMass;
