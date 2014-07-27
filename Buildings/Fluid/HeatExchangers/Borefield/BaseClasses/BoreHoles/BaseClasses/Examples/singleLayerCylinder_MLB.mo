within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.Examples;
model singleLayerCylinder_MLB
  "Comparison of the CylindricalGroundLayer with the Modelica Buildings Library"
  extends Modelica.Icons.Example;

  parameter Data.BorefieldData.SandStone_Bentonite_c8x1_h110_b5_d3600_T283 bfData
    annotation (Placement(transformation(extent={{-60,76},{-40,96}})));

  CylindricalGroundLayer soi(
    final material=bfData.soi,
    final h=bfData.gen.hSeg,
    final nSta=bfData.gen.nHor,
    final r_a=bfData.gen.rBor,
    final r_b=bfData.gen.rExt,
    final steadyStateInitial=false,
    final TInt_start=bfData.gen.TFil0_start,
    final TExt_start=bfData.gen.TExt0_start) "Heat conduction in the soil"
                                  annotation (Placement(
        transformation(extent={{-12,16},{8,36}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature2
    annotation (Placement(transformation(extent={{42,16},{62,36}})));
  Modelica.Blocks.Sources.Constant const1(k=bfData.gen.TFil0_start)
    annotation (Placement(transformation(extent={{-2,-14},{18,6}})));
  Modelica.Blocks.Sources.Step     const4(
    height=120,
    offset=0,
    startTime=1000)
    annotation (Placement(transformation(extent={{-94,18},{-74,38}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2
    annotation (Placement(transformation(extent={{-64,18},{-44,38}})));
equation
  connect(soi.port_b, prescribedTemperature2.port) annotation (Line(
      points={{8,26},{22,26},{22,50},{78,50},{78,26},{62,26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const1.y, prescribedTemperature2.T) annotation (Line(
      points={{19,-4},{30,-4},{30,26},{40,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const4.y, prescribedHeatFlow2.Q_flow) annotation (Line(
      points={{-73,28},{-64,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow2.port, soi.port_a) annotation (Line(
      points={{-44,28},{-28,28},{-28,26},{-12,26}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=187200),
    __Dymola_experimentSetupOutput);
end singleLayerCylinder_MLB;
