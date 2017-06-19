within Buildings.Experimental.ScalableModels.ScalableBuildingModels;
model IdealHVAC_ScableZones
  extends Modelica.Icons.Example;
  parameter Integer nZon(min=1) = 6 "Number of zones per floor"
    annotation(Evaluate=true);
  parameter Integer nFlo(min=1) = 1 "Number of floors"
    annotation(Evaluate=true);

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-86,-10},{-66,10}})));
  Buildings.Experimental.ScalableModels.HVACSystems.IdealAir_P idealAir_P(
    nZon = nZon,
    nFlo = nFlo,
    each sensitivityGainHeat = 1,
    each sensitivityGainCool = 1)
    annotation (Placement(transformation(extent={{36,-20},{70,16}})));
  Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses.MultiZoneFluctuatingIHG multiZoneFluctuatingIHG(
    nZon = nZon,
    nFlo = nFlo)
    annotation (Placement(transformation(extent={{-40,-22},{4,20}})));

  Modelica.Blocks.Continuous.Integrator Energy[nZon,nFlo]
    annotation (Placement(transformation(extent={{42,24},{62,44}})));
  Buildings.Experimental.ScalableModels.Schedules.CoolSetpoint TSetCoo "Cooling setpoint"
    annotation (Placement(transformation(extent={{-10,24},{-2,32}})));
  Buildings.Experimental.ScalableModels.Schedules.HeatSetpoint TSetHea "Heating setpoint"
    annotation (Placement(transformation(extent={{-10,38},{-2,46}})));
equation
  connect(weaDat.weaBus, multiZoneFluctuatingIHG.weaBus) annotation (Line(
      points={{-66,0},{-52,0},{-52,-1},{-36.04,-1}},
      color={255,204,51},
      thickness=0.5));
  for iZon in 1:nZon loop
    for iFlo in 1:nFlo loop
      connect(multiZoneFluctuatingIHG.TRooAir[iZon, iFlo], idealAir_P.Tmea[iZon, iFlo])    annotation (Line(points={{6.2,
              -12.76},{21.66,-12.76},{21.66,-9.2},{32.6,-9.2}},
        color={0,0,127}));
      connect(idealAir_P.supplyAir[iZon, iFlo], multiZoneFluctuatingIHG.portsIn[iZon, iFlo])    annotation (Line(points={{71.7,-2},
              {84,-2},{84,-34},{-17.78,-34},{-17.78,-15.91}},
        color={0,127,255}));
      connect(multiZoneFluctuatingIHG.heaCooPow[iZon, iFlo], Energy[iZon, iFlo].u) annotation (
      Line(points={{6.2,12.44},{13.66,12.44},{13.66,34},{40,34}},  color={0,0,127}));
      connect(TSetHea.y[1], idealAir_P.TheatSetpoint[iZon, iFlo]) annotation (
          Line(points={{-1.6,42},{26,42},{26,10.6},{32.6,10.6}}, color={0,0,127}));
      connect(TSetCoo.y[1], idealAir_P.TcoolSetpoint[iZon, iFlo]) annotation (
          Line(points={{-1.6,28},{-1.6,28},{20,28},{20,3.4},{32.6,3.4}},
                                                                      color={0,0,
              127}));
    end for;
  end for;

  annotation (
  experiment(StopTime=604800, Tolerance=1e-06,__Dymola_Algorithm="Radau"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/ScalableModels/ScalableBuildingModels/IdealHVAC_ScableZones.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end IdealHVAC_ScableZones;
