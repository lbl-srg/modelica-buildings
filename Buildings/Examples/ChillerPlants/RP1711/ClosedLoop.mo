within Buildings.Examples.ChillerPlants.RP1711;
model ClosedLoop
  extends Buildings.Examples.ChillerPlants.RP1711.BaseClasses.ChillerPlant;
  Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller chiPlaCon(
    have_WSE=false,
    nSenChiWatPum=1,
    totSta=3,
    staVec={0,1,2},
    desConWatPumSpe={0,0.5,0.75},
    desConWatPumNum={0,1,2},
    towCelOnSet={0,2,2},
    nTowCel=2)
    annotation (Placement(transformation(extent={{-340,60},{-300,180}})));
  Fluid.MixingVolumes.MixingVolume           rooVol1(nPorts=2)
                                                    "Volume of air in the room" annotation (Placement(
        transformation(extent={{235,-586},{255,-566}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow intHeaGai1
    "Internal heat gain"
    annotation (Placement(transformation(extent={{54,-556},{74,-536}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1
    annotation (Placement(transformation(extent={{54,-586},{74,-566}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor rooHeaCap1
    "Heat capacitance of the room and walls"
    annotation (Placement(transformation(extent={{164,-536},{184,-516}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{14,-586},{34,-566}})));
  Fluid.Sensors.TemperatureTwoPort rooAirTem1
                                             "Room air temperature"
    annotation (Placement(transformation(extent={{294,-596},{314,-576}})));
  Fluid.HeatExchangers.DryCoilCounterFlow cooCoi1
    annotation (Placement(transformation(extent={{234,-496},{254,-476}})));
equation
  connect(thermalConductor1.port_b, rooVol1.heatPort)
    annotation (Line(points={{74,-576},{235,-576}}, color={191,0,0}));
  connect(prescribedTemperature1.port, thermalConductor1.port_a)
    annotation (Line(points={{34,-576},{54,-576}}, color={191,0,0}));
  connect(intHeaGai1.port, rooVol1.heatPort) annotation (Line(points={{74,-546},
          {174,-546},{174,-576},{235,-576}}, color={191,0,0}));
  connect(rooHeaCap1.port, rooVol1.heatPort) annotation (Line(points={{174,-536},
          {174,-576},{235,-576}}, color={191,0,0}));
  connect(cooCoi1.port_b2, rooVol1.ports[1]) annotation (Line(points={{234,-492},
          {114,-492},{114,-586},{243,-586}}, color={0,127,255}));
  connect(cooCoi1.port_a2, rooAirTem1.port_b) annotation (Line(points={{254,
          -492},{354,-492},{354,-586},{314,-586}}, color={0,127,255}));
  connect(rooAirTem1.port_a, rooVol1.ports[2])
    annotation (Line(points={{294,-586},{247,-586}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ClosedLoop;
