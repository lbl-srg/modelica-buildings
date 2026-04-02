within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice;
model IdealHeatingCoolingWinter_Autosizing
  extends IdealHeatingCoolingWinter(
    redeclare Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor_Autosizing_MultipleSystems flo,
    coo(
      Q_flow_nominal=-{
        flo.sou.sizCoo.QSen_flow,
        flo.eas.sizCoo.QSen_flow,
        flo.nor.sizCoo.QSen_flow,
        flo.wes.sizCoo.QSen_flow,
        flo.cor.sizCoo.QSen_flow}),
    hea(
      Q_flow_nominal={
        flo.sou.sizHea.QSen_flow,
        flo.eas.sizHea.QSen_flow,
        flo.nor.sizHea.QSen_flow,
        flo.wes.sizHea.QSen_flow,
        flo.cor.sizHea.QSen_flow}),
    THeaCoo(
      k={
        flo.sou.sizCoo.TSet,
        flo.eas.sizCoo.TSet,
        flo.nor.sizCoo.TSet,
        flo.wes.sizCoo.TSet,
        flo.cor.sizCoo.TSet}),
    THeaSet(
      k={
        flo.sou.sizHea.TSet,
        flo.eas.sizHea.TSet,
        flo.nor.sizHea.TSet,
        flo.wes.sizHea.TSet,
        flo.cor.sizHea.TSet}));
  annotation(
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Examples/SmallOffice/IdealHeatingCoolingWinter_Autosizing.mos" "Simulate and plot"),
    experiment(
      StartTime=432000,
      StopTime=864000,
      Tolerance=1e-07));
end IdealHeatingCoolingWinter_Autosizing;
