within Buildings.Experimental.ScalableModels.ThermalZones.Validation;
model MultiZoneFluctuatingIHG "Multiple thermal zone models"
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Medium model";

  parameter Integer nZon(min=1) = 6 "Number of zones per floor"
    annotation(Evaluate=true);
  parameter Integer nFlo(min=1) = 1 "Number of floors"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude";

  parameter Real ampFactor[nZon,nFlo]=
    if (nZon*nFlo)<=5 then
        {{abs(cos(i*j*3.1415926/(nZon*nFlo))) for j in 1:nFlo} for i in 1:nZon}
    else
        {{abs(cos(i*j*3.1415926/5)) for j in 1:nFlo} for i in 1:nZon}
    "IHG fluctuating amplitude factor";

  BaseClasses.ThermalZoneFluctuatingIHG theZon[nZon, nFlo](
    redeclare each package MediumA = MediumA,
    each final lat=lat,
    gainFactor={{(ampFactor[i,j]) for j in 1:nFlo} for i in 1:nZon})           "Thermal zone model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  for iZon in 1:nZon-1 loop
    for iFlo in 1:nFlo-1 loop
      connect(theZon[iZon, iFlo].heaPorFlo, theZon[iZon, if iFlo == nFlo then 1 else iFlo+1].heaPorCei) annotation (Line(
        points={{0,-10.2},{0,-20},{16,-20},{16,20},{0,20},{0,10}}, color={191,0,
          0}));
      connect(theZon[iZon, iFlo].heaPorWal1, theZon[if iZon == nZon then 1 else iZon+1, iFlo].heaPorWal2) annotation (Line(
        points={{-10,-1.6},{-20,-1.6},{-20,-24},{20,-24},{20,0},{10.2,0}},
                                                                     color={191,
          0,0}));
    end for;
  end for;
  for iZon in 1:nZon loop
    for iFlo in 1:nFlo loop
      connect(weaDat.weaBus, theZon[iZon, iFlo].weaBus) annotation (Line(
      points={{-40,-30},{-7.4,-30},{-7.4,-8}},
      color={255,204,51},
      thickness=0.5));
    end for;
  end for;

  annotation (
  experiment(StopTime=604800, Tolerance=1e-06, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/ScalableModels/ThermalZones/Validation/MultiZoneFluctuatingIHG.mos"
        "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MultiZoneFluctuatingIHG;
