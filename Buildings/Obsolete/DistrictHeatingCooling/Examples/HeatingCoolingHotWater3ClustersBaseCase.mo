within Buildings.Obsolete.DistrictHeatingCooling.Examples;
model HeatingCoolingHotWater3ClustersBaseCase
  "Base case for model of a system with 3 clusters"
  extends
    Buildings.Obsolete.DistrictHeatingCooling.Examples.BaseClasses.HeatingCoolingHotWater3Clusters(
      larOff1(mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
      ret1(mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
      larOff2(mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
      apa1(mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
      larOff3(mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
      larOff4(mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
      apa2(mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
      ret2(mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState));

  extends Modelica.Icons.Example;

  BaseClasses.SubStationBoundaryCondition bou_a1(redeclare package Medium =
        Medium, warmSide=true) "Boundary condition"
    annotation (Placement(transformation(extent={{-332,70},{-312,90}})));
  BaseClasses.SubStationBoundaryCondition bou_b1(redeclare package Medium =
        Medium, warmSide=false) "Boundary condition"
    annotation (Placement(transformation(extent={{-220,70},{-240,90}})));
  BaseClasses.SubStationBoundaryCondition bou_a2(redeclare package Medium =
        Medium, warmSide=true) "Boundary condition"
    annotation (Placement(transformation(extent={{-212,70},{-192,90}})));
  BaseClasses.SubStationBoundaryCondition bou_b2(redeclare package Medium =
        Medium, warmSide=false) "Boundary condition"
    annotation (Placement(transformation(extent={{-100,70},{-120,90}})));
  BaseClasses.SubStationBoundaryCondition bou_a3(redeclare package Medium =
        Medium, warmSide=true) "Boundary condition"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  BaseClasses.SubStationBoundaryCondition bou_b3(redeclare package Medium =
        Medium, warmSide=false) "Boundary condition"
    annotation (Placement(transformation(extent={{22,70},{2,90}})));
  BaseClasses.SubStationBoundaryCondition bou_a4(redeclare package Medium =
        Medium, warmSide=true) "Boundary condition"
    annotation (Placement(transformation(extent={{188,70},{208,90}})));
  BaseClasses.SubStationBoundaryCondition bou_b4(redeclare package Medium =
        Medium, warmSide=false) "Boundary condition"
    annotation (Placement(transformation(extent={{300,70},{280,90}})));
  BaseClasses.SubStationBoundaryCondition bou_a5(redeclare package Medium =
        Medium, warmSide=true) "Boundary condition"
    annotation (Placement(transformation(extent={{328,70},{348,90}})));
  BaseClasses.SubStationBoundaryCondition bou_b5(redeclare package Medium =
        Medium, warmSide=false) "Boundary condition"
    annotation (Placement(transformation(extent={{440,70},{420,90}})));
  BaseClasses.SubStationBoundaryCondition bou_a6(redeclare package Medium =
        Medium, warmSide=true) "Boundary condition"
    annotation (Placement(transformation(extent={{470,70},{490,90}})));
  BaseClasses.SubStationBoundaryCondition bou_b6(redeclare package Medium =
        Medium, warmSide=false) "Boundary condition"
    annotation (Placement(transformation(extent={{580,70},{560,90}})));
  BaseClasses.SubStationBoundaryCondition bou_a7(redeclare package Medium =
        Medium, warmSide=true) "Boundary condition"
    annotation (Placement(transformation(extent={{190,-150},{210,-130}})));
  BaseClasses.SubStationBoundaryCondition bou_b7(redeclare package Medium =
        Medium, warmSide=false) "Boundary condition"
    annotation (Placement(transformation(extent={{300,-150},{280,-130}})));
  BaseClasses.SubStationBoundaryCondition bou_a8(redeclare package Medium =
        Medium, warmSide=true) "Boundary condition"
    annotation (Placement(transformation(extent={{330,-150},{350,-130}})));
  BaseClasses.SubStationBoundaryCondition bou_b8(redeclare package Medium =
        Medium, warmSide=false) "Boundary condition"
    annotation (Placement(transformation(extent={{440,-150},{420,-130}})));
equation
  connect(weaBus.TDryBul, bou_a1.TOut) annotation (Line(
      points={{-340,190},{-340,190},{-340,144},{-340,80},{-334,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_b1.TOut) annotation (Line(
      points={{-340,190},{-284,190},{-214,190},{-214,80},{-218,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_a2.TOut) annotation (Line(
      points={{-340,190},{-214,190},{-214,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_b2.TOut) annotation (Line(
      points={{-340,190},{-180,190},{-94,190},{-94,80},{-98,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_a3.TOut) annotation (Line(
      points={{-340,190},{-210,190},{-94,190},{-94,80},{-92,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_b3.TOut) annotation (Line(
      points={{-340,190},{-182,190},{32,190},{32,80},{24,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_a4.TOut) annotation (Line(
      points={{-340,190},{-46,190},{180,190},{180,80},{186,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_b4.TOut) annotation (Line(
      points={{-340,190},{-24,190},{314,190},{314,80},{302,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_a5.TOut) annotation (Line(
      points={{-340,190},{-46,190},{314,190},{314,80},{326,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_b5.TOut) annotation (Line(
      points={{-340,190},{52,190},{454,190},{454,80},{442,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_a6.TOut) annotation (Line(
      points={{-340,190},{54,190},{454,190},{454,80},{468,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_b6.TOut) annotation (Line(
      points={{-340,190},{106,190},{590,190},{590,80},{582,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_a7.TOut) annotation (Line(
      points={{-340,190},{-98,190},{120,190},{120,-44},{180,-44},{180,-140},{188,
          -140}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_b7.TOut) annotation (Line(
      points={{-340,190},{120,190},{120,-44},{316,-44},{316,-140},{302,-140}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_a8.TOut) annotation (Line(
      points={{-340,190},{120,190},{120,-44},{316,-44},{316,-140},{328,-140}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, bou_b8.TOut) annotation (Line(
      points={{-340,190},{-106,190},{120,190},{120,-44},{454,-44},{454,-140},{442,
          -140}},
      color={255,204,51},
      thickness=0.5));
  connect(bou_a1.port_a, larOff1.port_a) annotation (Line(points={{-312,80},{
          -305,80},{-300,80}},
                          color={0,127,255}));
  connect(bou_a1.heaPor, larOff1.heatPort_a) annotation (Line(points={{-312,74},
          {-300,74},{-300,73.5714}}, color={191,0,0}));
  connect(bou_b1.port_a, larOff1.port_b) annotation (Line(points={{-240,80},{
          -260.143,80}},      color={0,127,255}));
  connect(larOff1.heatPort_b, bou_b1.heaPor) annotation (Line(points={{-260,
          73.5714},{-250,73.5714},{-250,74},{-240,74}},
                                               color={191,0,0}));
  connect(bou_a2.port_a, ret1.port_a) annotation (Line(points={{-192,80},{-185,
          80},{-180,80}},
                      color={0,127,255}));
  connect(bou_a2.heaPor, ret1.heatPort_a) annotation (Line(points={{-192,74},{
          -180,74},{-180,73.5714}},
                               color={191,0,0}));
  connect(ret1.port_b, bou_b2.port_a) annotation (Line(points={{-140.143,80},{
          -140.143,80},{-120,80}},
                          color={0,127,255}));
  connect(ret1.heatPort_b, bou_b2.heaPor) annotation (Line(points={{-140,
          73.5714},{-130,73.5714},{-130,74},{-120,74}},
                                               color={191,0,0}));
  connect(bou_a3.port_a, larOff2.port_a)
    annotation (Line(points={{-70,80},{-64,80},{-60,80}}, color={0,127,255}));
  connect(bou_a3.heaPor, larOff2.heatPort_a) annotation (Line(points={{-70,74},
          {-60,74},{-60,73.5714}},color={191,0,0}));
  connect(larOff2.port_b, bou_b3.port_a) annotation (Line(points={{-20.1429,80},
          {-20.1429,80},{2,80}}, color={0,127,255}));
  connect(larOff2.heatPort_b, bou_b3.heaPor) annotation (Line(points={{-20,
          73.5714},{-10,73.5714},{-10,74},{2,74}},
                                          color={191,0,0}));
  connect(bou_a4.port_a, apa1.port_a)
    annotation (Line(points={{208,80},{216,80},{220,80}}, color={0,127,255}));
  connect(bou_a4.heaPor, apa1.heatPort_a) annotation (Line(points={{208,74},{
          220,74},{220,73.5714}},
                              color={191,0,0}));
  connect(apa1.port_b, bou_b4.port_a) annotation (Line(points={{259.857,80},{
          259.857,80},{280,80}},
                         color={0,127,255}));
  connect(apa1.heatPort_b, bou_b4.heaPor) annotation (Line(points={{260,73.5714},
          {270,73.5714},{270,74},{280,74}}, color={191,0,0}));
  connect(bou_a5.port_a, larOff3.port_a)
    annotation (Line(points={{348,80},{355,80},{360,80}}, color={0,127,255}));
  connect(bou_a5.heaPor, larOff3.heatPort_a) annotation (Line(points={{348,74},
          {360,74},{360,73.5714}},color={191,0,0}));
  connect(larOff3.port_b, bou_b5.port_a) annotation (Line(points={{399.857,80},
          {399.857,80},{420,80}},color={0,127,255}));
  connect(larOff3.heatPort_b, bou_b5.heaPor) annotation (Line(points={{400,
          73.5714},{412,73.5714},{412,74},{420,74}},
                                            color={191,0,0}));
  connect(bou_a6.port_a, larOff4.port_a)
    annotation (Line(points={{490,80},{496,80},{500,80}}, color={0,127,255}));
  connect(bou_a6.heaPor, larOff4.heatPort_a) annotation (Line(points={{490,74},
          {500,74},{500,73.5714}},color={191,0,0}));
  connect(larOff4.port_b, bou_b6.port_a) annotation (Line(points={{539.857,80},
          {539.857,80},{560,80}},color={0,127,255}));
  connect(larOff4.heatPort_b, bou_b6.heaPor) annotation (Line(points={{540,
          73.5714},{552,73.5714},{552,74},{560,74}},
                                            color={191,0,0}));
  connect(bou_a7.port_a, apa2.port_a) annotation (Line(points={{210,-140},{215,-140},
          {220,-140}}, color={0,127,255}));
  connect(bou_a7.heaPor, apa2.heatPort_a) annotation (Line(points={{210,-146},{
          220,-146},{220,-146.429}},
                                 color={191,0,0}));
  connect(apa2.port_b, bou_b7.port_a) annotation (Line(points={{259.857,-140},{
          259.857,-140},{280,-140}},
                             color={0,127,255}));
  connect(apa2.heatPort_b, bou_b7.heaPor) annotation (Line(points={{260,
          -146.429},{272,-146.429},{272,-146},{280,-146}},
                                                 color={191,0,0}));
  connect(bou_a8.port_a, ret2.port_a) annotation (Line(points={{350,-140},{355,-140},
          {360,-140}}, color={0,127,255}));
  connect(bou_a8.heaPor, ret2.heatPort_a) annotation (Line(points={{350,-146},{
          360,-146},{360,-146.429}},
                                 color={191,0,0}));
  connect(ret2.port_b, bou_b8.port_a) annotation (Line(points={{399.857,-140},{
          399.857,-140},{420,-140}},
                             color={0,127,255}));
  connect(ret2.heatPort_b, bou_b8.heaPor) annotation (Line(points={{400,
          -146.429},{410,-146.429},{410,-146},{420,-146}},
                                                 color={191,0,0}));
  annotation(experiment(Tolerance=1E-06, StopTime=31536000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/DistrictHeatingCooling/Examples/HeatingCoolingHotWater3ClustersBaseCase.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This is the base case model for
<a href=\"modelica://Buildings.Obsolete.DistrictHeatingCooling.Examples.HeatingCoolingHotWater3Clusters\">
Buildings.Obsolete.DistrictHeatingCooling.Examples.HeatingCoolingHotWater3Clusters</a>.
</p>
<p>
Rather than being connected in a bi-directional district heating
and cooling system, the heat pumps of each building are exposed
to outside air conditions. Hence, they do not share any waste heat
with each other.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 12, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-580,-260},{780,
            400}})));
end HeatingCoolingHotWater3ClustersBaseCase;
