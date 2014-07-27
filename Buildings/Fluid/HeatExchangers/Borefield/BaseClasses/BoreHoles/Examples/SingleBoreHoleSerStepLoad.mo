within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.Examples;
model SingleBoreHoleSerStepLoad "SingleBoreHoleSer with step input load "
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  redeclare replaceable parameter Data.Records.Soil soi=
      Data.SoilData.SandStone()
    annotation (Placement(transformation(extent={{14,-76},{24,-66}})));
  redeclare replaceable parameter Data.Records.Filling fil=
      Data.FillingData.Bentonite() "Thermal properties of the filling material"
    annotation (Placement(transformation(extent={{30,-76},{40,-66}})));
  redeclare replaceable parameter Data.Records.General gen=
      Data.GeneralData.c8x1_h110_b5_d3600_T283()
    "General charachteristic of the borefield"
    annotation (Placement(transformation(extent={{46,-76},{56,-66}})));

  SingleBoreHolesInSerie borHolSer(
    redeclare each package Medium = Medium,
    soi=soi,
    fil=fil,
    gen=gen) "Borehole heat exchanger" annotation (Placement(
        transformation(extent={{-12,-50},{12,-26}}, rotation=0)));

  Buildings.Fluid.Sources.Boundary_ph sin(redeclare package Medium = Medium,
      nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{22,-34},{34,-22}})));

  Modelica.Blocks.Sources.Step step(height=1)
    annotation (Placement(transformation(extent={{48,-18},{36,-6}})));

  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea(
    redeclare package Medium = Medium,
    m_flow_nominal=gen.m_flow_nominal_bh,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow(start=gen.m_flow_nominal_bh),
    T_start=gen.T_start,
    Q_flow_nominal=gen.q_ste*gen.hBor*gen.nbSer,
    p_start=100000)
    annotation (Placement(transformation(extent={{26,10},{6,-10}})));
  Modelica.Blocks.Sources.Constant mFlo(k=gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{-50,-28},{-38,-16}})));

  Movers.FlowMachine_m_flow                 pum(
    redeclare package Medium = Medium,
    m_flow_nominal=gen.m_flow_nominal_bh,
    dynamicBalance=false,
    T_start=gen.T_start)
    annotation (Placement(transformation(extent={{-14,10},{-34,-10}})));
equation
  connect(pum.port_b, borHolSer.port_a) annotation (Line(
      points={{-34,0},{-58,0},{-58,-38},{-12,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-14,0},{6,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, borHolSer.port_b) annotation (Line(
      points={{26,0},{56,0},{56,-38},{12,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, sin.ports[1]) annotation (Line(
      points={{26,0},{56,0},{56,-28},{34,-28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, hea.u) annotation (Line(
      points={{35.4,-12},{34,-12},{34,-6},{28,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFlo.y, pum.m_flow_in) annotation (Line(
      points={{-37.4,-22},{-23.8,-22},{-23.8,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics),
    experimentSetupOutput,
    Diagram,
    Documentation(info="<html>
<p>

</p>
</html>", revisions="<html>
<ul>
</ul>
</html>"),
    experiment(
      StopTime=3.1536e+007,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
        graphics));
end SingleBoreHoleSerStepLoad;
