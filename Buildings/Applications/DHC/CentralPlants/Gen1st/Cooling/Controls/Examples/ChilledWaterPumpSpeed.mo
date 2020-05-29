within Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Controls.Examples;
model ChilledWaterPumpSpeed
  "Example to test the chilled water pump speed controller"
  extends Modelica.Icons.Example;
  Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Controls.ChilledWaterPumpSpeed
    chiWatPumSpe(
    dpSetPoi=68900,
    tWai=30,
    m_flow_nominal=0.5,
    k=0.00001,
    Ti=240) "Chilled water pump speed controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant dpMea(k=0.6*chiWatPumSpe.dpSetPoi)
    "Measured demand side pressure difference"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Pulse mFloTot(
    amplitude=0.4*chiWatPumSpe.m_flow_nominal,
    period=300,
    offset=0.5*chiWatPumSpe.m_flow_nominal,
    startTime=150) "Total chilled water mass flow rate"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
equation
  connect(dpMea.y, chiWatPumSpe.dpMea) annotation (Line(points={{-39,-20},{-30,
          -20},{-30,-4},{-12,-4}}, color={0,0,127}));
  connect(mFloTot.y, chiWatPumSpe.masFloPum) annotation (Line(points={{-39,20},
          {-30,20},{-30,4},{-12,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/CentralPlants/Cooling/Controls/Examples/ChilledWaterPumpSpeed.mos"
        "Simulate and Plot"));
end ChilledWaterPumpSpeed;
