within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model ModeValueSelector "Test model for ModeValueSelector"

extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeValueSelector modVal
    "Averages dry and wet coil conditions"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant THea(k=283.15)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.Constant mCooWat_flow(k=0.01)
    annotation (Placement(transformation(extent={{-94,-36},{-74,-16}})));
  Modelica.Blocks.Sources.Constant SHRCoo(k=0.5)
    annotation (Placement(transformation(extent={{-92,-84},{-72,-64}})));
  Modelica.Blocks.Sources.Constant QHea_flow(k=3000)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant EIRHea(k=0.3)
    annotation (Placement(transformation(extent={{-58,80},{-38,100}})));
  Modelica.Blocks.Sources.Constant TCoo(k=293.15)
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Modelica.Blocks.Sources.Constant QCoo_flow(k=-2000)
    annotation (Placement(transformation(extent={{-48,-100},{-28,-80}})));
  Modelica.Blocks.Sources.Constant EIRDry(k=0.2)
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  Modelica.Blocks.Sources.IntegerTable intTab(table=[0,0; 1,1; 2,2; 3,0; 4,2; 5,
        1]) "Mode change"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(intTab.y, modVal.mode) annotation (Line(
      points={{-39,6.10623e-16},{-20.5,6.10623e-16},{-20.5,4.996e-16},{-1,
          4.996e-16}},
      color={255,127,0},
      smooth=Smooth.None));

  connect(SHRCoo.y, modVal.SHRCoo) annotation (Line(
      points={{-71,-74},{10,-74},{10,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mCooWat_flow.y, modVal.mCooWat_flow) annotation (Line(
      points={{-73,-26},{2,-26},{2,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(THea.y, modVal.THeaCoiSur) annotation (Line(
      points={{-79,40},{6,40},{6,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QHea_flow.y, modVal.QHea_flow) annotation (Line(
      points={{-59,70},{14,70},{14,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(EIRHea.y, modVal.EIRHea) annotation (Line(
      points={{-37,90},{18,90},{18,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TCoo.y, modVal.TADPCoo) annotation (Line(
      points={{-49,-50},{6,-50},{6,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(EIRDry.y, modVal.EIRCoo) annotation (Line(
      points={{51,-90},{60,-90},{60,-20},{18,-20},{18,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QCoo_flow.y, modVal.QCoo_flow) annotation (Line(
      points={{-27,-90},{14,-90},{14,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics),__Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/ModeValueSelector.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of DryWetSelector block 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeValueSelector\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeValueSelector</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
August 29, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ModeValueSelector;
