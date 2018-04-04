within Buildings.ThermalZones.EnergyPlus.Validation;
model RefBldgSmallOffice "Validation model for six zones small office building"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter String idfName = "aaa.fmu" "Name of the FMU file that contains this zone";

  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-74,-50},{-54,-30}})));
  ThermalZone zon1(
    idfName="bld.fmu",
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Attic")                                          "Thermal zone"
    annotation (Placement(transformation(extent={{40,74},{80,114}})));
  ThermalZone zon2(
    idfName="bld.fmu",
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Core_ZN")
              "Thermal zone"
    annotation (Placement(transformation(extent={{40,28},{80,68}})));
  ThermalZone zon3(
    idfName="bld.fmu",
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Perimeter_ZN_1")
              "Thermal zone"
    annotation (Placement(transformation(extent={{40,-18},{80,22}})));
  ThermalZone zon4(
    idfName="bld.fmu",
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Perimeter_ZN_2")
              "Thermal zone"
    annotation (Placement(transformation(extent={{40,-64},{80,-24}})));
  ThermalZone zon5(
    idfName="bld.fmu",
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Perimeter_ZN_3")
              "Thermal zone"
    annotation (Placement(transformation(extent={{40,-112},{80,-72}})));
  ThermalZone zon6(
    idfName="bld.fmu",
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Perimeter_ZN_4")
              "Thermal zone"
    annotation (Placement(transformation(extent={{40,-156},{80,-116}})));
equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-53,40},{-40,40},{-40,7},{-30,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-53,0},{-30,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow. y) annotation (Line(points={{-30,-7},
          {-40,-7},{-40,-40},{-53,-40}},color={0,0,127}));
  connect(zon1.qGai_flow, multiplex3_1.y) annotation (Line(points={{38,104},{0,104},
          {0,0},{-7,0}},         color={0,0,127}));
  connect(zon2.qGai_flow, multiplex3_1.y) annotation (Line(points={{38,58},{0,58},
          {0,0},{-7,0}},          color={0,0,127}));
  connect(multiplex3_1.y, zon3.qGai_flow)
    annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));
  connect(zon4.qGai_flow, multiplex3_1.y) annotation (Line(points={{38,-34},{20,
          -34},{20,0},{-7,0}}, color={0,0,127}));
  connect(zon5.qGai_flow, multiplex3_1.y)
    annotation (Line(points={{38,-82},{0,-82},{0,0},{-7,0}}, color={0,0,127}));
  connect(multiplex3_1.y, zon6.qGai_flow) annotation (Line(points={{-7,0},{0,0},
          {0,-126},{38,-126}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Simple test case for one buildings with two thermal zones.
</p>
</html>", revisions="<html>
<ul><li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/TwoZones.mos"
        "Simulate and plot"),
experiment(
      StopTime=86400,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-160},{160,120}})),
    Icon(coordinateSystem(extent={{-100,-160},{160,120}})));
end RefBldgSmallOffice;
