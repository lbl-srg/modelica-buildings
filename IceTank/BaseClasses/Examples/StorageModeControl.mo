within IceTank.BaseClasses.Examples;
model StorageModeControl
  import VirtualTestbed;
  extends Modelica.Icons.Example;

  VirtualTestbed.NISTChillerTestbed.Component.BaseClasses.StorageModeControl
    stoCon(
    dTif_min=0.5,
    smaLoa=10,
    TFre=273.15,
    waiTim=0) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerTable mod(table=[0,1; 3600,1; 3601,2; 5400,2;
        5401,3; 7200,3])
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.Step locLoa(
    height=2000,
    offset=-1000,
    startTime=5400)
    annotation (Placement(transformation(extent={{-60,-6},{-40,14}})));
  Modelica.Blocks.Sources.TimeTable TIn(table=[0,273.15; 3600,273.15; 5400,
        268.15; 5400,278.15; 7200,278.15])
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.TimeTable SOC(table=[0,0.5; 3600,0.5; 5400,0.8; 7200,
        0.4])
    annotation (Placement(transformation(extent={{-60,-72},{-40,-52}})));
equation
  connect(mod.y, stoCon.u) annotation (Line(points={{-39,40},{-26,40},{-26,8},{
          -12,8}}, color={255,127,0}));
  connect(locLoa.y, stoCon.locLoa)
    annotation (Line(points={{-39,4},{-12,4}}, color={0,0,127}));
  connect(TIn.y, stoCon.TIn) annotation (Line(points={{-39,-30},{-26,-30},{-26,
          0},{-12,0}}, color={0,0,127}));
  connect(SOC.y, stoCon.SOC) annotation (Line(points={{-39,-62},{-26,-62},{-26,
          0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "modelica://VirtualTestbed/Resources/scripts/dymola/NISTChillerTestbed/Component/BaseClasses/Examples/StorageModeControl.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to validate the controller of storage mode. </p>
</html>", revisions="<html>
<p>April 2021, Guowen Li First implementation.</p>
</html>"));
end StorageModeControl;
