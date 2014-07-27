within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.Examples;
model SingleBoreHolesInSerie "Test for the SingleBoreHole model"
  import DaPModels;
  import Buildings;
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.SingleBoreHolesInSerie
    seg(
    redeclare package Medium = Medium,
    soi=Data.SoilData.SandStone(),
    fil=Data.FillingData.Bentonite(),
    gen=Buildings.Fluid.HeatExchangers.Borefield.Data.GeneralData.c8x1_h110_b5_d3600_T283())
            annotation (Placement(transformation(
        extent={{-13,-13},{13,13}},
        rotation=270,
        origin={9,33})));

  Sources.MassFlowSource_T        sou_1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=1,
    T=303.15) annotation (Placement(transformation(extent={{-60,40},{-40,60}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) annotation (Placement(transformation(extent={{-60,10},{-40,30}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
equation
  connect(sou_1.ports[1], seg.port_a) annotation (Line(
      points={{-40,50},{9,50},{9,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(seg.port_b, sin_2.ports[1]) annotation (Line(
      points={{9,20},{-40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/BaseClasses/Examples/BoreholeSegment.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    experimentSetupOutput,
    Diagram,
    Documentation(info="<html>
This example illustrates modeling a segment of a borehole heat exchanger.
It simulates the behavior of the borehole on a single horizontal section including the ground and the
boundary condition.
</html>", revisions="<html>
<ul>
<li>
August 30, 2011, by Pierre Vigouroux:<br>
First implementation.
</li>
</ul>
</html>"));
end SingleBoreHolesInSerie;
