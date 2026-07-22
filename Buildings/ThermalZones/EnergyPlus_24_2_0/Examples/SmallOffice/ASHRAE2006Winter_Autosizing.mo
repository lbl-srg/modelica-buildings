within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice;
model ASHRAE2006Winter_Autosizing
  "Variable air volume flow system with terminal reheat and five thermal zones using a control sequence published by ASHRAE in 2006 with HVAC sized using autosizing"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.HVACBuilding(
    mCor_flow_nominal=flo.cor.sizCoo.QSen_flow/(cpAir*(flo.cor.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    mSou_flow_nominal=flo.sou.sizCoo.QSen_flow/(cpAir*(flo.sou.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    mEas_flow_nominal=flo.eas.sizCoo.QSen_flow/(cpAir*(flo.eas.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    mNor_flow_nominal=flo.nor.sizCoo.QSen_flow/(cpAir*(flo.nor.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    mWes_flow_nominal=flo.wes.sizCoo.QSen_flow/(cpAir*(flo.wes.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    redeclare Buildings.Examples.VAVReheat.BaseClasses.ASHRAE2006 hvac(
      TCooAirSup_nominal=TCooAirSup_nominal,
      VAVBox(
        THeaAirDis_nominal=
          {THeaAirDis_nominal,
           THeaAirDis_nominal,
           THeaAirDis_nominal,
           THeaAirDis_nominal,
           THeaAirDis_nominal}),
      mCooAir_flow_nominal=flo.sysVAV1.sizCoo.QSen_flow/(cpAir*(TZonSetAve - hvac.TCooAirSup_nominal)),
      mHeaVAV_flow_nominal=
          {flo.sou.sizHea.QSen_flow/(cpAir*(hvac.VAVBox[1].THeaAirDis_nominal - flo.sou.sizHea.TSet)),
           flo.eas.sizHea.QSen_flow/(cpAir*(hvac.VAVBox[2].THeaAirDis_nominal - flo.eas.sizHea.TSet)),
           flo.nor.sizHea.QSen_flow/(cpAir*(hvac.VAVBox[3].THeaAirDis_nominal - flo.nor.sizHea.TSet)),
           flo.wes.sizHea.QSen_flow/(cpAir*(hvac.VAVBox[4].THeaAirDis_nominal - flo.wes.sizHea.TSet)),
           flo.cor.sizHea.QSen_flow/(cpAir*(hvac.VAVBox[5].THeaAirDis_nominal - flo.cor.sizHea.TSet))},
      TCooAirMix_nominal = ((hvac.mCooAir_flow_nominal-flo.sysVAV1.sizCoo.mOut_flow)*TZonSetAve + flo.sysVAV1.sizCoo.mOut_flow*flo.sysVAV1.sizCoo.TOut)/hvac.mCooAir_flow_nominal,
      wCooAirMix_nominal = ((hvac.mCooAir_flow_nominal-flo.sysVAV1.sizCoo.mOut_flow)*XZonSetAve + flo.sysVAV1.sizCoo.mOut_flow*flo.sysVAV1.sizCoo.XOut)/hvac.mCooAir_flow_nominal,
      QCooAHU_flow_nominal=QCooSenAHU_flow_nominal + QCooLatAHU_flow_nominal,
      Vot_flow_nominal=flo.sysVAV1.sizCoo.mOut_flow/1.2,
      VZonOA_flow_nominal=
          {flo.sou.sizHea.mOut_flow/1.2,
           flo.eas.sizHea.mOut_flow/1.2,
           flo.nor.sizHea.mOut_flow/1.2,
           flo.wes.sizHea.mOut_flow/1.2,
           flo.cor.sizHea.mOut_flow/1.2}),
    redeclare Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor_Autosizing flo);

  parameter Modelica.Units.SI.Temperature
    TZonSetAve = (flo.cor.sizCoo.TSet+flo.sou.sizCoo.TSet+flo.eas.sizCoo.TSet+flo.nor.sizCoo.TSet+flo.wes.sizCoo.TSet)/5
    "Average zone set point temperature to use in AHU airflow sizing";
  parameter Modelica.Units.SI.MassFraction
    XZonSetAve = (flo.cor.sizCoo.XSet+flo.sou.sizCoo.XSet+flo.eas.sizCoo.XSet+flo.nor.sizCoo.XSet+flo.wes.sizCoo.XSet)/5
    "Average zone set point humidity ratio to use in AHU airflow sizing";
  parameter Modelica.Units.SI.Temperature
    TCooAirSup_nominal = 12+273.15
    "Nominal discharge air temperature for AHU during cooling";
  parameter Modelica.Units.SI.MassFraction
    XCooAirSup_nominal = 0.0085/(1+0.0085)
    "Nominal discharge air humidity ratio for AHU during cooling";
  parameter Modelica.Units.SI.HeatFlowRate
    QCooSenAHU_flow_nominal = hvac.mCooAir_flow_nominal * cpAir *(TCooAirSup_nominal-hvac.TCooAirMix_nominal)
    "Nominal sensible cooling load on AHU cooling coil";
  parameter Modelica.Units.SI.HeatFlowRate
    QCooLatAHU_flow_nominal = hvac.mCooAir_flow_nominal * h_fg *(XCooAirSup_nominal-hvac.wCooAirMix_nominal)
    "Nominal latent cooling load on AHU cooling coil";
  parameter Modelica.Units.SI.Temperature
    THeaAirDis_nominal = 40+273.15
    "Nominal discharge air temperature for VAV boxes during heating";
  constant Modelica.Units.SI.SpecificHeatCapacity cpAir = 1005
    "Specific heat capacity of air";
  constant Modelica.Units.SI.SpecificEnergy h_fg=
      Buildings.Media.Air.enthalpyOfCondensingGas(TCooAirSup_nominal)
    "Latent heat of water vapor";
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Examples/SmallOffice/ASHRAE2006Winter_Autosizing.mos" "Simulate and plot"),
    experiment(
      StartTime=432000,
      StopTime=864000,
      Interval=900,
      Tolerance=1e-07,
      __Dymola_Algorithm="Cvode"),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true)),
    Documentation(
      info="<html>
<p>
Same example as <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.ASHRAE2006Winter\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.ASHRAE2006Winter</a>,
except that the HVAC system is sized using the autosizing feature in Spawn.
The autosizing feature is used as follows:
<ul>
<li>
Zone level heating and cooling nominal air flowrates for each VAV box are 
sized using the autosized zone level design sensible heating and cooling loads 
and design heating and cooling temperature set points.
</li>
<li>
Zone level minimum outside air flowrates are specified using the autosized
zone level design minimum outside air flowrates.
</li>
<li>
AHU nominal air flowrate is specified using the autosized system level design
sensible cooling load as well as an assumed average of the zone cooling
temperature set points.
</li>
<li>
AHU minimum outside air flowrate is specified using the autosized
system level design minimum outside air flowrate.
</li>
<li>
AHU cooling coil nominal capacity is calculated as the sum the design
system level sensible and latent loads.  The sensible/latent load is calculated using a 
design mixed air temperature/humidity ratio determined using mixing box mass and energy balance
that makes use of the autosized system level cooling 
design outside air temperature/humidity ratio and minimum outside air flowrate, along with
the determined AHU nominal air flowrate and the assumed average of the zone 
cooling temperature/humidity ratio set points.
</li>
</ul>
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 22, 2024, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ASHRAE2006Winter_Autosizing;
